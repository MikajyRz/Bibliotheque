package bibliotheque.entity;

import jakarta.persistence.*;
import java.util.Date;

@Entity
public class Prolongement {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id_prolongement;

    @ManyToOne
    @JoinColumn(name = "id_pret", nullable = false)
    private Pret pret;

    @Column(name = "date_prolongement_proposee", nullable = false)
    private Date dateProlongementProposee;

    @Column(name = "statut", nullable = false)
    private String statut;

    public Prolongement() {
        this.statut = "en attente"; // Statut par défaut
    }

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

    public Date getDateProlongementProposee() {
        return dateProlongementProposee;
    }

    public void setDateProlongementProposee(Date dateProlongementProposee) {
        this.dateProlongementProposee = dateProlongementProposee;
    }

    public String getStatut() {
        return statut;
    }

    public void setStatut(String statut) {
        this.statut = statut;
    }
}
