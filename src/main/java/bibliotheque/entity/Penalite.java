package bibliotheque.entity;

import java.util.Date;

import jakarta.persistence.*;

@Entity
public class Penalite {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id_penalite;

    @ManyToOne
    @JoinColumn(name = "id_pret", nullable = false)
    private Pret pret;

    @Column(name = "duree_penalite", nullable = false)
    private int dureePenalite;

    @Column(name = "date_application", nullable = false)
    private Date dateApplication;

    public Penalite() {}

    public int getId_penalite() {
        return id_penalite;
    }

    public void setId_penalite(int id_penalite) {
        this.id_penalite = id_penalite;
    }

    public Pret getPret() {
        return pret;
    }

    public void setPret(Pret pret) {
        this.pret = pret;
    }

    public int getDureePenalite() {
        return dureePenalite;
    }

    public void setDureePenalite(int dureePenalite) {
        this.dureePenalite = dureePenalite;
    }

    public Date getDateApplication() {
        return dateApplication;
    }

    public void setDateApplication(Date dateApplication) {
        this.dateApplication = dateApplication;
    }

}