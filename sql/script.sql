CREATE DATABASE IF NOT EXISTS bibliotheque;
USE bibliotheque;

CREATE TABLE Auteur (
    id_auteur INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL
);

CREATE TABLE TypeLivre (
    id_type INT PRIMARY KEY AUTO_INCREMENT,
    libelle VARCHAR(50) NOT NULL
);

CREATE TABLE Bibliothecaire (
    id_biblio INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(50) NOT NULL,
    mot_de_passe VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE TypeAdherent (
    id_type_adherent INT PRIMARY KEY AUTO_INCREMENT,
    libelle VARCHAR(50) NOT NULL,
    duree_pret INT NOT NULL,
    quota INT NOT NULL,
    nb_reservation_max INT NOT NULL,
    duree_penalite INT NOT NULL,
    nb_jour_max_prolongement INT NOT NULL
);


CREATE TABLE TypePret (
    id_type_pret INT PRIMARY KEY AUTO_INCREMENT,
    libelle VARCHAR(50) NOT NULL
);

CREATE TABLE StatutReservation (
    id_statut_reservation INT PRIMARY KEY AUTO_INCREMENT,
    libelle VARCHAR(50) NOT NULL
);

CREATE TABLE JourFerie (
    id_jour_ferie INT PRIMARY KEY AUTO_INCREMENT,
    date_jourferie DATE NOT NULL,
    nom VARCHAR(100) NOT NULL
);

CREATE TABLE JourOuvrable (
    id_jour_ouv INT PRIMARY KEY AUTO_INCREMENT,
    date_jourouv DATE NOT NULL,
    nom VARCHAR(100) NOT NULL
);

CREATE TABLE Adherent (
    id_adherent INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    mot_de_passe VARCHAR(100) NOT NULL, 
    date_naissance DATE NOT NULL,
    id_type_adherent INT NOT NULL,
    quota_restant INT NOT NULL,
    FOREIGN KEY (id_type_adherent) REFERENCES TypeAdherent(id_type_adherent)
);

CREATE TABLE Abonnement (
    id_abonnement INT PRIMARY KEY AUTO_INCREMENT,
    id_adherent INT NOT NULL,
    date_debut DATE NOT NULL,
    date_fin DATE NOT NULL,
    FOREIGN KEY (id_adherent) REFERENCES Adherent(id_adherent)
);

CREATE TABLE Livre (
    id_livre INT PRIMARY KEY AUTO_INCREMENT,
    titre VARCHAR(100) NOT NULL,
    isbn VARCHAR(13) NOT NULL,
    id_type INT NOT NULL,
    edition VARCHAR(50),
    id_auteur INT NOT NULL,
    age_minimum INT NOT NULL,
    annee_publication INT,
    FOREIGN KEY (id_auteur) REFERENCES Auteur(id_auteur),
    FOREIGN KEY (id_type) REFERENCES TypeLivre(id_type)
);

CREATE TABLE Exemplaire (
    id_exemplaire INT PRIMARY KEY AUTO_INCREMENT,
    id_livre INT NOT NULL,
    FOREIGN KEY (id_livre) REFERENCES Livre(id_livre)
);

CREATE TABLE EtatExemplaire (
    id_etat INT PRIMARY KEY AUTO_INCREMENT,
    libelle VARCHAR(50) NOT NULL
);

-- Historique des statuts d'exemplaires
CREATE TABLE StatusExemplaire (
    id_status_exemplaire INT PRIMARY KEY AUTO_INCREMENT,
    id_exemplaire INT NOT NULL,
    id_etat_exemplaire INT NOT NULL,
    date_changement DATE NOT NULL,
    id_biblio INT,
    FOREIGN KEY (id_etat_exemplaire) REFERENCES EtatExemplaire(id_etat),
    FOREIGN KEY (id_exemplaire) REFERENCES Exemplaire(id_exemplaire),
    FOREIGN KEY (id_biblio) REFERENCES Bibliothecaire(id_biblio)
);

CREATE TABLE Pret (
    id_pret INT PRIMARY KEY AUTO_INCREMENT,
    id_exemplaire INT NOT NULL,
    id_adherent INT NOT NULL,
    id_type_pret INT NOT NULL,
    date_pret DATE NOT NULL,
    date_retour_prevue DATE NOT NULL,
    date_retour_reelle DATE,
    FOREIGN KEY (id_exemplaire) REFERENCES Exemplaire(id_exemplaire),
    FOREIGN KEY (id_adherent) REFERENCES Adherent(id_adherent),
    FOREIGN KEY (id_type_pret) REFERENCES TypePret(id_type_pret)
);

CREATE TABLE Prolongement (
    id_prolongement INT PRIMARY KEY AUTO_INCREMENT,
    id_pret INT NOT NULL,
    FOREIGN KEY (id_pret) REFERENCES Pret(id_pret)
);

CREATE TABLE Reservation (
    id_reservation INT PRIMARY KEY AUTO_INCREMENT,
    id_exemplaire INT NOT NULL,
    id_adherent INT NOT NULL,
    id_statut_reservation INT NOT NULL,
    date_reservation DATE NOT NULL,
    FOREIGN KEY (id_exemplaire) REFERENCES Exemplaire(id_exemplaire),
    FOREIGN KEY (id_adherent) REFERENCES Adherent(id_adherent),
    FOREIGN KEY (id_statut_reservation) REFERENCES StatutReservation(id_statut_reservation)
);

CREATE TABLE Penalite (
    id_penalite INT PRIMARY KEY AUTO_INCREMENT,
    id_pret INT NOT NULL,
    duree_penalite INT NOT NULL,
    FOREIGN KEY (id_pret) REFERENCES Pret(id_pret)
);

CREATE TABLE Retour (
    id_retour INT PRIMARY KEY AUTO_INCREMENT,
    id_pret INT NOT NULL,
    id_reservation INT,
    date_retour DATE NOT NULL,
    FOREIGN KEY (id_pret) REFERENCES Pret(id_pret),
    FOREIGN KEY (id_reservation) REFERENCES Reservation(id_reservation)
);