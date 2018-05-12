----------------------------------------
-- VERROUS
----------------------------------------

-- Lorsqu'une session MySQL pose un verrou sur un élément de la base de données, cela veut dire qu'il restreint,
-- voire interdit, l'accès à cet élément aux autres sessions MySQL qui voudraient y accéder.

-- Il est possible de poser un verrou sur une table entière, ou seulement sur une ou plusieurs lignes d'une table



----------------------------------------
-- VERROUS DE TABLE
----------------------------------------

-- les seuls supportés par MyISAM. Supporté par INNOBD

LOCK TABLES nom_table [AS alias_table] [READ | WRITE] [, ...]; -- verrou d'une table.

-- En utilisantREAD, un verrou de lecture sera posé ;
-- c'est-à-dire que les autres sessions pourront toujours lire les données des tables verrouillées,
-- mais ne pourront plus les modifier.

-- En utilisantWRITE, un verrou d'écriture sera posé.
-- Les autres sessions ne pourront plus ni lire ni modifier les données des tables verrouillées.


UNLOCK TABLES -- dévérouille toutes les tables verrouillées. Impossible de préciser quelle table verrouiller.


-- QUAND UNE SESSION POSE UN VERROU DE TABLE:
-- elle ne peut plus accéder qu'aux tables sur lesquelles elle a posé un verrou ;
-- elle ne peut accéder à ces tables qu'en utilisant les noms qu'elle a donnés lors du verrouillage (soit le nom de la table, soit le/les alias donné(s)) ;
-- s'il s'agit d'un verrou de lecture (READ), elle peut uniquement lire les données, pas les modifier.


-- Si une session a obtenu un verrou de lecture sur une table, les autres sessions :
-- peuvent lire les données de la table ;
-- peuvent également acquérir un verrou de lecture sur cette table ;
-- ne peuvent pas modifier les données, ni acquérir un verrou d'écriture sur cette table.


-- verrou d'écriture: les autres sessions ne peuvent absolument pas accéder à cette table tant que ce verrou existe.



----------------------------------------
-- LES COMMANDES QUI HOTENT LES VERROUS
----------------------------------------

-- START TRANSACTION ôte les verrous de table ;
-- les commandes LOCK TABLES et UNLOCK TABLES provoquent une validation implicite si elles sont exécutées à l'intérieur d'une transaction.



----------------------------------------
-- UTILISER VERROUS ET TRANSACTIONS
----------------------------------------

-- Il faut renoncer à démarrer explicitement les transactions, et donc utiliser le mode non-autocommit.
-- Lorsque l'on est dans ce mode, il est facile de contourner la validation implicite provoquée par LOCK TABLES et UNLOCK TABLES:
-- il suffit d'appeler LOCK TABLES avant toute modification de données, et de commiter/annuler les modifications avant d'exécuter UNLOCK TABLES.

-- EXEMPLE:
SET autocommit = 0;
LOCK TABLES Adoption WRITE; 
    -- La validation implicite ne commite rien puisque aucun changement n'a été fait

UPDATE Adoption SET date_adoption = NOW() WHERE client_id = 9 AND animal_id = 54;
SELECT client_id, animal_id, date_adoption FROM Adoption WHERE client_id = 9;

ROLLBACK;
UNLOCK TABLES; 
    -- On a annulé les changements juste avant donc la validation implicite n'a aucune conséquence
SELECT client_id, animal_id, date_adoption FROM Adoption WHERE client_id = 9;
SET autocommit = 1;


----------------------------------------
-- VERROUS DE LIGNE
----------------------------------------

-- DEUX TYPES DE VERROUS:
-- Les verrous partagés : permettent aux autres sessions de lire les données, mais pas de les modifier (équivalents aux verrous de table de lecture);
-- Les verrous exclusifs : ne permettent ni la lecture ni la modification des données (équivalents aux verrous d'écriture).

-- - Les requêtes de modification et suppression des données posent automatiquement un verrou exclusif sur les lignes concernées,
--   à savoir les lignes sélectionnées par la clause WHERE,
--   ou toutes les lignes s'il n'y a pas de clause WHERE(ou sur les colonnes utilisées s'il n'y a pas d'index,  comme nous verrons plus loin).
-- - Les requêtes d'insertion quant à elles posent un verrou exclusif sur la ligne insérée.

-- Les requêtes de sélection, par défaut, ne posent pas de verrous. Il faut donc en poser explicitement au besoin.

SELECT * FROM Animal WHERE espece_id = 5 LOCK IN SHARE MODE; -- verrou partagé (aux autres: lire mais pas modifier)
SELECT * FROM Animal WHERE espece_id = 5 FOR UPDATE; -- verrou exclusif (aux autres: pas lire pas modifier)

-- Ces verrous ne sont pas posés par des commandes spécifiques, mais par des requêtes de sélection, insertion ou modification.
-- Ils existent donc uniquement tant que la requête qui les a posés interagit avec les données.

-- Du coup, ce type de verrou s'utilise en conjonction avec les transactions.
-- En effet, hors transaction, dès qu'une requête est lancée, elle est effectuée et les éventuelles modifications des données sont immédiatement validées. 
-- Par contre, dans le cas d'une requête faite dans une transaction,
-- les changements ne sont pas validés tant que la transaction n'a pas été commitée.

-- Donc, à partir du moment où une requête a été exécutée dans une transaction, et jusqu'à la fin de la transaction (COMMITouROLLBACK),
-- la requête a potentiellement un effet sur les données.
-- C'est à ce moment-là (quand une requête a été exécutée mais pas validée ou annulée) qu'il est intéressant de verrouiller les données
-- qui vont potentiellement être modifiées (ou supprimées) par la transaction.

-- Un verrou de ligne est donc lié à la transaction dans laquelle il est posé.
-- Dès que l'on fait unCOMMITou unROLLBACKde la transaction, le verrou est levé.



----------------------------------------
-- ON PEUT VISIONNER UNE SELECTION POURTANT VERROUILLEE!
----------------------------------------

-- lorsqu'une session démarre une transaction, elle prend en quelque sorte une photo des tables dans leur état actuel (les modifications non commitées n'étant pas visibles).
-- La transaction va alors travailler sur la base de cette photo, tant qu'on ne lui demande pas d'aller vérifier que les données n'ont pas changé.
-- Donc le SELECT ne voit pas les changements, et ne se heurte pas au verrou,
-- puisque celui-ci est posé sur les lignes de la table, et non pas sur la photo de cette table que détient la session.

-- Mais quand on pose un verrou, on est obligé de travailler sur la vrai table et non une photo.


-- RESUME:
-- On pose un verrou partagé lorsqu'on fait une requête dans le but de lire des données.
-- On pose un verrou exclusif lorsqu'on fait une requête dans le but (immédiat ou non) de modifier des données.
-- Un verrou partagé sur les lignes x va permettre aux autres sessions d'obtenir également un verrou partagé sur les lignes x, mais pas d'obtenir un verrou exclusif.
-- Un verrou exclusif sur les lignes x va empêcher les autres sessions d'obtenir un verrou sur les lignes x, qu'il soit partagé ou exclusif.



----------------------------------------
-- VERROUS ET INDEX
----------------------------------------

-- Si on ne crée pas d'index sur une table, elle ne pourra pas trier les données et selectionner facilement une donnée dans la masse.
-- ainsi, on ne verouillera pas réellement une donnée mais toute sa table...



----------------------------------------
-- LIGNE FANTOME ET INDEX DE CLE SUIVANTE
----------------------------------------

-- EXEMPLE:
START TRANSACTION;

SELECT * FROM Adoption WHERE client_id > 13 FOR UPDATE; 
    -- ne pas oublier le FOR UPDATE pour poser le verrou exclusif

-- Imaginons maintenant qu'une seconde session démarre une transaction à ce moment-là,
-- insère et commite une ligne dans Adoption pour le client 15.
-- Si, par la suite, la première session refait la même requête de sélection avec verrou exclusif,
-- elle va faire apparaître une troisième ligne de résultat : l'adoption nouvellement insérée
-- (étant donné que pour poser le verrou, la session va aller chercher les données les plus à jour, prenant en compte le commit de la seconde session).

-- Cette ligne nouvellement apparue malgré les verrous est une "ligne fantôme".

 -- les verrous posés par des requêtes de lecture, de modification et de suppression 
 -- sont des verrous dits "de clé suivante" ; ils empêchent l'insertion d'une ligne dans les espaces entre les lignes verrouillées,
 -- ainsi que dans l'espace juste après les lignes verrouillées.

-- CONTINUITE SUR UNE DEUXIEME SESSION
 START TRANSACTION;

INSERT INTO Adoption (client_id, animal_id, date_reservation, prix) 
VALUES (15, 61, NOW(), 735.00);
-- la session va donc bloquer!



----------------------------------------
-- POURQUOI VERROUILLER LES REQUETES DE SELECTIONS?
----------------------------------------

-- parce que dans certains cas, ces données sont voués à être modifiés juste après (exemple: selection d'un billet de train)



----------------------------------------
-- NIVEAUX D ISOLATION
----------------------------------------

-- Nous avons vu que par défaut :

-- lorsque l'on démarre une transaction, la session prend une photo des tables, et travaille uniquement sur cette photo (donc sur des données potentiellement périmées) tant qu'elle ne pose pas un verrou;
-- les requêtes SELECT ne posent pas de verrous si l'on ne le demande pas explicitement ;
-- les requêtes SELECT ... LOCK IN SHARE MODE, SELECT ... FOR UPDATE, DELETE et UPDATE posent un verrou de clé suivante (sauf dans le cas d'une recherche sur index unique, avec une valeur unique).
-- Ce comportement est défini par le niveau d'isolation des transactions.

SET [GLOBAL | SESSION] TRANSACTION ISOLATION LEVEL { READ UNCOMMITTED | READ COMMITTED  | REPEATABLE READ  | SERIALIZABLE }
-- définition des niveau d'isolation

REPEATABLE READ -- non verrouillé, statut de base.
READ COMMITTED -- voir les derniers changements committés
READ UNCOMMITTED -- READ COMMITTED + lecture sale, soit la vision des changements non-committés.
SERIALIZABLE -- REPEATABLE READ + quand mode autocommit = désactivé, tous les SELECT deviennent SELECT ... LOCK IN SHARE MODE