package bibliotheque.entity;

import jakarta.persistence.*;

@Entity
public class TypeAdherent {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id_type_adherent;

    @Column(name = "libelle", length = 50, nullable = false)
    private String libelle;

    @Column(name = "duree_pret", nullable = false)
    private int dureePret;

    @Column(name = "quota", nullable = false)
    private int quota;

    @Column(name = "nb_reservation_max", nullable = false)
    private int nbReservationMax;

    @Column(name = "duree_penalite", nullable = false)
    private int dureePenalite;

    @Column(name = "nb_jour_max_prolongement", nullable = false)
    private int nbJourMaxProlongement;

    public TypeAdherent() {}

    public int getId_type_adherent() {
        return id_type_adherent;
    }

    public void setId_type_adherent(int id_type_adherent) {
        this.id_type_adherent = id_type_adherent;
    }

    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }

    public int getDureePret() {
        return dureePret;
    }

    public void setDureePret(int dureePret) {
        this.dureePret = dureePret;
    }

    public int getQuota() {
        return quota;
    }

    public void setQuota(int quota) {
        this.quota = quota;
    }

    public int getNbReservationMax() {
        return nbReservationMax;
    }

    public void setNbReservationMax(int nbReservationMax) {
        this.nbReservationMax = nbReservationMax;
    }

    public int getDureePenalite() {
        return dureePenalite;
    }

    public void setDureePenalite(int dureePenalite) {
        this.dureePenalite = dureePenalite;
    }

    public int getNbJourMaxProlongement() {
        return nbJourMaxProlongement;
    }

    public void setNbJourMaxProlongement(int nbJourMaxProlongement) {
        this.nbJourMaxProlongement = nbJourMaxProlongement;
    }
}