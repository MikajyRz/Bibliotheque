package bibliotheque.entity;

import jakarta.persistence.*;

@Entity
public class EtatExemplaire {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id_etat;

    @Column(name = "libelle", length = 100, nullable = false)
    private String libelle;

    public EtatExemplaire() {}

    public int getId_etat() {
        return id_etat;
    }

    public void setId_etat(int id_etat) {
        this.id_etat = id_etat;
    }

    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }
}