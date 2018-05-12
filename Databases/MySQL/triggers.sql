-- --------------------------------------
-- TRIGGERS
-- --------------------------------------

-- Les triggers (ou déclencheurs) sont des objets de la base de données.
-- Attachés à une table, ils vont déclencher l'exécution d'une instruction,
-- ou d'un bloc d'instructions, lorsqu'une, ou plusieurs lignes sont insérées,
-- supprimées ou modifiées dans la table à laquelle ils sont attachés.


-- Un trigger est attaché à une table, et peut être déclenché par :
-- une insertion dans la table (requête INSERT) ;
-- la suppression d'une partie des données de la table (requête DELETE) ;
-- la modification d'une partie des données de la table (requête UPDATE).
-- Une fois le trigger déclenché, ses instructions peuvent être exécutées soit juste avant soit juste après l'instruction déclencheuse.


-- Un trigger exécute un traitement pour chaque ligne insérée, modifiée ou supprimée par l'événement déclencheur.



-- --------------------------------------
-- CREER UN TRIGGER
-- --------------------------------------


CREATE TRIGGER nom_trigger moment_trigger evenement_trigger
ON nom_table FOR EACH ROW
corps_trigger;


-- INSERT, UPDATE, DELETE -> trois types de déclencheurs.
-- BEFORE, AFTER -> 2 moment d'intervention
-- seul un trigger par combinaison possible (6 en tout)
-- on les nomme selon leur combinaison (ex: before_update_animal)

-- OLD (read only), NEW (read and write) -> représentent les données avant et après modif'. Seul UPDATE possède les deux valeurs.


-- blabla gestion d'exeptions:
-- https://openclassrooms.com/courses/administrez-vos-bases-de-donnees-avec-mysql/triggers#/id/r-1990245



-- --------------------------------------
-- SUPPRIMER UN TRIGGER
-- --------------------------------------


DROP TRIGGER nom_trigger;



-- --------------------------------------
-- EXEMPLES
-- --------------------------------------

-- On va créer des triggers qui empêche l'insertion d'autrez caractère que 'F' et 'M' pour le sexe.

-- Trigger déclenché par l'insertion
DELIMITER |
CREATE TRIGGER before_insert_animal BEFORE INSERT
ON Animal FOR EACH ROW
BEGIN
    IF NEW.sexe IS NOT NULL   -- le sexe n'est ni NULL
    AND NEW.sexe != 'M'       -- ni "M"âle
    AND NEW.sexe != 'F'       -- ni "F"emelle
    AND NEW.sexe != 'A'       -- ni "A"utre
      THEN
        SET NEW.sexe = NULL;
    END IF;
END |

-- Trigger déclenché par la modification
CREATE TRIGGER before_update_animal BEFORE UPDATE
ON Animal FOR EACH ROW
BEGIN
    IF NEW.sexe IS NOT NULL   -- le sexe n'est ni NULL
    AND NEW.sexe != 'M'       -- ni "M"âle
    AND NEW.sexe != 'F'       -- ni "F"emelle
    AND NEW.sexe != 'A'       -- ni "A"utre
      THEN
        SET NEW.sexe = NULL;
    END IF;
END |
DELIMITER ;


-- Le reste est archi relou et situationnel, je met le lien (il fait chier ce tuto):
-- https://openclassrooms.com/courses/administrez-vos-bases-de-donnees-avec-mysql/triggers