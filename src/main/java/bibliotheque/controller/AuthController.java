package bibliotheque.controller;

import bibliotheque.service.AuthService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/auth")
public class AuthController {

    @Autowired
    private AuthService authService;

    @GetMapping("/login")
    public String loginPage() {
        return "login";
    }

    @PostMapping("/login")
    public String login(
        @RequestParam("email") String email,
        @RequestParam("motDePasse") String motDePasse,
        HttpSession session,
        Model model
    ) {
        try {
            String role = authService.authenticate(email, motDePasse, session);
            if ("adherent".equals(role)) {
                return "redirect:/adherent/accueil";
            } else if ("bibliothecaire".equals(role)) {
                return "redirect:/bibliothecaires/accueil";
            } else {
                model.addAttribute("error", "Rôle inconnu.");
                return "login";
            }
        } catch (RuntimeException ex) {
            model.addAttribute("error", ex.getMessage());
            return "login";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/auth/login";
    }
}