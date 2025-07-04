package bibliotheque.entity;

import java.util.Date;
import jakarta.persistence.*;

@Entity
public class Pret {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id_pret;

    @ManyToOne
    @JoinColumn(name = "id_exemplaire", nullable = false)
    private Exemplaire exemplaire;

    @ManyToOne
    @JoinColumn(name = "id_adherent", nullable = false)
    private Adherent adherent;

    @ManyToOne
    @JoinColumn(name = "id_type_pret", nullable = false)
    private TypePret typePret;

    @Column(name = "date_pret", nullable = false)
    private Date datePret;

    @Column(name = "date_retour_prevue", nullable = false)
    private Date dateRetourPrevue;

    @Column(name = "date_retour_reelle")
    private Date dateRetourReelle;

    public Pret() {}

    public int getId_pret() {
        return id_pret;
    }

    public void setId_pret(int id_pret) {
        this.id_pret = id_pret;
    }

    public Exemplaire getExemplaire() {
        return exemplaire;
    }

    public void setExemplaire(Exemplaire exemplaire) {
        this.exemplaire = exemplaire;
    }

    public Adherent getAdherent() {
        return adherent;
    }

    public void setAdherent(Adherent adherent) {
        this.adherent = adherent;
    }

    public TypePret getTypePret() {
        return typePret;
    }

    public void setTypePret(TypePret typePret) {
        this.typePret = typePret;
    }

    public Date getDatePret() {
        return datePret;
    }

    public void setDatePret(Date datePret) {
        this.datePret = datePret;
    }

    public Date getDateRetourPrevue() {
        return dateRetourPrevue;
    }

    public void setDateRetourPrevue(Date dateRetourPrevue) {
        this.dateRetourPrevue = dateRetourPrevue;
    }

    public Date getDateRetourReelle() {
        return dateRetourReelle;
    }

    public void setDateRetourReelle(Date dateRetourReelle) {
        this.dateRetourReelle = dateRetourReelle;
    }
}