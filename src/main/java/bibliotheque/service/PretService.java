package bibliotheque.service;

import bibliotheque.entity.*;
import bibliotheque.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Optional;
import java.util.TimeZone;

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
    private StatusExemplaireRepository statutExemplaireRepository;
    @Autowired
    private PenaliteRepository penaliteRepository;
    @Autowired
    private ReservationRepository reservationRepository;
    @Autowired
    private TypePretRepository typePretRepository;
    @Autowired
    private EtatExemplaireRepository etatExemplaireRepository;
    @Autowired
    private TypeAdherentRepository typeAdherentRepository;

    public String validerPret(int idAdherent, int idExemplaire, int idTypePret, int idBibliothecaire, Date datePret) {
        // 1. Vérifier existence de l'adhérent
        Optional<Adherent> optAdherent = adherentRepository.findById(idAdherent);
        if (optAdherent.isEmpty()) return "L'adhérent n'existe pas.";
        Adherent adherent = optAdherent.get();

        // 2. Vérifier abonnement valide et réinitialiser le quota si nécessaire
        List<Abonnement> abonnements = abonnementRepository.findByAdherentId(idAdherent);
        boolean abonnementValide = abonnements.stream()
                .anyMatch(ab -> !ab.getDateDebut().after(datePret) && !ab.getDateFin().before(datePret));
        if (!abonnementValide) {
            return "L'adhérent n'a pas d'abonnement valide.";
        }

        // Réinitialiser le quota si nouvelle période (mois)
        resetQuotaIfNewPeriod(adherent, abonnements, datePret);

        // 3. Vérifier existence de l'exemplaire
        Optional<Exemplaire> optExemplaire = exemplaireRepository.findById(idExemplaire);
        if (optExemplaire.isEmpty()) return "L'exemplaire n'existe pas.";
        Exemplaire exemplaire = optExemplaire.get();

        // 4. Vérifier disponibilité de l'exemplaire (dernier statut == Disponible)
        List<StatusExemplaire> statuts = statutExemplaireRepository.findByExemplaireIdOrderByDateChangementDesc(idExemplaire);
        if (statuts.isEmpty() || !"Disponible".equalsIgnoreCase(statuts.get(0).getEtatExemplaire().getLibelle()))
            return "L'exemplaire n'est pas disponible.";

        // 5. Vérifier pénalité de l'adhérent
        boolean penalise = penaliteRepository.findByAdherentId(idAdherent)
                .stream().anyMatch(p -> p.getDureePenalite() > 0);
        if (penalise) return "L'adhérent est pénalisé et ne peut pas emprunter.";

        // 6. Vérifier quota restant
        if (adherent.getQuotaRestant() <= 0) return "L'adhérent a atteint son quota de prêts.";

        // 7. Vérifier âge minimum
        Livre livre = exemplaire.getLivre();
        if (livre.getAgeMinimum() > getAge(adherent.getDateNaissance(), datePret))
            return "L'adhérent est trop jeune pour ce livre.";

        // 8. Vérifier exemplaire non réservé par un autre adhérent
        boolean reservedByOther = reservationRepository.findByExemplaireId(idExemplaire).stream()
                .anyMatch(r -> r.getAdherent().getId_adherent() != idAdherent);
        if (reservedByOther) return "L'exemplaire est réservé par un autre adhérent.";

        // 9. Créer le prêt
        TypePret typePret = typePretRepository.findById(idTypePret).orElse(null);
        if (typePret == null) return "Type de prêt inconnu.";

        // Récupérer la durée de prêt depuis TypeAdherent
        Optional<TypeAdherent> optTypeAdherent = typeAdherentRepository.findById(adherent.getTypeAdherent().getId_type_adherent());
        if (optTypeAdherent.isEmpty()) {
            return "Type d'adhérent inconnu.";
        }
        TypeAdherent typeAdherent = optTypeAdherent.get();
        
        Pret pret = new Pret();
        pret.setAdherent(adherent);
        pret.setExemplaire(exemplaire);
        pret.setTypePret(typePret);
        pret.setDatePret(datePret);

        // Gestion spéciale pour prêt "Sur place" (id_type_pret = 2)        // Gestion spéciale pour prêt "Sur place" (id_type_pret = 2)
        boolean isSurPlace = idTypePret == 2;
        if (isSurPlace) {
            pret.setDateRetourPrevue(datePret);
            pret.setDateRetourReelle(datePret); // Retour immédiat pour prêt sur place
        }else {
            pret.setDateRetourPrevue(calculerDateRetourPrevue(datePret, typeAdherent.getDureePret())); // Date retour prévue basée sur duree_pret
        }

        pretRepository.save(pret);


        // 10. Changer le statut de l'exemplaire à Non disponible
        StatusExemplaire statut = new StatusExemplaire();
        statut.setExemplaire(exemplaire);
        statut.setDateChangement(datePret);
        EtatExemplaire etatNonDisponible = etatExemplaireRepository.findByLibelle("Emprunte")
                .orElseThrow(() -> new RuntimeException("Statut 'Emprunté' non trouvé"));
        statut.setEtatExemplaire(etatNonDisponible);
        statut.setBibliothecaire(new Bibliothecaire());
        statut.getBibliothecaire().setId_biblio(idBibliothecaire);
        statutExemplaireRepository.save(statut);

        // Pour prêt "Sur place", programmer le retour à Disponible le lendemain
        if (isSurPlace) {
            StatusExemplaire statutDisponible = new StatusExemplaire();
            statutDisponible.setExemplaire(exemplaire);
            statutDisponible.setDateChangement(calculerDateLendemain(datePret));
            EtatExemplaire etatDisponible = etatExemplaireRepository.findByLibelle("Disponible")
                    .orElseThrow(() -> new RuntimeException("Statut 'Disponible' non trouvé"));
            statutDisponible.setEtatExemplaire(etatDisponible);
            statutDisponible.setBibliothecaire(new Bibliothecaire());
            statutDisponible.getBibliothecaire().setId_biblio(idBibliothecaire);
            statutExemplaireRepository.save(statutDisponible);
        }

        // 11. Décrémenter le quota de l'adhérent
        int nouveauQuota = adherent.getQuotaRestant() - 1;
        adherent.setQuotaRestant(nouveauQuota);
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

    private void resetQuotaIfNewPeriod(Adherent adherent, List<Abonnement> abonnements, Date today) {
        // Trouver l'abonnement actif
        Optional<Abonnement> abonnementActif = abonnements.stream()
                .filter(ab -> !ab.getDateDebut().after(today) && !ab.getDateFin().before(today))
                .findFirst();
        if (abonnementActif.isEmpty()) {
            return; // Pas d'abonnement actif, quota non réinitialisé
        }

        // Récupérer TypeAdherent pour obtenir le quota max
        Optional<TypeAdherent> optTypeAdherent = typeAdherentRepository.findById(adherent.getTypeAdherent().getId_type_adherent());
        if (optTypeAdherent.isEmpty()) {
            return;
        }
        TypeAdherent typeAdherent = optTypeAdherent.get();
        int quotaMax = typeAdherent.getQuota();

        // Vérifier si la date actuelle est dans un nouveau mois par rapport à date_debut
        Calendar todayCal = Calendar.getInstance();
        todayCal.setTime(today);
        Calendar debutCal = Calendar.getInstance();
        debutCal.setTime(abonnementActif.get().getDateDebut());

        int moisCourant = todayCal.get(Calendar.YEAR) * 12 + todayCal.get(Calendar.MONTH);
        int moisDebut = debutCal.get(Calendar.YEAR) * 12 + debutCal.get(Calendar.MONTH);
        int moisEcoules = moisCourant - moisDebut;

        if (moisEcoules > 0) {
            // Réinitialiser le quota si un nouveau mois a commencé dans la période d'abonnement
            if (adherent.getQuotaRestant() != quotaMax) {
                adherent.setQuotaRestant(quotaMax);
                adherentRepository.save(adherent);
            }
        }
    }

    private Date calculerDateLendemain(Date date) {
        java.util.Calendar cal = java.util.Calendar.getInstance();
        cal.setTime(date);
        cal.add(java.util.Calendar.DATE, 1);
        return cal.getTime();
    }

    private Date calculerDateRetourPrevue(Date datePret, int dureePret) {
        java.util.Calendar cal = java.util.Calendar.getInstance();
        cal.setTime(datePret);
        cal.add(java.util.Calendar.DATE, dureePret);
        return cal.getTime();
    }

    public List<Pret> rechercherPrets(String adherent, String exemplaire, Integer idTypePret, String dateDebut, String dateFin) {

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        sdf.setTimeZone(TimeZone.getTimeZone("EAT"));
        Date startDate = null;
        Date endDate = null;
        Integer exemplaireId = null;

        try {
            if (dateDebut != null && !dateDebut.isEmpty()) {
                startDate = sdf.parse(dateDebut);
            }
            if (dateFin != null && !dateFin.isEmpty()) {
                endDate = sdf.parse(dateFin);
                Calendar cal = Calendar.getInstance(TimeZone.getTimeZone("EAT"));
                cal.setTime(endDate);
                cal.set(Calendar.HOUR_OF_DAY, 23);
                cal.set(Calendar.MINUTE, 59);
                cal.set(Calendar.SECOND, 59);
                endDate = cal.getTime();
            }
            if (exemplaire != null && !exemplaire.isEmpty()) {
                try {
                    exemplaireId = Integer.parseInt(exemplaire);
                } catch (NumberFormatException e) {
                    // Si ce n'est pas un entier, on le traite comme un titre
                }
            }
        } catch (Exception e) {
            return List.of();
        }

        String adherentSearch = (adherent != null && !adherent.isEmpty()) ? "%" + adherent + "%" : null;
        String exemplaireSearch = (exemplaire != null && !exemplaire.isEmpty() && exemplaireId == null) ? "%" + exemplaire + "%" : null;

        return pretRepository.findByCriteria(
                adherentSearch,
                exemplaireSearch,
                exemplaireId,
                idTypePret != null && idTypePret != 0 ? idTypePret : null,
                startDate,
                endDate);
    }
}