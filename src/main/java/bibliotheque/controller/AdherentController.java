package bibliotheque.controller;

import bibliotheque.entity.Adherent;
import bibliotheque.entity.Exemplaire;
import bibliotheque.entity.Livre;
import bibliotheque.entity.StatusExemplaire;
import bibliotheque.repository.AdherentRepository;
import bibliotheque.repository.ExemplaireRepository;
import bibliotheque.repository.LivreRepository;
import bibliotheque.repository.StatusExemplaireRepository;
import bibliotheque.service.LivreService;
import bibliotheque.service.PretService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpSession;
// import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class AdherentController {

    @Autowired
    private AdherentRepository adherentRepository;

    @Autowired
    private ExemplaireRepository exemplaireRepository;

    @Autowired
    private StatusExemplaireRepository statusExemplaireRepository;

    @Autowired
    private LivreRepository livreRepository;

    @Autowired
    private PretService pretService;

    @Autowired
    private LivreService livreService;

    @GetMapping("/adherent/accueil")
    public String showAdherentAccueil(Model model, HttpSession session) {
        Integer userId = (Integer) session.getAttribute("userId");
        String userRole = (String) session.getAttribute("userRole");
        if (userId == null || !"adherent".equals(userRole)) {
            model.addAttribute("error", "Utilisateur non authentifié ou non autorisé.");
            return "redirect:/";
        }

        Adherent adherent = adherentRepository.findById(userId).orElse(null);
        if (adherent == null) {
            model.addAttribute("error", "Adhérent non trouvé.");
            return "redirect:/";
        }

        // Charger tous les livres
        List<Livre> livres = livreRepository.findAll();
        model.addAttribute("livres", livres);

        // Charger les exemplaires
        List<Exemplaire> exemplaires = exemplaireRepository.findAll();
        model.addAttribute("exemplaires", exemplaires);

        // Charger les statuts des exemplaires
        Map<Integer, String> statutsExemplaires = new HashMap<>();
        for (Exemplaire exemplaire : exemplaires) {
            List<StatusExemplaire> statuts = statusExemplaireRepository.findByExemplaireIdOrderByDateChangementDesc(exemplaire.getId_exemplaire());
            String statut = statuts.isEmpty() ? "Inconnu" : statuts.get(0).getEtatExemplaire().getLibelle();
            statutsExemplaires.put(exemplaire.getId_exemplaire(), statut);
        }
        model.addAttribute("statutsExemplaires", statutsExemplaires);

        // Charger les livres suggérés
        List<Livre> livresSuggeres = livreService.getSuggestedLivres(userId);
        model.addAttribute("livresSuggeres", livresSuggeres);

        model.addAttribute("userName", adherent.getNom());
        return "adherent_accueil";
    }

    @PostMapping("/adherent/emprunter")
    public String emprunterLivre(
            @RequestParam("idExemplaire") int idExemplaire,
            @RequestParam("idTypePret") int idTypePret,
            Model model,
            HttpSession session) {
        Integer userId = (Integer) session.getAttribute("userId");
        String userRole = (String) session.getAttribute("userRole");
        if (userId == null || !"adherent".equals(userRole)) {
            model.addAttribute("error", "Utilisateur non authentifié ou non autorisé.");
            return "redirect:/";
        }

        try {
            String result = pretService.validerPret(userId, idExemplaire, idTypePret, 1, new Date());
            if (result == null) {
                model.addAttribute("success", "Prêt effectué avec succès.");
            } else {
                model.addAttribute("error", result);
            }
        } catch (Exception e) {
            model.addAttribute("error", "Erreur lors du prêt : " + e.getMessage());
        }

        // Recharger les données
        List<Livre> livres = livreRepository.findAll();
        model.addAttribute("livres", livres);
        List<Exemplaire> exemplaires = exemplaireRepository.findAll();
        model.addAttribute("exemplaires", exemplaires);
        Map<Integer, String> statutsExemplaires = new HashMap<>();
        for (Exemplaire exemplaire : exemplaires) {
            List<StatusExemplaire> statuts = statusExemplaireRepository.findByExemplaireIdOrderByDateChangementDesc(exemplaire.getId_exemplaire());
            String statut = statuts.isEmpty() ? "Inconnu" : statuts.get(0).getEtatExemplaire().getLibelle();
            statutsExemplaires.put(exemplaire.getId_exemplaire(), statut);
        }
        model.addAttribute("statutsExemplaires", statutsExemplaires);
        List<Livre> livresSuggeres = livreService.getSuggestedLivres(userId);
        model.addAttribute("livresSuggeres", livresSuggeres);
        Adherent adherent = adherentRepository.findById(userId).orElse(null);
        model.addAttribute("userName", adherent != null ? adherent.getNom() : "Adhérent");
        return "adherent_accueil";
    }
}