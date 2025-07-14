package bibliotheque.controller;

import bibliotheque.entity.Adherent;
import bibliotheque.entity.Pret;
import bibliotheque.repository.AdherentRepository;
import bibliotheque.repository.PretRepository;
import bibliotheque.service.PenaliteService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.TimeZone;

@Controller
@RequestMapping("/penalites")
public class PenaliteController {

    @Autowired
    private PenaliteService penaliteService;

    @Autowired
    private AdherentRepository adherentRepository;

    @Autowired
    private PretRepository pretRepository;

    @GetMapping("/appliquer")
    public String formPenalite(Model model, HttpSession session) {
        if (!"bibliothecaire".equals(session.getAttribute("userRole"))) {
            return "redirect:/auth/login";
        }
        List<Adherent> adherents = adherentRepository.findAll();
        List<Pret> prets = pretRepository.findAll();
        model.addAttribute("adherents", adherents);
        model.addAttribute("prets", prets);
        model.addAttribute("section", "penalite");
        model.addAttribute("userName", session.getAttribute("userName"));
        return "bibliothecaire_accueil";
    }

    @PostMapping("/appliquer")
    public String traiterPenalite(
            @RequestParam int idPret,
            @RequestParam int idAdherent,
            @RequestParam int dureePenalite,
            @RequestParam String dateApplication,
            HttpSession session,
            Model model) {
        if (!"bibliothecaire".equals(session.getAttribute("userRole"))) {
            return "redirect:/auth/login";
        }

        Date applicationDate;
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            sdf.setTimeZone(TimeZone.getTimeZone("EAT"));
            applicationDate = sdf.parse(dateApplication);
        } catch (Exception e) {
            model.addAttribute("errorMessage", "Erreur : Format de la date d'application invalide.");
            model.addAttribute("adherents", adherentRepository.findAll());
            model.addAttribute("prets", pretRepository.findAll());
            model.addAttribute("section", "penalite");
            model.addAttribute("userName", session.getAttribute("userName"));
            return "bibliothecaire_accueil";
        }

        String resultat = penaliteService.appliquerPenalite(idPret, idAdherent, dureePenalite, applicationDate);
        model.addAttribute("adherents", adherentRepository.findAll());
        model.addAttribute("prets", pretRepository.findAll());
        model.addAttribute("section", "penalite");
        model.addAttribute("userName", session.getAttribute("userName"));

        if (resultat == null) {
            model.addAttribute("successMessage", "La pénalité a été appliquée avec succès.");
        } else {
            model.addAttribute("errorMessage", resultat);
        }

        return "bibliothecaire_accueil";
    }
}