----------------------------------------
-- TYPES
----------------------------------------
-- Datas types:

TINYINT SMALLINT MEDIUMINT INT BIGINT [UNSIGNED ZEROFILL]   -- numbers
DECIMAL NUMERIC FLOAT REAL DOUBLE                           -- decimals
CHAR VARCHAR TINYTEXT TEXT MEDIUMTEXT LONGTEXT              -- text
VARBINARY BINARY TINYBLOB MEDIUMBLOB BLOB LONGBLOB          -- binaries
DATE DATETIME TIME,TIMESTAMP YEAR                           -- date and time

----------------------------------------
-- EXECUTE FILE
----------------------------------------
SOURCE monFichier.sql;
\. monFichier.sql;

----------------------------------------
-- for .csv or others

LOAD DATA LOCAL INFILE 'C:\\Users\\mbrio\\Desktop\\programmation\\SQL\\animal.csv' -- can be relative path
INTO TABLE Personne
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n' -- ou '\n' selon l'ordinateur et le programme utilisés pour créer le fichier
IGNORE 1 LINES
(nom,prenom,date_naissance);

----------------------------------------
-- DATABASES
----------------------------------------
-- create/drop/use database

CREATE DATABASE elevage CHARACTER SET 'utf8';
DROP DATABASE IF EXISTS elevage;
USE elevage;


----------------------------------------
-- TABLES
----------------------------------------
-- create tables

CREATE TABLE [IF NOT EXISTS] Nom_table (
    colonne1 description_colonne1,
    [colonne2 description_colonne2,
    colonne3 description_colonne3,
    ...,]
    [PRIMARY KEY (colonne_clé_primaire)]
)
[ENGINE=moteur];
----------------------------------------
-- example

CREATE TABLE Animal (
    id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    espece VARCHAR(40) NOT NULL,
    sexe CHAR(1),
    date_naissance DATETIME NOT NULL,
    nom VARCHAR(30),
    commentaires TEXT,
    PRIMARY KEY (id)
)
ENGINE=INNODB;
----------------------------------------
-- verifications

SHOW TABLES;      -- liste les tables de la base de données
DESCRIBE Animal;  -- liste les colonnes de la table avec leurs caractéristiques
----------------------------------------
-- drop table

DROP TABLE Animal;
----------------------------------------
-- modify table

ALTER TABLE nom_table ADD ... -- permet d'ajouter quelque chose (une colonne par exemple)

ALTER TABLE nom_table DROP ... -- permet de retirer quelque chose 

ALTER TABLE nom_table 
CHANGE ancien_nom nouveau_nom nouvelle_description;
ALTER TABLE nom_table 
MODIFY nom_colonne nouvelle_description; -- permettent de modifier une colonne

ALTER TABLE Test_tuto 
CHANGE prenom nom VARCHAR(30) NOT NULL; -- Changement du type + changement du nom
ALTER TABLE Test_tuto 
CHANGE id id BIGINT NOT NULL; -- Changement du type sans renommer
ALTER TABLE Test_tuto
MODIFY id BIGINT NOT NULL AUTO_INCREMENT; -- Ajout de l'auto-incrémentation
ALTER TABLE Test_tuto 
MODIFY nom VARCHAR(30) NOT NULL DEFAULT 'Blabla'; -- Changement de la description (même type mais ajout d'une valeur par défaut)

----------------------------------------
-- DATA INSERTION
----------------------------------------
INSERT INTO nom_table [(colonne1, colonne2, ...)] VALUES (valeur1, valeur2, ...);

INSERT INTO Animal (espece, sexe, date_naissance, nom) 
VALUES ('chien', 'F', '2008-12-06 05:18:00', 'Caroline'),
        ('chat', 'M', '2008-09-11 15:38:00', 'Bagherra'),
        ('tortue', NULL, '2010-08-23 05:18:00', NULL);

----------------------------------------
-- DATA SELECTION
----------------------------------------
SELECT colonne1, colonne2, ... 
FROM nom_table
[WHERE column = value];

-- Operators:
-------------
-- =    égal
-- <    inférieur
-- <=   inférieur ou égal
-- >    supérieur
-- >=   supérieur ou égal
-- <>   ou != différent
-- <=>  égal (valable pour NULL aussi)

-- Logical operators:
-------------
-- AND    &&    ET
-- OR     ||    OU
-- XOR          OU exclusif
-- NOT    !     NON

-- examples:
-------------
-- Femals cats
SELECT * 
FROM Animal 
WHERE espece='chat' 
    AND sexe='F';
-- OU
SELECT * 
FROM Animal 
WHERE espece='chat' 
    && sexe='F';

-- turtles or perroquets:
SELECT * 
FROM Animal 
WHERE espece='tortue' 
    OR espece='perroquet';

-- Mal or perroquets, but not both:
SELECT * 
FROM Animal 
WHERE sexe='M' 
    XOR espece='perroquet';

-- complex example:
SELECT * 
FROM Animal 
WHERE date_naissance > '2009-12-31'
    OR
    ( espece='chat'
         AND
        ( sexe='M'
            OR
            ( sexe='F' AND date_naissance < '2007-06-01' )
        )
    );

-- NULL operator:
-------------
SELECT * 
FROM Animal 
WHERE nom <=> NULL; -- sélection des animaux sans nom
-- OU
SELECT * 
FROM Animal 
WHERE nom IS NULL;

SELECT * 
FROM Animal 
WHERE commentaires IS NOT NULL; -- sélection des animaux pour lesquels un commentaire existe

-- ORDER BY:
-------------
SELECT * 
FROM Animal 
WHERE espece='chien' 
    AND nom IS NOT NULL 
ORDER BY nom DESC;

SELECT * 
FROM Animal 
ORDER BY espece, date_naissance;

-- DISTINCT:
-------------
SELECT DISTINCT espece -- avoid duplicates.
FROM Animal;

--LIMIT:
-------------
SELECT * 
FROM Animal 
ORDER BY id 
LIMIT 6 OFFSET 0; -- want the 6 first lines

SELECT * 
FROM Animal 
ORDER BY id 
LIMIT 6 OFFSET 3; -- want the 6 first line, begin after the 3rst line

----------------------------------------
-- DATA SELECTION ++
----------------------------------------
-- LIKE:
-------------
-- use 'LIKE' keyword to search words as regex.
-- % and _ are specials caracters for the 'LIKE' keyword.
-- % search any string lenght from 0 to x.
-- _ represent 1 caracter.

SELECT * 
FROM Animal 
WHERE commentaires LIKE '%\%%'; -- search sentence with the '%' caracter

SELECT * 
FROM Animal 
WHERE nom LIKE '%Lu%'; -- insensible à la casse

SELECT * 
FROM Animal 
WHERE nom LIKE BINARY '%Lu%'; -- sensible à la casse

SELECT * 
FROM Animal 
WHERE id LIKE '1%'; -- 1, 10, 153...

-- RESEARCH IN INTERVAL:
-------------
SELECT * 
FROM Animal 
WHERE date_naissance BETWEEN '2008-01-05' AND '2009-03-23';

-- IN:
-------------
SELECT * 
FROM Animal 
WHERE nom IN ('Moka', 'Bilba', 'Tortilla', 'Balou', 'Dana', 'Redbul', 'Gingko');

----------------------------------------
-- SAVE DATABASE
----------------------------------------
'mysqldump -u user -p --opt nom_de_la_base > sauvegarde.sql' -- shell command

'mysql elevage < elevage_sauvegarde.sql' -- shell command / if the database does not exist, create and load the save content.

USE elevage;
SOURCE elevage_sauvegarde.sql; -- The same in MySQL.

----------------------------------------
-- DELETE [FROM] TABLE
----------------------------------------
DELETE FROM Animal 
WHERE nom = 'Zoulou';

DELETE FROM Animal; -- delete all datas

----------------------------------------
-- UPDATE TABLE
----------------------------------------
-- The ALTER changes the table in the database, you can add or remove columns, etc.
-- But it does not change data (except in the dropped or added columns of course).

-- While the UPDATE changes the rows in the table, and leaves the table unchanged.

UPDATE nom_table
SET col1 = val1 [, col2 = val2, ...]
[WHERE ...];

UPDATE Animal
SET sexe='F', nom='Pataude'
WHERE id=21;

UPDATE Animal
SET commentaires='modification de toutes les lignes';

----------------------------------------
-- INDEX
----------------------------------------
-- 'index par la gauche' (non utilisable avec FULLTEXT).
-- Ajouter un index unique, c'est ajouter une contrainte (NOT NULL est aussi une contrainte, ainsi que les valeurs par défaut).

-- classical index is just KEY or INDEX.
-- add UNIQUE     -> you can't have 2 same values
-- add FULLTEXT   -> used to search in VAR, CHARVAR AND TEXT

CREATE TABLE nom_table (
    colonne1 description_colonne1,
    [colonne2 description_colonne2,
    colonne3 description_colonne3,
    ...,]
    [PRIMARY KEY (colonne_clé_primaire)],
    [INDEX [nom_index] (colonne1_index [, colonne2_index, ...])]
    [UNIQUE [INDEX] ind_uni_col2 (colonne2),     -- Crée un index UNIQUE sur la colonne2, INDEX est facultatif
    FULLTEXT [INDEX] ind_full_col3 (colonne3)]   -- Crée un index FULLTEXT sur la colonne3, INDEX est facultatif
)
[ENGINE=moteur];

-- example:
CREATE TABLE Animal (
    id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    espece VARCHAR(40) NOT NULL,
    sexe CHAR(1),
    date_naissance DATETIME NOT NULL,
    nom VARCHAR(30),
    commentaires TEXT,
    PRIMARY KEY (id),
    INDEX ind_date_naissance (date_naissance),  -- index sur la date de naissance
    UNIQUE INDEX ind_uni_nom_espece (nom, espece)  -- Index sur le nom et l'espece
)
ENGINE=INNODB;


-- ADD INDEX TO A TABLE:
------------------------
ALTER TABLE nom_table
ADD INDEX [nom_index] (colonne_index [, colonne2_index ...]); --Ajout d'un index simple
--
ALTER TABLE nom_table
ADD UNIQUE [nom_index] (colonne_index [, colonne2_index ...]); --Ajout d'un index UNIQUE
--
ALTER TABLE nom_table
ADD FULLTEXT [nom_index] (colonne_index [, colonne2_index ...]); --Ajout d'un index FULLTEXT


CREATE INDEX nom_index
ON nom_table (colonne_index [, colonne2_index ...]);  -- Crée un index simple
--
CREATE UNIQUE INDEX nom_index
ON nom_table (colonne_index [, colonne2_index ...]);  -- Crée un index UNIQUE
--
CREATE FULLTEXT INDEX nom_index
ON nom_table (colonne_index [, colonne2_index ...]);  -- Crée un index FULLTEXT


-- ADD UNIQUE INDEX AS A CONSTAINT:
------------------------
CREATE TABLE nom_table (
    colonne1 INT NOT NULL,   
    colonne2 VARCHAR(40), 
    colonne3 TEXT,
    CONSTRAINT [symbole_contrainte] UNIQUE [INDEX] ind_uni_col2 (colonne2)
);

ALTER TABLE nom_table
    ADD CONSTRAINT [symbole_contrainte] UNIQUE ind_uni_col2 (colonne2);


-- DROP AN INDEX:
------------------------
ALTER TABLE nom_table 
    DROP INDEX nom_index;

----------------------------------------
-- SEARCH WITH FULLTEXT INDEX
----------------------------------------
SELECT *                                 -- Vous mettez évidemment les colonnes que vous voulez.
    FROM nom_table
    WHERE MATCH(colonne1[, colonne2, ...])   -- La (ou les) colonne(s) dans laquelle (ou lesquelles) on veut faire la recherche (index FULLTEXT correspondant nécessaire).
    AGAINST ('chaîne recherchée' IN NATURAL LANGUAGE MODE);            -- La chaîne de caractères recherchée, entre guillemets bien sûr.

SELECT *
    FROM Livre
    WHERE MATCH(auteur)
    AGAINST ('Terry');

SELECT * 
    FROM nom_table
    WHERE MATCH(colonne) 
    AGAINST('chaîne recherchée' IN BOOLEAN MODE);  -- IN BOOLEAN MODE à l'intérieur des parenthèses !

SELECT * 
    FROM Livre
    WHERE MATCH(titre)
    AGAINST ('+bonheur -ogres' IN BOOLEAN MODE); -- want 'bonheur' but not 'ogres'.

SELECT * 
    FROM Livre
    WHERE MATCH(titre)
    AGAINST ('petit*' IN BOOLEAN MODE); -- every words who begins by 'petit'.

SELECT * 
    FROM Livre
    WHERE MATCH(titre, auteur)
    AGAINST ('d*' IN BOOLEAN MODE); -- every words in 'titre' and 'auteur' who begins by 'd'.

SELECT *
    FROM Livre
    WHERE MATCH(titre, auteur)
    AGAINST ('Daniel' WITH QUERY EXPANSION); -- second research after a first, who add result from the firsts results.

----------------------------------------
-- KEYS
----------------------------------------
-- PRIMARY KEY:
------------------------
CREATE TABLE [IF NOT EXISTS] Nom_table (
    colonne1 description_colonne1 [,
    colonne2 description_colonne2,
    colonne3 description_colonne3,
    ...],
    [CONSTRAINT [symbole_contrainte]] PRIMARY KEY (colonne_pk1 [, colonne_pk2, ...])  -- comme pour les index UNIQUE, CONSTRAINT est facultatif
)
[ENGINE=moteur];

-- ADD/DROP PRIMARY KEY:
------------------------
ALTER TABLE nom_table
ADD [CONSTRAINT [symbole_contrainte]] PRIMARY KEY (colonne_pk1 [, colonne_pk2, ...]);

ALTER TABLE nom_table
DROP PRIMARY KEY

----------------------------------------
-- FOREIGN KEYS
----------------------------------------
-- Permet de gérer les liens entre 2 tables.

-- Comme pour les index et les clés primaires, il est possible de créer des clés étrangères composites.

-- Lorsque vous créez une clé étrangère sur une colonne (ou un groupe de colonnes)
-- – la colonne client de Commande dans notre exemple –,
-- un index est automatiquement ajouté sur celle-ci (ou sur le groupe).

-- Par contre, la colonne (le groupe de colonnes) qui sert de référence - la colonne numero de Client -
-- doit déjà posséder un index (où être clé primaire bien sûr).

-- La colonne (ou le groupe de colonnes) sur laquelle (lequel) la clé est créée doit être exactement
-- du même type que la colonne (le groupe de colonnes) qu'elle (il) référence. Cela implique qu'en cas de clé composite,
-- il faut le même nombre de colonnes dans la clé et la référence. Donc, si numero (dans Client) est un INT UNSIGNED,
-- client (dans Commande) doit être de type INT UNSIGNED aussi.

-- Tous les moteurs de table ne permettent pas l'utilisation des clés étrangères. Par exemple, MyISAM ne le permet pas, contrairement à InnoDB.

CREATE TABLE [IF NOT EXISTS] Nom_table (
    colonne1 description_colonne1,
    [colonne2 description_colonne2,
    colonne3 description_colonne3,
    ...,]
    [ [CONSTRAINT [symbole_contrainte]]  FOREIGN KEY (colonne(s)_clé_étrangère) REFERENCES table_référence (colonne(s)_référence)]
)
[ENGINE=moteur];

-- example:
CREATE TABLE Commande (
    numero INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    client INT UNSIGNED NOT NULL,
    produit VARCHAR(40),
    quantite SMALLINT DEFAULT 1,
    CONSTRAINT fk_client_numero          -- On donne un nom à notre clé
        FOREIGN KEY (client)             -- Colonne sur laquelle on crée la clé
        REFERENCES Client(numero)        -- Colonne de référence
)
ENGINE=InnoDB;                           -- MyISAM interdit, je le rappelle encore une fois !

ALTER TABLE Commande
ADD CONSTRAINT fk_client_numero FOREIGN KEY (client) REFERENCES Client(numero);

-- DROP FOREIGN KEY:
------------------------
ALTER TABLE nom_table
DROP FOREIGN KEY symbole_contrainte

-- EXAMPLE:
------------------------
-- Ajout d'une colonne espece_id
ALTER TABLE Animal ADD COLUMN espece_id SMALLINT UNSIGNED; -- même type que la colonne id de Espece

-- Remplissage de espece_id
UPDATE Animal SET espece_id = 1 WHERE espece = 'chien';
UPDATE Animal SET espece_id = 2 WHERE espece = 'chat';
UPDATE Animal SET espece_id = 3 WHERE espece = 'tortue';
UPDATE Animal SET espece_id = 4 WHERE espece = 'perroquet';

-- Suppression de la colonne espece
ALTER TABLE Animal DROP COLUMN espece;

-- Ajout de la clé étrangère
ALTER TABLE Animal
ADD CONSTRAINT fk_espece_id FOREIGN KEY (espece_id) REFERENCES Espece(id);

----------------------------------------
-- JOINTURES
----------------------------------------
-- INTERNAL JOINTURE:
------------------------
SELECT Espece.description           -- je sélectionne la colonne description de la table Espece.
FROM Espece                         -- je travaille sur la table Espece.
INNER JOIN Animal                   -- je la joins (avec une jointure interne) à la table Animal.
    ON Espece.id = Animal.espece_id -- la jointure se fait sur les colonnes id de la table Espece et espece_id de la table Animal, qui doivent donc correspondre.
WHERE Animal.nom = 'Cartouche';     -- dans la table résultant de la jointure, je sélectionne les lignes qui ont la valeur "Cartouche" dans la colonne nom venant de la table Animal.


SELECT *                                   -- comme d'habitude, vous sélectionnez les colonnes que vous voulez
FROM nom_table1   
[INNER] JOIN nom_table2                    -- INNER explicite le fait qu'il s'agit d'une jointure interne, mais c'est facultatif
    ON colonne_table1 = colonne_table2     -- sur quelles colonnes se fait la jointure (vous pouvez mettre colonne_table2 = colonne_table1, l'ordre n'a pas d'importance)
[WHERE ...]                               
[ORDER BY ...]                            -- les clauses habituelles sont bien sûr utilisables !
[LIMIT ...]

-- OTHER EXAMPLE:
------------------------
SELECT Espece.id,                   -- ici, pas le choix, il faut préciser
       Espece.description,          -- ici, on pourrait mettre juste description
       Animal.nom                   -- idem, la précision n'est pas obligatoire. C'est cependant plus clair puisque les espèces ont un nom aussi
FROM Espece   
INNER JOIN Animal
     ON Espece.id = Animal.espece_id
WHERE Animal.nom LIKE 'Ch%';


-- ALIAS EXAMPLE:
------------------------
SELECT Espece.id AS id_espece,                  
       Espece.description AS description_espece,          
       Animal.nom AS nom_bestiole                   
FROM Espece   
INNER JOIN Animal
     ON Espece.id = Animal.espece_id
WHERE Animal.nom LIKE 'Ch%';


-- EXTERNAL JOINTURES:
------------------------
SELECT Animal.nom AS nom_animal, Race.nom AS race
FROM Animal                         -- Table de gauche
LEFT JOIN Race                      -- Table de droite
    ON Animal.race_id = Race.id
WHERE Animal.espece_id = 2 
    AND Animal.nom LIKE 'C%'
ORDER BY Race.nom, Animal.nom;

SELECT Animal.nom AS nom_animal, Race.nom AS race
FROM Animal                                                -- Table de gauche
RIGHT JOIN Race                                            -- Table de droite
    ON Animal.race_id = Race.id
WHERE Race.espece_id = 2
ORDER BY Race.nom, Animal.nom;


SELECT *
FROM table1
[INNER | LEFT | RIGHT] JOIN table2 USING (colonneJ);  -- colonneJ est présente dans les deux tables

-- équivalent à 

SELECT *
FROM table1
[INNER | LEFT | RIGHT] JOIN table2 ON Table1.colonneJ = table2.colonneJ;

SELECT * 
FROM table1
NATURAL JOIN table3;

-- EST ÉQUIVALENT À

SELECT *
FROM table1
INNER JOIN table3
    ON table1.A = table3.A AND table1.C = table3.C;

-- On peut joindre une table à elle même (auto-jointure)


----------------------------------------
-- SOUS-REQUETES
----------------------------------------
SELECT MIN(date_naissance)
FROM (
    SELECT Animal.id, Animal.sexe, Animal.date_naissance, Animal.nom, Animal.espece_id, 
            Espece.id AS espece_espece_id         -- On renomme la colonne id de Espece, donc il n'y a plus de doublons.
    FROM Animal                                   -- Attention de ne pas la renommer espece_id, puisqu'on sélectionne aussi la colonne espece_id dans Animal !
    INNER JOIN Espece
        ON Espece.id = Animal.espece_id
    WHERE sexe = 'F'
    AND Espece.nom_courant IN ('Tortue d''Hermann', 'Perroquet amazone')
) AS tortues_perroquets_F;

SELECT id, nom, espece_id
FROM Race
WHERE espece_id < (
    SELECT id    
    FROM Espece
    WHERE nom_courant = 'Tortue d''Hermann');

SELECT id, sexe, nom, espece_id, race_id 
FROM Animal
WHERE (id, race_id) = (
    SELECT id, espece_id
    FROM Race
    WHERE id = 7);

SELECT *
FROM Animal
WHERE espece_id < ALL (
    SELECT id
    FROM Espece
    WHERE nom_courant IN ('Tortue d''Hermann', 'Perroquet amazone')
);

SELECT colonne1 
FROM tableA
WHERE colonne2 IN (
    SELECT colonne3
    FROM tableB
    WHERE tableB.colonne4 = tableA.colonne5
    );

SELECT id, nom, espece_id FROM Race 
WHERE EXISTS (SELECT * FROM Animal WHERE nom = 'Balou');

SELECT * FROM Race
WHERE NOT EXISTS (SELECT * FROM Animal WHERE Animal.race_id = Race.id);

----------------------------------------
-- COMPLEX INSERTIONS
----------------------------------------
INSERT INTO nom_table
   [(colonne1, colonne2, ...)]
SELECT [colonne1, colonne2, ...]
FROM nom_table2
[WHERE ...]

INSERT INTO Animal 
    (nom, sexe, date_naissance, race_id, espece_id)              
    -- Je précise les colonnes puisque je ne donne pas une valeur pour toutes.
SELECT  'Yoda', 'M', '2010-11-09', id AS race_id, espece_id     
    -- Attention à l'ordre !
FROM Race WHERE nom = 'Maine coon';

----------------------------------------
-- COMPLEX UPDATES
----------------------------------------
UPDATE Animal SET commentaires = 'Coco veut un gâteau !' WHERE espece_id = 
    (SELECT id FROM Espece WHERE nom_courant LIKE 'Perroquet%');


UPDATE Animal SET race_id = 
    (SELECT id FROM Race WHERE nom = 'Nebelung' AND espece_id = 2)
WHERE nom = 'Cawette';

-- on ne peut pas modifier un élément d'une table que l'on utilise dans une sous-requête!

----------------------------------------
-- COMPLEX DELETIONS
----------------------------------------
DELETE FROM Animal
WHERE nom = 'Carabistouille' AND espece_id = 
    (SELECT id FROM Espece WHERE nom_courant = 'Chat');

DELETE Animal   -- Je précise de quelles tables les données doivent être supprimées
FROM Animal     -- Table principale
INNER JOIN Espece ON Animal.espece_id = Espece.id    
    -- Jointure     
WHERE Animal.nom = 'Carabistouille' 
    AND Espece.nom_courant = 'Chat';


----------------------------------------
-- UNIONS
----------------------------------------
SELECT Animal.* FROM Animal 
INNER JOIN Espece ON Animal.espece_id = Espece.id 
WHERE Espece.nom_courant = 'Chat'
UNION
SELECT Animal.* FROM Animal 
INNER JOIN Espece ON Animal.espece_id = Espece.id 
WHERE Espece.nom_courant = 'Tortue d''Hermann'; -- want cats and turtles

-- Pas le même nombre de colonnes = erreur!!
------------------------------------
SELECT Animal.id, Animal.nom, Espece.nom_courant                    
    -- 3 colonnes sélectionnées
FROM Animal
INNER JOIN Espece ON Animal.espece_id = Espece.id
WHERE Espece.nom_courant = 'Chat'
UNION
SELECT Animal.id, Animal.nom, Espece.nom_courant, Animal.espece_id 
    -- 4 colonnes sélectionnées
FROM Animal
INNER JOIN Espece ON Animal.espece_id = Espece.id
WHERE Espece.nom_courant = 'Tortue d''Hermann';

-- UNION ALL:
------------------------------------
SELECT * FROM Espece
UNION ALL
SELECT * FROM Espece; -- duplicates

-- LIMIT:
------------------------------------
SELECT id, nom, 'Race' AS table_origine FROM Race LIMIT 3
UNION
SELECT id, nom_latin, 'Espèce' AS table_origine FROM Espece;

SELECT id, nom, 'Race' AS table_origine FROM Race
UNION
(SELECT id, nom_latin, 'Espèce' AS table_origine FROM Espece LIMIT 2); -- no parentheses = LIMIT for both selects! ;)

-- ORDER:
------------------------------------
(SELECT id, nom, 'Race' AS table_origine FROM Race LIMIT 6)
UNION
(SELECT id, nom_latin, 'Espèce' AS table_origine FROM Espece LIMIT 3)
ORDER BY nom LIMIT 5;

(SELECT id, nom, 'Race' AS table_origine FROM Race ORDER BY nom DESC LIMIT 6)
UNION
(SELECT id, nom_latin, 'Espèce' AS table_origine FROM Espece LIMIT 3);


----------------------------------------
-- DELETE FOREIGN KEYS
----------------------------------------
ALTER TABLE nom_table
ADD [CONSTRAINT fk_col_ref]         
    FOREIGN KEY (colonne)            
    REFERENCES table_ref(col_ref)
    ON DELETE {RESTRICT | NO ACTION | SET NULL | CASCADE};  
    -- Nouvelle option !

ALTER TABLE Animal
ADD CONSTRAINT fk_race_id FOREIGN KEY (race_id) REFERENCES Race(id) ON DELETE SET NULL; -- if we delete a race, animals who have that race will have NULL race.

-- ON DELETE CASCADE: quand on supprime la clé, on supprime toutes les données auquelles on a affecté cette clé! be care!!

----------------------------------------
-- UPDATE FOREIGN KEYS
----------------------------------------
-- Suppression de la clé --
-- ------------------------
ALTER TABLE Animal DROP FOREIGN KEY fk_race_id;
-- Recréation de la clé avec les bonnes options --
-- -----------------------------------------------
ALTER TABLE Animal
ADD CONSTRAINT fk_race_id FOREIGN KEY (race_id) REFERENCES Race(id)
    ON DELETE SET NULL   
        -- N'oublions pas de remettre le ON DELETE !
    ON UPDATE CASCADE;   
-- Modification de l'id des Singapura --
-- -------------------------------------
UPDATE Race SET id = 3 WHERE nom = 'Singapura';

----------------------------------------
-- VIOLATION DE CONTRAINTE D UNICITE
----------------------------------------
INSERT IGNORE INTO Espece (nom_courant, nom_latin, description)
VALUES ('Chien en peluche', 'Canis canis', 'Tout doux, propre et  silencieux'); -- IGNORE = pas d'erreur mais pas de ligne inséré non plus..!

LOAD DATA [LOCAL] INFILE 'nom_fichier' IGNORE    
-- IGNORE se place juste avant INTO, comme dans INSERT
INTO TABLE nom_table
[FIELDS
    [TERMINATED BY '\t']
    [ENCLOSED BY '']
    [ESCAPED BY '\\' ]
]
[LINES 
    [STARTING BY '']    
    [TERMINATED BY '\n']
]
[IGNORE nombre LINES]
[(nom_colonne,...)];

-- REPLACEMENT:
--------------------
REPLACE INTO Animal (id, sexe, nom, date_naissance, espece_id) 
    -- Je donne moi-même un id, qui existe déjà !
VALUES (32, 'M', 'Spoutnik', '2009-07-26 11:52:00', 3);        
    -- Et Spoutnik est mon souffre-douleur du jour.

INSERT INTO nom_table [(colonne1, colonne2, colonne3)]
VALUES (valeur1, valeur2, valeur3)
ON DUPLICATE KEY UPDATE colonne2 = valeur2 [, colonne3 = valeur3];

SELECT id, sexe, date_naissance, nom, espece_id, mere_id, pere_id 
FROM Animal 
WHERE nom = 'Spoutnik';