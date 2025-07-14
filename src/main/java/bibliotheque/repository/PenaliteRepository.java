package bibliotheque.repository;

import bibliotheque.entity.Penalite;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PenaliteRepository extends JpaRepository<Penalite, Integer> {
    // Méthodes personnalisées peuvent être ajoutées si nécessaire
}