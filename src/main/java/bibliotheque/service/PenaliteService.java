package bibliotheque.service;

import bibliotheque.entity.*;
import bibliotheque.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Optional;

@Service
public class PenaliteService {

    @Autowired
    private PenaliteRepository penaliteRepository;

    @Autowired
    private PretRepository pretRepository;

    @Autowired
    private AdherentRepository adherentRepository;

    @Autowired
    private AbonnementRepository abonnementRepository;

    @Autowired
    private TypeAdherentRepository typeAdherentRepository;

    public String appliquerPenalite(int idPret, int idAdherent, int dureePenalite, Date dateApplication) {
        // 1. Vérifier l'existence de l'adhérent
        Optional<Adherent> optAdherent = adherentRepository.findById(idAdherent);
        if (optAdherent.isEmpty()) {
            return "L'adhérent n'existe pas.";
        }
        Adherent adherent = optAdherent.get();

        // 2. Vérifier l'existence du prêt
        Optional<Pret> optPret = pretRepository.findById(idPret);
        if (optPret.isEmpty()) {
            return "Le prêt n'existe pas.";
        }
        Pret pret = optPret.get();

        // 3. Vérifier que le prêt est retourné en retard
        if (pret.getDateRetourReelle() == null || !pret.getDateRetourReelle().after(pret.getDateRetourPrevue())) {
            return "Le prêt n'est pas retourné en retard.";
        }

        // 4. Vérifier la validité de la durée de la pénalité
        Optional<TypeAdherent> optTypeAdherent = typeAdherentRepository.findById(adherent.getTypeAdherent().getId_type_adherent());
        if (optTypeAdherent.isEmpty()) {
            return "Type d'adhérent inconnu.";
        }
        TypeAdherent typeAdherent = optTypeAdherent.get();
        if (dureePenalite <= 0 || dureePenalite > typeAdherent.getDureePenalite()) {
            return "La durée de la pénalité doit être un entier positif et ne doit pas dépasser " + typeAdherent.getDureePenalite() + " jours.";
        }

        // 5. Vérifier l'abonnement valide à la date d'application
        List<Abonnement> abonnements = abonnementRepository.findByAdherentId(idAdherent);
        boolean abonnementValide = abonnements.stream()
                .anyMatch(ab -> !ab.getDateDebut().after(dateApplication) && !ab.getDateFin().before(dateApplication));
        if (!abonnementValide) {
            return "L'adhérent n'a pas d'abonnement valide à la date d'application.";
        }

        // 6. Vérifier que la date d'application est la date de retour réelle
        if (!dateApplication.equals(pret.getDateRetourReelle())) {
            return "La date d'application doit être la date de retour réelle.";
        }

        // 7. Appliquer la pénalité
        Penalite penalite = new Penalite();
        penalite.setPret(pret);
        penalite.setDureePenalite(dureePenalite);
        penalite.setDateApplication(dateApplication); // Conversion en String comme dans l'entité Penalite
        penaliteRepository.save(penalite);

        return null; // Succès
    }
}