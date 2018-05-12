-- --------------------------------------
-- REQUETES PREPAREES
-- --------------------------------------

-- C'est une requête stocké en mémoire.



-- --------------------------------------
-- VARIABLES UTILISATEURS
-- --------------------------------------

-- variable définie par l'utilisateur.
-- On les définit en précedent les noms d'un @.
-- peut contenir: un entier, un réel, une string, une binary string.

-- (il existe aussi les variables système définis par MySQL)



--
-- CREER/MODIFIER VARIABLES UTILISATEUR
--


SET @age = 24;                                  
    -- Ne pas oublier le @
SET @salut = 'Hello World !', @poids = 7.8;     
    -- On peut créer plusieurs variables en même temps

SELECT @age := 32, @poids := 48.15, @perroquet := 4; -- assignation direct dans une requête.



--
-- EXEMPLES D UTILISATION
--


SELECT id, sexe, nom, commentaires, espece_id 
FROM Animal 
WHERE espece_id = @perroquet; 
    -- On sélectionne les perroquets

SET @conversionDollar = 1.31564;       
    -- On crée une variable contenant le taux de conversion des euros en dollars
SELECT prix AS prix_en_euros,         
    -- On sélectionne le prix des races, en euros et en dollars.
        ROUND(prix * @conversionDollar, 2) AS prix_en_dollars,   
        -- En arrondissant à deux décimales
        nom FROM Race;


-- A savoir:
-- Une variable utilisateur n'existe que pour la session dans laquelle elle a été définie.
-- Pas de partage de variables entre utilisateurs.



-- --------------------------------------
-- RETOUR SUR LES REQÊTES
-- --------------------------------------


-- Tout comme les variables utilisateur, une requête préparée n'existe que pour la session qui la crée.

PREPARE nom_requete
FROM 'requete_preparable';


-- Exemples:

-- Sans paramètre
PREPARE select_race
FROM 'SELECT * FROM Race';

-- Avec un paramètre
PREPARE select_client
FROM 'SELECT * FROM Client WHERE email = ?';

-- Avec deux paramètres
PREPARE select_adoption
FROM 'SELECT * FROM Adoption WHERE client_id = ? AND animal_id = ?';



-- Que le paramètre soit un nombre (client_id = ?) ou une chaîne de caractères (email = ?), cela ne change rien.
-- La chaîne de caractères contenant la requête à préparer ne peut contenir qu'une seule requête (et non plusieurs séparées par un ;).
-- Les paramètres ne peuvent représenter que des données, des valeurs, pas des noms de tables ou de colonnes, ni des morceaux de commandes SQL.


-- Exemples:
SET @req = 'SELECT * FROM Race';
PREPARE select_race
FROM @req;

SET @colonne = 'nom';
SET @req_animal = CONCAT('SELECT ', @colonne, ' FROM Animal WHERE id = ?');
PREPARE select_col_animal
FROM @req_animal; 			--! pas possible de mettre directement la fonction CONCAT() dans la clause FROM



-- --------------------------------------
-- EXECUTION D UNE REQUETE PREPAREE
-- --------------------------------------


EXECUTE nom_requete [USING @parametre1, @parametre2, ...];


-- Exemples:
EXECUTE select_race;

SET @id = 3;
EXECUTE select_col_animal USING @id;

SET @client = 2;
EXECUTE select_adoption USING @client, @id;

SET @email = 'jean.dupont@email.com';
EXECUTE select_client USING @email;

SET @email = 'marie.boudur@email.com';
EXECUTE select_client USING @email;

SET @email = 'fleurtrachon@email.com';
EXECUTE select_client USING @email;

SET @email = 'jeanvp@email.com';
EXECUTE select_client USING @email;

SET @email = 'johanetpirlouit@email.com';
EXECUTE select_client USING @email;



-- --------------------------------------
-- SUPPRESSION D UNE REQUETE PREPAREE
-- --------------------------------------

DEALLOCATE PREPARE select_race;



-- --------------------------------------
-- USAGES
-- --------------------------------------


--! Souvent, une API d'un langage de programmation permet de le faire sans utiliser MySQL.

-- Les requêtes préparées sont principalement utilisées pour deux raisons :
--  -protéger son application des injections SQL ;
--  -gagner en performance dans le cas d'une requête exécutée plusieurs fois par la même session.


-- CONTRER L'INJECTION SQL:
-- En utilisant les requêtes préparées, lorsque vous liez une valeur à un paramètre de la requête préparée grâce
-- à la fonction correspondante dans le langage que vous utilisez, le type du paramètre attendu est également donné,
-- explicitement ou implicitement. La plupart du temps, soit une erreur sera générée si la donnée de l'utilisateur ne correspond pas au type attendu,
-- soit la donnée de l'utilisateur sera rendue inoffensive (par l'ajout de guillemets qui en feront une simple chaîne de caractères par exemple). 

-- Par ailleurs, lorsque MySQL injecte les valeurs dans la requête,
-- les mots-clés SQL qui s'y trouveraient pour une raison où une autre ne seront pas interprétés
-- (puisque les paramètres n'acceptent que des valeurs, et pas des morceaux de requêtes).