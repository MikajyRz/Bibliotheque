package bibliotheque.repository;

import bibliotheque.entity.TypeAdherent;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface TypeAdherentRepository extends JpaRepository<TypeAdherent, Integer> {
    Optional<TypeAdherent> findByLibelle(String libelle);
}