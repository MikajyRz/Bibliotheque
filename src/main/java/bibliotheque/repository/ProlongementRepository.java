package bibliotheque.repository;

import bibliotheque.entity.Prolongement;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ProlongementRepository extends JpaRepository<Prolongement, Integer> {
    @Query("SELECT p FROM Prolongement p WHERE p.statut = 'en attente'")
    List<Prolongement> findAllEnAttente();

    @Query("SELECT p FROM Prolongement p WHERE p.pret.id_pret = :idPret")
    List<Prolongement> findByPretId(@Param("idPret") Integer idPret);
}