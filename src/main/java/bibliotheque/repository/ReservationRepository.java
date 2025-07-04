package bibliotheque.repository;

import bibliotheque.entity.Reservation;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ReservationRepository extends JpaRepository<Reservation, Integer> {
    List<Reservation> findByExemplaireId_exemplaire(int idExemplaire);
}