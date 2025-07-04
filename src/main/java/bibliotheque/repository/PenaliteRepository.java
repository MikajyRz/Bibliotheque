package bibliotheque.repository;

import bibliotheque.entity.Penalite;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface PenaliteRepository extends JpaRepository<Penalite, Integer> {
    @Query("SELECT p FROM Penalite p WHERE p.pret.adherent.id_adherent = :idAdherent")
    List<Penalite> findByAdherentId(@Param("idAdherent") int id_adherent);
}