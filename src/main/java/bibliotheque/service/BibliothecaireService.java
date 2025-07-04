package bibliotheque.service;

import bibliotheque.entity.Bibliothecaire;
import bibliotheque.repository.BibliothecaireRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class BibliothecaireService {

    @Autowired
    private BibliothecaireRepository bibliothecaireRepository;

    public List<Bibliothecaire> findAll() {
        return bibliothecaireRepository.findAll();
    }

    public Optional<Bibliothecaire> findById(int id) {
        return bibliothecaireRepository.findById(id);
    }

    public Bibliothecaire save(Bibliothecaire bibliothecaire) {
        return bibliothecaireRepository.save(bibliothecaire);
    }

    public void deleteById(int id) {
        bibliothecaireRepository.deleteById(id);
    }
}