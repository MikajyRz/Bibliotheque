package bibliotheque.entity;

import java.util.List;

import jakarta.persistence.*;

@Entity
public class Exemplaire {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id_exemplaire;

    @ManyToOne
    @JoinColumn(name = "id_livre", nullable = false)
    private Livre livre;

        // Autres champs et relations
        @OneToMany(mappedBy = "exemplaire")
        private List<StatusExemplaire> statusExemplaires;
    
        @OneToMany(mappedBy = "exemplaire")
        private List<Pret> prets;
    
        @OneToMany(mappedBy = "exemplaire")
        private List<Reservation> reservations;

    public Exemplaire() {}

    public int getId_exemplaire() {
        return id_exemplaire;
    }

    public void setId_exemplaire(int id_exemplaire) {
        this.id_exemplaire = id_exemplaire;
    }

    public Livre getLivre() {
        return livre;
    }

    public void setLivre(Livre livre) {
        this.livre = livre;
    }
}