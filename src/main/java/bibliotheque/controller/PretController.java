package bibliotheque.controller;

import bibliotheque.entity.Adherent;
import bibliotheque.entity.Exemplaire;
import bibliotheque.entity.Pret;
import bibliotheque.entity.Prolongement;
import bibliotheque.entity.TypePret;
import bibliotheque.repository.AdherentRepository;
import bibliotheque.repository.ExemplaireRepository;
import bibliotheque.repository.ProlongementRepository;
import bibliotheque.repository.PretRepository;
import bibliotheque.repository.TypePretRepository;
import bibliotheque.service.PretService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.TimeZone;

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
    @Autowired
    private ProlongementRepository prolongementRepository;

    @GetMapping("/nouveau/accueil")
    public String formPretAccueil(@RequestParam(value = "section", defaultValue = "pret") String section, Model model, HttpSession session) {
        if (!"bibliothecaire".equals(session.getAttribute("userRole"))) {
            return "redirect:/auth/login";
        }
        List<Adherent> adherents = adherentRepository.findAll();
        List<Exemplaire> exemplaires = exemplaireRepository.findAll();
        List<TypePret> typesPret = typePretRepository.findAll();
        model.addAttribute("adherents", adherents);
        model.addAttribute("exemplaires", exemplaires);
        model.addAttribute("typesPret", typesPret);
        model.addAttribute("section", section);
        model.addAttribute("userName", session.getAttribute("userName"));
        return "bibliothecaire_accueil";
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
            model.addAttribute("section", "pret");
            model.addAttribute("userName", session.getAttribute("userName"));
            return "bibliothecaire_accueil";
        }

        Date pretDate;
        try {
            if (datePret != null && !datePret.isEmpty()) {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                sdf.setTimeZone(TimeZone.getTimeZone("EAT"));
                pretDate = sdf.parse(datePret);
            } else {
                pretDate = new Date();
            }
        } catch (Exception e) {
            model.addAttribute("errorMessage", "Erreur : Format de la date de prêt invalide.");
            model.addAttribute("adherents", adherentRepository.findAll());
            model.addAttribute("exemplaires", exemplaireRepository.findAll());
            model.addAttribute("typesPret", typePretRepository.findAll());
            model.addAttribute("section", "pret");
            model.addAttribute("userName", session.getAttribute("userName"));
            return "bibliothecaire_accueil";
        }

        String resultat = pretService.validerPret(idAdherent, idExemplaire, idTypePret, idBibliothecaire, pretDate);
        model.addAttribute("adherents", adherentRepository.findAll());
        model.addAttribute("exemplaires", exemplaireRepository.findAll());
        model.addAttribute("typesPret", typePretRepository.findAll());
        model.addAttribute("section", "pret");
        model.addAttribute("userName", session.getAttribute("userName"));

        if (resultat == null) {
            model.addAttribute("successMessage", "Le prêt a bien été enregistré.");
        } else {
            model.addAttribute("errorMessage", resultat);
        }

        return "bibliothecaire_accueil";
    }

    @GetMapping("/historique/accueil")
    public String historiquePretsAccueil(@RequestParam(value = "section", defaultValue = "historique") String section, Model model, HttpSession session) {
        if (!"bibliothecaire".equals(session.getAttribute("userRole"))) {
            return "redirect:/auth/login";
        }
        List<Pret> prets = pretRepository.findAll();
        List<TypePret> typesPret = typePretRepository.findAll();
        model.addAttribute("prets", prets);
        model.addAttribute("typesPret", typesPret);
        model.addAttribute("section", section);
        model.addAttribute("userName", session.getAttribute("userName"));
        return "bibliothecaire_accueil";
    }

    @GetMapping("/recherche")
    public String formRecherche(@RequestParam(value = "section", defaultValue = "recherche") String section, Model model, HttpSession session) {
        if (!"bibliothecaire".equals(session.getAttribute("userRole"))) {
            return "redirect:/auth/login";
        }
        List<TypePret> typesPret = typePretRepository.findAll();
        model.addAttribute("typesPret", typesPret);
        model.addAttribute("section", section);
        model.addAttribute("userName", session.getAttribute("userName"));
        return "bibliothecaire_accueil";
    }

    @PostMapping("/recherche")
    public String traiterRecherche(
            @RequestParam(required = false) String adherent,
            @RequestParam(required = false) String exemplaire,
            @RequestParam(required = false) Integer idTypePret,
            @RequestParam(required = false) String dateDebut,
            @RequestParam(required = false) String dateFin,
            HttpSession session,
            Model model) {
        if (!"bibliothecaire".equals(session.getAttribute("userRole"))) {
            return "redirect:/auth/login";
        }

        List<Pret> prets = pretService.rechercherPrets(adherent, exemplaire, idTypePret, dateDebut, dateFin);
        model.addAttribute("searchResults", prets);
        model.addAttribute("prets", prets);
        model.addAttribute("section", "recherche");
        model.addAttribute("userName", session.getAttribute("userName"));
        model.addAttribute("typesPret", typePretRepository.findAll());

        return "bibliothecaire_accueil";
    }

    @PostMapping("/retour")
    public String traiterRetour(
            @RequestParam int idAdherent,
            @RequestParam int idExemplaire,
            @RequestParam String dateRetour,
            @RequestParam(required = false) String adherent,
            @RequestParam(required = false) String exemplaire,
            @RequestParam(required = false) Integer idTypePret,
            @RequestParam(required = false) String dateDebut,
            @RequestParam(required = false) String dateFin,
            HttpSession session,
            Model model) {
        if (!"bibliothecaire".equals(session.getAttribute("userRole"))) {
            return "redirect:/auth/login";
        }
        Integer idBibliothecaire = (Integer) session.getAttribute("userId");
        if (idBibliothecaire == null) {
            model.addAttribute("errorMessage", "Erreur : Identifiant du bibliothécaire non trouvé.");
            model.addAttribute("typesPret", typePretRepository.findAll());
            model.addAttribute("section", "recherche");
            model.addAttribute("userName", session.getAttribute("userName"));
            return "bibliothecaire_accueil";
        }

        String resultat = pretService.retournerPret(idAdherent, idExemplaire, dateRetour, idBibliothecaire);
        List<TypePret> typesPret = typePretRepository.findAll();
        model.addAttribute("typesPret", typesPret);
        model.addAttribute("section", "recherche");
        model.addAttribute("userName", session.getAttribute("userName"));

        // Relancer la recherche pour rafraîchir les résultats
        List<Pret> prets = pretService.rechercherPrets(adherent, exemplaire, idTypePret, dateDebut, dateFin);
        model.addAttribute("searchResults", prets);
        model.addAttribute("prets", prets);

        if (resultat == null) {
            model.addAttribute("successMessage", "Le retour a bien été enregistré.");
        } else {
            model.addAttribute("errorMessage", resultat);
        }

        return "bibliothecaire_accueil";
    }

    @PostMapping("/demander-prolongement")
    public String demanderProlongement(
            @RequestParam("idPret") int idPret,
            // @RequestParam("idBibliothecaire") int idBibliothecaire,
            @RequestParam("dateProlongement") String dateProlongement,
            Model model,
            HttpSession session) {
        if (!"bibliothecaire".equals(session.getAttribute("userRole"))) {
            return "redirect:/auth/login";
        }

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        sdf.setTimeZone(TimeZone.getTimeZone("EAT"));
        try {
            Date dateProlongementParsed = sdf.parse(dateProlongement);
            String result = pretService.demanderProlongement(idPret,  dateProlongementParsed);
            if (result != null) {
                model.addAttribute("errorMessage", result);
            } else {
                model.addAttribute("successMessage", "Demande de prolongation enregistrée avec succès.");
            }
        } catch (Exception e) {
            model.addAttribute("errorMessage", "Format de date invalide.");
        }

        model.addAttribute("section", "recherche_prets");
        return "bibliothecaire_accueil";
    }

    @GetMapping("/prolongements/demandes")
    public String afficherDemandesProlongement(Model model, HttpSession session) {
        if (!"bibliothecaire".equals(session.getAttribute("userRole"))) {
            return "redirect:/auth/login";
        }
        List<Prolongement> prolongements = prolongementRepository.findAllEnAttente();
        model.addAttribute("prolongements", prolongements);
        model.addAttribute("section", "demandes_prolongements");
        model.addAttribute("userName", session.getAttribute("userName"));
        return "bibliothecaire_accueil";
    }

    @PostMapping("/prolongements/accepter")
    public String accepterProlongement(
            @RequestParam("idProlongement") int idProlongement,
            @RequestParam("idBibliothecaire") int idBibliothecaire,
            Model model,
            HttpSession session) {
        if (!"bibliothecaire".equals(session.getAttribute("userRole"))) {
            return "redirect:/auth/login";
        }
        String result = pretService.accepterProlongement(idProlongement, idBibliothecaire);
        if (result != null) {
            model.addAttribute("errorMessage", result);
        } else {
            model.addAttribute("successMessage", "Prolongation acceptée avec succès.");
        }
        return "redirect:/prets/prolongements/demandes";
    }

    @PostMapping("/prolongements/refuser")
    public String refuserProlongement(
            @RequestParam("idProlongement") int idProlongement,
            Model model,
            HttpSession session) {
        if (!"bibliothecaire".equals(session.getAttribute("userRole"))) {
            return "redirect:/auth/login";
        }
        String result = pretService.refuserProlongement(idProlongement);
        if (result != null) {
            model.addAttribute("errorMessage", result);
        } else {
            model.addAttribute("successMessage", "Prolongation refusée avec succès.");
        }
        return "redirect:/prets/prolongements/demandes";
    }
}