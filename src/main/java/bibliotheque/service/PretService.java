package bibliotheque.service;

import bibliotheque.entity.*;
import bibliotheque.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Optional;
import java.util.TimeZone;
import java.util.stream.Collectors;

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
    @Autowired
    private JourFerieRepository jourFerieRepository;
    @Autowired
    private ProlongementRepository prolongementRepository;

    // Liste des jours fériés pour 2025 (exemple pour Madagascar)
    private static final List<String> JOURS_FERIES_2025 = Arrays.asList(
            "2025-01-01", // Nouvel An
            "2025-03-29", // Commémoration des martyrs
            "2025-04-21", // Lundi de Pâques
            "2025-05-01", // Fête du Travail
            "2025-05-29", // Ascension
            "2025-06-09", // Lundi de Pentecôte
            "2025-06-26", // Fête de l'Indépendance
            "2025-08-15", // Assomption
            "2025-11-01", // Toussaint
            "2025-12-25"  // Noël
    );

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
    
        // 4. Vérifier disponibilité de l'exemplaire
        // a. Vérifier le dernier statut dans StatusExemplaire
        List<StatusExemplaire> statuts = statutExemplaireRepository.findByExemplaireIdOrderByDateChangementDesc(idExemplaire);
        if (statuts.isEmpty() || !"Disponible".equalsIgnoreCase(statuts.get(0).getEtatExemplaire().getLibelle())) {
            return "L'exemplaire n'est pas disponible (statut non disponible).";
        }
    
        // b. Vérifier qu'il n'y a pas de prêt actif pour cet exemplaire à la datePret
        List<Pret> pretsActifs = pretRepository.findActivePretsByExemplaireAndDate(idExemplaire, datePret);
        if (!pretsActifs.isEmpty()) {
            return "L'exemplaire n'est pas disponible car il est encore emprunté à la date demandée.";
        }
    
        // 5. Vérifier pénalité de l'adhérent
        List<Penalite> penalites = penaliteRepository.findAll().stream()
            .filter(p -> p.getPret().getAdherent().getId_adherent() == idAdherent)
            .filter(p -> {
                Calendar cal = Calendar.getInstance();
                cal.setTime(p.getDateApplication());
                cal.add(Calendar.DATE, p.getDureePenalite());
                Date dateFinPenalite = cal.getTime();
                return datePret.before(dateFinPenalite) || datePret.equals(dateFinPenalite);
            })
            .collect(Collectors.toList());
        if (!penalites.isEmpty()) {
            return "L'adhérent est actuellement pénalisé et ne peut pas emprunter.";
        }
    
        // 6. Vérifier quota restant
        if (adherent.getQuotaRestant() <= 0) return "L'adhérent a atteint son quota de prêts.";
    
        // 7. Vérifier âge minimum
        Livre livre = exemplaire.getLivre();
        if (livre.getAgeMinimum() > getAge(adherent.getDateNaissance(), datePret))
            return "L'adhérent est trop jeune pour ce livre.";
    
        // 8. Vérifier exemplaire non réservé par un autre adhérent
        boolean reservedByOther = reservationRepository.findByExemplaireId(idExemplaire)
            .stream()
            .anyMatch(r -> r.getAdherent().getId_adherent() != idAdherent 
                && ("en attente".equalsIgnoreCase(r.getStatutReservation().getLibelle()) 
                    || "valide".equalsIgnoreCase(r.getStatutReservation().getLibelle())));
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
    
        // Gestion spéciale pour prêt "Sur place" (id_type_pret = 2)
        boolean isSurPlace = idTypePret == 2;
        if (isSurPlace) {
            pret.setDateRetourPrevue(datePret);
            pret.setDateRetourReelle(datePret); // Retour immédiat pour prêt sur place
        } else {
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

    public String retournerPret(int idAdherent, int idExemplaire, String dateRetour, int idBibliothecaire) {
        // Vérifier si le prêt existe et n'est pas retourné
        Optional<Pret> optPret = pretRepository.findNonReturnedByAdherentAndExemplaire(idAdherent, idExemplaire);
        if (optPret.isEmpty()) {
            return "Aucun prêt actif trouvé pour cet adhérent et cet exemplaire.";
        }
        Pret pret = optPret.get();

        // Convertir la date de retour
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        sdf.setTimeZone(TimeZone.getTimeZone("EAT"));
        Date dateRetourReelle;
        try {
            dateRetourReelle = sdf.parse(dateRetour);
        } catch (Exception e) {
            return "Format de la date de retour invalide.";
        }

        // Vérifier si la date de retour est postérieure ou égale à la date de prêt
        if (dateRetourReelle.before(pret.getDatePret())) {
            return "La date de retour ne peut pas être antérieure à la date de prêt.";
        }

        // Vérifier si la date est un jour férié
        String dateRetourStr = sdf.format(dateRetourReelle);
        Calendar cal = Calendar.getInstance(TimeZone.getTimeZone("EAT"));
        cal.setTime(dateRetourReelle);
        if (JOURS_FERIES_2025.contains(dateRetourStr)) {
            cal.add(Calendar.DAY_OF_MONTH, 1);
            while (JOURS_FERIES_2025.contains(sdf.format(cal.getTime()))) {
                cal.add(Calendar.DAY_OF_MONTH, 1);
            }
            dateRetourReelle = cal.getTime();
        }

        // Mettre à jour le prêt
        pret.setDateRetourReelle(dateRetourReelle);
        pretRepository.save(pret);

        // Mettre à jour le statut de l'exemplaire
        StatusExemplaire statut = new StatusExemplaire();
        statut.setExemplaire(pret.getExemplaire());
        statut.setDateChangement(dateRetourReelle);
        EtatExemplaire etatDisponible = etatExemplaireRepository.findByLibelle("Disponible")
                .orElseThrow(() -> new RuntimeException("Statut 'Disponible' non trouvé"));
        statut.setEtatExemplaire(etatDisponible);
        statut.setBibliothecaire(new Bibliothecaire());
        statut.getBibliothecaire().setId_biblio(idBibliothecaire);
        statutExemplaireRepository.save(statut);

        return null;
    }

    public String demanderProlongement(int idPret, Date dateProlongement) {
        // 1. Vérifier l'existence du prêt
        Optional<Pret> optPret = pretRepository.findById(idPret);
        if (optPret.isEmpty()) {
            return "Le prêt n'existe pas.";
        }
        Pret pret = optPret.get();

                // 2. Vérifier si une demande de prolongation existe déjà pour ce prêt
                List<Prolongement> prolongementsExistants = prolongementRepository.findByPretId(idPret);
                if (!prolongementsExistants.isEmpty()) {
                    return "Une demande de prolongation a déjà été soumise pour ce prêt.";
                }

        // 2. Vérifier si le prêt est déjà retourné
        if (pret.getDateRetourReelle() != null) {
            return "Le prêt a déjà été retourné.";
        }

        // 3. Vérifier si le prêt est de type "Sur place" (non prolongeable)
        if (pret.getTypePret().getId_type_pret() == 2) {
            return "Les prêts 'Sur place' ne peuvent pas être prolongés.";
        }

        // 4. Vérifier le type d'adhérent
        Optional<TypeAdherent> optTypeAdherent = typeAdherentRepository.findById(pret.getAdherent().getTypeAdherent().getId_type_adherent());
        if (optTypeAdherent.isEmpty()) {
            return "Type d'adhérent inconnu.";
        }
        TypeAdherent typeAdherent = optTypeAdherent.get();

        // 5. Vérifier le nombre de prolongements (limité à 1)
        if (pret.getNbProlongements() >= 1) {
            return "Le prêt a déjà été prolongé une fois, aucune prolongation supplémentaire autorisée.";
        }

        // 6. Vérifier les réservations sur l'exemplaire
        boolean reservedByOther = reservationRepository.findByExemplaireId(pret.getExemplaire().getId_exemplaire())
                .stream()
                .anyMatch(r -> r.getAdherent().getId_adherent() != pret.getAdherent().getId_adherent());
        if (reservedByOther) {
            return "L'exemplaire est réservé par un autre adhérent et ne peut pas être prolongé.";
        }

        // 7. Calculer la date maximale de prolongation
        Calendar cal = Calendar.getInstance(TimeZone.getTimeZone("EAT"));
        cal.setTime(pret.getDateRetourPrevue());
        cal.add(Calendar.DAY_OF_MONTH, typeAdherent.getNbJourMaxProlongement());
        Date dateMaxProlongement = cal.getTime();

        // 8. Vérifier si la date de prolongation choisie est valide
        if (dateProlongement.after(dateMaxProlongement)) {
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
            sdf.setTimeZone(TimeZone.getTimeZone("EAT"));
            return "La date de prolongation choisie (" + sdf.format(dateProlongement) + ") dépasse la date maximale autorisée (" + sdf.format(dateMaxProlongement) + ").";
        }

        // 9. Vérifier si la date de prolongation est postérieure à la date de retour prévue actuelle
        if (!dateProlongement.after(pret.getDateRetourPrevue())) {
            return "La date de prolongation doit être postérieure à la date de retour prévue actuelle.";
        }

        // 10. Vérifier si la date de prolongation tombe un jour férié
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        sdf.setTimeZone(TimeZone.getTimeZone("EAT"));
        List<JourFerie> joursFeries = jourFerieRepository.findAll();
        final String[] dateStrHolder = {sdf.format(dateProlongement)};
        cal.setTime(dateProlongement);
        Date tempDateRetourPrevue = dateProlongement;
        while (joursFeries.stream().anyMatch(jf -> sdf.format(jf.getDateJourferie()).equals(dateStrHolder[0])) || JOURS_FERIES_2025.contains(dateStrHolder[0])) {
            cal.add(Calendar.DAY_OF_MONTH, 1);
            tempDateRetourPrevue = cal.getTime();
            dateStrHolder[0] = sdf.format(tempDateRetourPrevue);
        }
        final Date nouvelleDateRetourPrevue = tempDateRetourPrevue;

        // 11. Vérifier si la nouvelle date est antérieure à la date de fin de l'abonnement
        List<Abonnement> abonnements = abonnementRepository.findByAdherentId(pret.getAdherent().getId_adherent());
        boolean abonnementValide = abonnements.stream()
                .anyMatch(ab -> !ab.getDateDebut().after(nouvelleDateRetourPrevue) && !ab.getDateFin().before(nouvelleDateRetourPrevue));
        if (!abonnementValide) {
            return "La nouvelle date de retour dépasse la date de fin de l'abonnement de l'adhérent.";
        }

        // 12. Créer une demande de prolongation
        Prolongement prolongement = new Prolongement();
        prolongement.setPret(pret);
        prolongement.setDateProlongementProposee(nouvelleDateRetourPrevue);
        prolongement.setStatut("en attente");
        prolongementRepository.save(prolongement);

        return null; // Succès
    }

    public String accepterProlongement(int idProlongement, int idBibliothecaire) {
        // 1. Vérifier l'existence de la demande de prolongation
        Optional<Prolongement> optProlongement = prolongementRepository.findById(idProlongement);
        if (optProlongement.isEmpty()) {
            return "La demande de prolongation n'existe pas.";
        }
        Prolongement prolongement = optProlongement.get();

        // 2. Vérifier si la demande est en attente
        if (!"en attente".equalsIgnoreCase(prolongement.getStatut())) {
            return "La demande de prolongation n'est pas en attente.";
        }

        Pret pret = prolongement.getPret();

        // 3. Vérifier si le prêt est déjà retourné
        if (pret.getDateRetourReelle() != null) {
            return "Le prêt a déjà été retourné.";
        }

        // 4. Vérifier le quota de l'adhérent
        Adherent adherent = pret.getAdherent();
        if (adherent.getQuotaRestant() <= 0) {
            return "L'adhérent a atteint son quota de prêts.";
        }

        // 5. Mettre à jour le prêt
        pret.setDateRetourPrevue(prolongement.getDateProlongementProposee());
        pret.setNbProlongements(pret.getNbProlongements() + 1);
        pretRepository.save(pret);

        // 6. Mettre à jour le statut de la prolongation
        prolongement.setStatut("acceptée");
        prolongementRepository.save(prolongement);

        // 7. Décrémenter le quota de l'adhérent
        int nouveauQuota = adherent.getQuotaRestant() - 1;
        adherent.setQuotaRestant(nouveauQuota);
        adherentRepository.save(adherent);

        return null; // Succès
    }

    public String refuserProlongement(int idProlongement) {
        // 1. Vérifier l'existence de la demande de prolongation
        Optional<Prolongement> optProlongement = prolongementRepository.findById(idProlongement);
        if (optProlongement.isEmpty()) {
            return "La demande de prolongation n'existe pas.";
        }
        Prolongement prolongement = optProlongement.get();

        // 2. Vérifier si la demande est en attente
        if (!"en attente".equalsIgnoreCase(prolongement.getStatut())) {
            return "La demande de prolongation n'est pas en attente.";
        }

        // 3. Mettre à jour le statut de la prolongation
        prolongement.setStatut("refusée");
        prolongementRepository.save(prolongement);

        return null; // Succès
    }
}