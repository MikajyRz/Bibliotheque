package bibliotheque.entity;

import jakarta.persistence.*;

@Entity
public class TypeLivre {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id_type;

    @Column(name = "libelle", length = 50, nullable = false)
    private String libelle;

    public TypeLivre() {}

    public int getId_type() {
        return id_type;
    }

    public void setId_type(int id_type) {
        this.id_type = id_type;
    }

    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }
}