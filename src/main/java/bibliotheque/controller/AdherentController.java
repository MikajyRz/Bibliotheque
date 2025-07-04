package bibliotheque.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class AdherentController {

    @GetMapping("/adherent/accueil")
    public String adherentAccueil(HttpSession session, Model model) {
        // Vérification de session et du rôle
        if (!"adherent".equals(session.getAttribute("userRole"))) {
            return "redirect:/auth/login";
        }
        // Passage du nom à la vue
        model.addAttribute("userName", session.getAttribute("userName"));
        // ...autres attributs nécessaires à la page...
        return "adherent_accueil";
    }
}