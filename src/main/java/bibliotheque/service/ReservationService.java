package bibliotheque.service;

import bibliotheque.entity.*;
import bibliotheque.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Optional;
import java.util.TimeZone;

@Service
public class ReservationService {

    @Autowired
    private AdherentRepository adherentRepository;

    @Autowired
    private AbonnementRepository abonnementRepository;

    @Autowired
    private ExemplaireRepository exemplaireRepository;

    @Autowired
    private ReservationRepository reservationRepository;

    @Autowired
    private StatutReservationRepository statutReservationRepository;

    @Autowired
    private StatusExemplaireRepository statusExemplaireRepository;

    @Autowired
    private PretRepository pretRepository;

    @Autowired
    private TypeAdherentRepository typeAdherentRepository;

    @Autowired
    private EtatExemplaireRepository etatExemplaireRepository;

    @Autowired
    private TypePretRepository typePretRepository;

    public String validerReservation(int idAdherent, int idExemplaire, Date dateReservation) {
        // Vérifier que la date n'est pas dans le passé
        Calendar today = Calendar.getInstance(TimeZone.getTimeZone("EAT"));
        today.set(Calendar.HOUR_OF_DAY, 0);
        today.set(Calendar.MINUTE, 0);
        today.set(Calendar.SECOND, 0);
        if (dateReservation.before(today.getTime())) {
            return "La date de réservation ne peut pas être dans le passé.";
        }

        // 1. Vérifier l'existence de l'adhérent
        Optional<Adherent> optAdherent = adherentRepository.findById(idAdherent);
        if (optAdherent.isEmpty()) {
            return "L'adhérent n'existe pas.";
        }
        Adherent adherent = optAdherent.get();

        // 2. Vérifier si l'adhérent a un abonnement valide
        List<Abonnement> abonnements = abonnementRepository.findByAdherentId(idAdherent);
        boolean abonnementValide = abonnements.stream()
                .anyMatch(ab -> !ab.getDateDebut().after(dateReservation) && !ab.getDateFin().before(dateReservation));
        if (!abonnementValide) {
            return "L'adhérent n'a pas d'abonnement valide pour la date de réservation.";
        }

        // 3. Vérifier l'existence de l'exemplaire
        Optional<Exemplaire> optExemplaire = exemplaireRepository.findById(idExemplaire);
        if (optExemplaire.isEmpty()) {
            return "L'exemplaire n'existe pas.";
        }
        Exemplaire exemplaire = optExemplaire.get();

        // 4. Vérifier la disponibilité de l'exemplaire (statut "Disponible")
        List<StatusExemplaire> statuts = statusExemplaireRepository.findByExemplaireIdOrderByDateChangementDesc(idExemplaire);
        if (statuts.isEmpty() || !"Disponible".equalsIgnoreCase(statuts.get(0).getEtatExemplaire().getLibelle())) {
            return "L'exemplaire n'est pas disponible.";
        }

        // 5. Vérifier le nombre maximum de réservations
        Optional<TypeAdherent> optTypeAdherent = typeAdherentRepository.findById(adherent.getTypeAdherent().getId_type_adherent());
        if (optTypeAdherent.isEmpty()) {
            return "Type d'adhérent inconnu.";
        }
        TypeAdherent typeAdherent = optTypeAdherent.get();
        long nbReservationsActives = reservationRepository.findByAdherentId(idAdherent)
                .stream()
                .filter(r -> "en attente".equalsIgnoreCase(r.getStatutReservation().getLibelle()) ||
                             "valide".equalsIgnoreCase(r.getStatutReservation().getLibelle()))
                .count();
        if (nbReservationsActives >= typeAdherent.getNbReservationMax()) {
            return "L'adhérent a atteint le nombre maximum de réservations autorisées.";
        }

        // 6. Vérifier l'âge minimum pour le livre
        Livre livre = exemplaire.getLivre();
        int ageAdherent = getAge(adherent.getDateNaissance(), dateReservation);
        if (livre.getAgeMinimum() > ageAdherent) {
            return "L'adhérent est trop jeune pour réserver ce livre.";
        }

        // 7. Vérifier si l'exemplaire est déjà réservé
        boolean isReserved = reservationRepository.findByExemplaireId(idExemplaire)
                .stream()
                .anyMatch(r -> "en attente".equalsIgnoreCase(r.getStatutReservation().getLibelle()) ||
                               "valide".equalsIgnoreCase(r.getStatutReservation().getLibelle()));
        if (isReserved) {
            return "L'exemplaire est déjà réservé.";
        }

        // 8. Vérifier si l'exemplaire est prêté à la date de réservation
        List<Pret> pretsActifs = pretRepository.findActivePretsByExemplaireAndDate(idExemplaire, dateReservation);
        if (!pretsActifs.isEmpty()) {
            return "L'exemplaire est prêté à la date de réservation.";
        }

        // 9. Créer la réservation avec statut "en attente"
        Reservation reservation = new Reservation();
        reservation.setAdherent(adherent);
        reservation.setExemplaire(exemplaire);
        reservation.setDateReservation(dateReservation);
        Optional<StatutReservation> optStatutEnAttente = statutReservationRepository.findByLibelle("en attente");
        if (optStatutEnAttente.isEmpty()) {
            return "Statut 'en attente' non trouvé dans la base de données.";
        }
        StatutReservation statutEnAttente = optStatutEnAttente.get();
        reservation.setStatutReservation(statutEnAttente);
        reservationRepository.save(reservation);

        return null; // Succès
    }

    public String accepterReservation(int idReservation, int userId, int idAdherent, int idExemplaire, Date dateReservation) {
        // 1. Vérifier l'existence de la réservation
        Optional<Reservation> optReservation = reservationRepository.findById(idReservation);
        if (optReservation.isEmpty()) {
            return "La réservation n'existe pas.";
        }
        Reservation reservation = optReservation.get();

        // 2. Vérifier que la réservation est en attente
        if (!"en attente".equalsIgnoreCase(reservation.getStatutReservation().getLibelle())) {
            return "La réservation n'est pas en attente et ne peut pas être acceptée.";
        }

        // Récupérer l'adhérent sans vérifier son existence
        Optional<Adherent> optAdherent = adherentRepository.findById(idAdherent);
        Adherent adherent = optAdherent.orElse(null);
        if (adherent == null) {
            return "L'adhérent n'existe pas.";
        }

        // 3. Vérifier l'existence de l'exemplaire
        Optional<Exemplaire> optExemplaire = exemplaireRepository.findById(idExemplaire);
        if (optExemplaire.isEmpty()) {
            return "L'exemplaire n'existe pas.";
        }
        Exemplaire exemplaire = optExemplaire.get();

        // 4. Vérifier la disponibilité de l'exemplaire
        List<StatusExemplaire> statuts = statusExemplaireRepository.findByExemplaireIdOrderByDateChangementDesc(idExemplaire);
        if (statuts.isEmpty() || !"Disponible".equalsIgnoreCase(statuts.get(0).getEtatExemplaire().getLibelle())) {
            return "L'exemplaire n'est pas disponible.";
        }

        // 5. Vérifier l'abonnement valide
        List<Abonnement> abonnements = abonnementRepository.findByAdherentId(idAdherent);
        boolean abonnementValide = abonnements.stream()
                .anyMatch(ab -> !ab.getDateDebut().after(dateReservation) && !ab.getDateFin().before(dateReservation));
        if (!abonnementValide) {
            return "L'adhérent n'a pas d'abonnement valide pour la date de réservation.";
        }

        // 6. Vérifier le quota restant
        if (adherent.getQuotaRestant() <= 0) {
            return "L'adhérent a atteint son quota de prêts.";
        }

        // 7. Mettre à jour le statut de la réservation à "valide"
        Optional<StatutReservation> optStatutValide = statutReservationRepository.findByLibelle("valide");
        if (optStatutValide.isEmpty()) {
            return "Statut 'valide' non trouvé dans la base de données.";
        }
        StatutReservation statutValide = optStatutValide.get();
        reservation.setStatutReservation(statutValide);
        reservationRepository.save(reservation);

        // 8. Créer un prêt
        Pret pret = new Pret();
        pret.setAdherent(adherent);
        pret.setExemplaire(exemplaire);
        pret.setDatePret(dateReservation);
        TypeAdherent typeAdherent = adherent.getTypeAdherent();
        pret.setDateRetourPrevue(calculerDateRetourPrevue(dateReservation, typeAdherent.getDureePret()));
        Optional<TypePret> optTypePret = typePretRepository.findByLibelle("A domicile");
        if (optTypePret.isEmpty()) {
            return "Type de prêt 'A domicile' non trouvé dans la base de données.";
        }
        TypePret typePret = optTypePret.get();
        pret.setTypePret(typePret);
        pretRepository.save(pret);

        // 9. Mettre à jour le statut de l'exemplaire à "Emprunté"
        StatusExemplaire statutExemplaire = new StatusExemplaire();
        statutExemplaire.setExemplaire(exemplaire);
        statutExemplaire.setDateChangement(dateReservation);
        Optional<EtatExemplaire> optEtatEmprunte = etatExemplaireRepository.findByLibelle("Emprunte");
        if (optEtatEmprunte.isEmpty()) {
            return "Statut 'Emprunte' non trouvé dans la base de données.";
        }
        EtatExemplaire etatEmprunte = optEtatEmprunte.get();
        statutExemplaire.setEtatExemplaire(etatEmprunte);
        Bibliothecaire bibliothecaire = new Bibliothecaire();
        bibliothecaire.setId_biblio(userId);
        statutExemplaire.setBibliothecaire(bibliothecaire);
        statusExemplaireRepository.save(statutExemplaire);

        // 10. Décrementer le quota de l'adhérent
        adherent.setQuotaRestant(adherent.getQuotaRestant() - 1);
        adherentRepository.save(adherent);

        return null; // Succès
    }

    public String refuserReservation(int idReservation) {
        // 1. Vérifier l'existence de la réservation
        Optional<Reservation> optReservation = reservationRepository.findById(idReservation);
        if (optReservation.isEmpty()) {
            return "La réservation n'existe pas.";
        }
        Reservation reservation = optReservation.get();

        // 2. Vérifier que la réservation est en attente
        if (!"en attente".equalsIgnoreCase(reservation.getStatutReservation().getLibelle())) {
            return "La réservation n'est pas en attente et ne peut pas être refusée.";
        }

        // 3. Mettre à jour le statut de la réservation à "non valide"
        Optional<StatutReservation> optStatutNonValide = statutReservationRepository.findByLibelle("non valide");
        if (optStatutNonValide.isEmpty()) {
            return "Statut 'non valide' non trouvé dans la base de données.";
        }
        StatutReservation statutNonValide = optStatutNonValide.get();
        reservation.setStatutReservation(statutNonValide);
        reservationRepository.save(reservation);

        // L'exemplaire reste disponible, pas de changement de statut
        // Pas de changement sur le quota de l'adhérent
        return null; // Succès
    }

    private int getAge(Date naissance, Date today) {
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

    private Date calculerDateRetourPrevue(Date datePret, int dureePret) {
        Calendar cal = Calendar.getInstance(TimeZone.getTimeZone("EAT"));
        cal.setTime(datePret);
        cal.add(Calendar.DATE, dureePret);
        return cal.getTime();
    }
}