package bibliotheque.repository;

import bibliotheque.entity.EtatExemplaire;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface EtatExemplaireRepository extends JpaRepository<EtatExemplaire, Integer> {
    Optional<EtatExemplaire> findByLibelle(String libelle);
}