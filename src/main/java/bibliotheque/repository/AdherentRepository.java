package bibliotheque.repository;

import bibliotheque.entity.Adherent;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AdherentRepository extends JpaRepository<Adherent, Integer> {
    Adherent findByEmail(String email);
}