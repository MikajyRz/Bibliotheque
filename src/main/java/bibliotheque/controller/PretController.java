package bibliotheque.controller;

import bibliotheque.entity.Adherent;
import bibliotheque.entity.Exemplaire;
import bibliotheque.entity.Pret;
import bibliotheque.entity.TypePret;
import bibliotheque.service.PretService;
import bibliotheque.repository.AdherentRepository;
import bibliotheque.repository.ExemplaireRepository;
import bibliotheque.repository.PretRepository;
import bibliotheque.repository.TypePretRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.text.SimpleDateFormat;
import java.util.Date;
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
    @Autowired
    private PretRepository pretRepository;

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
            @RequestParam(required = false) String datePret,
            HttpSession session,
            Model model) {
        if (!"bibliothecaire".equals(session.getAttribute("userRole"))) {
            return "redirect:/auth/login";
        }
        
        Integer idBibliothecaire = (Integer) session.getAttribute("userId");
        if (idBibliothecaire == null) {
            model.addAttribute("errorMessage", "Erreur : Identifiant du bibliothécaire non trouvé.");
            model.addAttribute("adherents", adherentRepository.findAll());
            model.addAttribute("exemplaires", exemplaireRepository.findAll());
            model.addAttribute("typesPret", typePretRepository.findAll());
            return "preter_exemplaire";
        }

        // Convertir datePret en Date, ou utiliser la date du jour si vide
        Date pretDate;
        try {
            if (datePret != null && !datePret.isEmpty()) {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                pretDate = sdf.parse(datePret);
            } else {
                pretDate = new Date();
            }
        } catch (Exception e) {
            model.addAttribute("errorMessage", "Erreur : Format de la date de prêt invalide.");
            model.addAttribute("adherents", adherentRepository.findAll());
            model.addAttribute("exemplaires", exemplaireRepository.findAll());
            model.addAttribute("typesPret", typePretRepository.findAll());
            return "preter_exemplaire";
        }

        String erreur = pretService.validerPret(idAdherent, idExemplaire, idTypePret, idBibliothecaire, pretDate);
        model.addAttribute("adherents", adherentRepository.findAll());
        model.addAttribute("exemplaires", exemplaireRepository.findAll());
        model.addAttribute("typesPret", typePretRepository.findAll());

        if (erreur != null) {
            model.addAttribute("errorMessage", erreur);
        } else {
            model.addAttribute("successMessage", "Le prêt a été enregistré avec succès.");
        } 
        return "preter_exemplaire";
    }

    @GetMapping("/historique")
    public String historiquePrets(Model model, HttpSession session) {
        if (!"bibliothecaire".equals(session.getAttribute("userRole"))) {
            return "redirect:/auth/login";
        }
        List<Pret> prets = pretRepository.findAll();
        model.addAttribute("prets", prets);
        return "historique_prets";
    }
}