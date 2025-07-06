package bibliotheque.repository;

import bibliotheque.entity.Reservation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ReservationRepository extends JpaRepository<Reservation, Integer> {

    List<Reservation> findAll();

    @Query("SELECT r FROM Reservation r WHERE r.adherent.id_adherent = :idAdherent")
    List<Reservation> findByAdherentId(@Param("idAdherent") Integer idAdherent);

    @Query("SELECT r FROM Reservation r WHERE r.exemplaire.id_exemplaire = :idExemplaire")
    List<Reservation> findByExemplaireId(@Param("idExemplaire") Integer idExemplaire);


    @Query("SELECT r FROM Reservation r WHERE r.statutReservation.libelle = :libelle")
    List<Reservation> findByStatutReservationLibelle(@Param("libelle") String libelle);
}