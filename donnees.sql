INSERT INTO Auteur (nom, prenom) VALUES
('Dumas', 'Alexandre'),
('Rowling', 'J.K.'),
('Tolkien', 'J.R.R.');

INSERT INTO TypeLivre (libelle) VALUES
('Roman'),
('Professionnel'),
('Jeunesse');



INSERT INTO Bibliothecaire (nom, mot_de_passe, email) VALUES
('Martin', 'hashed_password_123', 'martin@bibliotheque.com'),
('Dupont', 'hashed_password_456', 'dupont@bibliotheque.com');

INSERT INTO TypeAdherent (libelle, duree_pret, quota, nb_reservation_max, duree_penalite, nb_jour_max_prolongement) VALUES
('Etudiant', 14, 3, 2, 7, 7),
('Prof', 21, 5, 3, 14, 14),
('Standard', 14, 2, 1, 7, 7);

INSERT INTO EtatExemplaire (libelle) VALUES
('Neuf'),
('Bon état'),
('Usé'),
('Endommagé');

INSERT INTO TypePret (libelle) VALUES
('À domicile'),
('Sur place');

INSERT INTO TypePret (libelle) VALUES
('À domicile'),
('Sur place');


INSERT INTO JourFerie (date_jourferie, nom) VALUES
('2025-01-01', 'Nouvel An'),
('2025-07-14', 'Fête Nationale'),
('2025-12-25', 'Noël');

INSERT INTO JourOuvrable (date_jourouv, nom) VALUES
('2025-07-04', 'Vendredi ouvrable'),
('2025-07-05', 'Samedi ouvrable');

INSERT INTO Adherent (nom, email, mot_de_passe, date_naissance, id_type_adherent, quota_restant) VALUES
('Jean Dupont', 'jean.dupont@email.com', 'hashed_password_789', '1995-03-15', 1, 3),
('Marie Curie', 'marie.curie@email.com', 'hashed_password_012', '1970-11-07', 2, 5),
('Paul Martin', 'paul.martin@email.com', 'hashed_password_345', '2005-06-20', 3, 2);


INSERT INTO Abonnement (id_adherent, date_debut, date_fin) VALUES
(1, '2025-01-01', '2025-12-31'),
(2, '2025-01-01', '2025-12-31'),
(3, '2025-01-01', '2025-12-31');

INSERT INTO Livre (titre, isbn, id_type, edition, id_auteur, age_minimum, annee_publication) VALUES
('Les Trois Mousquetaires', '9780140440744', 1, 'Gallimard', 1, 12, 1844),
('Harry Potter à lécole des sorciers', '9782070612369', 3, 'Folio Junior', 2, 8, 1997),
('Le Seigneur des Anneaux', '9782070612888', 1, 'Gallimard', 3, 14, 1954),
('Manuel de programmation Java', '9780134685991', 2, 'Pearson', 1, 16, 2020);


INSERT INTO Exemplaire (id_livre) VALUES
(1), (1), -- Two copies of Les Trois Mousquetaires
(2), -- One copy of Harry Potter
(3), -- One copy of Le Seigneur des Anneaux
(4); -- One copy of Manuel de programmation Java

INSERT INTO StatusExemplaire (id_exemplaire, date_changement, id_etat, id_biblio) VALUES
(1, '2025-01-01', 1, 1),
(2, '2025-01-01', 2, 1),
(3, '2025-01-01', 1, 2),
(4, '2025-01-01', 1, 2),
(5, '2025-01-01', 2, 1);


INSERT INTO Pret (id_exemplaire, id_adherent, id_type_pret, date_pret, date_retour_prevue, date_retour_reelle) VALUES
(1, 1, 1, '2025-06-01', '2025-06-15', NULL), -- Overdue loan for Jean Dupont
(2, 2, 1, '2025-06-10', '2025-07-01', NULL), -- Overdue loan for Marie Curie
(3, 3, 2, '2025-07-03', '2025-07-03', '2025-07-03'), -- Returned on-site loan for Paul Martin
(4, 1, 1, '2025-06-20', '2025-07-04', NULL), -- Due today for Jean Dupont
(5, 2, 1, '2025-06-15', '2025-07-06', NULL); -- Not overdue for Marie Curie


INSERT INTO Prolongement (id_pret) VALUES
(1), -- Prolongement for Jean Dupont's overdue loan
(2); -- Prolongement for Marie Curie's overdue loan



INSERT INTO Penalite (id_pret, duree_penalite) VALUES
(1, 7), -- Penalty for Jean Dupont's overdue loan
(2, 14); -- Penalty for Marie Curie's overdue loan

INSERT INTO Retour (id_pret, id_reservation, date_retour) VALUES
(3, NULL, '2025-07-03'); -- Return for Paul Martin’s on-site loan