----------------------------------------
			DATES CALCULS
----------------------------------------


-- calculer la différence entre deux données temporelles
-- ajouter un intervalle de temps à une donnée temporelle
-- convertir une donnée horaire en un nombre de secondes

-- DATEDIFF() -> donne un résultat en nombre de jours
SELECT DATEDIFF('2011-12-25','2011-11-10') AS nb_jours;
SELECT DATEDIFF('2011-12-25 22:12:18','2011-11-10 12:15:41') AS nb_jours;
SELECT DATEDIFF('2011-12-25 22:12:18','2011-11-10') AS nb_jours;
--
-- +----------+
-- | nb_jours |
-- +----------+
-- |       45 |
-- +----------+
--


--TIMEDIFF(expr1, expr2) -> calcule la durée entre expr1 et expr2. Les deux arguments doivent être de même type, soit TIME, soit DATETIME.
SELECT '2011-10-08 12:35:45' AS datetime1, '2011-10-07 16:00:25' AS datetime2, TIMEDIFF('2011-10-08 12:35:45', '2011-10-07 16:00:25') as difference; -- Avec des DATETIME
SELECT '12:35:45' AS time1, '00:00:25' AS time2, TIMEDIFF('12:35:45', '00:00:25') as difference; -- Avec des TIME
--
-- +---------------------+---------------------+------------+
-- | datetime1           | datetime2           | difference |
-- +---------------------+---------------------+------------+
-- | 2011-10-08 12:35:45 | 2011-10-07 16:00:25 | 20:35:20   |
-- +---------------------+---------------------+------------+
-- 


-- TIMESTAMPDIFF(unite, date1, date2) -> SECOND, MINUTE, HOUR, DAY, WEEK, MONTH, QUARTER (trimestres) et YEAR (années).
SELECT TIMESTAMPDIFF(DAY, '2011-11-10', '2011-12-25') AS nb_jours,
       TIMESTAMPDIFF(HOUR,'2011-11-10', '2011-12-25 22:00:00') AS nb_heures_def, 
       TIMESTAMPDIFF(HOUR,'2011-11-10 14:00:00', '2011-12-25 22:00:00') AS nb_heures,
       TIMESTAMPDIFF(QUARTER,'2011-11-10 14:00:00', '2012-08-25 22:00:00') AS nb_trimestres;
-- 
-- +----------+---------------+-----------+---------------+
-- | nb_jours | nb_heures_def | nb_heures | nb_trimestres |
-- +----------+---------------+-----------+---------------+
-- |       45 |          1102 |      1088 |             3 |
-- +----------+---------------+-----------+---------------+
-- 



----------------------------------------
			ADDITIONS
----------------------------------------


--
-- OPERATIONS AVEC LE MOT CLE INTERVAL
--


-- lien du tableau récapitulant les quantités:
-- https://openclassrooms.com/courses/administrez-vos-bases-de-donnees-avec-mysql/calculs-sur-les-donnees-temporelles#/id/r-1986709


--ADDDATE(date, INTERVAL quantite unite)
--ADDDATE(date, nombreJours)
SELECT ADDDATE('2011-05-21', INTERVAL 3 MONTH) AS date_interval,  
        -- Avec DATE et INTERVAL
       ADDDATE('2011-05-21 12:15:56', INTERVAL '3 02:10:32' DAY_SECOND) AS datetime_interval, 
        -- Avec DATETIME et INTERVAL
       ADDDATE('2011-05-21', 12) AS date_nombre_jours,                                        
        -- Avec DATE et nombre de jours
       ADDDATE('2011-05-21 12:15:56', 42) AS datetime_nombre_jours;                           
        -- Avec DATETIME et nombre de jours
-- 
-- +---------------+---------------------+-------------------+-----------------------+
-- | date_interval | datetime_interval   | date_nombre_jours | datetime_nombre_jours |
-- +---------------+---------------------+-------------------+-----------------------+
-- | 2011-08-21    | 2011-05-24 14:26:28 | 2011-06-02        | 2011-07-02 12:15:56   |
-- +---------------+---------------------+-------------------+-----------------------+
--


-- DATE_ADD(date, INTERVAL quantite unite) s'utilise exactement de la même manière que ADDDATE(date, INTERVAL quantite unite)
SELECT DATE_ADD('2011-05-21', INTERVAL 3 MONTH) AS avec_date,       
        -- Avec DATE
       DATE_ADD('2011-05-21 12:15:56', INTERVAL '3 02:10:32' DAY_SECOND) AS avec_datetime;  
        -- Avec DATETIME
-- 
-- +------------+---------------------+
-- | avec_date  | avec_datetime       |
-- +------------+---------------------+
-- | 2011-08-21 | 2011-05-24 14:26:28 |
-- +------------+---------------------+
--


-- utiliser l'opérateur '+' pour les intervals:
SELECT '2011-05-21' + INTERVAL 5 DAY AS droite, -- Avec DATE et intervalle à droite
       INTERVAL '3 12' DAY_HOUR + '2011-05-21 12:15:56' AS gauche; -- Avec DATETIME et intervalle à gauche
-- 
-- +------------+---------------------+
-- | droite     | gauche              |
-- +------------+---------------------+
-- | 2011-05-26 | 2011-05-25 00:15:56 |
-- +------------+---------------------+
--


-- ADDTIME(expr1, expr2) -> ajoute expr2 (de type TIME) à expr1
SELECT NOW() AS Maintenant, ADDTIME(NOW(), '01:00:00') AS DansUneHeure, -- Avec un DATETIME
       CURRENT_TIME() AS HeureCourante, ADDTIME(CURRENT_TIME(), '03:20:02') AS PlusTard; -- Avec un TIME
-- 
-- +---------------------+---------------------+---------------+----------+
-- | Maintenant          | DansUneHeure        | HeureCourante | PlusTard |
-- +---------------------+---------------------+---------------+----------+
-- | 2018-04-19 13:20:49 | 2018-04-19 14:20:49 | 13:20:49      | 16:40:51 |
-- +---------------------+---------------------+---------------+----------+
--




----------------------------------------
			SOUSTRACTIONS
----------------------------------------



SELECT SUBDATE('2011-05-21 12:15:56', INTERVAL '3 02:10:32' DAY_SECOND) AS SUBDATE1, 
       SUBDATE('2011-05-21', 12) AS SUBDATE2,
       DATE_SUB('2011-05-21', INTERVAL 3 MONTH) AS DATE_SUB;
-- 
-- +---------------------+------------+------------+
-- | SUBDATE1            | SUBDATE2   | DATE_SUB   |
-- +---------------------+------------+------------+
-- | 2011-05-18 10:05:24 | 2011-05-09 | 2011-02-21 |
-- +---------------------+------------+------------+
-- 

SELECT SUBTIME('2011-05-21 12:15:56', '18:35:15') AS SUBTIME1,
       SUBTIME('12:15:56', '8:35:15') AS SUBTIME2;
-- 
-- +---------------------+----------+
-- | SUBTIME1            | SUBTIME2 |
-- +---------------------+----------+
-- | 2011-05-20 17:40:41 | 03:40:41 |
-- +---------------------+----------+
--



----------------------------------------
			DIVERS
----------------------------------------



SELECT SEC_TO_TIME(102569), TIME_TO_SEC('01:00:30');
-- 
-- +---------------------+-------------------------+
-- | SEC_TO_TIME(102569) | TIME_TO_SEC('01:00:30') |
-- +---------------------+-------------------------+
-- | 28:29:29            |                    3630 |
-- +---------------------+-------------------------+
--


SELECT LAST_DAY('2012-02-03') AS fevrier2012, LAST_DAY('2100-02-03') AS fevrier2100;
-- 
-- +-------------+-------------+
-- | fevrier2012 | fevrier2100 |
-- +-------------+-------------+
-- | 2012-02-29  | 2100-02-28  |
-- +-------------+-------------+
--



