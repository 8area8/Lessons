-- --------------------------------------
-- GESTIONNAIRE D'ERREURS, CURESEURS ET UTILISATION AVANCE
-- --------------------------------------

-- Nous verrons deux structures utilisables dans les blocs d'instructions:
-- les gestionnaires d'erreur, qui permettent de gérer les cas où une erreur se produirait pendant l'exécution d'une série d'instructions ;
-- les curseurs, qui permettent de parcourir les lignes de résultat d'une requête SELECT.

--Ensuite, nous verrons quelques cas d'utilisation avancée des blocs d'instructions,
-- utilisant non seulement les structures décrites dans ce chapitre et le précédent,
-- mais également d'autres notions et objets (transaction, variables utilisateur, etc.).


-- --------------------------------------
-- GESTION DES ERREURS
-- --------------------------------------


-- Il arrive souvent des erreurs pour les blocs d'instructions,
-- dus aux variables non définies ou encore NULL.
-- Un gestionnaire d'erreurs permet d'y remédier.

DECLARE { EXIT | CONTINUE } HANDLER FOR { numero_erreur | { SQLSTATE identifiant_erreur } | condition } 
    -- instruction ou bloc d'instructions


-- Définit une seule instruction, ou un bloc d'instructions (BEGIN ... END;), qui va être exécuté en cas d'erreur correspondant au gestionnaire.
-- Déclaration après la déclaration des variables locales, mais avant les instructions de la procédure.
-- Peut provoquer l'arrêt de la procédure (EXIT) ou faire reprendre la procédure après avoir géré l'erreur (CONTINUE).
-- 3 identifications : un numéro d'erreur, un identifiant, ou une CONDITION.
-- Etant défini grâce au mot-clé DECLARE, il a la même portée que les variables locales.

--Exemple:
--
DELIMITER |
CREATE PROCEDURE ajouter_adoption_exit(IN p_client_id INT, IN p_animal_id INT, IN p_date DATE, IN p_paye TINYINT)
BEGIN
    DECLARE v_prix DECIMAL(7,2);
    DECLARE EXIT HANDLER FOR SQLSTATE '23000' 
        BEGIN
            SELECT 'Une erreur est survenue...';
            SELECT 'Arrêt prématuré de la procédure';
        END;

    SELECT 'Début procédure';

    SELECT COALESCE(Race.prix, Espece.prix) INTO v_prix
    FROM Animal
    INNER JOIN Espece ON Espece.id = Animal.espece_id
    LEFT JOIN Race ON Race.id = Animal.race_id
    WHERE Animal.id = p_animal_id;
    
    INSERT INTO Adoption (animal_id, client_id, date_reservation, date_adoption, prix, paye)
    VALUES (p_animal_id, p_client_id, CURRENT_DATE(), p_date, v_prix, p_paye);

    SELECT 'Fin procédure' AS message;
END|

CREATE PROCEDURE ajouter_adoption_continue(IN p_client_id INT, IN p_animal_id INT, IN p_date DATE, IN p_paye TINYINT)
BEGIN
    DECLARE v_prix DECIMAL(7,2);
    DECLARE CONTINUE HANDLER FOR SQLSTATE '23000' SELECT 'Une erreur est survenue...';

    SELECT 'Début procédure';

    SELECT COALESCE(Race.prix, Espece.prix) INTO v_prix
    FROM Animal
    INNER JOIN Espece ON Espece.id = Animal.espece_id
    LEFT JOIN Race ON Race.id = Animal.race_id
    WHERE Animal.id = p_animal_id;
    
    INSERT INTO Adoption (animal_id, client_id, date_reservation, date_adoption, prix, paye)
    VALUES (p_animal_id, p_client_id, CURRENT_DATE(), p_date, v_prix, p_paye);
  
    SELECT 'Fin procédure';
END|
DELIMITER ;

SET @date_adoption = CURRENT_DATE() + INTERVAL 7 DAY;

CALL ajouter_adoption_exit(18, 6, @date_adoption, 1);
CALL ajouter_adoption_continue(18, 6, @date_adoption, 1);


-- message d'erreur type:
ERROR 1062 (23000): Duplicate entry '21' for key 'ind_uni_animal_id'
-- 1062 = numéro d'erreur (propre à MySQL, plus préçit)
-- 23000 = identifiant de l'erreur (propre au SQL, plus général)



-- --------------------------------------
-- GEXEMPLE D'ERREURS
-- --------------------------------------


-- 1048 - 23000 - La colonne x ne peut pas être NULL
--
-- 1169 - 23000 - Violation de contrainte d'unicité
--
-- 1216 - 23000 - Violation de clé secondaire : insertion ou modification 
--				  impossible (table avec la clé secondaire)
--
-- 1217 - 23000 - Violation de clé secondaire : suppression ou modification 
--				  impossible (table avec la référence de la clé secondaire)
--
-- 1172 - 42000 - Plusieurs lignes de résultats alors qu'on ne peut en avoir 
--				  qu'une seule
--
-- 1242 - 21000 - La sous-requête retourne plusieurs lignes de résultats 
--				  alors qu'on ne peut en avoir qu'une seule

-- Documentation officielle:
-- https://dev.mysql.com/doc/refman/5.5/en/error-messages-server.html



-- --------------------------------------
-- CONDITIONS ET ERREURS
-- --------------------------------------


DECLARE nom_erreur CONDITION FOR { SQLSTATE identifiant_SQL | numero_erreur_MySQL };

-- Exemple:
--
DROP PROCEDURE ajouter_adoption_exit;
DELIMITER |
CREATE PROCEDURE ajouter_adoption_exit(IN p_client_id INT, IN p_animal_id INT, IN p_date DATE, IN p_paye TINYINT)
BEGIN
    DECLARE v_prix DECIMAL(7,2);

    -- Déclaration des CONDITIONS
    DECLARE violation_cle_etrangere CONDITION FOR 1452;            
    DECLARE violation_unicite CONDITION FOR 1062;
    
    -- Déclaration du gestionnaire pour les erreurs de clés étrangères
    DECLARE EXIT HANDLER FOR violation_cle_etrangere                  
        BEGIN                                               
            SELECT 'Erreur : violation de clé étrangère.';
        END;
    -- Déclaration du gestionnaire pour les erreurs d'index unique
    DECLARE EXIT HANDLER FOR violation_unicite  
        BEGIN                                                    
            SELECT 'Erreur : violation de contrainte d''unicité.';
        END;
    -- Déclaration du gestionnaire pour toutes les autres erreurs ou avertissements
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING              
        BEGIN                               
            SELECT 'Une erreur est survenue...';
        END;

    SELECT 'Début procédure';

    SELECT COALESCE(Race.prix, Espece.prix) INTO v_prix
    FROM Animal
    INNER JOIN Espece ON Espece.id = Animal.espece_id
    LEFT JOIN Race ON Race.id = Animal.race_id
    WHERE Animal.id = p_animal_id;
    
    INSERT INTO Adoption (animal_id, client_id, date_reservation, date_adoption, prix, paye)
    VALUES (p_animal_id, p_client_id, CURRENT_DATE(), p_date, v_prix, p_paye);

    SELECT 'Fin procédure';
END|
DELIMITER ;

SET @date_adoption = CURRENT_DATE() + INTERVAL 7 DAY;

CALL ajouter_adoption_exit(12, 3, @date_adoption, 1);        
-- Violation unicité (animal 3 est déjà adopté)
CALL ajouter_adoption_exit(133, 6, @date_adoption, 1);       
-- Violation clé étrangère (client 133 n'existe pas)
CALL ajouter_adoption_exit(NULL, 6, @date_adoption, 1);      
-- Violation de contrainte NOT NULL



-- --------------------------------------
-- CURSEURS
-- --------------------------------------

-- Les curseurs permettent de parcourir un jeu de résultats d'une requête SELECT,
-- quel que soit le nombre de lignes récupérées, et d'en exploiter les valeurs.


-- Quatre étapes sont nécessaires pour utiliser un curseur.
-- Déclaration du curseur : avec une instruction DECLARE.
-- Ouverture du curseur : on exécute la requête SELECT du curseur et on stocke le résultat dans celui-ci.
-- Parcours du curseur : on parcourt une à une les lignes.
-- Fermeture du curseur.

-- on déclare les curseurs après les variables locales et les conditions, mais avant les gestionnaires d'erreur.
DECLARE nom_curseur CURSOR FOR requete_select;

DECLARE curseur_client CURSOR 
    FOR SELECT * 
    FROM Client;

-- En déclarant le curseur, on a donc associé un nom et une requête SELECT.
-- L'ouverture du curseur va provoquer l'exécution de la requête SELECT, ce qui va produire un jeu de résultats.
-- Une fois qu'on aura parcouru les résultats, il n'y aura plus qu'à fermer le curseur.
-- Si on ne le fait pas explicitement, le curseur sera fermé à la fin du bloc d'instructions.

OPEN nom_curseur;
  -- Parcours du curseur et instructions diverses
CLOSE nom_curseur;


-- --------------------------------------
-- PARCOURS DU CURSEUR
-- --------------------------------------


-- Une fois que le curseur a été ouvert et le jeu de résultats récupéré,
-- le curseur place un pointeur sur la première ligne de résultats.
-- Avec la commande FETCH, on récupère la ligne sur laquelle pointe le curseur,
-- et on fait avancer le pointeur vers la ligne de résultats suivante.
FETCH nom_curseur INTO variable(s);

-- Exemple:
--
DELIMITER |
CREATE PROCEDURE parcours_deux_clients()
BEGIN
    DECLARE v_nom, v_prenom VARCHAR(100);

    DECLARE curs_clients CURSOR
        FOR SELECT nom, prenom  -- Le SELECT récupère deux colonnes
        FROM Client
        ORDER BY nom, prenom;   
        -- On trie les clients par ordre alphabétique

    OPEN curs_clients;  -- Ouverture du curseur

    FETCH curs_clients INTO v_nom, v_prenom;    
    -- On récupère la première ligne et on assigne les valeurs récupérées à nos variables locales
    SELECT CONCAT(v_prenom, ' ', v_nom) AS 'Premier client';

    FETCH curs_clients INTO v_nom, v_prenom;
    -- On récupère la seconde ligne et on assigne les valeurs récupérées à nos variables locales
    SELECT CONCAT(v_prenom, ' ', v_nom) AS 'Second client';

    CLOSE curs_clients;     -- Fermeture du curseur
END|
DELIMITER ;

CALL parcours_deux_clients();

-- Ne peut parcourir les lignes que unes à unes.


-- --------------------------------------
-- BOOLEENS
-- --------------------------------------

-- 0 == False et 1 == True

DROP PROCEDURE test_condition2;
DELIMITER |
CREATE PROCEDURE test_condition2(IN p_ville VARCHAR(100))
BEGIN
    DECLARE v_nom, v_prenom VARCHAR(100);
    
    -- On déclare fin comme un BOOLEAN, avec FALSE pour défaut
    DECLARE fin BOOLEAN DEFAULT FALSE;                     
    
    DECLARE curs_clients CURSOR
        FOR SELECT nom, prenom
        FROM Client
        WHERE ville = p_ville;

    -- On utilise TRUE au lieu de 1
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = TRUE; 

    OPEN curs_clients;                                    

    loop_curseur: LOOP                                                
        FETCH curs_clients INTO v_nom, v_prenom;

        IF fin THEN     -- Plus besoin de "= 1"
            LEAVE loop_curseur;
        END IF;
                   
        SELECT CONCAT(v_prenom, ' ', v_nom) AS 'Client';
    END LOOP;

    CLOSE curs_clients; 
END|
DELIMITER ;



-- --------------------------------------
-- UTILISATION AVANCE
-- --------------------------------------


-- Eviter d'utiliser les variables utilisateur dans les blocs d'instruction, c'est dangereux (revient aux variables globales)
-- astuce: appeler un bloc d'instruction depuis un autre bloc d'instruction!

DELIMITER |
CREATE PROCEDURE carre(INOUT p_nb FLOAT) SET p_nb = p_nb * p_nb|

CREATE PROCEDURE surface_cercle(IN p_rayon FLOAT, OUT p_surface FLOAT)
BEGIN
    CALL carre(p_rayon);

    SET p_surface = p_rayon * PI();
END|
DELIMITER ;

CALL surface_cercle(1, @surface);   -- Donne environ pi (3,14...)
SELECT @surface;
CALL surface_cercle(2, @surface);   -- Donne environ 12,57...
SELECT @surface;


--
-- On utilise souvent les gestionnaires d'erreur pour annuler une transaction:
--

DELIMITER |
CREATE PROCEDURE adoption_deux_ou_rien(p_client_id INT, p_animal_id_1 INT, p_animal_id_2 INT)
BEGIN
    DECLARE v_prix DECIMAL(7,2);

    -- Gestionnaire qui annule la transaction et termine la procédure
    DECLARE EXIT HANDLER FOR SQLEXCEPTION ROLLBACK;  

    START TRANSACTION;

    SELECT COALESCE(Race.prix, Espece.prix) INTO v_prix
    FROM Animal
    INNER JOIN Espece ON Espece.id = Animal.espece_id
    LEFT JOIN Race ON Race.id = Animal.race_id
    WHERE Animal.id = p_animal_id_1;
    
    INSERT INTO Adoption (animal_id, client_id, date_reservation, date_adoption, prix, paye)
    VALUES (p_animal_id_1, p_client_id, CURRENT_DATE(), CURRENT_DATE(), v_prix, TRUE);

    SELECT 'Adoption animal 1 réussie' AS message;

    SELECT COALESCE(Race.prix, Espece.prix) INTO v_prix
    FROM Animal
    INNER JOIN Espece ON Espece.id = Animal.espece_id
    LEFT JOIN Race ON Race.id = Animal.race_id
    WHERE Animal.id = p_animal_id_2;
    
    INSERT INTO Adoption (animal_id, client_id, date_reservation, date_adoption, prix, paye)
    VALUES (p_animal_id_2, p_client_id, CURRENT_DATE(), CURRENT_DATE(), v_prix, TRUE);
    
    SELECT 'Adoption animal 2 réussie' AS message;
    
    COMMIT;
END|
DELIMITER ;

CALL adoption_deux_ou_rien(2, 43, 55);  -- L'animal 55 a déjà été adopté



-- On peut aussi executer une requete préparé dans un bloc d'instruction, mais ça genère des problèmes de sécu potentiels (!)
-- lien:
-- https://openclassrooms.com/courses/administrez-vos-bases-de-donnees-avec-mysql/gestionnaires-d-erreurs-curseurs-et-utilisation-avancee#/id/r-1990118