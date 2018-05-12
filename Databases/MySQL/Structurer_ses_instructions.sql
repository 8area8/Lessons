-- --------------------------------------
-- STRUCTURER SES INSTRUCTIONS
-- --------------------------------------

-- Lorsque l'on écrit une série d'instructions, par exemple dans le corps d'une procédure stockée,
-- il est nécessaire d'être capable de structurer ses instructions.
-- Cela va permettre d’instiller de la logique dans le traitement :
-- exécuter telles ou telles instructions en fonction des données que l'on possède, répéter une instruction un certain nombre de fois, etc.



-- --------------------------------------
-- OUTILS DE STRUCTURATION
-- --------------------------------------


-- les variables locales : qui vont permettre de stocker et modifier des valeurs pendant le déroulement d'une procédure ;
-- les conditions : qui vont permettre d'exécuter certaines instructions seulement si une certaine condition est remplie ;
-- les boucles : qui vont permettre de répéter une instruction plusieurs fois.


-- Ces structures sont bien sûr utilisables dans les procédures stockées, que nous avons vues au chapitre précédent, mais pas uniquement.
-- Elles sont utilisables dans tout objet définissant une série d'instructions à exécuter.
-- C'est le cas des fonctions stockées (non couvertes par ce cours et qui forment avec les procédures stockées ce qu'on appelle les "routines"),
-- des événements (non couverts), et également des triggers, auxquels un chapitre est consacré à la fin de cette partie.


-- --------------------------------------
-- BLOCS D'INSTRUCTION ET VARIABLES LOCALES
-- --------------------------------------


-- Il est possible d'imbriquer les blocs d'instruction:
BEGIN
    SELECT 'Bloc d''instructions principal';
	
    BEGIN
        SELECT 'Bloc d''instructions 2, imbriqué dans le bloc principal';
		
        BEGIN
            SELECT 'Bloc d''instructions 3, imbriqué dans le bloc d''instructions 2';
        END;
    END;
	
    BEGIN
        SELECT 'Bloc d''instructions 4, imbriqué dans le bloc principal';
    END;

END;



--
-- VARIABLES LOCALES
--


-- les variables locales peuvent être définies dans un bloc d'instructions.
DECLARE nom_variable type_variable [DEFAULT valeur_defaut];

-- Cette instruction doit se trouver au tout début du bloc d'instructions
-- dans lequel la variable locale sera utilisée (donc directement après le BEGIN).

BEGIN
    -- Déclarations (de variables locales par exemple)

    -- Instructions (dont éventuels blocs d'instructions imbriqués)
END;




-- --------------------------------------
-- CAS D'APPLICATION
-- --------------------------------------


DELIMITER |
CREATE PROCEDURE aujourdhui_demain ()
BEGIN
    DECLARE v_date DATE DEFAULT CURRENT_DATE();               
    -- On déclare une variable locale et on lui met une valeur par défaut (préfice 'v_')

    SELECT DATE_FORMAT(v_date, '%W %e %M %Y') AS Aujourdhui;

    SET v_date = v_date + INTERVAL 1 DAY;                     
    -- On change la valeur de la variable locale
    SELECT DATE_FORMAT(v_date, '%W %e %M %Y') AS Demain;
END|
DELIMITER ;


SET lc_time_names = 'fr_FR';
CALL aujourdhui_demain();


-- Les variables locales n'existent que dans le bloc d'instructions dans lequel elles ont été déclarées.
-- Dès que le mot-clé END est atteint, toutes les variables locales du bloc sont détruites.



-- --------------------------------------
-- Structures conditionnelles
-- --------------------------------------



--
-- LA STRUCTURE IF
--


IF condition THEN instructions
[ELSEIF autre_condition THEN instructions
[ELSEIF ...]]
[ELSE instructions]
END IF;

-- forme minimale
IF condition THEN
    instructions
END IF;


-- Exemple:
--
DELIMITER |
CREATE PROCEDURE est_adopte(IN p_animal_id INT)
BEGIN
    DECLARE v_nb INT DEFAULT 0;           
    -- On crée une variable locale

    SELECT COUNT(*) INTO v_nb             
    FROM Adoption                         
    WHERE animal_id = p_animal_id;
    -- On met le nombre de lignes correspondant à l'animal dans Adoption dans notre variable locale

    IF v_nb > 0 THEN 
    -- On teste si v_nb est supérieur à 0 (donc si l'animal a été adopté)
        SELECT 'J''ai déjà été adopté !';
    END IF;                               
    -- Et on n'oublie surtout pas le END IF et le ; final
END |
DELIMITER ;

CALL est_adopte(3);
CALL est_adopte(28);


-- Autre exemple:
--
DELIMITER |
CREATE PROCEDURE message_sexe(IN p_animal_id INT)
BEGIN
    DECLARE v_sexe VARCHAR(10);

    SELECT sexe INTO v_sexe
    FROM Animal
    WHERE id = p_animal_id;

    IF (v_sexe = 'F') THEN      -- Première possibilité
        SELECT 'Je suis une femelle !' AS sexe;
    ELSEIF (v_sexe = 'M') THEN  -- Deuxième possibilité
        SELECT 'Je suis un mâle !' AS sexe;
    ELSE                        -- Défaut
        SELECT 'Je suis en plein questionnement existentiel...' AS sexe;
    END IF;
END|
DELIMITER ;

CALL message_sexe(8);   -- Mâle
CALL message_sexe(6);   -- Femelle
CALL message_sexe(9);   -- Ni l'un ni l'autre



--
-- LA STRUCTURE CASE
--

CASE valeur_a_comparer
    WHEN possibilite1 THEN instructions
    [WHEN possibilite2 THEN instructions] ...
    [ELSE instructions]
END CASE;


-- Exemple:
--
DELIMITER |
CREATE PROCEDURE message_sexe2(IN p_animal_id INT)
BEGIN
    DECLARE v_sexe VARCHAR(10);

    SELECT sexe INTO v_sexe
    FROM Animal
    WHERE id = p_animal_id;

    CASE v_sexe
        WHEN 'F' THEN   -- Première possibilité
            SELECT 'Je suis une femelle !' AS sexe;
        WHEN 'M' THEN   -- Deuxième possibilité
            SELECT 'Je suis un mâle !' AS sexe;
        ELSE            -- Défaut
            SELECT 'Je suis en plein questionnement existentiel...' AS sexe;
    END CASE;
END|
DELIMITER ;

CALL message_sexe2(8);   -- Mâle
CALL message_sexe2(6);   -- Femelle
CALL message_sexe2(9);   -- Ni l'un ni l'autre


-- Seconde syntaxe:
--
CASE
    WHEN condition THEN instructions
    [WHEN condition THEN instructions] ...
    [ELSE instructions]
END CASE

DELIMITER |
CREATE PROCEDURE avant_apres_2010_case (IN p_animal_id INT, OUT p_message VARCHAR(100))
BEGIN
    DECLARE v_annee INT;

    SELECT YEAR(date_naissance) INTO v_annee
    FROM Animal
    WHERE id = p_animal_id;

    CASE
        WHEN v_annee < 2010 THEN
            SET p_message = 'Je suis né avant 2010.';
        WHEN v_annee = 2010 THEN
            SET p_message = 'Je suis né en 2010.';
        ELSE
            SET p_message = 'Je suis né après 2010.';   
    END CASE;
END |
DELIMITER ;

CALL avant_apres_2010_case(59, @message);   
SELECT @message;
CALL avant_apres_2010_case(62, @message);   
SELECT @message;
CALL avant_apres_2010_case(69, @message);
SELECT @message;


-- La suite sur le cours en question:
-- https://openclassrooms.com/courses/administrez-vos-bases-de-donnees-avec-mysql/structurer-ses-instructions#/id/r-1989450




-- --------------------------------------
-- LES BOUCLES
-- --------------------------------------


--
-- WHILE
--

WHILE condition DO    
-- Attention de ne pas oublier le DO, erreur classique
    instructions
END WHILE;


DELIMITER |
CREATE PROCEDURE compter_jusque_while(IN p_nombre INT)
BEGIN
    DECLARE v_i INT DEFAULT 1;

    WHILE v_i <= p_nombre DO
        SELECT v_i AS nombre; 

        SET v_i = v_i + 1;    
        -- À ne surtout pas oublier, sinon la condition restera vraie
    END WHILE;
END |
DELIMITER ;

CALL compter_jusque_while(3);


--
-- REPEAT
--

DELIMITER |
CREATE PROCEDURE compter_jusque_repeat(IN p_nombre INT)
BEGIN
    DECLARE v_i INT DEFAULT 1;

    REPEAT
        SELECT v_i AS nombre; 

        SET v_i = v_i + 1;    
        -- À ne surtout pas oublier, sinon la condition restera vraie
    UNTIL v_i > p_nombre END REPEAT;
END |
DELIMITER ;

CALL compter_jusque_repeat(3);



-- Condition fausse dès le départ, on ne rentre pas dans la boucle
CALL compter_jusque_while(0);   

-- Condition fausse dès le départ, on rentre quand même une fois dans la boucle
CALL compter_jusque_repeat(0);




-- --------------------------------------
-- LES LABELS
-- --------------------------------------


-- Boucle WHILE
-- ------------
super_while: WHILE condition DO    
    -- La boucle a pour label "super_while"
    instructions
END WHILE super_while;             
    -- On ferme en donnant le label de la boucle (facultatif)

-- Boucle REPEAT
-- -------------                  
repeat_genial: REPEAT  -- La boucle s'appelle "repeat_genial"
    instructions
UNTIL condition END REPEAT;
    -- Cette fois, on choisit de ne pas faire référence au label lors de la fermeture

-- Bloc d'instructions
-- -------------------
bloc_extra: BEGIN   -- Le bloc a pour label "bloc_extra"
    instructions
END bloc_extra;



-- --------------------------------------
-- LEAVE
-- --------------------------------------

LEAVE label_structure;


DELIMITER |
CREATE PROCEDURE test_leave1(IN p_nombre INT)
BEGIN
    DECLARE v_i INT DEFAULT 4;
    
    SELECT 'Avant la boucle WHILE';
    
    while1: WHILE v_i > 0 DO

        SET p_nombre = p_nombre + 1 -- On incrémente le nombre de 1
        
        IF p_nombre%10 = 0 THEN     -- Si p_nombre est divisible par 10,
            SELECT 'Stop !' AS 'Multiple de 10';
            LEAVE while1;   -- On quitte la boucle WHILE.
        END IF;
        
        SELECT p_nombre;    -- On affiche p_nombre
        SET v_i = v_i - 1;  -- Attention de ne pas l'oublier
    
    END WHILE while1;

    SELECT 'Après la boucle WHILE';
END|
DELIMITER ;

CALL test_leave1(3); -- La boucle s'exécutera 4 fois


-- QUITER LE CORPS MEME DE LA PROCEDURE:
--
DELIMITER |
CREATE PROCEDURE test_leave2(IN p_nombre INT)
corps_procedure: BEGIN                           
    -- On donne un label au bloc d'instructions principal
    DECLARE v_i INT DEFAULT 4;
    
    SELECT 'Avant la boucle WHILE';
    while1: WHILE v_i > 0 DO
        SET p_nombre = p_nombre + 1;    -- On incrémente le nombre de 1
        IF p_nombre%10 = 0 THEN     -- Si p_nombre est divisible par 10,
            SELECT 'Stop !' AS 'Multiple de 10';
            LEAVE corps_procedure;  -- je quitte la procédure.
        END IF;
        
        SELECT p_nombre;    -- On affiche p_nombre
        SET v_i = v_i - 1;  -- Attention de ne pas l'oublier
    END WHILE while1;

    SELECT 'Après la boucle WHILE';
END|
DELIMITER ;

CALL test_leave2(8);



-- --------------------------------------
-- LA BOUCLE LOOP
-- --------------------------------------

[label:] LOOP
    instructions
END LOOP [label] -- Utiliser obligatoirement LEAVE pour la quitter (!)

DELIMITER |
CREATE PROCEDURE compter_jusque_loop(IN p_nombre INT)
BEGIN
    DECLARE v_i INT DEFAULT 1;

    boucle_loop: LOOP
        SELECT v_i AS nombre; 

        SET v_i = v_i + 1;

        IF v_i > p_nombre THEN
            LEAVE boucle_loop;
        END IF;    
    END LOOP;
END |
DELIMITER ;

CALL compter_jusque_loop(3);