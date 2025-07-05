package bibliotheque.repository;

import bibliotheque.entity.Pret;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Date;
import java.util.List;
import java.util.Optional;

public interface PretRepository extends JpaRepository<Pret, Integer> {
    List<Pret> findAll();

    @Query("SELECT p FROM Pret p " +
           "JOIN p.adherent a " +
           "JOIN p.exemplaire e " +
           "JOIN e.livre l " +
           "JOIN p.typePret tp " +
           "WHERE (:adherent IS NULL OR LOWER(a.nom) LIKE LOWER(:adherent) OR LOWER(a.email) LIKE LOWER(:adherent)) " +
           "AND (:exemplaire IS NULL OR LOWER(l.titre) LIKE LOWER(:exemplaire) OR e.id_exemplaire = :exemplaireId) " +
           "AND (:idTypePret IS NULL OR p.typePret.id_type_pret = :idTypePret) " +
           "AND (:dateDebut IS NULL OR p.datePret >= :dateDebut) " +
           "AND (:dateFin IS NULL OR p.datePret <= :dateFin)")
    List<Pret> findByCriteria(
            @Param("adherent") String adherent,
            @Param("exemplaire") String exemplaire,
            @Param("exemplaireId") Integer exemplaireId,
            @Param("idTypePret") Integer idTypePret,
            @Param("dateDebut") Date dateDebut,
            @Param("dateFin") Date dateFin);


    @Query("SELECT p FROM Pret p " +
            "WHERE p.adherent.id_adherent = :idAdherent " +
            "AND p.exemplaire.id_exemplaire = :idExemplaire " +
            "AND p.dateRetourReelle IS NULL")
     Optional<Pret> findNonReturnedByAdherentAndExemplaire(
             @Param("idAdherent") Integer idAdherent,
             @Param("idExemplaire") Integer idExemplaire);

    @Query("SELECT p FROM Pret p " +
            "WHERE p.exemplaire.id_exemplaire = :idExemplaire " +
            "AND (p.dateRetourReelle IS NULL OR p.dateRetourReelle > :datePret)")
    List<Pret> findActivePretsByExemplaireAndDate(
            @Param("idExemplaire") Integer idExemplaire,
            @Param("datePret") Date datePret);
}