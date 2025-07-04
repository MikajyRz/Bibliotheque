package bibliotheque.repository;

import bibliotheque.entity.StatusExemplaire;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface StatusExemplaireRepository extends JpaRepository<StatusExemplaire, Integer> {
    @Query("SELECT s FROM StatusExemplaire s WHERE s.exemplaire.id_exemplaire = :idExemplaire ORDER BY s.dateChangement DESC")
List<StatusExemplaire> findByExemplaireIdOrderByDateChangementDesc(@Param("idExemplaire") int id_exemplaire);
}