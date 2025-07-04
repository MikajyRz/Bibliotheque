package bibliotheque.entity;

import java.util.Date;
import jakarta.persistence.*;

@Entity
public class StatusExemplaire {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id_status_exemplaire;

    @ManyToOne
    @JoinColumn(name = "id_exemplaire", nullable = false)
    private Exemplaire exemplaire;

    @ManyToOne
    @JoinColumn(name = "id_etat_exemplaire", nullable = false)
    private EtatExemplaire etatExemplaire;

    @Column(name = "date_changement", nullable = false)
    private Date dateChangement;

    @ManyToOne
    @JoinColumn(name = "id_biblio")
    private Bibliothecaire bibliothecaire;

    public StatusExemplaire() {}

    public int getId_status_exemplaire() {
        return id_status_exemplaire;
    }

    public void setId_status_exemplaire(int id_status_exemplaire) {
        this.id_status_exemplaire = id_status_exemplaire;
    }

    public Exemplaire getExemplaire() {
        return exemplaire;
    }

    public void setExemplaire(Exemplaire exemplaire) {
        this.exemplaire = exemplaire;
    }

    public EtatExemplaire getEtatExemplaire() {
        return etatExemplaire;
    }

    public void setEtatExemplaire(EtatExemplaire etatExemplaire) {
        this.etatExemplaire = etatExemplaire;
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