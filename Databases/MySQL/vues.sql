-- --------------------------------------
-- VUES
-- --------------------------------------


-- Pour notre élevage, cette requête est très utile:
--
SELECT Animal.id, Animal.sexe, Animal.date_naissance, Animal.nom, Animal.commentaires, 
       Animal.espece_id, Animal.race_id, Animal.mere_id, Animal.pere_id, Animal.disponible,
       Espece.nom_courant AS espece_nom, Race.nom AS race_nom
FROM Animal
INNER JOIN Espece ON Animal.espece_id = Espece.id
LEFT JOIN Race ON Animal.race_id = Race.id;


-- On aimerai bien stocker cette requête pour s'en reservir souvent (avec ou sans clause WHERE).
-- C'est très exactement le principe d'une vue : on stocke une requête SELECT en lui donnant un nom, et on peut ensuite appeler directement la vue par son nom.

-- Remarques importantes :
-- Il s'agit bien d'objets de la base de données, stockés de manière durable, comme le sont les tables ou les procédures stockées.
-- C'est donc bien différent des requêtes préparées, qui ne sont définies que le temps d'une session, et qui ont un tout autre but.
-- Ce qui est stocké est la requête, et non pas les résultats de celle-ci. On ne gagne absolument rien en terme de performance
-- en utilisant une vue plutôt qu'en faisant une requête directement sur les tables.



-- --------------------------------------
-- CREATION
-- --------------------------------------


CREATE [OR REPLACE] VIEW nom_vue
AS requete_select;


-- Exemple sur la requête précedente:
--
CREATE VIEW V_Animal_details -- préfixe par 'V_'
AS SELECT Animal.id, Animal.sexe, Animal.date_naissance, Animal.nom, Animal.commentaires, 
       Animal.espece_id, Animal.race_id, Animal.mere_id, Animal.pere_id, Animal.disponible,
       Espece.nom_courant AS espece_nom, Race.nom AS race_nom
FROM Animal
INNER JOIN Espece ON Animal.espece_id = Espece.id
LEFT JOIN Race ON Animal.race_id = Race.id;

-- Appel de la requête:
--
SELECT * FROM V_Animal_details;



-- --------------------------------------
-- DESCRIPTION DE LA VUE
-- --------------------------------------

DESCRIBE V_Animal_details; -- ça marche aussi pour les vues.


-- Pour renommer
CREATE VIEW V_Animal_details  (id, sexe, date_naissance, nom, commentaires, espece_id, race_id, mere_id, pere_id, disponible, espece_nom, race_nom)
AS SELECT Animal.id, Animal.sexe, Animal.date_naissance, Animal.nom, Animal.commentaires, 
       Animal.espece_id, Animal.race_id, Animal.mere_id, Animal.pere_id, Animal.disponible,
       Espece.nom_courant, Race.nom
FROM Animal
INNER JOIN Espece ON Animal.espece_id = Espece.id
LEFT JOIN Race ON Animal.race_id = Race.id;



-- --------------------------------------
-- EXCEPTIONS
-- --------------------------------------


-- pas de sous-requêtes
-- pas de variables
-- toutes les tables doivent exister au moment de la requête.

-- Une vue est 'figée' au moment de sa création. Même si on utilise * dans la requête select,
-- elle n'ajoutera pas de nouvelle colonnes si la table en question a été updaté.



-- --------------------------------------
-- ORDER BY
-- --------------------------------------


-- On peut mettre un ORDER BY différent de celui crée pour une vue.


CREATE OR REPLACE VIEW V_Race
AS SELECT Race.id, nom, Espece.nom_courant AS espece
FROM Race
INNER JOIN Espece ON Espece.id = Race.espece_id
ORDER BY nom;

SELECT * 
FROM V_Race;     
-- Sélection sans ORDER BY, on prend l'ORDER BY de la définition

SELECT * 
FROM V_Race
ORDER BY espece; 
-- Sélection avec ORDER BY, c'est celui-là qui sera pris en compte



-- --------------------------------------
-- TRAITEMENTS
-- --------------------------------------

-- On peut utiliser une vue comme une bête table.

SELECT V_Nombre_espece.id, Espece.nom_courant, V_Nombre_espece.nb
FROM V_Nombre_espece
INNER JOIN Espece ON Espece.id = V_Nombre_espece.id;



-- --------------------------------------
-- MODIFICATION / SUPPRESSION
-- --------------------------------------

-- MODIFICATION:
--
CREATE OR REPLACE VIEW V_Espece_dollars
AS SELECT id, nom_courant, nom_latin, description, ROUND(prix*1.30813, 2) AS prix_dollars
FROM Espece;

ALTER VIEW V_Espece_dollars
AS SELECT id, nom_courant, nom_latin, description, ROUND(prix*1.30813, 2) AS prix_dollars
FROM Espece;


-- SUPPRESSION:
--
DROP VIEW [IF EXISTS] nom_vue;



-- --------------------------------------
-- UTILITE
-- --------------------------------------

-- clarification et facilitation des requêtes
-- Création d'une interface entre l'application et la base de données (meilleure maintenance car juste à réecrire les vues)
-- Restriction des données visibles par les utilisateurs



-- --------------------------------------
-- ALGORITHMES
-- --------------------------------------

-- Inutile, mais bon pour la culture G:
-- https://openclassrooms.com/courses/administrez-vos-bases-de-donnees-avec-mysql/vues#/id/r-1973825



-- --------------------------------------
-- MODIFICATION DES DONNEES D'UNE VUE
-- --------------------------------------


-- Anecdotique:
-- https://openclassrooms.com/courses/administrez-vos-bases-de-donnees-avec-mysql/vues#/id/r-1973942