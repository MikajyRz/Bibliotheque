package bibliotheque.entity;

import java.util.Date;
import jakarta.persistence.*;

@Entity
public class JourFerie {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id_jour_ferie;

    @Column(name = "date_jourferie", nullable = false)
    private Date dateJourferie;

    @Column(name = "nom", length = 100, nullable = false)
    private String nom;

    public JourFerie() {}

    public int getId_jour_ferie() {
        return id_jour_ferie;
    }

    public void setId_jour_ferie(int id_jour_ferie) {
        this.id_jour_ferie = id_jour_ferie;
    }

    public Date getDateJourferie() {
        return dateJourferie;
    }

    public void setDateJourferie(Date dateJourferie) {
        this.dateJourferie = dateJourferie;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }
}