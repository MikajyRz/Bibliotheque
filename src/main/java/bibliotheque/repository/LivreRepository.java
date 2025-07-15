package bibliotheque.repository;

import bibliotheque.dto.LivreDisponibleProjection;
import bibliotheque.entity.Livre;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface LivreRepository extends JpaRepository<Livre, Integer> {

    List<Livre> findAll();

    /**
     * Récupère les livres les plus populaires basés sur le nombre de prêts.
     * @return Liste des livres triés par nombre de prêts décroissant
     */
    @Query("SELECT l FROM Livre l LEFT JOIN Exemplaire e ON e.livre.id_livre = l.id_livre LEFT JOIN Pret p ON p.exemplaire.id_exemplaire = e.id_exemplaire GROUP BY l.id_livre, l.titre, l.isbn, l.typeLivre, l.edition, l.auteur, l.ageMinimum, l.anneePublication ORDER BY COUNT(p.id_pret) DESC")
    List<Livre> findPopularLivres();

    /**
     * Récupère les livres d'un type donné, non empruntés par l'adhérent.
     * @param typeId ID du type de livre
     * @param idAdherent ID de l'adhérent
     * @return Liste des livres correspondants
     */
    @Query("SELECT l FROM Livre l WHERE l.typeLivre.id_type = :typeId AND l.id_livre NOT IN (SELECT p.exemplaire.livre.id_livre FROM Pret p WHERE p.adherent.id_adherent = :idAdherent)")
    List<Livre> findByTypeLivreAndNotBorrowedByAdherent(@Param("typeId") Integer typeId, @Param("idAdherent") Integer idAdherent);

    /**
     * Récupère les livres d'un auteur donné, non empruntés par l'adhérent.
     * @param auteurId ID de l'auteur
     * @param idAdherent ID de l'adhérent
     * @return Liste des livres correspondants
     */
    @Query("SELECT l FROM Livre l WHERE l.auteur.id_auteur = :auteurId AND l.id_livre NOT IN (SELECT p.exemplaire.livre.id_livre FROM Pret p WHERE p.adherent.id_adherent = :idAdherent)")
    List<Livre> findByAuteurAndNotBorrowedByAdherent(@Param("auteurId") Integer auteurId, @Param("idAdherent") Integer idAdherent);




    @Query(value = """
        SELECT 
            l.id_livre AS idLivre,
            l.titre AS titre,
            COUNT(e.id_exemplaire) AS nbExemplairesDisponibles
        FROM Livre l
        JOIN Exemplaire e ON l.id_livre = e.id_livre
        JOIN (
            SELECT se1.id_exemplaire, se1.id_etat_exemplaire
            FROM StatusExemplaire se1
            JOIN (
                SELECT id_exemplaire, MAX(date_changement) AS date_max
                FROM StatusExemplaire
                GROUP BY id_exemplaire
            ) se2 ON se1.id_exemplaire = se2.id_exemplaire AND se1.date_changement = se2.date_max
        ) last_status ON e.id_exemplaire = last_status.id_exemplaire
        JOIN EtatExemplaire etat ON last_status.id_etat_exemplaire = etat.id_etat
        WHERE etat.libelle = 'disponible' AND l.id_livre = :idLivre
        GROUP BY l.id_livre, l.titre
        ORDER BY nbExemplairesDisponibles DESC
        """, nativeQuery = true)
    List<LivreDisponibleProjection> findNbExemplairesDisponiblesByLivreId(@Param("idLivre") Long idLivre);


}