----------------------------------------
-- Informations sur la base de données et les requêtes
----------------------------------------


----------------------------------------
-- COMMANDES DE DESCRIPTION
----------------------------------------

SHOW objets; -- liste les objets

-- Exemple:
SHOW TABLES;

-- Liste des possibles:
SHOW CHARACTER SET
SHOW [FULL] COLUMNS FROM nom_table [FROM nom_bdd]
SHOW DATABASES
SHOW GRANTS [FOR utilisateur]
SHOW INDEX FROM nom_table [FROM nom_bdd]
SHOW PRIVILEGES
SHOW PROCEDURE STATUS
SHOW [FULL] TABLES [FROM nom_bdd]
SHOW TRIGGERS [FROM nom_bdd]
SHOW [GLOBAL | SESSION] VARIABLES
SHOW WARNINGS

SHOW COLUMNS 
FROM Adoption
LIKE 'date%';

SHOW CHARACTER SET
WHERE Description LIKE '%arab%';


-- DESCRIBE:
DESCRIBE nom_table

-- SHOW sert egalement à voir la requête qui a servit à la création d'un objet!
SHOW CREATE TABLE Espece \G
-- Le \G est un délimiteur, comme ;. Il change simplement la manière d'afficher le résultat, qui ne sera plus sous forme de tableau,
-- mais formaté verticalement. Pour les requêtes de description comme SHOW CREATE,
-- qui renvoient peu de lignes (ici : une) mais contenant beaucoup d'informations, c'est beaucoup plus lisible.

*************************** 1. row ***************************
       Table: Espece
Create Table: CREATE TABLE `Espece` (
  `id` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  `nom_courant` varchar(40) NOT NULL,
  `nom_latin` varchar(40) NOT NULL,
  `description` text,
  `prix` decimal(7,2) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nom_latin` (`nom_latin`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8


----------------------------------------
-- BASE DE DONNEES INFORMATION SCHEMA
----------------------------------------

-- En MySQL, un schéma est une base de données. Ce sont des synonymes.
-- La base information_schema contient donc des informations sur les bases de données.

SHOW TABLES FROM information_schema;

-- Cette base contient donc des informations sur les tables, les colonnes, les contraintes, les vues, etc., des bases de données stockées sur le serveur MySQL.
-- En fait, c'est de cette base de données que sont extraites les informations affichées grâce à la commande SHOW.
-- Par conséquent, si les informations données par SHOW ne suffisent pas, il est possible d'interroger directement cette base de données.



----------------------------------------
-- INFORMATIONS SUR LES REQUETES
----------------------------------------



-- https://openclassrooms.com/courses/administrez-vos-bases-de-donnees-avec-mysql/informations-sur-la-base-de-donnees-et-les-requetes#/id/r-1976509