----------------------------------------
-- LES TRANSACTIONS
----------------------------------------


-- Les transactions servent à verouiller les requêtes en cours.

-- INNODB support les transactions.
-- par défaut tout est 'autocommité'.

SET autocommit=0; -- sortir du mode autocommit

COMMIT;   -- pour valider les requêtes
ROLLBACK; -- pour annuler les requêtes

SET autocommit=1; -- repasser en mode autocommit


-- En désactivant le mode autocommit, en réalité, on démarre une transaction.
-- Et chaque fois que l'on fait un rollback ou un commit (ce qui met fin à la transaction),
-- une nouvelle transaction est créée automatiquement, et ce tant que la session est ouverte.

START TRANSACTION; -- démarrer une transaction explicitement.
-- elle prendra fin lors du prochain rollback ou commit.



----------------------------------------
-- JALON DE TRANSACTION
----------------------------------------


-- Points de repère dans la transaction, qui permet de revenir à ce point lors d'un rollback.

SAVEPOINT nom_jalon; 
-- Crée un jalon avec comme nom "nom_jalon"

ROLLBACK [WORK] TO [SAVEPOINT] nom_jalon; 
-- Annule les requêtes exécutées depuis le jalon "nom_jalon", WORK et SAVEPOINT ne sont pas obligatoires

RELEASE SAVEPOINT nom_jalon; 
-- Retire le jalon "nom_jalon" (sans annuler, ni valider les requêtes faites depuis)



----------------------------------------
-- VALIDATION IMPLICITE ET COMMANDES NON-ANNULABLE
----------------------------------------

-- Toutes les commandes qui créent, modifient,
-- suppriment des objets dans la base de données
-- valident implicitement les transactions.


-- la création et suppression de bases de données : CREATE DATABASE, DROP DATABASE ;
-- la création, modification, suppression de tables : CREATE TABLE, ALTER TABLE, RENAME TABLE, DROP TABLE ;
-- la création, modification, suppression d'index : CREATE INDEX, DROP INDEX ;
-- la création d'objets comme les procédures stockées, les vues, etc., dont nous parlerons plus tard.

-- De manière générale, tout ce qui influe sur la structure de la base de données, et non sur les données elles-mêmes.

-- Utilisateurs
-- La création, la modification et la suppression d'utilisateurs (voir partie 7) provoquent aussi une validation implicite.

-- Transactions et verrous
-- Je vous ai signalé qu'il n'était pas possible d'imbriquer des transactions,
-- donc d'avoir une transaction à l'intérieur d'une transaction.
-- En fait, la commande START TRANSACTION provoque également une validation implicite si elle est exécutée à l'intérieur d'une transaction.
-- Le fait d'activer le mode autocommit (s'il n'était pas déjà activé) a le même effet.

-- La création et suppression de verrous de table clôturent aussi une transaction en la validant implicitement (voir chapitre suivant).

-- Chargements de données
-- Enfin, le chargement de données avec LOAD DATA provoque également une validation implicite.


----------------------------------------
-- ACID
----------------------------------------

-- Atomicité, Cohérence, Isolation et Durabilité
