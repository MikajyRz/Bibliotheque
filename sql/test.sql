SELECT 
    l.id_livre,
    l.titre,
    COUNT(e.id_exemplaire) AS nb_exemplaires_disponibles
FROM Livre l
JOIN Exemplaire e ON l.id_livre = e.id_livre
JOIN (
    SELECT se1.id_exemplaire, se1.id_etat_exemplaire
    FROM StatusExemplaire se1
    JOIN (
        SELECT id_exemplaire, MAX(date_changement) AS date_max
        FROM StatusExemplaire
        GROUP BY id_exemplaire
    ) se2 ON se1.id_exemplaire = se2.id_exemplaire AND se1.date_changement = se2.date_max
) last_status ON e.id_exemplaire = last_status.id_exemplaire
JOIN EtatExemplaire etat ON last_status.id_etat_exemplaire = etat.id_etat
WHERE etat.libelle = 'disponible' AND l.id_livre = 1
GROUP BY l.id_livre, l.titre
ORDER BY nb_exemplaires_disponibles DESC;
