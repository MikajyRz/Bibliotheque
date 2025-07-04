package bibliotheque.repository;

import bibliotheque.entity.Penalite;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface PenaliteRepository extends JpaRepository<Penalite, Integer> {
    List<Penalite> findByPretAdherentId_adherent(int idAdherent);
}