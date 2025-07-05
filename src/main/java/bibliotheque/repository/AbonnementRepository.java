package bibliotheque.repository;

import bibliotheque.entity.Abonnement;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface AbonnementRepository extends JpaRepository<Abonnement, Integer> {
    @Query("SELECT a FROM Abonnement a WHERE a.adherent.id_adherent = :idAdherent")
List<Abonnement> findByAdherentId(@Param("idAdherent") int id_adherent);
}