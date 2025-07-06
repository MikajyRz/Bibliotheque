package bibliotheque.repository;

import bibliotheque.entity.TypePret;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface TypePretRepository extends JpaRepository<TypePret, Integer> {
    Optional<TypePret> findByLibelle(String libelle);
}