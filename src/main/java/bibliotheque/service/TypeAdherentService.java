package bibliotheque.service;

import bibliotheque.entity.TypeAdherent;
import bibliotheque.repository.TypeAdherentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class TypeAdherentService {

    @Autowired
    private TypeAdherentRepository typeAdherentRepository;

    public List<TypeAdherent> findAll() {
        return typeAdherentRepository.findAll();
    }

    public Optional<TypeAdherent> findById(int id) {
        return typeAdherentRepository.findById(id);
    }

    public TypeAdherent save(TypeAdherent typeAdherent) {
        return typeAdherentRepository.save(typeAdherent);
    }

    public void deleteById(int id) {
        typeAdherentRepository.deleteById(id);
    }
}