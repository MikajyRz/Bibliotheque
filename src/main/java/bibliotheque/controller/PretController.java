package bibliotheque.controller;

import bibliotheque.entity.Adherent;
import bibliotheque.entity.Exemplaire;
import bibliotheque.entity.TypePret;
import bibliotheque.service.PretService;
import bibliotheque.repository.AdherentRepository;
import bibliotheque.repository.ExemplaireRepository;
import bibliotheque.repository.TypePretRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/prets")
public class PretController {

    @Autowired
    private PretService pretService;
    @Autowired
    private AdherentRepository adherentRepository;
    @Autowired
    private ExemplaireRepository exemplaireRepository;
    @Autowired
    private TypePretRepository typePretRepository;

    // Lien depuis bibliothecaire_accueil
    @GetMapping("/nouveau")
    public String formPret(Model model, HttpSession session) {
        // Vérification du rôle
        if (!"bibliothecaire".equals(session.getAttribute("userRole"))) {
            return "redirect:/auth/login";
        }
        List<Adherent> adherents = adherentRepository.findAll();
        List<Exemplaire> exemplaires = exemplaireRepository.findAll();
        List<TypePret> typesPret = typePretRepository.findAll();
        model.addAttribute("adherents", adherents);
        model.addAttribute("exemplaires", exemplaires);
        model.addAttribute("typesPret", typesPret);
        return "preter_exemplaire";
    }

    @PostMapping("/nouveau")
    public String traiterPret(
            @RequestParam int idAdherent,
            @RequestParam int idExemplaire,
            @RequestParam int idTypePret,
            HttpSession session,
            Model model) {
        if (!"bibliothecaire".equals(session.getAttribute("userRole"))) {
            return "redirect:/auth/login";
        }
        Integer idBibliothecaire = (Integer) session.getAttribute("userId");
        String erreur = pretService.validerPret(idAdherent, idExemplaire, idTypePret, idBibliothecaire);
        if (erreur != null) {
            model.addAttribute("error", erreur);
            return "erreur_pret";
        }
        model.addAttribute("success", "Le prêt a bien été enregistré.");
        return "success_pret";
    }
}