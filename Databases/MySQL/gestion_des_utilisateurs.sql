----------------------------------------
-- GESTION DES UTILISATEURS
----------------------------------------

-- On a vu au début du cours:
GRANT ALL PRIVILEGES ON elevage.* TO 'sdz'@'localhost' IDENTIFIED BY 'mot_de_passe';


-- Il existe une base de donnée appelé MySQL, qui stock toutes les informations utilisateur.

-- 4 niveaux de privilèges:
-- db : privilèges au niveau des bases de données.
-- tables_priv : privilèges au niveau des tables.
-- columns_priv : privilèges au niveau des colonnes.
-- proc_priv : privilèges au niveau des routines (procédures et fonctions stockées).



----------------------------------------
-- CREATIONS / SUPPRESSIONS / MODIFICATION DES UTILISATEURS
----------------------------------------

-- Création
CREATE USER 'login'@'hote' [IDENTIFIED BY 'mot_de_passe'];

-- Suppression
DROP USER 'login'@'hote';

-- Exemples:
CREATE USER 'max'@'localhost' IDENTIFIED BY 'maxisthebest';
CREATE USER 'elodie'@'194.28.12.4' IDENTIFIED BY 'ginko1';
CREATE USER 'gabriel'@'arb.brab.net' IDENTIFIED BY 'chinypower';

-- thibault peut se connecter à partir de n'importe quel hôte dont l'adresse IP commence par 194.28.12.
CREATE USER 'thibault'@'194.28.12.%' IDENTIFIED BY 'basketball8';

-- joelle peut se connecter à partir de n'importe quel hôte du domaine brab.net
CREATE USER 'joelle'@'%.brab.net' IDENTIFIED BY 'singingisfun';

-- hannah peut se connecter à partir de n'importe quel hôte
CREATE USER 'hannah'@'%' IDENTIFIED BY 'looking4sun';

-- renommer un utilisateur:
RENAME USER 'max'@'localhost' TO 'maxime'@'localhost';

-- changer le mdp. Utiliser la fonction PASSWORD pour le hashage.
SET PASSWORD FOR 'thibault'@'194.28.12.%' = PASSWORD('basket8');



----------------------------------------
-- LES PRIVILEGES
----------------------------------------


-- Lorsque l'on crée un utilisateur avecCREATE USER, celui-ci n'a au départ aucun privilège, aucun droit.
-- En SQL, avoir un privilège, c'est avoir l'autorisation d'effectuer une action sur un objet.

-- Un utilisateur sans aucun privilège ne peut rien faire d'autre que se connecter.
-- Il n'aura pas accès aux données, ne pourra créer aucun objet (base/table/procédure/autre), ni en utiliser.

-- CREATE TABLE 			- 	Création de tables
-- CREATE TEMPORARY TABLE 	- 	Création de tables temporaires
-- CREATE VIEW 				- 	Création de vues (il faut également avoir le privilègeSELECTsur les colonnes sélectionnées par la vue)
-- ALTER 					- 	Modification de tables (avecALTER TABLE)
-- DROP 					- 	Suppression de tables, vues et bases de données

-- CREATE ROUTINE 			- 	Création de procédures stockées (et de fonctions stockées - non couvert dans ce cours)
-- ALTER ROUTINE 			- 	Modification et suppression de procédures stockées (et fonctions stockées)
-- EXECUTE 					- 	Exécution de procédures stockées (et fonctions stockées)
-- INDEX 					- 	Création et suppression d'index
-- TRIGGER 					- 	Création et suppression de triggers
-- LOCK TABLES 				- 	Verrouillage de tables (sur lesquelles on a le privilègeSELECT)
-- CREATE USER 				- 	Gestion d'utilisateur (commandesCREATE USER,DROP USER,RENAME USERetSET PASSWORD)



----------------------------------------
-- LES NIVEAUX D'APPLICATION DES PRIVILEGES
----------------------------------------

-- marre des tableaux!
-- https://openclassrooms.com/courses/administrez-vos-bases-de-donnees-avec-mysql/gestion-des-utilisateurs-4#/id/r-1993296

-- lire la suite pour le reste.