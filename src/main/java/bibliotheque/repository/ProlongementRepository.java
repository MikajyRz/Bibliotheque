package bibliotheque.repository;

import bibliotheque.entity.Prolongement;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ProlongementRepository extends JpaRepository<Prolongement, Integer> {
}