package bibliotheque.entity;

import jakarta.persistence.*;

@Entity
public class Bibliothecaire {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id_biblio;

    @Column(name = "nom", length = 50, nullable = false)
    private String nom;

    @Column(name = "mot_de_passe", length = 100, nullable = false)
    private String motDePasse;

    @Column(name = "email", length = 100, nullable = false, unique = true)
    private String email;

    public Bibliothecaire() {}

    public int getId_biblio() {
        return id_biblio;
    }

    public void setId_biblio(int id_biblio) {
        this.id_biblio = id_biblio;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getMotDePasse() {
        return motDePasse;
    }

    public void setMotDePasse(String motDePasse) {
        this.motDePasse = motDePasse;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }
}