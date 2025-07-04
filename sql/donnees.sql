```sql
-- Sélectionner la base de données
USE bibliotheque;

-- Vider les tables pour repartir de zéro (facultatif)
DELETE FROM Retour;
DELETE FROM Penalite;
DELETE FROM Reservation;
DELETE FROM Prolongement;
DELETE FROM Pret;
DELETE FROM StatusExemplaire;
DELETE FROM Exemplaire;
DELETE FROM Livre;
DELETE FROM Abonnement;
DELETE FROM Adherent;
DELETE FROM TypeAdherent;
DELETE FROM Bibliothecaire;
DELETE FROM TypePret;
DELETE FROM EtatExemplaire;
DELETE FROM StatutReservation;
DELETE FROM JourFerie;
DELETE FROM JourOuvrable;
DELETE FROM TypeLivre;
DELETE FROM Auteur;

-- Insérer dans Auteur
INSERT INTO Auteur (id_auteur, nom, prenom) VALUES
(1, 'Zola', 'Émile'),
(2, 'Inconnu', 'Ny Andevo'),
(3, 'Camus', 'Albert'),
(4, 'Inconnu', 'Tantely');

-- Insérer dans TypeLivre
INSERT INTO TypeLivre (id_type, libelle) VALUES
(1, 'Roman'),
(2, 'Essai'),
(3, 'Bande dessinée'),
(4, 'Conte malgache');

-- Insérer dans Bibliothecaire
INSERT INTO Bibliothecaire (nom, mot_de_passe, email) VALUES
('Durand', 'biblio123', 'durand@gmail.com'),
('Rasoanaivo', 'admin456', 'rasoa@gmail.com');

-- Insérer dans TypeAdherent
INSERT INTO TypeAdherent (libelle, duree_pret, quota, nb_reservation_max, duree_penalite, nb_jour_max_prolongement) VALUES
('Étudiant', 14, 3, 2, 7, 5),
('Professeur', 30, 5, 3, 10, 10),
('Anonyme', 7, 1, 1, 3, 2);

-- Insérer dans Adherent (exemple de données, car absentes dans donnees.sql)
INSERT INTO Adherent (nom, email, mot_de_passe, date_naissance, id_type_adherent) VALUES
('Dupont', 'dupont@example.com', 'pass123', '1995-03-15', 1),
('Rakoto', 'rakoto@example.com', 'pass456', '1980-07-22', 2),
('Randria', 'randria@example.com', 'pass789', '2000-11-30', 3);

-- Insérer dans Abonnement (exemple de données)
INSERT INTO Abonnement (id_adherent, date_debut, date_fin) VALUES
(1, '2025-01-01', '2025-12-31'),
(2, '2025-02-01', '2026-01-31'),
(3, '2025-03-01', '2025-09-30');

-- Insérer dans Livre
INSERT INTO Livre (titre, isbn, id_type, edition, id_auteur, age_minimum, annee_publication) VALUES
('Germinal', '9782070409189', 1, 'Gallimard', 1, 16, 1885),
('Ny Andevo', '9782913214100', 4, 'Tsipika', 2, 14, 1960),
('LÉtranger', '9782070360022', 2, 'Folio', 3, 16, 1942),
('Tantely amin ny rano', '9789999999991', 4, 'Jeunesse Mada', 4, 8, 2005);

-- Insérer dans Exemplaire
INSERT INTO Exemplaire (id_livre) VALUES
(1), (1), -- Deux exemplaires de Germinal
(2), (2), -- Deux exemplaires de Ny Andevo
(3), (3), -- Deux exemplaires de L'Étranger
(4), (4); -- Deux exemplaires de Tantely aminny rano

-- Insérer dans EtatExemplaire
INSERT INTO EtatExemplaire (libelle) VALUES
('Disponible'),
('Emprunté'),
('Réservé'),
('Endommagé');

-- Insérer dans StatusExemplaire
INSERT INTO StatusExemplaire (id_exemplaire, date_changement, id_etat, id_biblio) VALUES
(1, '2025-06-01', 1, 1), -- Exemplaire 1 (Germinal) disponible
(2, '2025-06-01', 2, 2), -- Exemplaire 2 (Germinal) emprunté
(3, '2025-06-02', 1, 1), -- Exemplaire 3 (Ny Andevo) disponible
(4, '2025-06-02', 1, 1), -- Exemplaire 4 (Ny Andevo) disponible
(5, '2025-06-03', 1, 2), -- Exemplaire 5 (L'Étranger) disponible
(6, '2025-06-03', 1, 2), -- Exemplaire 6 (L'Étranger) disponible
(7, '2025-06-04', 1, 1), -- Exemplaire 7 (Tantely) disponible
(8, '2025-06-04', 1, 2); -- Exemplaire 8 (Tantely) disponible

-- Insérer dans TypePret
INSERT INTO TypePret (libelle) VALUES
('Sur place'),
('À domicile');

-- Insérer dans StatutReservation
INSERT INTO StatutReservation (libelle) VALUES
('En attente'),
('Validée'),
('Annulée');

-- Insérer dans JourFerie
INSERT INTO JourFerie (date_jourferie, nom) VALUES
('2025-05-01', 'Fête du Travail'),
('2025-06-26', 'Fête de l’Indépendance (Madagascar)');

-- Insérer dans JourOuvrable
INSERT INTO JourOuvrable (date_jourouv, nom) VALUES
('2025-06-27', 'Vendredi'),
('2025-06-30', 'Lundi');

-- Insérer dans Pret
INSERT INTO Pret (id_exemplaire, id_adherent, id_type_pret, date_pret, date_retour_prevue, date_retour_reelle) VALUES
(2, 1, 2, '2025-06-10', '2025-06-24', NULL), -- Prêt d'un exemplaire de Germinal
(5, 2, 2, '2025-06-01', '2025-06-30', '2025-06-28'); -- Prêt d'un exemplaire de L'Étranger

-- Insérer dans Prolongement
INSERT INTO Prolongement (id_pret) VALUES
(1); -- Prolongement du prêt 1

-- Insérer dans Reservation
INSERT INTO Reservation (id_exemplaire, id_adherent, id_statut_reservation, date_reservation) VALUES
(3, 3, 1, '2025-06-15'), -- Réservation d'un exemplaire de Ny Andevo
(1, 2, 2, '2025-06-10'); -- Réservation d'un exemplaire de Germinal

-- Insérer dans Retour
INSERT INTO Retour (id_pret, id_reservation, date_retour) VALUES
(2, 2, '2025-06-28'); -- Retour du prêt 2 avec réservation 2

-- Vérifier les insertions
SELECT * FROM Auteur;
SELECT * FROM TypeLivre;
SELECT * FROM Bibliothecaire;
SELECT * FROM TypeAdherent;
SELECT * FROM Adherent;
SELECT * FROM Abonnement;
SELECT * FROM Livre;
SELECT * FROM Exemplaire;
SELECT * FROM EtatExemplaire;
SELECT * FROM StatusExemplaire;
SELECT * FROM TypePret;
SELECT * FROM StatutReservation;
SELECT * FROM JourFerie;
SELECT * FROM JourOuvrable;
SELECT * FROM Pret;
SELECT * FROM Prolongement;
SELECT * FROM Reservation;
SELECT * FROM Retour;
```

### Explications des modifications

1. **Correction des incohérences** :
   - Changé `INSERT INTO auteur (id, nom, prenom)` en `INSERT INTO Auteur (id_auteur, nom, prenom)` pour correspondre à la table `Auteur` définie dans `script.sql`.
   - Modifié les noms de colonnes dans l'insertion de `Livre` : `ageMinimum` → `age_minimum` et `anneePublication` → `annee_publication` pour correspondre à la définition de la table `Livre`.
   - Corrigé `motDePasse` en `mot_de_passe` dans l'insertion de `Bibliothecaire` pour correspondre à la définition de la table.

2. **Ajout des données manquantes** :
   - Ajouté des insertions pour les tables `Adherent` et `Abonnement`, qui n'étaient pas présentes dans l'original `donnees.sql`. Les données sont cohérentes avec les contraintes de clés étrangères (par exemple, `id_type_adherent` référence des valeurs valides de `TypeAdherent`).
   - Complété les insertions pour `EtatExemplaire` en ajoutant des états supplémentaires comme 'Réservé' et 'Endommagé' pour refléter des scénarios réalistes.

3. **Ordre des insertions** :
   - Les tables sont remplies dans l'ordre suivant pour respecter les dépendances des clés étrangères :
     - Tables sans dépendances : `Auteur`, `TypeLivre`, `Bibliothecaire`, `TypeAdherent`, `EtatExemplaire`, `TypePret`, `StatutReservation`, `JourFerie`, `JourOuvrable`.
     - Tables avec dépendances : `Adherent` (dépend de `TypeAdherent`), `Abonnement` (dépend de `Adherent`), `Livre` (dépend de `Auteur` et `TypeLivre`), `Exemplaire` (dépend de `Livre`), `StatusExemplaire` (dépend de `Exemplaire`, `EtatExemplaire`, `Bibliothecaire`), `Pret` (dépend de `Exemplaire`, `Adherent`, `TypePret`), `Prolongement` (dépend de `Pret`), `Reservation` (dépend de `Exemplaire`, `Adherent`, `StatutReservation`), `Retour` (dépend de `Pret`, `Reservation`).
   - Les suppressions initiales (`DELETE FROM ...`) garantissent que les tables sont vides avant l'insertion, évitant les conflits d'ID ou les violations de contraintes.

4. **Vérification des données** :
   - Les instructions `SELECT *` à la fin permettent de vérifier que les données ont été insérées correctement.
   - Les valeurs des clés étrangères (par exemple, `id_auteur`, `id_type`, `id_adherent`, etc.) correspondent aux `id` générés dans les tables référencées.

### Vérification
Pour exécuter et vérifier le script :
1. Exécutez le script de création corrigé (`script.sql`) pour créer la base de données et les tables :
   ```bash
   mysql -u <username> -p < script.sql
   ```
2. Exécutez le script de données corrigé :
   ```bash
   mysql -u <username> -p < donnees.sql
   ```
3. Vérifiez les tables, par exemple :
   ```sql
   USE bibliotheque;
   SELECT * FROM Livre;
   SELECT * FROM Exemplaire;
   ```

### Notes supplémentaires
- **Mots de passe** : Dans `donnees.sql`, les mots de passe (`mot_de_passe`) sont insérés en texte clair pour simplifier. Dans un environnement réel, ils devraient être hachés (par exemple, avec BCrypt, comme dans le code Java fourni précédemment).
- **Auto-increment** : Les insertions spécifient les `id` (par exemple, `id_auteur`, `id_type`) pour correspondre à l'original `donnees.sql`. Si vous préférez laisser MariaDB gérer les `id` avec `AUTO_INCREMENT`, supprimez les valeurs explicites des `id` dans les insertions et ajustez les clés étrangères en conséquence.
- **Casse des noms** : Les noms de tables et de colonnes sont cohérents avec `script.sql` (par exemple, `Auteur` au lieu de `auteur`, `age_minimum` au lieu de `ageMinimum`).
- **Impact sur le code Java** : Ce script de données corrigé est compatible avec les classes Java (`AuthService.java`, etc.) fournies précédemment, car il respecte le schéma de la base de données et inclut des données pour `Adherent` et `Bibliothecaire` nécessaires à l'authentification.

Si vous rencontrez des erreurs ou avez besoin d'autres ajustements (par exemple, ajouter plus de données ou modifier des valeurs), faites-le-moi savoir !











```sql
INSERT INTO TypeLivre (libelle) VALUES ('Roman'), ('Science-Fiction');
INSERT INTO Auteur (nom, prenom) VALUES ('Hugo', 'Victor'), ('Asimov', 'Isaac');
INSERT INTO Livre (titre, isbn, id_type, edition, id_auteur, age_minimum, annee_publication)
VALUES ('Les Misérables', '9781234567890', 1, 'Gallimard', 1, 12, 1862),
       ('Fondation', '9780987654321', 2, 'Denoël', 2, 14, 1951);
INSERT INTO Exemplaire (id_livre) VALUES (1), (1), (2);
INSERT INTO TypePret (libelle) VALUES ('Standard');
INSERT INTO StatutReservation (libelle) VALUES ('Réservé');
INSERT INTO TypeAdherent (libelle, duree_pret, quota, nb_reservation_max, duree_penalite, nb_jour_max_prolongement)
VALUES ('Standard', 14, 5, 3, 30, 7);
INSERT INTO Adherent (nom, email, mot_de_passe, date_naissance, id_type_adherent)
VALUES ('Dupont', 'jean@example.com', 'password123', '1990-01-01', 1);
INSERT INTO Bibliothecaire (nom, email, mot_de_passe)
VALUES ('Curie', 'marie@example.com', 'password123');
INSERT INTO Abonnement (id_adherent, date_debut, date_fin)
VALUES (1, '2025-01-01', '2026-01-01');
INSERT INTO EtatExemplaire (libelle) VALUES ('Disponible'), ('Emprunté'), ('Endommagé');
INSERT INTO StatusExemplaire (id_exemplaire, date_changement, id_etat)
VALUES (1, '2025-07-03', 1), (2, '2025-07-03', 1), (3, '2025-07-03', 1);
INSERT INTO JourFerie (date_jourferie, nom)
VALUES ('2025-12-25', 'Noël'), ('2026-01-01', 'Jour de l''An');
```