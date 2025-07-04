package bibliotheque.entity;

import jakarta.persistence.*;

@Entity
public class Prolongement {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id_prolongement;

    @ManyToOne
    @JoinColumn(name = "id_pret", nullable = false)
    private Pret pret;

    public Prolongement() {}

    public int getId_prolongement() {
        return id_prolongement;
    }

    public void setId_prolongement(int id_prolongement) {
        this.id_prolongement = id_prolongement;
    }

    public Pret getPret() {
        return pret;
    }

    public void setPret(Pret pret) {
        this.pret = pret;
    }
}