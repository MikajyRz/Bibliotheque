package bibliotheque.service;

import bibliotheque.entity.Exemplaire;
import bibliotheque.repository.ExemplaireRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ExemplaireService {

    @Autowired
    private ExemplaireRepository exemplaireRepository;

    /**
     * Récupère tous les exemplaires disponibles dans la base de données.
     *
     * @return Liste de tous les exemplaires.
     */
    public List<Exemplaire> findAll() {
        return exemplaireRepository.findAll();
    }

    /**
     * Récupère un exemplaire par son ID.
     *
     * @param idExemplaire ID de l'exemplaire.
     * @return Optional contenant l'exemplaire s'il existe, sinon vide.
     */
    public Optional<Exemplaire> findById(int idExemplaire) {
        return exemplaireRepository.findById(idExemplaire);
    }
}