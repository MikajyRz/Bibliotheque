package bibliotheque.entity;

import jakarta.persistence.*;

@Entity
public class StatutReservation {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id_statut_reservation;

    @Column(name = "libelle", length = 50, nullable = false)
    private String libelle;

    public StatutReservation() {}

    public int getId_statut_reservation() {
        return id_statut_reservation;
    }

    public void setId_statut_reservation(int id_statut_reservation) {
        this.id_statut_reservation = id_statut_reservation;
    }

    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }

}