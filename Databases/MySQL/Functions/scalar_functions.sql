----------------------------------------
-- SCALAR FUNCTIONS
----------------------------------------



--
-- MANIPULATION DES NOMBRES
--

SELECT CEIL(3.2), CEIL(3.7); 								 -- arrondis entier supérieur
SELECT FLOOR(3.2), FLOOR(3.7); 								 -- arrondis entier inférieur
SELECT ROUND(3.22, 1), ROUND(3.55, 1), ROUND(3.77, 1); 		 -- ROUND(n, d) arrondis au décimal d le plus proche
SELECT TRUNCATE(3.2, 0), TRUNCATE(3.5, 0), TRUNCATE(3.7, 0); -- arrondis en enlevant simplement les décimales en trop
SELECT ABS(-43), ABS(0), ABS(37); 							 -- retourne valeur absolue (sans le signe '-')

SELECT POW(2, 5), POWER(5, 2); 								 -- retourne la puissance d'un nombre
SELECT SQRT(4); 											 -- retourne la racine carré positive

SELECT RAND(); 												 -- retourne nombre aléatoire entre 0 et 1.

SELECT SIGN(-43), SIGN(0), SIGN(37); 						 -- renvoit -1, 0 et 1

SELECT MOD(56, 10); 									     -- retourne le modulo



--
-- MANIPULATION DES CHAINES DE CARACTERES
--

SELECT BIT_LENGTH('élevage'), 
       CHAR_LENGTH('élevage'), 								 -- la plus utile, TAILLE de la chaine par caracter
       LENGTH('élevage'); 									 -- Les caractères accentués sont codés sur 2 octets en UTF-8


SELECT REPEAT('Ok ', 3); 									 -- repète la chaine x fois


LPAD(texte, long, caract) -- RETOURNE une chaîne avec une longueur particulière (paramètre). La chaine sera raccourcie si trop longue, et des caractères seront ajoutés si trop courte,
RPAD(texte, long, caract) -- à gauche de la chaîne pour LPAD(), à droite pour RPAD()
SELECT LPAD('texte', 3, '@') AS '3_gauche_@', -- tex
       LPAD('texte', 7, '$') AS '7_gauche_$', -- $$texte
       RPAD('texte', 5, 'u') AS '5_droite_u', -- texte
       RPAD('texte', 7, '*') AS '7_droite_*', -- texte**
       RPAD('texte', 3, '-') AS '3_droite_-'; -- tex


TRIM([[BOTH | LEADING | TRAILING] [caract] FROM] texte); -- SUPPRIME caractères inutiles avant et/ou après la chaîne. BOTH = avant et arrière (par défaut) LEADING = avant, TRAILING = après
SELECT TRIM('   Tralala  ') AS both_espace, 
       TRIM(LEADING FROM '   Tralala  ') AS lead_espace, 
       TRIM(TRAILING FROM '   Tralala  ') AS trail_espace,

       TRIM('e' FROM 'eeeBouHeee') AS both_e,
       TRIM(LEADING 'e' FROM 'eeeBouHeee') AS lead_e,
       TRIM(BOTH 'e' FROM 'eeeBouHeee') AS both_e,

       TRIM('123' FROM '1234ABCD4321') AS both_123;


SUBSTRING(chaine FROM pos FOR long) 				   	-- RECUPERE une SOUS-CHAINE.
SELECT SUBSTRING('texte', 2) AS from2, 				   	-- exte
        SUBSTRING('texte' FROM 3) AS from3, 		   	-- xte
        SUBSTRING('texte', 2, 3) AS from2long3, 	   	--ext
        SUBSTRING('texte' FROM 3 FOR 1) AS from3long1; 	-- x


INSTR(chaine, rech)
LOCATE(rech, chaine, pos) 								-- pos = position où commencer la recherche.
POSITION(rech IN chaine) 								-- RETOURNE la POSITION de la Ppremière occurence d'une chaîne de caractères rech dans une chaîne de caractères chaine
SELECT INSTR('tralala', 'la') AS fct_INSTR, 			-- 4
       POSITION('la' IN 'tralala') AS fct_POSITION, 	-- 4
       LOCATE('la', 'tralala') AS fct_LOCATE, 			-- 4
       LOCATE('la', 'tralala', 5) AS fct_LOCATE2; 		-- 6


SELECT LOWER('AhAh') AS minuscule, 
        LCASE('AhAh') AS minuscule2, 
        UPPER('AhAh') AS majuscule,
        UCASE('AhAh') AS majuscule2; 				-- change la casse


SELECT LEFT('123456789', 5), RIGHT('123456789', 5); -- retourne x caracters d'une chaîne, par la gauche ou la droite.
SELECT REVERSE('abcde'); 							-- inverti la chaîne


INSERT(chaine, pos, long, nouvCaract) 					-- pos est la position du premier caractère à remplacer, long le nombre de caractères à remplacer
REPLACE(chaine, ancCaract, nouvCaract) 					-- tous les caractères (ou sous-chaînes) ancCaract seront remplacés par nouvCaract.
SELECT INSERT('texte', 3, 2, 'blabla') AS fct_INSERT, 	-- teblablae
        REPLACE('texte', 'e', 'a') AS fct_REPLACE, 		-- taxta
        REPLACE('texte', 'ex', 'ou') AS fct_REPLACE2; 	-- toute


SELECT CONCAT('My', 'SQL', '!'), CONCAT_WS('-', 'My', 'SQL', '!'); -- CONCATENETE PLUSIEURS CHAINES EN UNE. 1- 'MYSQL!' 2- 'MY-SQL-!'

FIELD(rech, chaine1, chaine2, chaine3,…) 														-- recherche premier argument (rech) parmis les suivant et retourne l'index auquel rech est trouvé, ou bien 0
SELECT FIELD('Bonjour', 'Bonjour !', 'Au revoir', 'Bonjour', 'Au revoir !') AS field_bonjour; 	-- 3
SELECT nom_courant, nom_latin,
	   FIELD(nom_courant, 'Rat brun', 'Chat', 'Tortue d''Hermann', 'Chien', 'Perroquet amazone') AS resultat_field
FROM Espece
ORDER BY FIELD(nom_courant, 'Rat brun', 'Chat', 'Tortue d''Hermann', 'Chien', 'Perroquet amazone'); -- peut être utilisé pour le tri