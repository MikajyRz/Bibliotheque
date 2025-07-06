package bibliotheque.service;

import java.time.LocalDate;
import java.time.Period;
import java.util.Arrays;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import bibliotheque.entity.Adherent;
import bibliotheque.entity.Exemplaire;
import bibliotheque.entity.Livre;
import bibliotheque.entity.Pret;
import bibliotheque.entity.Reservation;
import bibliotheque.entity.StatusExemplaire;
import bibliotheque.repository.AbonnementRepository;
import bibliotheque.repository.AdherentRepository;
import bibliotheque.repository.ExemplaireRepository;
import bibliotheque.repository.PretRepository;
import bibliotheque.repository.ReservationRepository;
import bibliotheque.repository.StatusExemplaireRepository;

@Service
public class ReservationService {
    @Autowired
    private ReservationRepository reservationRepository;
    @Autowired
    private AdherentRepository adherentRepository;
    @Autowired
    private ExemplaireRepository exemplaireRepository;
    @Autowired
    private StatusExemplaireRepository statusExemplaireRepository;
    @Autowired
    private PretRepository pretRepository;
    @Autowired
    private StatutReservationRepository statutReservationRepository;
    @Autowired
    private AbonnementRepository abonnementRepository;
    @Autowired
    private LivreRepository livreRepository;

    public void createReservation(Long idAdherent, Long idExemplaire, LocalDate dateReservation) {
        // Vérifier que l'adhérent existe
        Adherent adherent = adherentRepository.findById(idAdherent)
            .orElseThrow(() -> new IllegalArgumentException("L'adhérent n'existe pas."));

        // Vérifier l'abonnement valide
        boolean hasValidSubscription = abonnementRepository.findByIdAdherent(idAdherent).stream()
            .anyMatch(ab -> !dateReservation.isBefore(ab.getDateDebut()) && !dateReservation.isAfter(ab.getDateFin()));
        if (!hasValidSubscription) {
            throw new IllegalArgumentException("L'adhérent n'a pas d'abonnement valide pour cette date.");
        }

        // Vérifier que l'exemplaire existe
        Exemplaire exemplaire = exemplaireRepository.findById(idExemplaire)
            .orElseThrow(() -> new IllegalArgumentException("L'exemplaire n'existe pas."));

        // Vérifier l'état de l'exemplaire (disponible)
        StatusExemplaire latestStatus = statusExemplaireRepository.findTopByIdExemplaireOrderByDateChangementDesc(idExemplaire);
        if (latestStatus == null || !latestStatus.getEtatExemplaire().getLibelle().equals("disponible")) {
            throw new IllegalArgumentException("L'exemplaire n'est pas disponible.");
        }

        // Vérifier le quota de réservations
        long activeReservations = reservationRepository.countByIdAdherentAndIdStatutReservation(idAdherent, 
            statutReservationRepository.findByLibelle("valide").getIdStatutReservation());
        if (activeReservations >= adherent.getTypeAdherent().getNbReservationMax()) {
            throw new IllegalArgumentException("Le quota de réservations maximum est atteint.");
        }

        // Vérifier l'âge minimum
        Livre livre = livreRepository.findById(exemplaire.getIdLivre()).orElseThrow();
        LocalDate birthDate = adherent.getDateNaissance();
        int age = Period.between(birthDate, dateReservation).getYears();
        if (age < livre.getAgeMinimum()) {
            throw new IllegalArgumentException("L'adhérent est trop jeune pour réserver ce livre.");
        }

        // Vérifier si l'exemplaire est réservé
        boolean isReserved = reservationRepository.findByIdExemplaireAndDateReservationAndIdStatutReservationIn(
            idExemplaire, dateReservation, Arrays.asList(
                statutReservationRepository.findByLibelle("en attente").getIdStatutReservation(),
                statutReservationRepository.findByLibelle("valide").getIdStatutReservation()
            )).isPresent();
        if (isReserved) {
            throw new IllegalArgumentException("L'exemplaire est déjà réservé à cette date.");
        }

        // Vérifier si l'exemplaire est prêté
        boolean isBorrowed = pretRepository.findByIdExemplaireAndDatePretLessThanEqualAndDateRetourPrevueGreaterThanEqualAndDateRetourReelleIsNull(
            idExemplaire, dateReservation, dateReservation).isPresent();
        if (isBorrowed) {
            throw new IllegalArgumentException("L'exemplaire est prêté à la date de réservation.");
        }

        // Créer la réservation
        Reservation reservation = new Reservation();
        reservation.setAdherent(adherent);
        reservation.setExemplaire(exemplaire);
        reservation.setDateReservation(dateReservation);
        reservation.setStatutReservation(statutReservationRepository.findByLibelle("en attente"));
        reservationRepository.save(reservation);
    }

    public List<Reservation> findAllPending() {
        return reservationRepository.findByIdStatutReservation(
            statutReservationRepository.findByLibelle("en attente").getIdStatutReservation());
    }

    public void acceptReservation(Long idReservation, Long idAdherent, Long idExemplaire, LocalDate dateReservation) {
        Reservation reservation = reservationRepository.findById(idReservation)
            .orElseThrow(() -> new IllegalArgumentException("La réservation n'existe pas."));
        Adherent adherent = adherentRepository.findById(idAdherent).orElseThrow();
        Exemplaire exemplaire = exemplaireRepository.findById(idExemplaire).orElseThrow();

        // Mettre à jour le statut de la réservation
        reservation.setStatutReservation(statutReservationRepository.findByLibelle("valide"));
        reservationRepository.save(reservation);

        // Créer un prêt
        Pret pret = new Pret();
        pret.setAdherent(adherent);
        pret.setExemplaire(exemplaire);
        pret.setTypePret(pretRepository.findDefaultTypePret()); // À implémenter
        pret.setDatePret(dateReservation);
        pret.setDateRetourPrevue(dateReservation.plusDays(adherent.getTypeAdherent().getDureePret()));
        pret.setNbProlongements(0);
        pretRepository.save(pret);

        // Décrémenter le quota restant
        adherent.setQuotaRestant(adherent.getQuotaRestant() - 1);
        adherentRepository.save(adherent);

        // Mettre à jour le statut de l'exemplaire
        StatusExemplaire status = new StatusExemplaire();
        status.setExemplaire(exemplaire);
        status.setEtatExemplaire(etatExemplaireRepository.findByLibelle("non disponible"));
        status.setDateChangement(dateReservation);
        status.setBibliothecaire(bibliothecaireRepository.findById(getCurrentBibliothecaireId()).orElse(null));
        statusExemplaireRepository.save(status);
    }

    public void rejectReservation(Long idReservation) {
        Reservation reservation = reservationRepository.findById(idReservation)
            .orElseThrow(() -> new IllegalArgumentException("La réservation n'existe pas."));
        reservation.setStatutReservation(statutReservationRepository.findByLibelle("non valide"));
        reservationRepository.save(reservation);
    }
}
