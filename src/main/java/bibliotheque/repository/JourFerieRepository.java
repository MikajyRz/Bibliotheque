package bibliotheque.repository;

import bibliotheque.entity.JourFerie;
import org.springframework.data.jpa.repository.JpaRepository;

public interface JourFerieRepository extends JpaRepository<JourFerie, Integer> {
}