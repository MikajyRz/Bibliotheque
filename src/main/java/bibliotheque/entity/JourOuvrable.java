package bibliotheque.entity;

import java.util.Date;
import jakarta.persistence.*;

@Entity
public class JourOuvrable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id_jour_ouv;

    @Column(name = "date_jourouv", nullable = false)
    private Date dateJourouv;

    @Column(name = "nom", length = 100, nullable = false)
    private String nom;

    public JourOuvrable() {}

    public int getId_jour_ouv() {
        return id_jour_ouv;
    }

    public void setId_jour_ouv(int id_jour_ouv) {
        this.id_jour_ouv = id_jour_ouv;
    }

    public Date getDateJourouv() {
        return dateJourouv;
    }

    public void setDateJourouv(Date dateJourouv) {
        this.dateJourouv = dateJourouv;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }
}