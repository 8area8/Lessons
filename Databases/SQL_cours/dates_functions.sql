----------------------------------------
-- DATES FUNCTIONS
----------------------------------------


SELECT CURDATE(), CURRENT_DATE(), CURRENT_DATE; -- return the current date.
SELECT CURTIME(), CURRENT_TIME(), CURRENT_TIME; -- return the current time.
SELECT NOW(), SYSDATE(); 						-- return the current datetime.
SELECT LOCALTIME, CURRENT_TIMESTAMP(), LOCALTIMESTAMP; -- same as NOW().


-- Création d'une table de test toute simple
CREATE TABLE testDate (
    dateActu DATE, 
    timeActu TIME, 
    datetimeActu DATETIME
);

INSERT INTO testDate VALUES (NOW(), NOW(), NOW()); -- qui peut le plus peut le moins*

SELECT UNIX_TIMESTAMP(); -- retourne le timestamp unix actuel


----------------------------------------
-- FORMATER LES DONNEES TEMPORELLES
----------------------------------------

SELECT nom, date_naissance, 
        DATE(date_naissance) AS uniquementDate
FROM Animal
WHERE espece_id = 4; -- extrait la date d'un datetime (ou d'un date, mais c'est moin utile...)


SELECT nom, DATE(date_naissance) AS date_naiss, 
        DAY(date_naissance) AS jour, 
        DAYOFMONTH(date_naissance) AS jour, 
        DAYOFWEEK(date_naissance) AS jour_sem, -- semaine angalise de 1 à 7
        WEEKDAY(date_naissance) AS jour_sem2,  -- semaine francaise de 0 à 6
        DAYNAME(date_naissance) AS nom_jour, 
        DAYOFYEAR(date_naissance) AS jour_annee
FROM Animal
WHERE espece_id = 4;
--
-- +----------+------------+------+------+----------+-----------+-----------+------------+
-- | nom      | date_naiss | jour | jour | jour_sem | jour_sem2 | nom_jour  | jour_annee |
-- +----------+------------+------+------+----------+-----------+-----------+------------+
-- | Safran   | 2007-03-04 |    4 |    4 |        1 |         6 | Sunday    |         63 |
-- | Gingko   | 2008-02-20 |   20 |   20 |        4 |         2 | Wednesday |         51 |
-- | Bavard   | 2009-03-26 |   26 |   26 |        5 |         3 | Thursday  |         85 |
-- | Parlotte | 2009-03-26 |   26 |   26 |        5 |         3 | Thursday  |         85 |
-- +----------+------------+------+------+----------+-----------+-----------+------------+
--


SET lc_time_names = 'fr_FR'; -- demander le nom des jours en francais


SELECT nom, date_naissance, WEEK(date_naissance) AS semaine, WEEKOFYEAR(date_naissance) AS semaine2, YEARWEEK(date_naissance) AS semaine_annee
FROM Animal
WHERE espece_id = 4;
--
-- +----------+---------------------+---------+----------+---------------+
-- | nom      | date_naissance      | semaine | semaine2 | semaine_annee |
-- +----------+---------------------+---------+----------+---------------+
-- | Safran   | 2007-03-04 19:36:00 |       9 |        9 |        200709 |
-- | Gingko   | 2008-02-20 02:50:00 |       7 |        8 |        200807 |
-- | Bavard   | 2009-03-26 08:28:00 |      12 |       13 |        200912 |
-- | Parlotte | 2009-03-26 07:55:00 |      12 |       13 |        200912 |
-- +----------+---------------------+---------+----------+---------------+
--


SELECT nom, date_naissance, MONTH(date_naissance) AS numero_mois, MONTHNAME(date_naissance) AS nom_mois
FROM Animal
WHERE espece_id = 4;
--
-- +----------+---------------------+-------------+----------+
-- | nom      | date_naissance      | numero_mois | nom_mois |
-- +----------+---------------------+-------------+----------+
-- | Safran   | 2007-03-04 19:36:00 |           3 | March    |
-- | Gingko   | 2008-02-20 02:50:00 |           2 | February |
-- | Bavard   | 2009-03-26 08:28:00 |           3 | March    |
-- | Parlotte | 2009-03-26 07:55:00 |           3 | March    |
-- +----------+---------------------+-------------+----------+
--


SELECT nom, date_naissance, YEAR(date_naissance)
FROM Animal
WHERE espece_id = 4;
--
-- +----------+---------------------+----------------------+
-- | nom      | date_naissance      | YEAR(date_naissance) |
-- +----------+---------------------+----------------------+
-- | Safran   | 2007-03-04 19:36:00 |                 2007 |
-- | Gingko   | 2008-02-20 02:50:00 |                 2008 |
-- | Bavard   | 2009-03-26 08:28:00 |                 2009 |
-- | Parlotte | 2009-03-26 07:55:00 |                 2009 |
-- +----------+---------------------+----------------------+
--


SELECT nom, date_naissance, 
       TIME(date_naissance) AS time_complet, 
       HOUR(date_naissance) AS heure, 
       MINUTE(date_naissance) AS minutes, 
       SECOND(date_naissance) AS secondes
FROM Animal
WHERE espece_id = 4;
--
-- +----------+---------------------+--------------+-------+---------+----------+
-- | nom      | date_naissance      | time_complet | heure | minutes | secondes |
-- +----------+---------------------+--------------+-------+---------+----------+
-- | Safran   | 2007-03-04 19:36:00 | 19:36:00     |    19 |      36 |        0 |
-- | Gingko   | 2008-02-20 02:50:00 | 02:50:00     |     2 |      50 |        0 |
-- | Bavard   | 2009-03-26 08:28:00 | 08:28:00     |     8 |      28 |        0 |
-- | Parlotte | 2009-03-26 07:55:00 | 07:55:00     |     7 |      55 |        0 |
-- +----------+---------------------+--------------+-------+---------+----------+
--



--
-- DATE_FORMAT
--


-- Lien du tableau des mots clefs:
-- https://openclassrooms.com/courses/administrez-vos-bases-de-donnees-avec-mysql/formater-une-donnee-temporelle#/id/r-1986229

SELECT nom, date_naissance, DATE_FORMAT(date_naissance, 'le %W %e %M %Y') AS jolie_date
FROM Animal
WHERE espece_id = 4;
--
-- +----------+---------------------+-------------------------------+
-- | nom      | date_naissance      | jolie_date                    |
-- +----------+---------------------+-------------------------------+
-- | Safran   | 2007-03-04 19:36:00 | le Sunday 4 March 2007        |
-- | Gingko   | 2008-02-20 02:50:00 | le Wednesday 20 February 2008 |
-- | Bavard   | 2009-03-26 08:28:00 | le Thursday 26 March 2009     |
-- | Parlotte | 2009-03-26 07:55:00 | le Thursday 26 March 2009     |
-- +----------+---------------------+-------------------------------+
--

SELECT DATE_FORMAT(NOW(), 'Nous sommes aujourd''hui le %d %M de l''année %Y. Il est actuellement %l heures et %i minutes.') AS Top_date_longue;
--
-- +---------------------------------------------------------------------------------------------------+
-- | Top_date_longue                                                                                   |
-- +---------------------------------------------------------------------------------------------------+
-- | Nous sommes aujourd'hui le 18 April de l'année 2018. Il est actuellement 10 heures et 21 minutes. |
-- +---------------------------------------------------------------------------------------------------+
--

SELECT DATE_FORMAT(NOW(), '%d %b. %y - %r') AS Top_date_courte;
--
--+--------------------------+
--| Top_date_courte          |
--+--------------------------+
--| 18 Apr. 18 - 10:21:49 PM |
--+--------------------------+
--


-- Sur une DATETIME
SELECT TIME_FORMAT(NOW(), '%r') AS sur_datetime, 
       TIME_FORMAT(CURTIME(), '%r') AS sur_time, 
       TIME_FORMAT(NOW(), '%M %r') AS mauvais_specificateur, 
       TIME_FORMAT(CURDATE(), '%r') AS sur_date;
--
-- +--------------+-------------+-----------------------+-------------+
-- | sur_datetime | sur_time    | mauvais_specificateur | sur_date    |
-- +--------------+-------------+-----------------------+-------------+
-- | 10:24:53 PM  | 10:24:53 PM | NULL                  | 12:00:00 AM |
-- +--------------+-------------+-----------------------+-------------+
--


-- lien du tableau des formats prédéfinis:
-- https://openclassrooms.com/courses/administrez-vos-bases-de-donnees-avec-mysql/formater-une-donnee-temporelle#/id/r-1986468

SELECT DATE_FORMAT(NOW(), GET_FORMAT(DATE, 'EUR')) AS date_eur,
       DATE_FORMAT(NOW(), GET_FORMAT(TIME, 'JIS')) AS heure_jis,
       DATE_FORMAT(NOW(), GET_FORMAT(DATETIME, 'USA')) AS date_heure_usa;
--
-- +------------+-----------+---------------------+
-- | date_eur   | heure_jis | date_heure_usa      |
-- +------------+-----------+---------------------+
-- | 18.04.2018 | 22:27:47  | 2018-04-18 22.27.47 |
-- +------------+-----------+---------------------+
--


SELECT STR_TO_DATE('03/04/2011 à 09h17', '%d/%m/%Y à %Hh%i') AS StrDate,
       STR_TO_DATE('15blabla', '%Hblabla') StrTime;
--
-- +---------------------+----------+
-- | StrDate             | StrTime  |
-- +---------------------+----------+
-- | 2011-04-03 09:17:00 | 15:00:00 |
-- +---------------------+----------+
--

SELECT STR_TO_DATE('11.21.2011', GET_FORMAT(DATE, 'USA')) AS date_usa,
       STR_TO_DATE('12.34.45', GET_FORMAT(TIME, 'EUR')) AS heure_eur,
       STR_TO_DATE('20111027133056', GET_FORMAT(TIMESTAMP, 'INTERNAL')) AS date_heure_int;
--
-- +------------+-----------+---------------------+
-- | date_usa   | heure_eur | date_heure_int      |
-- +------------+-----------+---------------------+
-- | 2011-11-21 | 12:34:45  | 2011-10-27 13:30:56 |
-- +------------+-----------+---------------------+
--