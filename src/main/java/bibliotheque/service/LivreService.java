package bibliotheque.service;

import bibliotheque.dto.LivreDisponibleProjection;
import bibliotheque.entity.Adherent;
import bibliotheque.entity.Exemplaire;
import bibliotheque.entity.Livre;
import bibliotheque.entity.Pret;
import bibliotheque.entity.StatusExemplaire;
import bibliotheque.repository.AdherentRepository;
import bibliotheque.repository.ExemplaireRepository;
import bibliotheque.repository.LivreRepository;
import bibliotheque.repository.PretRepository;
import bibliotheque.repository.StatusExemplaireRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class LivreService {

    @Autowired
    private LivreRepository livreRepository;

    @Autowired
    private PretRepository pretRepository;

    @Autowired
    private AdherentRepository adherentRepository;

    @Autowired
    private ExemplaireRepository exemplaireRepository;

    @Autowired
    private StatusExemplaireRepository statusExemplaireRepository;

    /**
     * Récupère une liste de livres suggérés pour un adhérent basé sur son historique de prêts ou la popularité.
     * @param idAdherent ID de l'adhérent
     * @return Liste de jusqu'à 5 livres suggérés
     */
    public List<Livre> getSuggestedLivres(Integer idAdherent) {
        List<Livre> suggestions = new ArrayList<>();
        Optional<Adherent> optAdherent = adherentRepository.findById(idAdherent);
        if (optAdherent.isEmpty()) {
            return suggestions; // Retourne une liste vide si l'adhérent n'existe pas
        }
        Adherent adherent = optAdherent.get();
        int ageAdherent = calculateAge(adherent.getDateNaissance(), new Date());

        // Étape 1 : Récupérer l'historique des prêts
        List<Pret> prets = pretRepository.findByAdherentId(idAdherent);
        if (!prets.isEmpty()) {
            // Étape 2 : Identifier les types de livres les plus fréquents
            Map<Integer, Long> typeCounts = prets.stream()
                    .collect(Collectors.groupingBy(
                            p -> p.getExemplaire().getLivre().getTypeLivre().getId_type(),
                            Collectors.counting()
                    ));

            // Trier les types par fréquence décroissante
            List<Integer> topTypeIds = typeCounts.entrySet().stream()
                    .sorted(Map.Entry.comparingByValue(Comparator.reverseOrder()))
                    .limit(2) // Limiter à 2 types pour la diversité
                    .map(Map.Entry::getKey)
                    .collect(Collectors.toList());

            // Récupérer les livres des types les plus fréquents
            for (Integer typeId : topTypeIds) {
                List<Livre> livresByType = livreRepository.findByTypeLivreAndNotBorrowedByAdherent(typeId, idAdherent);
                suggestions.addAll(livresByType);
            }

            // Si moins de 5 suggestions, compléter avec des livres d'auteurs fréquents
            if (suggestions.size() < 5) {
                Map<Integer, Long> auteurCounts = prets.stream()
                        .collect(Collectors.groupingBy(
                                p -> p.getExemplaire().getLivre().getAuteur().getId_auteur(),
                                Collectors.counting()
                        ));
                List<Integer> topAuteurIds = auteurCounts.entrySet().stream()
                        .sorted(Map.Entry.comparingByValue(Comparator.reverseOrder()))
                        .limit(2)
                        .map(Map.Entry::getKey)
                        .collect(Collectors.toList());

                for (Integer auteurId : topAuteurIds) {
                    List<Livre> livresByAuteur = livreRepository.findByAuteurAndNotBorrowedByAdherent(auteurId, idAdherent);
                    suggestions.addAll(livresByAuteur);
                }
            }
        }

        // Étape 3 : Si pas assez de suggestions, ajouter des livres populaires
        if (suggestions.size() < 5) {
            List<Livre> popularLivres = livreRepository.findPopularLivres();
            suggestions.addAll(popularLivres);
        }

        // Étape 4 : Filtrer par disponibilité et âge minimum
        suggestions = filterSuggestions(suggestions, idAdherent, ageAdherent);

        // Étape 5 : Limiter à 5 livres et supprimer les doublons
        return suggestions.stream()
                .distinct()
                .limit(5)
                .collect(Collectors.toList());
    }

    /**
     * Filtre les livres pour ne garder que ceux avec des exemplaires disponibles
     * et compatibles avec l'âge de l'adhérent.
     */
    private List<Livre> filterSuggestions(List<Livre> livres, Integer idAdherent, int ageAdherent) {
        List<Exemplaire> exemplaires = exemplaireRepository.findAll();
        Map<Integer, String> statutsExemplaires = new HashMap<>();
        for (Exemplaire exemplaire : exemplaires) {
            List<StatusExemplaire> statuts = statusExemplaireRepository.findByExemplaireIdOrderByDateChangementDesc(exemplaire.getId_exemplaire());
            String statut = statuts.isEmpty() ? "Inconnu" : statuts.get(0).getEtatExemplaire().getLibelle();
            statutsExemplaires.put(exemplaire.getId_exemplaire(), statut);
        }

        return livres.stream()
                .filter(livre -> livre.getAgeMinimum() <= ageAdherent) // Filtrer par âge
                .filter(livre -> exemplaires.stream()
                        .anyMatch(ex -> ex.getLivre().getId_livre() == livre.getId_livre()
                                && "Disponible".equalsIgnoreCase(statutsExemplaires.get(ex.getId_exemplaire())))) // Vérifier disponibilité
                .filter(livre -> pretRepository.findByAdherentId(idAdherent).stream()
                        .noneMatch(p -> p.getExemplaire().getLivre().getId_livre() == livre.getId_livre())) // Exclure livres déjà empruntés
                .collect(Collectors.toList());
    }

    /**
     * Calcule l'âge de l'adhérent à la date donnée.
     */
    private int calculateAge(Date naissance, Date today) {
        Calendar birth = Calendar.getInstance();
        birth.setTime(naissance);
        Calendar now = Calendar.getInstance();
        now.setTime(today);
        int age = now.get(Calendar.YEAR) - birth.get(Calendar.YEAR);
        if (now.get(Calendar.DAY_OF_YEAR) < birth.get(Calendar.DAY_OF_YEAR)) {
            age--;
        }
        return age;
    }

    public Object getDisponibiliteParLivre(Long idLivre) {
        List<LivreDisponibleProjection> result = livreRepository.findNbExemplairesDisponiblesByLivreId(idLivre);

        if (result.isEmpty() || result.get(0).getNbExemplairesDisponibles() == 0) {
            return false;  
        }
        return result.get(0); 
    }
}