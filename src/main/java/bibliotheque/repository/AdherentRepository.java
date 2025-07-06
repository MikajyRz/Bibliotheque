package bibliotheque.repository;

import bibliotheque.entity.Adherent;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface AdherentRepository extends JpaRepository<Adherent, Integer> {
    Adherent findByEmail(String email);
    
    @Query("SELECT a FROM Adherent a WHERE a.id_adherent = :id")
    List<Adherent> findById_adherent(@Param("id") Integer id);
}