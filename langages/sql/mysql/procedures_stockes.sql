-- --------------------------------------
-- PROCEDURES STOCKES
-- --------------------------------------

-- Automatise des actions qui peuvent être très complexes.
-- Une procédure stockée est en fait une série d'instructions SQL désignée par un nom.

-- Lorsque l'on crée une procédure stockée, on l'enregistre dans la base de données que l'on utilise,
-- au même titre qu'une table par exemple. Une fois la procédure créée, il est possible d'appeler celle-ci, par son nom.
-- Les instructions de la procédure sont alors exécutées.

-- Contrairement aux requêtes préparées, qui ne sont gardées en mémoire que pour la session courante,
-- les procédures stockées sont, comme leur nom l'indique, stockées de manière durable,
-- et font bien partie intégrante de la base de données dans laquelle elles sont enregistrées.



--
-- CREATION D'UNE PROCEDURE
--


CREATE PROCEDURE nom_procedure ([parametre1 [, parametre2, ...]])
corps de la procédure;


-- Exemples:
CREATE PROCEDURE afficher_races_requete() 
    -- pas de paramètres dans les parenthèses
SELECT id, nom, espece_id, prix FROM Race;




--
-- BLOCS D'INSTRUCTION
--



-- Pour délimiter un bloc d'instructions (qui peut donc contenir plus d'une instruction), on utilise les mots BEGIN et END.
BEGIN
    -- Série d'instructions
END;



-- --------------------------------------
-- CHANGER LE DELIMITEUR
-- --------------------------------------

-- On doit changer le délimiteur pour utiliser les blocs d'instruction !
DELIMITER | -- change ';' en '|'
-- N'agit que pour la session courante.


DELIMITER | -- On change le délimiteur
CREATE PROCEDURE afficher_races()      
    -- toujours pas de paramètres, toujours des parenthèses
BEGIN
    SELECT id, nom, espece_id, prix
    FROM Race;  -- Cette fois, le ; ne nous embêtera pas
END|            -- Et on termine bien sûr la commande CREATE PROCEDURE par notre nouveau délimiteur



-- --------------------------------------
-- APPELER LA PROCEDURE
-- --------------------------------------


CALL afficher_races()|   -- le délimiteur est toujours | !!!



-- --------------------------------------
-- PARAMETRES DE PROCEDURE
-- --------------------------------------


-- Trois sens: entrant (IN), sortant (OUT), ou les deux (INOUT):

--  - IN : c'est un paramètre "entrant". C'est-à-dire qu'il s'agit d'un paramètre dont la valeur est fournie à la procédure stockée.
--    Cette valeur sera utilisée pendant la procédure (pour un calcul ou une sélection par exemple).

--  - OUT : il s'agit d'un paramètre "sortant", dont la valeur va être établie au cours de la procédure
--    et qui pourra ensuite être utilisé en dehors de cette procédure.

--  - INOUT : un tel paramètre sera utilisé pendant la procédure,
--    verra éventuellement sa valeur modifiée par celle-ci, et sera ensuite utilisable en dehors.



--
-- DEFINITION DES PARAMETRES
--


-- Son sens : entrant, sortant, ou les deux. Si aucun sens n'est donné, il s'agira d'un paramètre IN par défaut.
-- Son nom : indispensable pour le désigner à l'intérieur de la procédure.
-- Son type : INT, VARCHAR(10),…


DELIMITER | -- Facultatif si votre délimiteur est toujours |
CREATE PROCEDURE afficher_race_selon_espece (IN p_espece_id INT)  
    -- Définition du paramètre p_espece_id, préfixe de 'p_' pour 'paramètre'.
BEGIN
    SELECT id, nom, espece_id, prix 
    FROM Race
    WHERE espece_id = p_espece_id;  -- Utilisation du paramètre
END |
DELIMITER ;  -- On remet le délimiteur par défaut


-- Exemples d'appels:
CALL afficher_race_selon_espece(1);
SET @espece_id := 2;
CALL afficher_race_selon_espece(@espece_id);


-- Paramètre sortant:
DELIMITER |                                                      
CREATE PROCEDURE compter_races_selon_espece (p_espece_id INT, OUT p_nb_races INT)  
BEGIN
    SELECT COUNT(*) INTO p_nb_races -- INTO assigne une valeur à la variable. SELECT ne doit renvoyer qu'une ligne.
    FROM Race
    WHERE espece_id = p_espece_id;                               
END |
DELIMITER ;


SELECT id, nom INTO @var1, @var2
FROM Animal 
WHERE id = 7;
SELECT @var1, @var2; -- possible avec x valeurs si valeurs == paramètres.



-- --------------------------------------
-- UTILISATION D'UNE PROCEDURE AVEC PARAMETRE SORTANT
-- --------------------------------------


CALL compter_races_selon_espece (2, @nb_races_chats); -- On utilise une variable utilisateur
SELECT @nb_races_chats; -- On affiche le résultat




-- --------------------------------------
-- UTILISATION D'UNE PROCEDURE AVEC PARAMETRE INOUT
-- --------------------------------------


-- Définition de la procédure:
--
DELIMITER |

CREATE PROCEDURE calculer_prix (IN p_animal_id INT, INOUT p_prix DECIMAL(7,2))
BEGIN
    SELECT p_prix + COALESCE(Race.prix, Espece.prix) INTO p_prix
    FROM Animal
    INNER JOIN Espece ON Espece.id = Animal.espece_id
    LEFT JOIN Race ON Race.id = Animal.race_id
    WHERE Animal.id = p_animal_id;
END |

DELIMITER ;


-- Utilisation de la procédure:
--
SET @prix = 0;                   -- On initialise @prix à 0

CALL calculer_prix (13, @prix);  -- Achat de Rouquine
SELECT @prix AS prix_intermediaire;

CALL calculer_prix (24, @prix);  -- Achat de Cartouche
SELECT @prix AS prix_intermediaire;

CALL calculer_prix (42, @prix);  -- Achat de Bilba
SELECT @prix AS prix_intermediaire;

CALL calculer_prix (75, @prix);  -- Achat de Mimi
SELECT @prix AS total;




-- --------------------------------------
-- SUPRESSION D'UNE PROCEDURE
-- --------------------------------------

DROP PROCEDURE afficher_races;
-- les procédures stockées ne sont pas détruites à la fermeture de la session
-- mais bien enregistrées comme un élément de la base de données, au même titre qu'une table par exemple.



-- --------------------------------------
-- AVANTAGES / INVONVENIENTS
-- --------------------------------------


-- réduire les allers-retours entre le client et le serveur MySQL
-- sécuriser une base de données. Par exemple, il est possible de restreindre les droits des utilisateurs de façon à ce qu'ils puissent uniquement exécuter des procédures
-- s'assurer qu'un traitement est toujours exécuté de la même manière


 -- ajoutent évidemment à la charge sur le serveur de données
 -- La logique qu'il est possible d'implémenter avec MySQL permet de nombreuses choses, mais reste assez basique
 -- la syntaxe des procédures stockées diffère beaucoup d'un SGBD à un autre


-- Comme souvent, tout est question d'équilibre.
-- Il faut savoir utiliser des procédures quand c'est utile, quand on a une bonne raison de le faire. Il ne sert à rien d'en abuser.
-- Pour une base contenant des données ultrasensibles, une bonne gestion des droits des utilisateurs couplée à l'usage de procédures stockées peut se révéler salutaire. 
-- Pour une base de données destinée à être utilisée par plusieurs applications différentes,
-- on choisira de créer des procédures pour les traitements généraux et/ou pour lesquels la moindre erreur peut poser de gros problèmes.
-- Pour un traitement long, impliquant de nombreuses requêtes et une logique simple,
-- on peut sérieusement gagner en performance en le faisant dans une procédure stockée (a fortiori si ce traitement est souvent lancé).