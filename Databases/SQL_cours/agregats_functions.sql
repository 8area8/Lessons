----------------------------------------
-- AGREGATS FUNCTIONS
----------------------------------------


--
-- Fonctions statistiques
--

SELECT SUM(prix), GROUP_CONCAT(nom_courant) FROM Espece; -- concaténation des noms sur une seule ligne
GROUP_CONCAT(
              [DISTINCT] col1 [, col2, ...]
              [ORDER BY col [ASC | DESC]]
              [SEPARATOR sep]
            ) -- exemples poussés: https://openclassrooms.com/courses/administrez-vos-bases-de-donnees-avec-mysql/fonctions-d-agregation#/id/r-1984459

SELECT AVG(prix)
FROM Espece; -- retourne la moyenne des prix

SELECT MIN(nom), MAX(nom), MIN(date_naissance), MAX(date_naissance)
FROM Animal; -- retourne la plus petite/grande valeur.



----------------------------------------
-- REGROUPEMENT
----------------------------------------


SELECT ...
FROM nom_table
[WHERE condition]
GROUP BY nom_colonne; -- GROUP BY permet de faire des regroupements

SELECT nom_courant, COUNT(*) AS nb_animaux
FROM Animal
INNER JOIN Espece ON Animal.espece_id = Espece.id
GROUP BY nom_courant; -- chat: 20, chien: 21, perroquet: 4, etc.


-- règle:
-- Avec GROUP BY, on ne peut sélectionner que deux types d'éléments dans la clause SELECT :
-- une ou des colonnes ayant servi de critère pour le regroupement ;
-- une fonction d'agrégation (agissant sur n'importe quelle colonne).

SELECT Espece.id, nom_courant, nom_latin, COUNT(*) AS nb_animaux
FROM Animal
INNER JOIN Espece ON Animal.espece_id = Espece.id
GROUP BY nom_courant, Espece.id, nom_latin
ORDER BY nb_animaux; -- grouper sur x colonnes (+ tri)
-- pas d'experession (opérateurs math, fonctions) dans ORDER BY ou GROUP BY (donc alias pour ce cas)



--
-- REGROUPEMENT MULTI-CRITERES
--


SELECT nom_courant, sexe, COUNT(*) as nb_animaux
FROM Animal
INNER JOIN Espece ON Espece.id = Animal.espece_id
GROUP BY nom_courant, sexe;


SELECT nom_courant, COUNT(*) as nb_animaux
FROM Animal
INNER JOIN Espece ON Espece.id = Animal.espece_id
GROUP BY nom_courant WITH ROLLUP; 					-- WITH ROLLUP affiche les resultats des différents groupes


COALESCE() 											-- renvoit le premier paramètre non null
SELECT COALESCE(1, NULL, 3, 4); 					-- 1
SELECT COALESCE(NULL, 2);       					-- 2
SELECT COALESCE(NULL, NULL, 3); 					-- 3

SELECT COALESCE(nom_courant, 'Total'), COUNT(*) as nb_animaux
FROM Animal
INNER JOIN Espece ON Espece.id = Animal.espece_id
GROUP BY nom_courant WITH ROLLUP;


--
-- CONDITIONS
--

-- règle:
-- impossible d'utiliser la clause WHERE avec fonction d'agregation.

SELECT nom_courant, COUNT(*)
FROM Animal
INNER JOIN Espece ON Espece.id = Animal.espece_id
GROUP BY nom_courant
HAVING COUNT(*) > 15; -- utiliser HAVING, après GROUP BY. ! HAVING moins optimisé que WHERE