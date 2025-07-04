package bibliotheque.service;

import bibliotheque.entity.Adherent;
import bibliotheque.entity.Bibliothecaire;
import bibliotheque.repository.AdherentRepository;
import bibliotheque.repository.BibliothecaireRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import jakarta.servlet.http.HttpSession;

@Service
public class AuthService {

    @Autowired
    private AdherentRepository adherentRepository;

    @Autowired
    private BibliothecaireRepository bibliothecaireRepository;

    /**
     * Authentifie un utilisateur (adherent ou bibliothecaire)
     * @return "adherent", "bibliothecaire" ou lève une exception si erreur
     */
    public String authenticate(String email, String motDePasse, HttpSession session) {
        // Essai adherent
        Adherent adherent = adherentRepository.findByEmail(email);
        if (adherent != null) {
            if (motDePasse.equals(adherent.getMotDePasse())) {
                session.setAttribute("userId", adherent.getId_adherent());
                session.setAttribute("userName", adherent.getNom());
                session.setAttribute("userRole", "adherent");
                return "adherent";
            } else {
                throw new RuntimeException("Mot de passe incorrect pour l'adhérent.");
            }
        }

        // Essai bibliothecaire
        Bibliothecaire bibliothecaire = bibliothecaireRepository.findByEmail(email);
        if (bibliothecaire != null) {
            if (motDePasse.equals(bibliothecaire.getMotDePasse())) {
                session.setAttribute("userId", bibliothecaire.getId_biblio());
                session.setAttribute("userName", bibliothecaire.getNom());
                session.setAttribute("userRole", "bibliothecaire");
                return "bibliothecaire";
            } else {
                throw new RuntimeException("Mot de passe incorrect pour le bibliothécaire.");
            }
        }

        // Email inexistant
        throw new RuntimeException("Email non trouvé.");
    }
}