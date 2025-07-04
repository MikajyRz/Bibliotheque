package bibliotheque.entity;

import jakarta.persistence.*;

@Entity
public class TypePret {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id_type_pret;

    @Column(name = "libelle", length = 50, nullable = false)
    private String libelle;

    public TypePret() {}

    public int getId_type_pret() {
        return id_type_pret;
    }

    public void setId_type_pret(int id_type_pret) {
        this.id_type_pret = id_type_pret;
    }

    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }
}