package bibliotheque.controller;

import bibliotheque.entity.Adherent;
import bibliotheque.entity.Exemplaire;
import bibliotheque.entity.Reservation;
import bibliotheque.entity.StatusExemplaire;
import bibliotheque.repository.AdherentRepository;
import bibliotheque.repository.ExemplaireRepository;
import bibliotheque.repository.ReservationRepository;
import bibliotheque.repository.StatusExemplaireRepository;
import bibliotheque.service.ReservationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

@Controller
public class ReservationController {

    @Autowired
    private ReservationService reservationService;

    @Autowired
    private AdherentRepository adherentRepository;

    @Autowired
    private ExemplaireRepository exemplaireRepository;

    @Autowired
    private StatusExemplaireRepository statusExemplaireRepository;

    @Autowired
    private ReservationRepository reservationRepository;

    @GetMapping("/reservations/nouveau/accueil")
    public String showReservationForm(Model model) {
        // Charger tous les adhérents
        List<Adherent> adherents = adherentRepository.findAll();
        model.addAttribute("adherents", adherents);

        // Charger les exemplaires disponibles
        List<Exemplaire> exemplaires = exemplaireRepository.findAll().stream()
                .filter(exemplaire -> {
                    List<StatusExemplaire> statuts = statusExemplaireRepository
                            .findByExemplaireIdOrderByDateChangementDesc(exemplaire.getId_exemplaire());
                    return !statuts.isEmpty() && "Disponible".equalsIgnoreCase(statuts.get(0).getEtatExemplaire().getLibelle());
                })
                .collect(Collectors.toList());
        model.addAttribute("exemplaires", exemplaires);

        model.addAttribute("section", "reservation");
        return "bibliothecaire_accueil";
    }

    @GetMapping("/reservations/demandes/accueil")
    public String showReservationRequests(Model model) {
        // Charger les réservations en attente
        List<Reservation> reservations = reservationRepository.findByStatutReservationLibelle("en attente");
        model.addAttribute("reservations", reservations);
        model.addAttribute("section", "demande_reservation");
        return "bibliothecaire_accueil";
    }

    @PostMapping("/reservations/nouveau")
    public String createReservation(
            @RequestParam("idAdherent") int idAdherent,
            @RequestParam("idExemplaire") int idExemplaire,
            @RequestParam("dateReservation") String dateReservationStr,
            Model model,
            HttpSession session) {
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date dateReservation = sdf.parse(dateReservationStr);
            String result = reservationService.validerReservation(idAdherent, idExemplaire, dateReservation);
            if (result == null) {
                model.addAttribute("successMessage", "Réservation créée avec succès.");
            } else {
                model.addAttribute("errorMessage", result);
            }
        } catch (Exception e) {
            model.addAttribute("errorMessage", "Erreur lors de la création de la réservation : " + e.getMessage());
        }
        // Recharger les listes pour réafficher le formulaire
        model.addAttribute("adherents", adherentRepository.findAll());
        model.addAttribute("exemplaires", exemplaireRepository.findAll().stream()
                .filter(exemplaire -> {
                    List<StatusExemplaire> statuts = statusExemplaireRepository
                            .findByExemplaireIdOrderByDateChangementDesc(exemplaire.getId_exemplaire());
                    return !statuts.isEmpty() && "Disponible".equalsIgnoreCase(statuts.get(0).getEtatExemplaire().getLibelle());
                })
                .collect(Collectors.toList()));
        model.addAttribute("section", "reservation");
        return "bibliothecaire_accueil";
    }

    @PostMapping("/reservations/accepter")
    public String acceptReservation(
            @RequestParam("idReservation") int idReservation,
            @RequestParam("idAdherent") int idAdherent,
            @RequestParam("idExemplaire") int idExemplaire,
            @RequestParam("dateReservation") String dateReservationStr,
            Model model,
            HttpSession session) {
        Integer userId = (Integer) session.getAttribute("userId");
        String userRole = (String) session.getAttribute("userRole");
        if (userId == null || !"bibliothecaire".equals(userRole)) {
            model.addAttribute("errorMessage", "Utilisateur non authentifié ou non autorisé.");
            model.addAttribute("reservations", reservationRepository.findByStatutReservationLibelle("en attente"));
            model.addAttribute("section", "demande_reservation");
            return "bibliothecaire_accueil";
        }
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date dateReservation = sdf.parse(dateReservationStr);
            String result = reservationService.accepterReservation(idReservation, userId, idAdherent, idExemplaire, dateReservation);
            if (result == null) {
                model.addAttribute("successMessage", "Réservation acceptée avec succès.");
            } else {
                model.addAttribute("errorMessage", result);
            }
        } catch (Exception e) {
            model.addAttribute("errorMessage", "Erreur lors de l'acceptation de la réservation : " + e.getMessage());
        }
        // Recharger les réservations en attente
        model.addAttribute("reservations", reservationRepository.findByStatutReservationLibelle("en attente"));
        model.addAttribute("section", "demande_reservation");
        return "bibliothecaire_accueil";
    }

    @PostMapping("/reservations/refuser")
    public String refuseReservation(
            @RequestParam("idReservation") int idReservation,
            Model model,
            HttpSession session) {
        Integer userId = (Integer) session.getAttribute("userId");
        String userRole = (String) session.getAttribute("userRole");
        if (userId == null || !"bibliothecaire".equals(userRole)) {
            model.addAttribute("errorMessage", "Utilisateur non authentifié ou non autorisé.");
            model.addAttribute("reservations", reservationRepository.findByStatutReservationLibelle("en attente"));
            model.addAttribute("section", "demande_reservation");
            return "bibliothecaire_accueil";
        }
        try {
            String result = reservationService.refuserReservation(idReservation);
            if (result == null) {
                model.addAttribute("successMessage", "Réservation refusée avec succès.");
            } else {
                model.addAttribute("errorMessage", result);
            }
        } catch (Exception e) {
            model.addAttribute("errorMessage", "Erreur lors du refus de la réservation : " + e.getMessage());
        }
        // Recharger les réservations en attente
        model.addAttribute("reservations", reservationRepository.findByStatutReservationLibelle("en attente"));
        model.addAttribute("section", "demande_reservation");
        return "bibliothecaire_accueil";
    }
}
