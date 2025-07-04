package bibliotheque.repository;

import bibliotheque.entity.Reservation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ReservationRepository extends JpaRepository<Reservation, Integer> {
    @Query("SELECT r FROM Reservation r WHERE r.exemplaire.id_exemplaire = :idExemplaire")
List<Reservation> findByExemplaireId(@Param("idExemplaire") int id_exemplaire);
}