package bibliotheque.entity;

import java.util.Date;
import jakarta.persistence.*;

@Entity
public class StatutExemplaire {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id_statut_exemplaire;

    @Column(name = "libelle", length = 50, nullable = false)
    private String libelle;

    @ManyToOne
    @JoinColumn(name = "id_exemplaire", nullable = false)
    private Exemplaire exemplaire;

    @Column(name = "date_changement", nullable = false)
    private Date dateChangement;

    @ManyToOne
    @JoinColumn(name = "id_biblio")
    private Bibliothecaire bibliothecaire;

    public StatutExemplaire() {}

    public int getId_statut_exemplaire() {
        return id_statut_exemplaire;
    }

    public void setId_statut_exemplaire(int id_statut_exemplaire) {
        this.id_statut_exemplaire = id_statut_exemplaire;
    }

    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }

    public Exemplaire getExemplaire() {
        return exemplaire;
    }

    public void setExemplaire(Exemplaire exemplaire) {
        this.exemplaire = exemplaire;
    }

    public Date getDateChangement() {
        return dateChangement;
    }

    public void setDateChangement(Date dateChangement) {
        this.dateChangement = dateChangement;
    }

    public Bibliothecaire getBibliothecaire() {
        return bibliothecaire;
    }

    public void setBibliothecaire(Bibliothecaire bibliothecaire) {
        this.bibliothecaire = bibliothecaire;
    }
}