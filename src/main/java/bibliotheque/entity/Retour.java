package bibliotheque.entity;

import java.util.Date;
import jakarta.persistence.*;

@Entity
public class Retour {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id_retour;

    @ManyToOne
    @JoinColumn(name = "id_pret", nullable = false)
    private Pret pret;

    @ManyToOne
    @JoinColumn(name = "id_reservation")
    private Reservation reservation;

    @Column(name = "date_retour", nullable = false)
    private Date dateRetour;

    public Retour() {}

    public int getId_retour() {
        return id_retour;
    }

    public void setId_retour(int id_retour) {
        this.id_retour = id_retour;
    }

    public Pret getPret() {
        return pret;
    }

    public void setPret(Pret pret) {
        this.pret = pret;
    }

    public Reservation getReservation() {
        return reservation;
    }

    public void setReservation(Reservation reservation) {
        this.reservation = reservation;
    }

    public Date getDateRetour() {
        return dateRetour;
    }

    public void setDateRetour(Date dateRetour) {
        this.dateRetour = dateRetour;
    }
}