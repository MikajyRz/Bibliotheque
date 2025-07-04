package bibliotheque.entity;

import java.util.Date;
import jakarta.persistence.*;

@Entity
public class Adherent {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id_adherent;

    @Column(name = "nom", length = 50, nullable = false)
    private String nom;

    @Column(name = "email", length = 100, nullable = false, unique = true)
    private String email;

    @Column(name = "mot_de_passe", length = 100, nullable = false)
    private String motDePasse;

    @Column(name = "date_naissance", nullable = false)
    private Date dateNaissance;

    @Column(name = "quota_restant", nullable = false)
    private int quotaRestant;

    @ManyToOne
    @JoinColumn(name = "id_type_adherent", nullable = false)
    private TypeAdherent typeAdherent;

    public Adherent() {}

    public int getId_adherent() {
        return id_adherent;
    }

    public void setId_adherent(int id_adherent) {
        this.id_adherent = id_adherent;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getMotDePasse() {
        return motDePasse;
    }

    public void setMotDePasse(String motDePasse) {
        this.motDePasse = motDePasse;
    }

    public Date getDateNaissance() {
        return dateNaissance;
    }

    public void setDateNaissance(Date dateNaissance) {
        this.dateNaissance = dateNaissance;
    }

    public int getQuotaRestant() {
        return quotaRestant;
    }

    public void setQuotaRestant(int quotaRestant) {
        this.quotaRestant = quotaRestant;
    }

    public TypeAdherent getTypeAdherent() {
        return typeAdherent;
    }

    public void setTypeAdherent(TypeAdherent typeAdherent) {
        this.typeAdherent = typeAdherent;
    }
}