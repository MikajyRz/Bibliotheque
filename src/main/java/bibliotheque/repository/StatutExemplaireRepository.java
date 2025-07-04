package bibliotheque.repository;

import bibliotheque.entity.StatutExemplaire;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface StatutExemplaireRepository extends JpaRepository<StatutExemplaire, Integer> {
    List<StatutExemplaire> findByExemplaireId_exemplaireOrderByDateChangementDesc(int idExemplaire);
}