-- --------------------------------------
-- TABLES TEMPORAIRES
-- --------------------------------------

-- Elles n'existent que dans les sessions qui les a crées.
-- Inivisibles quand on fait SHOW TABLES;


-- Ajout de TEMPORARY:
--
CREATE TEMPORARY TABLE TMP_Animal (
    id INT UNSIGNED PRIMARY KEY,
    nom VARCHAR(30),
    espece_id INT UNSIGNED,
    sexe CHAR(1)
);

DESCRIBE TMP_Animal;


-- La modif se fait comme pour une table basique:
--
ALTER TABLE TMP_Animal
ADD COLUMN date_naissance DATETIME;


-- TEMPORARY permet de s'assurer que c'est bien une table temporaire.
--
DROP TEMPORARY TABLE TMP_Animal;



-- --------------------------------------
-- REMARQUES
-- --------------------------------------


-- En cas de conflit entre une table permanente et une temporaire, la temporaire va masquer la permanente.

-- Gardez bien en tête le fait que les tables temporaires sont détruites dès que la connexion prend fin.
-- Dans de nombreuses applications, une nouvelle connexion est créée à chaque nouvelle action.
-- Par exemple, pour un site internet codé en PHP, on crée une nouvelle connexion (donc une nouvelle session) à chaque rechargement de page.

-- on ne peut pas mettre de clé étrangère sur une table temporaire ;
-- on ne peut pas faire référence à une table temporaire deux fois dans la même requête.



-- --------------------------------------
-- TRANSACTIONS
-- --------------------------------------


-- CREATE TEMPORARY TABLE et DROP TEMPORARY TABLE ne valident pas les transactions.
-- Cependant ces deux commandes ne peuvent pas être annulées par un ROLLBACK



-- --------------------------------------
-- METHODES ALTERNATIVES DE CREATION DE TABLE
-- --------------------------------------

-- Copie de table:
--
CREATE [TEMPORARY] TABLE nouvelle_table -- copie tout sauf les clé étrangère (non possible dans les tables temporaires)
LIKE ancienne_table;

-- Cas d'utilisation:
--
INSERT INTO Espece_copy
SELECT * FROM Espece
WHERE prix < 100;

SELECT id, nom_courant, prix 
FROM Espece_copy;



-- Création depuis une requête:
--
DROP TABLE Animal_copy;

CREATE TEMPORARY TABLE Animal_copy
SELECT *
FROM Animal
WHERE espece_id = 5;

DESCRIBE Animal;

DESCRIBE Animal_copy;


-- on peut forcer aussi le type des colonnes:
-- https://openclassrooms.com/courses/administrez-vos-bases-de-donnees-avec-mysql/tables-temporaires#/id/r-1992387



-- --------------------------------------
-- UTILITE DES TABLES TEMPORAIRES
-- --------------------------------------


-- gain de performance
-- Tester des données avant tout ajout permanent (comme les transactions par exemple)