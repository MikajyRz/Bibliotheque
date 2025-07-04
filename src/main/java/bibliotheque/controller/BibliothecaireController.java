package bibliotheque.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class BibliothecaireController {

    @GetMapping("/bibliothecaires/accueil")
    public String bibliothecaireAccueil(HttpSession session, Model model) {
        // Vérification de session et du rôle
        if (!"bibliothecaire".equals(session.getAttribute("userRole"))) {
            return "redirect:/auth/login";
        }
        model.addAttribute("userName", session.getAttribute("userName"));
        // ...autres attributs nécessaires à la page...
        return "bibliothecaire_accueil";
    }
}