package bibliotheque.dto;

public interface LivreDisponibleProjection {
    Long getIdLivre();
    String getTitre();
    Long getNbExemplairesDisponibles();
}
