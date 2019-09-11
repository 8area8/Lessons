-- --------------------------------------
-- VUES MATERIALISES
-- --------------------------------------

-- des vues, dont les données sont matérialisées, c'est-à-dire stockées.
-- Pas implémenté par MySQL donc il faut ruser

-- les vues n'ont pas de gain de performance sur une requête classique.
-- Elles peuvent même être plus lentes: un algo de type TEMPTABLE utilise 2 requêtes, et en plus la table crée ne possède aucun index !

-- CAS D UTILISATION DE TEMPTABLE:
-- DISTINCT ;
-- LIMIT ;
-- une fonction d'agrégation (SUM(), COUNT(), MAX(), etc.) ;
-- GROUP BY ;
-- HAVING ;
-- UNION ;
-- une sous-requête dans la clause SELECT.


-- Une vue matérialisée est un objet qui permet de stocker le résultat d'une requête SELECT



-- --------------------------------------
-- CREATION
-- --------------------------------------


-- On peut en faire une table:
--
CREATE TABLE VM_Revenus_annee_espece
ENGINE = InnoDB
SELECT YEAR(date_reservation) AS annee, Espece.id AS espece_id, SUM(Adoption.prix) AS somme, COUNT(Adoption.animal_id) AS nb
FROM Adoption
INNER JOIN Animal ON Animal.id = Adoption.animal_id
INNER JOIN Espece ON Animal.espece_id = Espece.id
GROUP BY annee, Espece.id;



-- --------------------------------------
-- MISES A JOUR SUR DEMANDE
-- --------------------------------------


DELIMITER |
CREATE PROCEDURE maj_vm_revenus()
BEGIN
    TRUNCATE VM_Revenus_annee_espece;

    INSERT INTO VM_Revenus_annee_espece
    SELECT YEAR(date_reservation) AS annee, Espece.id AS espece_id, SUM(Adoption.prix) AS somme, COUNT(Adoption.animal_id) AS nb
    FROM Adoption
    INNER JOIN Animal ON Animal.id = Adoption.animal_id
    INNER JOIN Espece ON Animal.espece_id = Espece.id
    GROUP BY annee, Espece.id;
END |
DELIMITER ;

-- TRUNCATE supprime table et la recrée sans les données




-- --------------------------------------
-- MISES A JOUR AUTOMATISE
-- --------------------------------------


ALTER TABLE VM_Revenus_annee_espece
    ADD CONSTRAINT fk_vm_revenu_espece_id FOREIGN KEY (espece_id) REFERENCES Espece (id) ON DELETE CASCADE,
    ADD PRIMARY KEY (annee, espece_id);


DELIMITER |

DROP TRIGGER after_insert_adoption |
CREATE TRIGGER after_insert_adoption AFTER INSERT
ON Adoption FOR EACH ROW
BEGIN
    UPDATE Animal
    SET disponible = FALSE
    WHERE id = NEW.animal_id;

    INSERT INTO VM_Revenus_annee_espece (espece_id, annee, somme, nb)
    SELECT espece_id, YEAR(NEW.date_reservation), NEW.prix, 1
    FROM Animal
    WHERE id = NEW.animal_id
    ON DUPLICATE KEY UPDATE somme = somme + NEW.prix, nb = nb + 1;
END |

DROP TRIGGER after_update_adoption |
CREATE TRIGGER after_update_adoption AFTER UPDATE
ON Adoption FOR EACH ROW
BEGIN
    IF OLD.animal_id <> NEW.animal_id THEN
        UPDATE Animal
        SET disponible = TRUE
        WHERE id = OLD.animal_id;

        UPDATE Animal
        SET disponible = FALSE
        WHERE id = NEW.animal_id;
    END IF;

    INSERT INTO VM_Revenus_annee_espece (espece_id, annee, somme, nb)
    SELECT espece_id, YEAR(NEW.date_reservation), NEW.prix, 1
    FROM Animal
    WHERE id = NEW.animal_id
    ON DUPLICATE KEY UPDATE somme = somme + NEW.prix, nb = nb + 1;

    UPDATE VM_Revenus_annee_espece
    SET somme = somme - OLD.prix, nb = nb - 1
    WHERE annee = YEAR(OLD.date_reservation)
    AND espece_id = (SELECT espece_id FROM Animal WHERE id = OLD.animal_id);
 
    DELETE FROM VM_Revenus_annee_espece
    WHERE nb = 0;
END |

DROP TRIGGER after_delete_adoption |
CREATE TRIGGER after_delete_adoption AFTER DELETE
ON Adoption FOR EACH ROW
BEGIN
    UPDATE Animal
    SET disponible = TRUE
    WHERE id = OLD.animal_id;

    UPDATE VM_Revenus_annee_espece
    SET somme = somme - OLD.prix, nb = nb - 1
    WHERE annee = YEAR(OLD.date_reservation)
    AND espece_id = (SELECT espece_id FROM Animal WHERE id = OLD.animal_id);
 
    DELETE FROM VM_Revenus_annee_espece
    WHERE nb = 0;
END |

DELIMITER ;



-- --------------------------------------
-- GAINS DE PERFORMANCE
-- --------------------------------------

-- Les vues matérialisés sont en moyenne 5x plus rapide que les vues,
-- qui sont elles légèrement plus lentes que les requêtes sur table avec INNER JOIN.
-- le coût de la mise à jour est cependant très lourd !