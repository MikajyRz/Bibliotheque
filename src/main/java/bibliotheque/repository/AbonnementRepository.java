package bibliotheque.repository;

import bibliotheque.entity.Abonnement;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface AbonnementRepository extends JpaRepository<Abonnement, Integer> {
    List<Abonnement> findByAdherentId_adherent(int idAdherent);
}