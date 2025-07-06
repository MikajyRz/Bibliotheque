package bibliotheque.repository;

import bibliotheque.entity.StatutReservation;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface StatutReservationRepository extends JpaRepository<StatutReservation, Integer> {
    Optional<StatutReservation> findByLibelle(String libelle);
}