package bibliotheque.service;

import bibliotheque.entity.Adherent;
import bibliotheque.entity.TypeAdherent;
import bibliotheque.repository.AdherentRepository;
import bibliotheque.repository.TypeAdherentRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class AdherentService {

    @Autowired
    private AdherentRepository adherentRepository;

    @Autowired
    private TypeAdherentRepository typeAdherentRepository;

    public List<Adherent> findAll() {
        return adherentRepository.findAll();
    }

    public Optional<Adherent> findById(int id) {
        return adherentRepository.findById(id);
    }

    public Adherent save(Adherent adherent) {
        return adherentRepository.save(adherent);
    }

    public void deleteById(int id) {
        adherentRepository.deleteById(id);
    }

    public Adherent inscrireAdherent(Adherent adherent, int idTypeAdherent) {
        TypeAdherent typeAdherent = typeAdherentRepository.findById(idTypeAdherent)
            .orElseThrow(() -> new RuntimeException("Type d'adhérent non trouvé."));
        adherent.setTypeAdherent(typeAdherent);
        adherent.setQuotaRestant(typeAdherent.getQuota());
        return adherentRepository.save(adherent);
    }

    public boolean emailExiste(String email) {
        return adherentRepository.findByEmail(email) != null;
    }

    /**
     * Remet à zéro le quota individuel (ex: en début d'année, ou via admin)
     */
    public void resetQuotaAdherent(int idAdherent) {
        Adherent adherent = adherentRepository.findById(idAdherent)
            .orElseThrow(() -> new RuntimeException("Adhérent non trouvé."));
        adherent.setQuotaRestant(adherent.getTypeAdherent().getQuota());
        adherentRepository.save(adherent);
    }
}