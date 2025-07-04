package bibliotheque.service;

import bibliotheque.entity.*;
import bibliotheque.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Optional;

@Service
public class PretService {
    @Autowired
    private AdherentRepository adherentRepository;
    @Autowired
    private AbonnementRepository abonnementRepository;
    @Autowired
    private ExemplaireRepository exemplaireRepository;
    @Autowired
    private PretRepository pretRepository;
    @Autowired
    private StatutExemplaireRepository statutExemplaireRepository;
    @Autowired
    private PenaliteRepository penaliteRepository;
    @Autowired
    private ReservationRepository reservationRepository;
    @Autowired
    private TypePretRepository typePretRepository;

    public String validerPret(int idAdherent, int idExemplaire, int idTypePret, int idBibliothecaire) {
        // 1. Vérifier existence de l'adhérent
        Optional<Adherent> optAdherent = adherentRepository.findById(idAdherent);
        if (optAdherent.isEmpty()) return "L'adhérent n'existe pas.";
        Adherent adherent = optAdherent.get();

        // 2. Vérifier abonnement valide
        Date today = new Date();
        boolean abonnementValide = abonnementRepository.findByAdherentId_adherent(idAdherent)
                .stream().anyMatch(ab -> !ab.getDateDebut().after(today) && !ab.getDateFin().before(today));
        if (!abonnementValide) return "L'adhérent n'a pas d'abonnement valide.";

        // 3. Vérifier existence de l'exemplaire
        Optional<Exemplaire> optExemplaire = exemplaireRepository.findById(idExemplaire);
        if (optExemplaire.isEmpty()) return "L'exemplaire n'existe pas.";
        Exemplaire exemplaire = optExemplaire.get();

        // 4. Vérifier disponibilité de l'exemplaire (dernier statut == Disponible)
        List<StatutExemplaire> statuts = statutExemplaireRepository.findByExemplaireId_exemplaireOrderByDateChangementDesc(idExemplaire);
        if (statuts.isEmpty() || !"Disponible".equalsIgnoreCase(statuts.get(0).getLibelle()))
            return "L'exemplaire n'est pas disponible.";

        // 5. Vérifier pénalité de l'adhérent
        boolean penalisé = penaliteRepository.findByPretAdherentId_adherent(idAdherent)
                .stream().anyMatch(p -> p.getDureePenalite() > 0);
        if (penalisé) return "L'adhérent est pénalisé et ne peut pas emprunter.";

        // 6. Vérifier quota restant
        if (adherent.getQuotaRestant() <= 0) return "L'adhérent a atteint son quota de prêts.";

        // 7. Vérifier âge minimum
        Livre livre = exemplaire.getLivre();
        if (livre.getAgeMinimum() > getAge(adherent.getDateNaissance(), today))
            return "L'adhérent est trop jeune pour ce livre.";

        // 8. Vérifier exemplaire non réservé par un autre adhérent
        boolean reservedByOther = reservationRepository.findByExemplaireId_exemplaire(idExemplaire).stream()
        .anyMatch(r -> r.getAdherent().getId_adherent() != idAdherent);
        if (reservedByOther) return "L'exemplaire est réservé par un autre adhérent.";

        // 9. Créer le prêt
        TypePret typePret = typePretRepository.findById(idTypePret).orElse(null);
        if (typePret == null) return "Type de prêt inconnu.";

        Pret pret = new Pret();
        pret.setAdherent(adherent);
        pret.setExemplaire(exemplaire);
        pret.setTypePret(typePret);
        pret.setDatePret(today);
        pret.setDateRetourPrevue(calculerDateRetourPrevue(today, typePret.getLibelle())); // à implémenter selon règle métier
        pretRepository.save(pret);

        // 10. Changer le statut de l'exemplaire à Non disponible
        StatutExemplaire statut = new StatutExemplaire();
        statut.setExemplaire(exemplaire);
        statut.setDateChangement(today);
        statut.setLibelle("Non disponible");
        statut.setBibliothecaire(new Bibliothecaire());
        statut.getBibliothecaire().setId_biblio(idBibliothecaire);
        statutExemplaireRepository.save(statut);

        // 11. Décrémenter le quota de l'adhérent
        adherent.setQuotaRestant(adherent.getQuotaRestant() - 1);
        adherentRepository.save(adherent);

        return null; // null = succès
    }

    private int getAge(Date naissance, Date today) {
        java.util.Calendar birth = java.util.Calendar.getInstance();
        birth.setTime(naissance);
        java.util.Calendar now = java.util.Calendar.getInstance();
        now.setTime(today);
        int age = now.get(java.util.Calendar.YEAR) - birth.get(java.util.Calendar.YEAR);
        if (now.get(java.util.Calendar.DAY_OF_YEAR) < birth.get(java.util.Calendar.DAY_OF_YEAR)) {
            age--;
        }
        return age;
    }

    private Date calculerDateRetourPrevue(Date datePret, String typePretLibelle) {
        // Exemple : 14 jours si "Normal", 7 si "Court", etc. (à personnaliser)
        java.util.Calendar cal = java.util.Calendar.getInstance();
        cal.setTime(datePret);
        cal.add(java.util.Calendar.DATE, "Court".equalsIgnoreCase(typePretLibelle) ? 7 : 14);
        return cal.getTime();
    }
}