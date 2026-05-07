-- phpMyAdmin SQL Dump
-- version 5.2.1deb1+deb12u1
-- https://www.phpmyadmin.net/
--
-- Hôte : localhost:3306
-- Généré le : lun. 01 déc. 2025 à 18:36
-- Version du serveur : 10.11.11-MariaDB-0+deb12u1-log
-- Version de PHP : 8.2.29

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `e22301417_db2`
--

DELIMITER $$
--
-- Procédures
--
CREATE DEFINER=`e22301417sql`@`%` PROCEDURE `doc_re` (IN `reunion_id` INT)   BEGIN
    DECLARE nom_reunion VARCHAR(255);
    DECLARE nb_part INT DEFAULT 0;
    DECLARE doc_exists INT DEFAULT 0;

    -- nb de participants à la réunion
    SELECT COUNT(*) INTO nb_part
    FROM t_participation_met
    WHERE met_id = reunion_id;

    -- titre de la réunion
    SELECT met_titre INTO nom_reunion
    FROM t_meeting_met
    WHERE met_id = reunion_id
    LIMIT 1;

    IF nom_reunion IS NOT NULL THEN
        -- y a-t-il déjà au moins un doc pour cette réunion ?
        SELECT COUNT(*) INTO doc_exists
        FROM t_meeting_doc
        WHERE met_id = reunion_id;

        IF doc_exists > 0 THEN
            UPDATE t_meeting_doc
            SET doc_nom = CONCAT('CR_', nom_reunion, '_', nb_part)
            WHERE met_id = reunion_id;
        ELSE
            INSERT INTO t_meeting_doc (doc_chemin_path, doc_nom, met_id)
            VALUES ('CR en attente', CONCAT('CR_', nom_reunion, '_', nb_part), reunion_id);
        END IF;
    END IF;
END$$

CREATE DEFINER=`e22301417sql`@`%` PROCEDURE `get_ressource` (IN `p_id` INT)   BEGIN
    SELECT *
    FROM t_ressource_ress
    WHERE ress_id = p_id;
END$$

--
-- Fonctions
--
CREATE DEFINER=`e22301417sql`@`%` FUNCTION `est_actif` (`pseudo` VARCHAR(255)) RETURNS INT(11)  BEGIN
    DECLARE etat CHAR(1);

    SELECT cpt_etat INTO etat
    FROM t_compte_cpt
    WHERE cpt_pseudo = pseudo;

    RETURN IF(etat = 'A', 1, 0);
END$$

CREATE DEFINER=`e22301417sql`@`%` FUNCTION `liste_emails` (`meeting_id` INT) RETURNS TEXT CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN
        DECLARE liste TEXT;
        IF NOT EXISTS (SELECT * FROM t_meeting_met WHERE met_id = meeting_id) THEN
            set liste =  'inexiste';
        END IF;

        SELECT GROUP_CONCAT( pfl_email SEPARATOR ' \n ')
        INTO liste
        FROM t_participation_met 
        JOIN t_compte_cpt USING (cpt_pseudo)
        JOIN t_profile_pfl USING (cpt_pseudo)
        WHERE met_id=meeting_id ;

        IF liste IS NULL THEN
            SET liste = 'pas de participant';
        END IF;

        RETURN liste;
    END$$

CREATE DEFINER=`e22301417sql`@`%` FUNCTION `nb_personne` (IN `ID` INT) RETURNS INT(11)  BEGIN
            DECLARE NB INT;
            IF NOT EXISTS (SELECT * FROM t_meeting_met WHERE met_id = ID) THEN
                SET NB= -1;
            ELSE
                SELECT COUNT(*) INTO NB
                FROM t_participation_met
                WHERE met_id = ID;

            END IF;

            RETURN NB;

        END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `t_actualite_act`
--

CREATE TABLE `t_actualite_act` (
  `act_id` int(11) NOT NULL,
  `act_titre` varchar(150) NOT NULL,
  `act_date_pub` datetime NOT NULL,
  `act_image` varchar(100) DEFAULT NULL,
  `act_text` varchar(200) NOT NULL,
  `act_etat` char(1) NOT NULL,
  `cpt_pseudo` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `t_actualite_act`
--

INSERT INTO `t_actualite_act` (`act_id`, `act_titre`, `act_date_pub`, `act_image`, `act_text`, `act_etat`, `cpt_pseudo`) VALUES
(1, 'Nouvelle activité #1', '2025-10-05 10:00:00', 'actu1.jpg', 'Découvrez l/activité spéciale numéro 1!', 'A', 'sofia.chehade'),
(2, 'Nouvelle activité #2', '2025-10-06 10:00:00', 'actu2.jpg', 'Découvrez l/activité spéciale numéro 2!', 'D', 'omar.fakih'),
(3, 'Nouvelle activité #3', '2025-10-07 10:00:00', 'actu3.jpg', 'Découvrez l/activité spéciale numéro 3!', 'D', 'yara.maalouf'),
(4, 'Nouvelle activité #4', '2025-10-08 10:00:00', 'actu4.jpg', 'Découvrez l/activité spéciale numéro 4!', 'A', 'elena.sebaaly'),
(5, 'Nouvelle activité #5', '2025-10-09 10:00:00', 'actu5.jpg', 'Découvrez l/activité spéciale numéro 5!', 'D', 'nadia.aridi'),
(6, 'Nouvelle activité #6', '2025-10-10 10:00:00', 'actu6.jpg', 'Découvrez l/activité spéciale numéro 6!', 'A', 'sami.semaan'),
(7, 'Nouvelle activité #7', '2025-11-15 13:14:46', 'actu1.jpg', 'Découvrez lactivité spéciale numéro 1!', 'D', 'sofia.chehade'),
(8, 'Nouvelle activité #8', '2025-11-15 13:14:46', 'actu2.jpg', 'Découvrez lactivité spéciale numéro 2!', 'A', 'omar.fakih'),
(9, 'Nouvelle activité #9', '2025-11-15 13:14:46', 'actu3.jpg', 'Découvrez Lactivité spéciale numéro 3!', 'A', 'yara.maalouf'),
(10, 'Nouvelle activité #10', '2025-11-15 13:14:46', 'actu4.jpg', 'Découvrez Lactivité spéciale numéro 4!', 'D', 'elena.sebaaly');

-- --------------------------------------------------------

--
-- Structure de la table `t_compte_cpt`
--

CREATE TABLE `t_compte_cpt` (
  `cpt_pseudo` varchar(150) NOT NULL,
  `cpt_mdp` char(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `cpt_etat` char(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `t_compte_cpt`
--

INSERT INTO `t_compte_cpt` (`cpt_pseudo`, `cpt_mdp`, `cpt_etat`) VALUES
('adam.khoury', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('akram@gmail.com', '51749fdfc9e4bf37efae79744172c7735d7cf0406589b274b15d0c64e7441198', 'A'),
('ali.aridi', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('ali.douaihy', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('amina.elias', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('amina.nehme', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('amine.bazzi', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'D'),
('amine.maalouf', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('amine.nasr', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'D'),
('amine.taleb', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('aya.bazzi', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('aya.fares', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'D'),
('aya.ghosn', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('aya.kahoul', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('aya.merhi', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'D'),
('aya.saab', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('baptiste.bitar', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'D'),
('baptiste.douaihy', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('baptiste.hachem', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('baptiste.khatib', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('camille.douaihy', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('camille.elias', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('camille.massoud', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('camille.mroueh', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'D'),
('chloe.chidiac', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('chloe.deeb', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('chloe.merhi', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('chloe.nehme', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('cvvvvv@gmail.com', '51749fdfc9e4bf37efae79744172c7735d7cf0406589b274b15d0c64e7441198', 'A'),
('elena.sebaaly', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'D'),
('elena.semaan', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('elham', '12345678', 'A'),
('elhamtest', '51749fdfc9e4bf37efae79744172c7735d7cf0406589b274b15d0c64e7441198', 'A'),
('emma.abouzeid', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('emma.fares', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('fadi.bousaab', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'D'),
('fadi.kahoul', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('fadi.nassar', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('fadi.saab', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('farah.taleb', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('farah.zaher', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('ghassan.khalil', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('hassan.chedid', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('hassan.hobeika', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('hassan.saade', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('hiba.bitar', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('hiba.bouali', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('hiba.maalouf', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('hiba.nassar', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'D'),
('hiba.nehme', '51749fdfc9e4bf37efae79744172c7735d7cf0406589b274b15d0c64e7441198', 'A'),
('hugo.abdallah', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('hugo.deeb', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'D'),
('hugo.merhi', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('imane.barakat', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('imane.chidiac', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('ines.aoun', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('ines.atallah', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('ines.massoud', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('ines.rahme', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('ines.saab', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('inviter', '51749fdfc9e4bf37efae79744172c7735d7cf0406589b274b15d0c64e7441198', 'A'),
('inviter1', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('inviter10	', '51749fdfc9e4bf37efae79744172c7735d7cf0406589b274b15d0c64e7441198', 'A'),
('inviter10', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('inviter2', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('inviter3', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('inviter4', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('inviter5', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('inviter6', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('inviter7', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('inviter8', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('inviter9', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('invitertest', '51749fdfc9e4bf37efae79744172c7735d7cf0406589b274b15d0c64e7441198', 'A'),
('jad.abdallah', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('jad.khatib', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('jana.hachem', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('jana.khalil', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('julie.abinader', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'D'),
('julie.chidiac', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('julie.rahme', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('julie.semaan', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('julie.sleiman', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('karim.chedid', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'D'),
('karim.fares', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'D'),
('karim.ghandour', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'D'),
('karim.ghosn', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('karim.semaan', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('layla.aoun', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('layla.bazzi', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('layla.chidiac', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('lea.bouali', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'D'),
('lea.tannous', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('lea.tarabay', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('lina.antoun', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('lina.bazzi', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('lina.chidiac', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('lina.ghosn', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('lucas.bouali', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('lucas.ghandour', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('lucas.mroueh', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'D'),
('lucas.nasr', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('lucas.sleiman', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('mahmoud.abouzeid', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('mahmoud.bousaab', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'D'),
('mahmoud.fadlallah', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'D'),
('mahmoud.khalil', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('mahmoud.moukalled', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'D'),
('mahmoud.mroueh', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'D'),
('mahmoud.saade', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('mahmoud.taleb', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'D'),
('malak.bitar', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('malak.douaihy', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('malak.ghandour', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('marwan.abdallah', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('marwan.bitar', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('marwan.chidiac', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('marwan.kahoul', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('marwan.nassar', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('marwan.sebaaly', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('maya.bazzi', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('maya.bitar', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'D'),
('maya.elias', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'D'),
('maya.hobeika', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('maya.maalouf', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('maya.massoud', '51749fdfc9e4bf37efae79744172c7735d7cf0406589b274b15d0c64e7441198', 'A'),
('maya.nassar', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('maya.nehme', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('maya.salhab', '51749fdfc9e4bf37efae79744172c7735d7cf0406589b274b15d0c64e7441198', 'A'),
('mchamaa22@gmail.com', '24512bcb09d85acdf773ed4efe24b01cbb9fec9ddd345bbcccca92a76bbb3143', 'A'),
('mchamaa25@gmail.com	', 'f801dd927c324f6dea9c75222e97745e4174ae2edf4a6f6b6ea0b0d93e2706b0', 'A'),
('mchamaa25@gmail.com', '122d4e029987e38c4460f65437911591a40db27c3808f9e7ce76bc4ef4f8c35e', 'A'),
('mira.abdallah', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('mira.abinader', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('mira.bitar', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('mira.sebaaly', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('mohamadtestfinal', '51749fdfc9e4bf37efae79744172c7735d7cf0406589b274b15d0c64e7441198', 'A'),
('momotest', '123456789', 'A'),
('nabil.nassar', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('nabil.nehme', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('nabil.sleiman', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('nabil.tarabay', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('nadia.aridi', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'D'),
('nadia.chedid', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('nadia.fadlallah', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('nadia.haddad', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('nadia.moukalled', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('nadia.sleiman', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'D'),
('noor.fadlallah', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('noor.ghandour', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('noor.maalouf', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('noor.massoud', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('noor.merhi', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('noor.sebaaly', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('nour.chehade', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'D'),
('nour.hobeika', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('nour.maalouf', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('nour.shaya', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('nour.zaher', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('omar.bitar', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('omar.deeb', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'D'),
('omar.fadlallah', '51749fdfc9e4bf37efae79744172c7735d7cf0406589b274b15d0c64e7441198', 'A'),
('omar.fakih', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('omar.ghosn', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'D'),
('omar.mroueh', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('omar.zaher', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('paul.bouhabib', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'D'),
('paul.hobeika', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('paul.nassar', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('paul.rahme', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'D'),
('paul.salhab', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('paul.taleb', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('principal', 'a6c9d915c2781929b357d5c6ffd799e6e01d9f4c10fce69a89c98f286e9f5356', 'A'),
('rami.abinader', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'D'),
('rami.abouzeid', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('rami.atallah', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'D'),
('rami.barakat', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('rami.bazzi', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('rami.chehade', '51749fdfc9e4bf37efae79744172c7735d7cf0406589b274b15d0c64e7441198', 'A'),
('rami.mansour', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('rami.sebaaly', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('rami.tarabay', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('rania.bazzi', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('rania.douaihy', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('rania.saade', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('rania.sebaaly', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'D'),
('rayan.nehme', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'D'),
('rayan.salhab', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'D'),
('rayan.shaya', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'D'),
('salim.barakat', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('salim.fadlallah', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('salim.khalil', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'D'),
('sami.abdallah', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('sami.atallah', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('sami.bousaab', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'D'),
('sami.semaan', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'D'),
('sara.antoun', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('sara.ghandour', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('sara.nassar', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('sofia.chehade', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('sofia.hobeika', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('test22@gmail.com', '15e2b0d3c33891ebb0f1ef609ec419420c20e320ce94c65fbc8c3312448eb225', 'A'),
('test25@gmail.com', '4b95161f70d37e0abdf74f9c54f6c1ea258d8eabc70427fcb698fe3bb8f37161', 'A'),
('test@gmail.com', '12345678', 'A'),
('testtoday', '51749fdfc9e4bf37efae79744172c7735d7cf0406589b274b15d0c64e7441198', 'A'),
('thomas.bazzi', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('thomas.fakih', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('thomas.mroueh', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('thomas.nassar', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('walid.abdallah', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('walid.abinader', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('walid.barakat', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('walid.bazzi', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('walid.douaihy', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('walid.elchamaa', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('walid.haddad', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('walid.saab', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('yara.elchamaa', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('yara.hachem', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('yara.maalouf', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'D'),
('yara.salah', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'D'),
('yara.zaher', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'D'),
('youssef.chehade', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('youssef.elchamaa', '51749fdfc9e4bf37efae79744172c7735d7cf0406589b274b15d0c64e7441198', 'D'),
('youssef.mroueh', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'D'),
('ziad.bousaab', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('ziad.ghosn', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A'),
('ziad.kahoul', '23407384b4fc17610f89bcdcb5c1c64a02b2345ab5086645e4fbbf59bee34dff', 'A');

-- --------------------------------------------------------

--
-- Structure de la table `t_concerantion_con`
--

CREATE TABLE `t_concerantion_con` (
  `ress_id` int(11) NOT NULL,
  `ind_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `t_concerantion_con`
--

INSERT INTO `t_concerantion_con` (`ress_id`, `ind_id`) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6);

-- --------------------------------------------------------

--
-- Structure de la table `t_indisponible_ind`
--

CREATE TABLE `t_indisponible_ind` (
  `ind_id` int(11) NOT NULL,
  `ind_heure_debut` datetime NOT NULL,
  `ind_heure_fin` time NOT NULL,
  `ind_date_debut` date NOT NULL,
  `ind_date_fin` date NOT NULL,
  `mot_id` int(11) NOT NULL,
  `ind_commentaire` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `t_indisponible_ind`
--

INSERT INTO `t_indisponible_ind` (`ind_id`, `ind_heure_debut`, `ind_heure_fin`, `ind_date_debut`, `ind_date_fin`, `mot_id`, `ind_commentaire`) VALUES
(1, '2014-00-00 00:00:00', '16:00:00', '2025-10-05', '2025-10-05', 1, 'Indisponibilité #1'),
(2, '2014-00-00 00:00:00', '16:00:00', '2025-10-06', '2025-10-06', 2, 'Indisponibilité #2'),
(3, '2014-00-00 00:00:00', '16:00:00', '2025-10-07', '2025-10-07', 3, 'Indisponibilité #3'),
(4, '2014-00-00 00:00:00', '16:00:00', '2025-10-08', '2025-10-08', 4, 'Indisponibilité #4'),
(5, '2014-00-00 00:00:00', '16:00:00', '2025-10-09', '2025-10-09', 5, 'Indisponibilité #5'),
(6, '2014-00-00 00:00:00', '16:00:00', '2025-10-10', '2025-10-10', 6, 'Indisponibilité #6');

-- --------------------------------------------------------

--
-- Structure de la table `t_meeting_doc`
--

CREATE TABLE `t_meeting_doc` (
  `doc_id` int(11) NOT NULL,
  `doc_chemin_path` varchar(100) DEFAULT NULL,
  `doc_nom` varchar(80) NOT NULL,
  `met_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `t_meeting_doc`
--

INSERT INTO `t_meeting_doc` (`doc_id`, `doc_chemin_path`, `doc_nom`, `met_id`) VALUES
(1, '/docs/meeting_1.pdf', 'CR_reunion_1.pdf', 1),
(2, '/docs/meeting_2.pdf', 'CR_reunion_2.pdf', 2),
(3, '/docs/meeting_3.pdf', 'CR_reunion_3.pdf', 3),
(4, '/docs/meeting_4.pdf', 'CR_Atelier staff_1', 4),
(5, '/docs/meeting_5.pdf', 'CR_Bilan mensuel_2', 5),
(7, 'CR .pdf', 'CR_Réunion encadrants_0 - mis en ligne le 02/11/2025', 7);

--
-- Déclencheurs `t_meeting_doc`
--
DELIMITER $$
CREATE TRIGGER `trg_avant_mise_en_ligne` BEFORE UPDATE ON `t_meeting_doc` FOR EACH ROW BEGIN
        IF NEW.doc_chemin_path LIKE '%.pdf'
        AND OLD.doc_chemin_path LIKE '%en attente%' THEN
        
            SET NEW.doc_nom = CONCAT(
                OLD.doc_nom,
                ' - mis en ligne le ',
                DATE_FORMAT(CURRENT_DATE, '%d/%m/%Y')
            );
        END IF;
    END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `t_meeting_met`
--

CREATE TABLE `t_meeting_met` (
  `met_id` int(11) NOT NULL,
  `met_titre` varchar(100) NOT NULL,
  `met_heure_debut` time NOT NULL,
  `met_heure_fin` time NOT NULL,
  `met_lieu` varchar(200) NOT NULL,
  `met_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `t_meeting_met`
--

INSERT INTO `t_meeting_met` (`met_id`, `met_titre`, `met_heure_debut`, `met_heure_fin`, `met_lieu`, `met_date`) VALUES
(1, 'Réunion encadrants', '14:00:00', '16:00:00', 'Salle A', '2025-10-05'),
(2, 'Comité jeunes', '10:00:00', '11:30:00', 'Salle B', '2025-10-06'),
(3, 'Préparation tournoi', '09:00:00', '10:30:00', 'Gymnase', '2025-10-07'),
(4, 'Atelier staff', '15:00:00', '17:00:00', 'Laboratoire', '2025-10-08'),
(5, 'Bilan mensuel', '13:00:00', '14:00:00', 'Salle C', '2025-10-09'),
(6, 'Sécurité & matériel', '16:00:00', '17:30:00', 'Stock', '2025-10-10'),
(7, 'Réunion encadrants', '14:00:00', '16:00:00', 'Salle A', '2025-10-05');

--
-- Déclencheurs `t_meeting_met`
--
DELIMITER $$
CREATE TRIGGER `trg_avant_supp_reunion` BEFORE DELETE ON `t_meeting_met` FOR EACH ROW BEGIN

        DELETE FROM t_meeting_doc
        WHERE met_id = OLD.met_id;

        DELETE FROM t_participation_met
        WHERE met_id = OLD.met_id;
    END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `t_message_msg`
--

CREATE TABLE `t_message_msg` (
  `msg_code_verfication` char(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL,
  `msg_sujet` varchar(150) NOT NULL,
  `msg_contenu` varchar(600) NOT NULL,
  `cpt_pseudo` varchar(150) DEFAULT NULL,
  `msg_sender` varchar(150) NOT NULL,
  `msg_reponse` varchar(600) DEFAULT NULL,
  `msg_status` char(2) NOT NULL,
  `date_de_demande` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `t_message_msg`
--

INSERT INTO `t_message_msg` (`msg_code_verfication`, `msg_sujet`, `msg_contenu`, `cpt_pseudo`, `msg_sender`, `msg_reponse`, `msg_status`, `date_de_demande`) VALUES
('ABX92KD7PLQW3ZTY68M1', 'Question  sur la réservation 2', 'Je souhaiterais obtenir une information complémentaire concernant la réservation n°2. Pourriez-vous m’éclairer à ce sujet ?', 'yara.maalouf', 'mohamad@elchamaa', 'Merci pour votre message, nous revenons vers vous.', 'TR', '2025-11-07 14:10:21'),
('ABX92KD7PLQW3ZTY68M2', 'Question #3 sur la réservation', 'Bonjour,\nJe souhaiterais obtenir une information complémentaire concernant la réservation n°2. Pourriez-vous m’éclairer à ce sujet ?', 'yara.salah', 'user', 'Merci pour votre message, nous revenons vers vous.', 'NV', '2025-11-07 14:10:21'),
('ABX92KD7PLQW3ZTY68M3', 'Question #4 sur la réservation', 'Bonjour,\nJe vous contacte car j’ai une question au sujet de la réservation n°2. Pourriez-vous me fournir plus d’informations ?', NULL, 'user', NULL, 'TR', '2025-11-07 14:10:21'),
('ABX92KD7PLQW3ZTY68M4', 'Question #5 sur la réservation', 'Bonjour, j/ai une question concernant la réservation n°5.', NULL, 'user', NULL, 'NV', '2025-11-07 14:10:21'),
('ABX92KD7PLQW3ZTY68M5', 'Question #6 sur la réservation', 'Bonjour, j/ai une question concernant la réservation n°6.', 'rami.abinader', 'user', 'Merci pour votre message, nous revenons vers vous.', 'NV', '2025-11-07 14:10:21'),
('ABX92KD7PLQW3ZTY68MN', 'Question #1 sur la réservation', 'Bonjour, j/ai une question concernant la réservation n°1.', 'nabil.nassar', 'user', 'Merci pour votre message, nous revenons vers vous.', 'NV', '2025-11-07 14:10:21'),
('ab4d8155514c57947006', 'question sur les horaires', 'Bonjour, j’aimerais avoir des informations concernant les horaires. Pourriez-vous me préciser les heures disponibles ?', NULL, 'mchamaa25@gmail.com', NULL, 'NR', '2025-11-17 00:29:41'),
('b0f97ae62836cabb8fe6', 'question sur les horaires', 'Bonjour, j/ai une question concernant la réservati...', NULL, 'ws@gmail.com', NULL, 'NR', '2025-11-16 21:33:38'),
('b1124eea600054c33100', 'question sur les horaires', 'Bonjour, je souhaiterais obtenir des précisions sur les horaires. Pourriez-vous me communiquer les disponibilités ?', NULL, 'mchamaa25@gmail.com', 'ok bravo\r\n', 'NR', '2025-11-18 13:34:30'),
('b2038192c09831eaefb1', 'l&#039; adesion', 'quelle est le prix', NULL, 'vm@tutu.fr', NULL, 'NR', '2025-11-18 14:27:14'),
('d05a84fdd3005968e859', 'question sur les horaires', 'Bonjour, j/ai une question concernant la réservati 4', NULL, 'mchamaa25@gmail.com', NULL, 'NR', '2025-11-17 19:11:50'),
('decafaa56c106dd7f502', 'test de test', 'Bonjour, j/ai une question concernant la réservati 3', NULL, 'test.visiteur@example.com', NULL, 'NR', '2025-11-16 01:42:54'),
('ece1b6689ad0cb0940c9', 'question sur les horaires', 'Bonjour, j/ai une question concernant la réservati 2', NULL, 'hamudi@gmail.com', NULL, 'NR', '2025-11-16 23:46:31'),
('fdc9a75b51a7a8fec779', 'question sur les horaires', 'Bonjour, j/ai une question concernant la réservati 6\n', NULL, 'mchamaa22@gmail.com', NULL, 'NR', '2025-11-16 01:42:10');

-- --------------------------------------------------------

--
-- Structure de la table `t_motif_mot`
--

CREATE TABLE `t_motif_mot` (
  `mot_id` int(11) NOT NULL,
  `mot_motif` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `t_motif_mot`
--

INSERT INTO `t_motif_mot` (`mot_id`, `mot_motif`) VALUES
(1, 'Maintenance planifiée'),
(2, 'Annulation météo'),
(3, 'Absence encadrant'),
(4, 'Priorité institutionnelle'),
(5, 'Événement externe'),
(6, 'Indisponibilité salle');

-- --------------------------------------------------------

--
-- Structure de la table `t_participation_met`
--

CREATE TABLE `t_participation_met` (
  `cpt_pseudo` varchar(150) NOT NULL,
  `met_id` int(11) NOT NULL,
  `role_personne` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `t_participation_met`
--

INSERT INTO `t_participation_met` (`cpt_pseudo`, `met_id`, `role_personne`) VALUES
('amine.taleb', 1, 'Réservant'),
('amine.taleb', 5, 'Participant'),
('maya.hobeika', 4, 'Participant'),
('omar.deeb', 5, 'Participant'),
('rania.sebaaly', 2, 'secrétaire'),
('salim.fadlallah', 3, 'Participant');

--
-- Déclencheurs `t_participation_met`
--
DELIMITER $$
CREATE TRIGGER `doc_desinscip` AFTER DELETE ON `t_participation_met` FOR EACH ROW BEGIN
    CALL doc_re(OLD.met_id);
    END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `doc_inscrip` AFTER INSERT ON `t_participation_met` FOR EACH ROW BEGIN
    CALL doc_re(NEW.met_id);
    END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `t_participation_res`
--

CREATE TABLE `t_participation_res` (
  `cpt_pseudo` varchar(150) NOT NULL,
  `res_id` int(11) NOT NULL,
  `role_personne` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `t_participation_res`
--

INSERT INTO `t_participation_res` (`cpt_pseudo`, `res_id`, `role_personne`) VALUES
('hiba.nehme', 3, 'organisateur'),
('maya.massoud', 6, 'organisateur'),
('maya.salhab', 3, 'participant'),
('omar.fadlallah', 1, 'participant'),
('rami.chehade', 3, 'organisateur'),
('testtoday', 4, 'organisateur'),
('testtoday', 9, 'participant'),
('youssef.elchamaa', 9, 'organisateur');

-- --------------------------------------------------------

--
-- Structure de la table `t_profile_pfl`
--

CREATE TABLE `t_profile_pfl` (
  `pfl_nom` varchar(80) NOT NULL,
  `pfl_prenom` varchar(80) NOT NULL,
  `pfl_email` varchar(150) NOT NULL,
  `pfl_date_naissance` date NOT NULL,
  `pfl_numero_telephone` char(17) NOT NULL,
  `pfl_adresse` varchar(200) NOT NULL,
  `pfl_statut` char(1) NOT NULL,
  `cpt_pseudo` varchar(150) NOT NULL,
  `vil_codePostal` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `t_profile_pfl`
--

INSERT INTO `t_profile_pfl` (`pfl_nom`, `pfl_prenom`, `pfl_email`, `pfl_date_naissance`, `pfl_numero_telephone`, `pfl_adresse`, `pfl_statut`, `cpt_pseudo`, `vil_codePostal`) VALUES
('Khoury', 'Adam', 'adam.khoury@example.com', '1992-12-11', '+33706102708', '77 Rue de la Mer', 'M', 'adam.khoury', 35000),
('Aridi', 'Ali', 'ali.aridi@inbox.fr', '1993-01-14', '+33653453534', '19 Rue de la Mer', 'M', 'ali.aridi', 35000),
('Douaihy', 'Ali', 'ali.douaihy@demo.org', '1999-05-19', '+33657106638', '20 Allée du Parc', 'A', 'ali.douaihy', 35000),
('Elias', 'Amina', 'amina.elias@demo.org', '1993-12-12', '+33635556038', '120 Route de Lannion', 'M', 'amina.elias', 35000),
('Nehme', 'Amina', 'amina.nehme@demo.org', '1988-06-23', '+33613577065', '101 Route de Lannion', 'M', 'amina.nehme', 29280),
('Bazzi', 'Amine', 'amine.bazzi@example.com', '1990-06-27', '+33734171884', '77 Impasse des Arts', 'M', 'amine.bazzi', 6000),
('Maalouf', 'Amine', 'amine.maalouf@inbox.fr', '2003-10-06', '+33721801317', '35 Chemin des Écoles', 'A', 'amine.maalouf', 35000),
('Nasr', 'Amine', 'amine.nasr@demo.org', '1996-02-12', '+33604893723', '47 Chemin des Écoles', 'M', 'amine.nasr', 35000),
('Taleb', 'Amine', 'amine.taleb@inbox.fr', '1994-04-09', '+33760029140', '90 Chemin des Écoles', 'M', 'amine.taleb', 13000),
('Bazzi', 'Aya', 'aya.bazzi@mail.com', '2005-03-18', '+33636838686', '98 Chemin des Écoles', 'A', 'aya.bazzi', 44000),
('Fares', 'Aya', 'aya.fares@student.fr', '1988-11-04', '+33615271307', '48 Chemin des Écoles', 'M', 'aya.fares', 6000),
('Ghosn', 'Aya', 'aya.ghosn@demo.org', '2002-08-03', '+33672499690', '79 Impasse des Arts', 'A', 'aya.ghosn', 75000),
('Kahoul', 'Aya', 'aya.kahoul@inbox.fr', '2006-10-13', '+33757554894', '75 Allée du Parc', 'M', 'aya.kahoul', 29280),
('Merhi', 'Aya', 'aya.merhi@mail.com', '1991-12-11', '+33786807394', '67 Rue des Capucins', 'M', 'aya.merhi', 13000),
('Saab', 'Aya', 'aya.saab@example.com', '1996-01-04', '+33618135380', '45 Rue du Port', 'M', 'aya.saab', 31000),
('Bitar', 'Baptiste', 'baptiste.bitar@student.fr', '1988-02-18', '+33694424535', '39 Rue de Siam', 'A', 'baptiste.bitar', 13000),
('Douaihy', 'Baptiste', 'baptiste.douaihy@student.fr', '2007-06-21', '+33793558252', '7 Chemin des Écoles', 'A', 'baptiste.douaihy', 44000),
('Hachem', 'Baptiste', 'baptiste.hachem@example.com', '1994-08-14', '+33687702997', '96 Rue de Siam', 'M', 'baptiste.hachem', 35000),
('Khatib', 'Baptiste', 'baptiste.khatib@mail.com', '1994-10-03', '+33632708416', '7 Rue du Port', 'A', 'baptiste.khatib', 6000),
('Douaihy', 'Camille', 'camille.douaihy@example.com', '1990-01-18', '+33661451429', '87 Quai des Fleurs', 'M', 'camille.douaihy', 6000),
('Elias', 'Camille', 'camille.elias@mail.com', '2003-06-02', '+33770251954', '110 Chemin des Écoles', 'A', 'camille.elias', 56100),
('Massoud', 'Camille', 'camille.massoud@mail.com', '1994-12-23', '+33629017537', '75 Rue de la Mer', 'A', 'camille.massoud', 31000),
('Mroueh', 'Camille', 'camille.mroueh@student.fr', '1989-03-20', '+33650353805', '67 Route de Lannion', 'A', 'camille.mroueh', 6000),
('Chidiac', 'Chloe', 'chloe.chidiac@demo.org', '1991-06-27', '+33673107917', '37 Quai des Fleurs', 'M', 'chloe.chidiac', 33000),
('Deeb', 'Chloe', 'chloe.deeb@demo.org', '1996-07-13', '+33720934054', '117 Rue des Capucins', 'A', 'chloe.deeb', 31000),
('Merhi', 'Chloe', 'chloe.merhi@student.fr', '1990-11-22', '+33759730162', '91 Avenue des Cèdres', 'A', 'chloe.merhi', 13000),
('Nehme', 'Chloe', 'chloe.nehme@inbox.fr', '2002-10-24', '+33621793595', '21 Rue du Port', 'M', 'chloe.nehme', 13000),
('Sebaaly', 'Elena', 'elena.sebaaly@example.com', '1991-02-19', '+33612172691', '5 Chemin des Écoles', 'A', 'elena.sebaaly', 22300),
('Semaan', 'Elena', 'elena.semaan@mail.com', '1994-06-18', '+33789772011', '37 Rue Saint-Michel', 'A', 'elena.semaan', 22300),
('Abou Zeid', 'Emma', 'emma.abouzeid@example.com', '1993-05-31', '+33793293571', '53 Rue des Capucins', 'M', 'emma.abouzeid', 33000),
('Fares', 'Emma', 'emma.fares@student.fr', '1992-12-02', '+33673265515', '56 Rue des Capucins', 'M', 'emma.fares', 69000),
('Bou Saab', 'Fadi', 'fadi.bousaab@student.fr', '1994-06-19', '+33777860913', '52 Impasse des Arts', 'M', 'fadi.bousaab', 75000),
('Kahoul', 'Fadi', 'fadi.kahoul@student.fr', '1991-04-07', '+33665551249', '68 Rue de Siam', 'M', 'fadi.kahoul', 29280),
('Nassar', 'Fadi', 'fadi.nassar@demo.org', '2005-04-16', '+33744893609', '107 Rue Saint-Michel', 'M', 'fadi.nassar', 6000),
('Saab', 'Fadi', 'fadi.saab@example.com', '1994-06-08', '+33726823654', '90 Boulevard de la Liberté', 'A', 'fadi.saab', 75000),
('Taleb', 'Farah', 'farah.taleb@inbox.fr', '2005-03-05', '+33739935353', '63 Allée du Parc', 'M', 'farah.taleb', 56100),
('Zaher', 'Farah', 'farah.zaher@example.com', '1995-05-24', '+33625368746', '72 Allée du Parc', 'A', 'farah.zaher', 56100),
('Khalil', 'Ghassan', 'ghassan.khalil@mail.com', '2006-04-26', '+33721098747', '114 Route de Lannion', 'M', 'ghassan.khalil', 69000),
('Chedid', 'Hassan', 'hassan.chedid@student.fr', '2007-02-01', '+33687245326', '24 Rue des Capucins', 'M', 'hassan.chedid', 44000),
('Hobeika', 'Hassan', 'hassan.hobeika@inbox.fr', '2005-11-08', '+33610709198', '116 Route de Lannion', 'M', 'hassan.hobeika', 6000),
('Saade', 'Hassan', 'hassan.saade@demo.org', '1994-09-18', '+33778077052', '14 Boulevard de la Liberté', 'A', 'hassan.saade', 22300),
('Bitar', 'Hiba', 'hiba.bitar@inbox.fr', '1990-03-24', '+33784060894', '48 Impasse des Arts', 'A', 'hiba.bitar', 29200),
('Bou Ali', 'Hiba', 'hiba.bouali@student.fr', '1996-12-10', '+33711666371', '94 Avenue des Cèdres', 'A', 'hiba.bouali', 69000),
('Maalouf', 'Hiba', 'hiba.maalouf@demo.org', '1997-11-18', '+33723931274', '99 Chemin des Écoles', 'A', 'hiba.maalouf', 13000),
('Nassar', 'Hiba', 'hiba.nassar@example.com', '1997-09-21', '+33697224110', '82 Rue des Capucins', 'M', 'hiba.nassar', 69000),
('Nehme', 'Hiba', 'hiba.nehme@student.fr', '2007-08-09', '+33699646490', '71 Avenue des Cèdres', 'M', 'hiba.nehme', 56100),
('Abdallah', 'Hugo', 'hugo.abdallah@student.fr', '1988-07-24', '+33766308344', '114 Impasse des Arts', 'A', 'hugo.abdallah', 31000),
('Deeb', 'Hugo', 'hugo.deeb@mail.com', '2004-10-30', '+33724744229', '73 Quai des Fleurs', 'A', 'hugo.deeb', 44000),
('Merhi', 'Hugo', 'hugo.merhi@mail.com', '2006-04-25', '+33723561709', '45 Chemin des Écoles', 'M', 'hugo.merhi', 35000),
('Barakat', 'Imane', 'imane.barakat@student.fr', '1999-10-19', '+33630507502', '96 Avenue des Cèdres', 'A', 'imane.barakat', 75000),
('Chidiac', 'Imane', 'imane.chidiac@mail.com', '1997-08-22', '+33755688478', '78 Allée du Parc', 'A', 'imane.chidiac', 75000),
('Aoun', 'Ines', 'ines.aoun@student.fr', '1997-11-08', '+33740678581', '67 Quai des Fleurs', 'M', 'ines.aoun', 44000),
('Atallah', 'Ines', 'ines.atallah@mail.com', '2001-03-16', '+33686911741', '3 Boulevard de la Liberté', 'A', 'ines.atallah', 29200),
('Massoud', 'Ines', 'ines.massoud@inbox.fr', '1991-07-28', '+33788247930', '14 Rue de Siam', 'M', 'ines.massoud', 75000),
('Rahme', 'Ines', 'ines.rahme@example.com', '2002-04-02', '+33724625866', '117 Rue Saint-Michel', 'A', 'ines.rahme', 6000),
('Saab', 'Ines', 'ines.saab@inbox.fr', '1993-02-06', '+33696873274', '23 Chemin des Écoles', 'M', 'ines.saab', 33000),
('Abdallah', 'Jad', 'jad.abdallah@mail.com', '2004-12-02', '+33765849674', '7 Allée du Parc', 'M', 'jad.abdallah', 56100),
('Khatib', 'Jad', 'jad.khatib@example.com', '1997-04-21', '+33709414123', '43 Impasse des Arts', 'M', 'jad.khatib', 69000),
('Hachem', 'Jana', 'jana.hachem@demo.org', '2004-03-02', '+33657719814', '56 Rue des Capucins', 'M', 'jana.hachem', 69000),
('Khalil', 'Jana', 'jana.khalil@demo.org', '1994-08-20', '+33787711299', '38 Rue de la Mer', 'A', 'jana.khalil', 56100),
('Abi Nader', 'Julie', 'julie.abinader@inbox.fr', '1992-02-19', '+33613791333', '33 Rue des Capucins', 'M', 'julie.abinader', 22300),
('Chidiac', 'Julie', 'julie.chidiac@example.com', '1992-01-17', '+33673355461', '90 Chemin des Écoles', 'A', 'julie.chidiac', 44000),
('Rahme', 'Julie', 'julie.rahme@student.fr', '2007-08-03', '+33726200925', '6 Allée du Parc', 'A', 'julie.rahme', 44000),
('Semaan', 'Julie', 'julie.semaan@mail.com', '2007-11-25', '+33744296568', '18 Rue de Siam', 'A', 'julie.semaan', 44000),
('Sleiman', 'Julie', 'julie.sleiman@student.fr', '2004-01-27', '+33678345990', '66 Rue Saint-Michel', 'A', 'julie.sleiman', 69000),
('Chedid', 'Karim', 'karim.chedid@example.com', '1992-07-25', '+33671687363', '71 Boulevard de la Liberté', 'A', 'karim.chedid', 75000),
('Fares', 'Karim', 'karim.fares@student.fr', '1993-06-19', '+33722617684', '71 Boulevard de la Liberté', 'A', 'karim.fares', 35000),
('Ghandour', 'Karim', 'karim.ghandour@mail.com', '2006-04-27', '+33653605951', '103 Quai des Fleurs', 'M', 'karim.ghandour', 56100),
('Ghosn', 'Karim', 'karim.ghosn@example.com', '1998-03-28', '+33635792942', '103 Rue des Capucins', 'A', 'karim.ghosn', 75000),
('Semaan', 'Karim', 'karim.semaan@student.fr', '1994-06-14', '+33781894786', '70 Boulevard de la Liberté', 'M', 'karim.semaan', 75000),
('Aoun', 'Layla', 'layla.aoun@inbox.fr', '2005-09-01', '+33767787730', '76 Allée du Parc', 'M', 'layla.aoun', 69000),
('Bazzi', 'Layla', 'layla.bazzi@demo.org', '2001-04-25', '+33629273962', '58 Impasse des Arts', 'M', 'layla.bazzi', 31000),
('Chidiac', 'Layla', 'layla.chidiac@student.fr', '1988-10-30', '+33633888974', '65 Quai des Fleurs', 'A', 'layla.chidiac', 22300),
('Bou Ali', 'Lea', 'lea.bouali@student.fr', '1989-10-20', '+33760534244', '6 Rue de Siam', 'A', 'lea.bouali', 31000),
('Tannous', 'Lea', 'lea.tannous@student.fr', '2007-07-11', '+33683288692', '96 Route de Lannion', 'M', 'lea.tannous', 44000),
('Tarabay', 'Lea', 'lea.tarabay@inbox.fr', '1997-09-03', '+33618783450', '86 Route de Lannion', 'A', 'lea.tarabay', 6000),
('Antoun', 'Lina', 'lina.antoun@inbox.fr', '1999-07-24', '+33778201907', '82 Quai des Fleurs', 'A', 'lina.antoun', 22300),
('Bazzi', 'Lina', 'lina.bazzi@mail.com', '1996-04-19', '+33683654518', '93 Route de Lannion', 'M', 'lina.bazzi', 29200),
('Chidiac', 'Lina', 'lina.chidiac@demo.org', '2000-08-05', '+33750775734', '43 Allée du Parc', 'M', 'lina.chidiac', 69000),
('Ghosn', 'Lina', 'lina.ghosn@student.fr', '2001-04-10', '+33751502819', '85 Rue de la Mer', 'M', 'lina.ghosn', 6000),
('Bou Ali', 'Lucas', 'lucas.bouali@inbox.fr', '2001-07-27', '+33727675694', '65 Boulevard de la Liberté', 'M', 'lucas.bouali', 75000),
('Ghandour', 'Lucas', 'lucas.ghandour@student.fr', '2001-05-25', '+33742420266', '38 Rue des Capucins', 'A', 'lucas.ghandour', 22300),
('Mroueh', 'Lucas', 'lucas.mroueh@demo.org', '1998-11-11', '+33692643503', '43 Impasse des Arts', 'A', 'lucas.mroueh', 75000),
('Nasr', 'Lucas', 'lucas.nasr@student.fr', '2006-12-15', '+33750583082', '99 Quai des Fleurs', 'M', 'lucas.nasr', 31000),
('Sleiman', 'Lucas', 'lucas.sleiman@example.com', '1990-01-21', '+33742400362', '28 Rue de Siam', 'A', 'lucas.sleiman', 75000),
('Abou Zeid', 'Mahmoud', 'mahmoud.abouzeid@example.com', '1989-01-11', '+33687073661', '102 Rue de la Mer', 'A', 'mahmoud.abouzeid', 44000),
('Bou Saab', 'Mahmoud', 'mahmoud.bousaab@inbox.fr', '2000-10-02', '+33766705752', '8 Quai des Fleurs', 'M', 'mahmoud.bousaab', 35000),
('Fadlallah', 'Mahmoud', 'mahmoud.fadlallah@example.com', '1988-08-24', '+33769120316', '78 Rue du Port', 'M', 'mahmoud.fadlallah', 56100),
('Khalil', 'Mahmoud', 'mahmoud.khalil@example.com', '2002-03-24', '+33713702755', '107 Chemin des Écoles', 'M', 'mahmoud.khalil', 29200),
('Moukalled', 'Mahmoud', 'mahmoud.moukalled@student.fr', '1998-11-22', '+33762960724', '57 Rue de Siam', 'A', 'mahmoud.moukalled', 35000),
('Mroueh', 'Mahmoud', 'mahmoud.mroueh@inbox.fr', '1989-07-18', '+33735817815', '83 Route de Lannion', 'M', 'mahmoud.mroueh', 69000),
('Saade', 'Mahmoud', 'mahmoud.saade@inbox.fr', '2001-08-23', '+33639818059', '9 Boulevard de la Liberté', 'A', 'mahmoud.saade', 31000),
('Taleb', 'Mahmoud', 'mahmoud.taleb@demo.org', '1997-01-26', '+33790454676', '82 Rue de Siam', 'A', 'mahmoud.taleb', 22300),
('Bitar', 'Malak', 'malak.bitar@mail.com', '2005-09-08', '+33759982602', '1 Chemin des Écoles', 'M', 'malak.bitar', 29280),
('Douaihy', 'Malak', 'malak.douaihy@mail.com', '2002-04-16', '+33670318081', '21 Rue Saint-Michel', 'A', 'malak.douaihy', 13000),
('Ghandour', 'Malak', 'malak.ghandour@example.com', '1995-02-23', '+33626597423', '108 Rue Saint-Michel', 'A', 'malak.ghandour', 29280),
('Abdallah', 'Marwan', 'marwan.abdallah@mail.com', '2007-10-08', '+33710674438', '4 Boulevard de la Liberté', 'A', 'marwan.abdallah', 69000),
('Bitar', 'Marwan', 'marwan.bitar@example.com', '2006-08-11', '+33748769020', '27 Quai des Fleurs', 'M', 'marwan.bitar', 35000),
('Chidiac', 'Marwan', 'marwan.chidiac@demo.org', '2000-07-13', '+33779327815', '104 Route de Lannion', 'M', 'marwan.chidiac', 69000),
('Kahoul', 'Marwan', 'marwan.kahoul@inbox.fr', '1993-08-29', '+33686778146', '15 Rue de Siam', 'M', 'marwan.kahoul', 6000),
('Nassar', 'Marwan', 'marwan.nassar@demo.org', '2007-08-28', '+33698209133', '68 Impasse des Arts', 'A', 'marwan.nassar', 29280),
('Sebaaly', 'Marwan', 'marwan.sebaaly@inbox.fr', '2004-01-08', '+33622636928', '65 Allée du Parc', 'M', 'marwan.sebaaly', 29200),
('Bazzi', 'Maya', 'maya.bazzi@mail.com', '1996-08-17', '+33729710176', '14 Rue du Port', 'A', 'maya.bazzi', 31000),
('Bitar', 'Maya', 'maya.bitar@student.fr', '1998-01-19', '+33604628703', '12 Chemin des Écoles', 'M', 'maya.bitar', 69000),
('Elias', 'Maya', 'maya.elias@inbox.fr', '2006-03-28', '+33634304376', '86 Rue Saint-Michel', 'M', 'maya.elias', 6000),
('Hobeika', 'Maya', 'maya.hobeika@demo.org', '1990-12-09', '+33760322121', '49 Boulevard de la Liberté', 'M', 'maya.hobeika', 29280),
('Maalouf', 'Maya', 'maya.maalouf@mail.com', '2007-07-05', '+33638453779', '73 Allée du Parc', 'A', 'maya.maalouf', 22300),
('Massoud', 'Maya', 'maya.massoud@student.fr', '1988-06-02', '+33723414341', '118 Avenue des Cèdres', 'M', 'maya.massoud', 31000),
('Nassar', 'Maya', 'maya.nassar@example.com', '1991-12-22', '+33768563715', '64 Rue des Capucins', 'A', 'maya.nassar', 6000),
('Nehme', 'Maya', 'maya.nehme@demo.org', '2007-08-02', '+33640365532', '43 Avenue des Cèdres', 'M', 'maya.nehme', 44000),
('Salhab', 'Maya', 'maya.salhab@mail.com', '2005-10-11', '+33682573916', '77 Rue Saint-Michel', 'A', 'maya.salhab', 75000),
('Abdallah', 'Mira', 'mira.abdallah@example.com', '1997-09-07', '+33625921316', '96 Rue Saint-Michel', 'A', 'mira.abdallah', 29280),
('Abi Nader', 'Mira', 'mira.abinader@inbox.fr', '2006-12-17', '+33749321376', '48 Avenue des Cèdres', 'A', 'mira.abinader', 31000),
('Bitar', 'Mira', 'mira.bitar@mail.com', '1996-12-08', '+33688117146', '36 Avenue des Cèdres', 'A', 'mira.bitar', 44000),
('Sebaaly', 'Mira', 'mira.sebaaly@student.fr', '1999-04-05', '+33700384523', '31 Rue de Siam', 'M', 'mira.sebaaly', 44000),
('EL CHAMAA', 'mohamad', 'mchamaa22@gmail.com', '1998-04-12', '+33766741166', '73 Avenue des Cèdres', 'M', 'mohamadtestfinal', 13000),
('momo', 'test', 'momotest@gmail.com', '1992-12-11', '+337444', '5 rue quartier', 'M', 'momotest', 35000),
('Nassar', 'Nabil', 'nabil.nassar@example.com', '1994-03-13', '+33711385258', '44 Impasse des Arts', 'A', 'nabil.nassar', 29200),
('Nehme', 'Nabil', 'nabil.nehme@mail.com', '1988-01-22', '+33709660600', '58 Rue Saint-Michel', 'A', 'nabil.nehme', 56100),
('Sleiman', 'Nabil', 'nabil.sleiman@inbox.fr', '1999-05-17', '+33683022969', '86 Rue de Siam', 'A', 'nabil.sleiman', 69000),
('Tarabay', 'Nabil', 'nabil.tarabay@demo.org', '2001-04-28', '+33736114981', '50 Rue des Capucins', 'M', 'nabil.tarabay', 75000),
('Aridi', 'Nadia', 'nadia.aridi@student.fr', '2004-01-14', '+33653238744', '10 Quai des Fleurs', 'M', 'nadia.aridi', 22300),
('Chedid', 'Nadia', 'nadia.chedid@student.fr', '1993-03-31', '+33743347527', '31 Chemin des Écoles', 'A', 'nadia.chedid', 35000),
('Fadlallah', 'Nadia', 'nadia.fadlallah@demo.org', '1993-08-15', '+33781936011', '97 Rue Saint-Michel', 'M', 'nadia.fadlallah', 6000),
('Haddad', 'Nadia', 'nadia.haddad@mail.com', '2006-09-06', '+33712781417', '50 Quai des Fleurs', 'M', 'nadia.haddad', 31000),
('Moukalled', 'Nadia', 'nadia.moukalled@example.com', '1999-02-26', '+33715603075', '23 Boulevard de la Liberté', 'A', 'nadia.moukalled', 13000),
('Sleiman', 'Nadia', 'nadia.sleiman@inbox.fr', '1992-04-03', '+33632791999', '109 Rue des Capucins', 'M', 'nadia.sleiman', 6000),
('Fadlallah', 'Noor', 'noor.fadlallah@demo.org', '2000-10-06', '+33680785617', '52 Impasse des Arts', 'M', 'noor.fadlallah', 56100),
('Ghandour', 'Noor', 'noor.ghandour@student.fr', '1994-03-15', '+33794504304', '76 Impasse des Arts', 'A', 'noor.ghandour', 22300),
('Maalouf', 'Noor', 'noor.maalouf@mail.com', '1993-04-19', '+33627596380', '19 Chemin des Écoles', 'M', 'noor.maalouf', 29280),
('Massoud', 'Noor', 'noor.massoud@inbox.fr', '1989-01-07', '+33614636716', '71 Chemin des Écoles', 'M', 'noor.massoud', 6000),
('Merhi', 'Noor', 'noor.merhi@example.com', '2005-09-25', '+33705917802', '2 Chemin des Écoles', 'M', 'noor.merhi', 75000),
('Sebaaly', 'Noor', 'noor.sebaaly@demo.org', '1991-06-02', '+33664033920', '17 Rue des Capucins', 'M', 'noor.sebaaly', 31000),
('Chehade', 'Nour', 'nour.chehade@demo.org', '2007-01-22', '+33619549679', '59 Rue de Siam', 'M', 'nour.chehade', 33000),
('Hobeika', 'Nour', 'nour.hobeika@mail.com', '2003-08-23', '+33664103875', '74 Rue de Siam', 'M', 'nour.hobeika', 69000),
('Maalouf', 'Nour', 'nour.maalouf@mail.com', '1994-07-14', '+33715222938', '1 Quai des Fleurs', 'A', 'nour.maalouf', 35000),
('Shaya', 'Nour', 'nour.shaya@student.fr', '2006-02-01', '+33679226429', '96 Route de Lannion', 'M', 'nour.shaya', 75000),
('Zaher', 'Nour', 'nour.zaher@example.com', '1988-06-04', '+33668699056', '28 Boulevard de la Liberté', 'A', 'nour.zaher', 22300),
('Bitar', 'Omar', 'omar.bitar@student.fr', '2004-03-29', '+33644303857', '108 Rue des Capucins', 'M', 'omar.bitar', 31000),
('Deeb', 'Omar', 'omar.deeb@demo.org', '1997-12-31', '+33642723624', '96 Rue des Capucins', 'A', 'omar.deeb', 56100),
('Fadlallah', 'Omar', 'omar.fadlallah@demo.org', '1993-01-15', '+33773848122', '20 Chemin des Écoles', 'M', 'omar.fadlallah', 22300),
('Fakih', 'Omar', 'omar.fakih@student.fr', '1988-12-23', '+33710289019', '47 Allée du Parc', 'M', 'omar.fakih', 75000),
('Ghosn', 'Omar', 'omar.ghosn@student.fr', '2003-02-25', '+33657365033', '66 Rue des Capucins', 'M', 'omar.ghosn', 6000),
('Mroueh', 'Omar', 'omar.mroueh@demo.org', '2007-05-27', '+33784092899', '100 Rue Saint-Michel', 'M', 'omar.mroueh', 31000),
('Zaher', 'Omar', 'omar.zaher@inbox.fr', '2001-01-23', '+33748317326', '19 Rue de Siam', 'M', 'omar.zaher', 29200),
('Bou Habib', 'Paul', 'paul.bouhabib@example.com', '2004-01-02', '+33676699567', '31 Chemin des Écoles', 'A', 'paul.bouhabib', 44000),
('Hobeika', 'Paul', 'paul.hobeika@example.com', '1998-07-13', '+33671141511', '44 Quai des Fleurs', 'A', 'paul.hobeika', 6000),
('Nassar', 'Paul', 'paul.nassar@demo.org', '2006-01-24', '+33632495470', '102 Quai des Fleurs', 'M', 'paul.nassar', 44000),
('Rahme', 'Paul', 'paul.rahme@example.com', '1999-10-18', '+33722655697', '2 Rue Saint-Michel', 'M', 'paul.rahme', 69000),
('Salhab', 'Paul', 'paul.salhab@example.com', '1998-04-12', '+33766741166', '73 Avenue des Cèdres', 'A', 'paul.salhab', 13000),
('Taleb', 'Paul', 'paul.taleb@mail.com', '1998-03-13', '+33687737003', '44 Rue de Siam', 'M', 'paul.taleb', 69000),
('Abi Nader', 'Rami', 'rami.abinader@mail.com', '2007-06-11', '+33723936233', '24 Rue de la Mer', 'A', 'rami.abinader', 69000),
('Abou Zeid', 'Rami', 'rami.abouzeid@demo.org', '1997-02-24', '+33625020655', '29 Avenue des Cèdres', 'A', 'rami.abouzeid', 22300),
('Atallah', 'Rami', 'rami.atallah@demo.org', '1994-01-07', '+33686517976', '110 Rue du Port', 'M', 'rami.atallah', 56100),
('Barakat', 'Rami', 'rami.barakat@mail.com', '1995-01-28', '+33632092731', '96 Impasse des Arts', 'M', 'rami.barakat', 35000),
('Bazzi', 'Rami', 'rami.bazzi@inbox.fr', '1991-07-16', '+33717624274', '107 Impasse des Arts', 'A', 'rami.bazzi', 31000),
('Chehade', 'Rami', 'rami.chehade@example.com', '1990-06-07', '+33760140876', '56 Route de Lannion', 'A', 'rami.chehade', 69000),
('Mansour', 'Rami', 'rami.mansour@demo.org', '1990-11-08', '+33651496683', '54 Allée du Parc', 'A', 'rami.mansour', 6000),
('Sebaaly', 'Rami', 'rami.sebaaly@demo.org', '1994-10-06', '+33722954852', '83 Rue de la Mer', 'M', 'rami.sebaaly', 75000),
('Tarabay', 'Rami', 'rami.tarabay@student.fr', '2003-09-09', '+33668784893', '99 Route de Lannion', 'M', 'rami.tarabay', 31000),
('Bazzi', 'Rania', 'rania.bazzi@demo.org', '1994-10-25', '+33622865574', '32 Avenue des Cèdres', 'A', 'rania.bazzi', 31000),
('Douaihy', 'Rania', 'rania.douaihy@inbox.fr', '1997-08-22', '+33629766746', '37 Allée du Parc', 'A', 'rania.douaihy', 13000),
('Saade', 'Rania', 'rania.saade@example.com', '1994-12-05', '+33718332575', '5 Quai des Fleurs', 'A', 'rania.saade', 33000),
('Sebaaly', 'Rania', 'rania.sebaaly@mail.com', '2002-11-25', '+33779372572', '11 Impasse des Arts', 'A', 'rania.sebaaly', 22300),
('Nehme', 'Rayan', 'rayan.nehme@demo.org', '1995-06-05', '+33607408963', '15 Chemin des Écoles', 'M', 'rayan.nehme', 31000),
('Salhab', 'Rayan', 'rayan.salhab@inbox.fr', '1988-09-25', '+33785295804', '48 Rue du Port', 'A', 'rayan.salhab', 75000),
('Shaya', 'Rayan', 'rayan.shaya@demo.org', '2004-08-24', '+33795044974', '20 Rue de Siam', 'M', 'rayan.shaya', 75000),
('Barakat', 'Salim', 'salim.barakat@mail.com', '1990-06-19', '+33777451308', '111 Rue de la Mer', 'M', 'salim.barakat', 29200),
('Fadlallah', 'Salim', 'salim.fadlallah@student.fr', '2000-12-06', '+33651023882', '33 Rue de la Mer', 'A', 'salim.fadlallah', 29200),
('Khalil', 'Salim', 'salim.khalil@example.com', '1995-04-14', '+33646136855', '103 Quai des Fleurs', 'A', 'salim.khalil', 33000),
('Abdallah', 'Sami', 'sami.abdallah@inbox.fr', '1996-09-08', '+33709728198', '100 Route de Lannion', 'M', 'sami.abdallah', 6000),
('Atallah', 'Sami', 'sami.atallah@student.fr', '2003-06-12', '+33681628856', '90 Rue de Siam', 'A', 'sami.atallah', 13000),
('Bou Saab', 'Sami', 'sami.bousaab@student.fr', '1989-08-29', '+33754892936', '81 Allée du Parc', 'M', 'sami.bousaab', 29280),
('Semaan', 'Sami', 'sami.semaan@demo.org', '1988-10-21', '+33765748012', '9 Rue du Port', 'A', 'sami.semaan', 35000),
('Antoun', 'Sara', 'sara.antoun@example.com', '2005-07-09', '+33774954058', '6 Rue de la Mer', 'M', 'sara.antoun', 35000),
('Ghandour', 'Sara', 'sara.ghandour@mail.com', '1991-05-20', '+33662078781', '50 Rue Saint-Michel', 'M', 'sara.ghandour', 33000),
('Nassar', 'Sara', 'sara.nassar@example.com', '1998-07-19', '+33605203160', '96 Impasse des Arts', 'M', 'sara.nassar', 44000),
('Chehade', 'Sofia', 'sofia.chehade@inbox.fr', '1996-05-24', '+33640973698', '88 Rue des Capucins', 'M', 'sofia.chehade', 22300),
('Hobeika', 'Sofia', 'sofia.hobeika@student.fr', '1992-04-21', '+33660812185', '18 Boulevard de la Liberté', 'M', 'sofia.hobeika', 56100),
('Today', 'Test', 'testtoday@example.com', '2000-01-01', '+330612345678', '5 rue de Paris', 'A', 'testtoday', 75000),
('Bazzi', 'Thomas', 'thomas.bazzi@example.com', '1997-10-17', '+33628417419', '32 Rue de Siam', 'A', 'thomas.bazzi', 13000),
('Fakih', 'Thomas', 'thomas.fakih@inbox.fr', '2004-09-13', '+33726963594', '91 Rue de Siam', 'A', 'thomas.fakih', 6000),
('Mroueh', 'Thomas', 'thomas.mroueh@inbox.fr', '2001-02-09', '+33702280752', '106 Allée du Parc', 'A', 'thomas.mroueh', 22300),
('Nassar', 'Thomas', 'thomas.nassar@student.fr', '1990-03-17', '+33770120386', '91 Avenue des Cèdres', 'A', 'thomas.nassar', 29280),
('Abdallah', 'Walid', 'walid.abdallah@inbox.fr', '2007-02-12', '+33781021460', '110 Impasse des Arts', 'A', 'walid.abdallah', 44000),
('Abi Nader', 'Walid', 'walid.abinader@student.fr', '1995-06-23', '+33686183419', '86 Avenue des Cèdres', 'M', 'walid.abinader', 44000),
('Barakat', 'Walid', 'walid.barakat@demo.org', '1988-11-25', '+33647027403', '61 Impasse des Arts', 'A', 'walid.barakat', 56100),
('Bazzi', 'Walid', 'walid.bazzi@demo.org', '1994-09-16', '+33771513801', '55 Rue Saint-Michel', 'A', 'walid.bazzi', 75000),
('Douaihy', 'Walid', 'walid.douaihy@mail.com', '2004-11-30', '+33660562982', '111 Allée du Parc', 'A', 'walid.douaihy', 13000),
('El Chamaa', 'Walid', 'walid.elchamaa@example.com', '1995-12-07', '+33750292587', '114 Rue de Siam', 'M', 'walid.elchamaa', 35000),
('Haddad', 'Walid', 'walid.haddad@mail.com', '1994-02-12', '+33720613208', '116 Impasse des Arts', 'M', 'walid.haddad', 69000),
('Saab', 'Walid', 'walid.saab@example.com', '2001-09-01', '+33702688453', '80 Allée du Parc', 'M', 'walid.saab', 75000),
('El Chamaa', 'Yara', 'yara.elchamaa@mail.com', '1998-05-05', '+33771236220', '33 Rue des Capucins', 'A', 'yara.elchamaa', 6000),
('Hachem', 'Yara', 'yara.hachem@example.com', '1999-06-13', '+33769979952', '15 Impasse des Arts', 'M', 'yara.hachem', 44000),
('Maalouf', 'Yara', 'yara.maalouf@example.com', '2007-07-29', '+33603292468', '74 Chemin des Écoles', 'A', 'yara.maalouf', 75000),
('Salah', 'Yara', 'yara.salah@inbox.fr', '2005-05-25', '+33661771935', '78 Route de Lannion', 'M', 'yara.salah', 6000),
('Zaher', 'Yara', 'yara.zaher@student.fr', '2003-05-22', '+33628980782', '63 Rue Saint-Michel', 'A', 'yara.zaher', 22300),
('Chehade', 'Youssef', 'youssef.chehade@inbox.fr', '2002-11-22', '+33756110139', '48 Rue des Capucins', 'A', 'youssef.chehade', 69000),
('El Chamaa', 'Youssef', 'youssef.elchamaa@demo.org', '1988-03-20', '+33630030916', '10 Rue Saint-Michel', 'M', 'youssef.elchamaa', 13000),
('Mroueh', 'Youssef', 'youssef.mroueh@student.fr', '1996-12-17', '+33665494075', '19 Allée du Parc', 'M', 'youssef.mroueh', 22300),
('Bou Saab', 'Ziad', 'ziad.bousaab@inbox.fr', '2001-04-06', '+33615078588', '46 Impasse des Arts', 'M', 'ziad.bousaab', 56100),
('Ghosn', 'Ziad', 'ziad.ghosn@demo.org', '1997-10-10', '+33770398724', '105 Rue des Capucins', 'M', 'ziad.ghosn', 75000),
('Kahoul', 'Ziad', 'ziad.kahoul@inbox.fr', '1991-05-21', '+33718047933', '9 Rue des Capucins', 'A', 'ziad.kahoul', 6000);

-- --------------------------------------------------------

--
-- Structure de la table `t_reservation_res`
--

CREATE TABLE `t_reservation_res` (
  `res_id` int(11) NOT NULL,
  `res_date` date NOT NULL,
  `res_heure_debut` time NOT NULL,
  `res_heure_fin` time NOT NULL,
  `res_commentaire` varchar(200) NOT NULL,
  `res_statut` varchar(20) NOT NULL,
  `ress_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `t_reservation_res`
--

INSERT INTO `t_reservation_res` (`res_id`, `res_date`, `res_heure_debut`, `res_heure_fin`, `res_commentaire`, `res_statut`, `ress_id`) VALUES
(1, '2025-10-05', '14:00:00', '18:00:00', 'Maintenance planifiée', 'CONFIRME', 4),
(2, '2025-10-07', '10:00:00', '12:00:00', 'Séance découverte', 'CONFIRME', 3),
(3, '2025-12-31', '16:00:00', '18:00:00', 'Créneau club', 'EN_ATTENTE', 3),
(4, '2025-12-31', '09:00:00', '11:00:00', 'Créneau scolaire', 'CONFIRME', 3),
(5, '2025-10-12', '13:00:00', '15:00:00', 'Tournage projet', 'REFUSE', 6),
(6, '2025-12-31', '15:00:00', '17:00:00', 'Session libre', 'CONFIRME', 5),
(8, '2025-10-05', '14:00:00', '18:00:00', 'Maintenance planifiée', 'CONFIRME', 4),
(9, '2025-11-24', '19:37:36', '19:37:36', 'Maintenance planifiée', 'CONFIRME', 4),
(10, '2025-10-05', '14:00:00', '18:00:00', 'Maintenance planifiée', 'CONFIRME', 15);

-- --------------------------------------------------------

--
-- Structure de la table `t_ressource_ress`
--

CREATE TABLE `t_ressource_ress` (
  `ress_id` int(11) NOT NULL,
  `ress_nom_jeux` varchar(80) NOT NULL,
  `ress_description` varchar(600) NOT NULL,
  `ress_capacite_max` int(11) NOT NULL,
  `ress_image` varchar(100) DEFAULT NULL,
  `ress_age_min` int(11) NOT NULL,
  `ress_age_max` int(11) NOT NULL,
  `ress_liste_de_matriels` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `t_ressource_ress`
--

INSERT INTO `t_ressource_ress` (`ress_id`, `ress_nom_jeux`, `ress_description`, `ress_capacite_max`, `ress_image`, `ress_age_min`, `ress_age_max`, `ress_liste_de_matriels`) VALUES
(1, 'Atelier Circuit Karting', 'Initiation au karting sur mini-circuit sécurisé.', 20, 'robotique.jpg', 12, 25, 'Karts enfants, casques'),
(2, 'Tournoi Futsal', 'Matchs de futsal 5v5 dans notre mini-stade indoor.', 30, 'futsal.jpg', 6, 20, 'Ballons,chasubles'),
(3, 'Studio Musique', 'Studio complet pour apprendre batterie, guitare, chant', 8, 'musique.jpg', 15, 30, 'Casques, micros, carte son'),
(4, 'Atelier Design UX', 'Atelier dédié à la découverte du karting sur un circuit sécurisé. Les jeunes apprennent les bases de la conduite sportive : trajectoires, freinage, sécurité et maîtrise du véhicule. Activité encadrée, adaptée aux adolescents et jeunes adultes.', 16, 'ux.jpg', 15, 30, 'PC, tableau blanc'),
(5, 'Jeux de Société', 'Après-midi ludique autour de jeux de société modernes et coopératifs. Les participants découvrent différents jeux favorisant la stratégie, la réflexion et l’esprit d’équipe. Activité idéale pour renforcer la cohésion et passer un moment convivial.', 24, 'boardgames.jpg', 10, 99, 'Jeux, tables'),
(6, 'Montage Vidéo', 'Initiation au karting dans un environnement encadré. Les participants évoluent sur une piste adaptée en apprenant les règles essentielles de pilotage et les consignes de sécurité. Sensations garanties dans un cadre sécurisé.', 10, 'video.jpg', 15, 30, 'PC, caméra'),
(7, 'Atelier Circuit Karting', 'Initiation au design d’interface et à l’expérience utilisateur. Les participants apprennent à concevoir des maquettes, structurer une interface, améliorer l’ergonomie et comprendre les attentes des utilisateurs grâce aux principes fondamentaux du UX design.', 20, 'robotique.jpg', 12, 25, 'Arduino kits, laptops'),
(8, 'Trampoline Géant', 'Un grand trampoline sécurisé permettant aux enfants de sauter et jouer en toute sécurité.', 8, 'dawnload.jpg', 6, 12, NULL),
(15, 'salle de mohamad', 'qdwqdqdwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww', 2, 'dawnload.jpg', 2, 1, NULL);

--
-- Déclencheurs `t_ressource_ress`
--
DELIMITER $$
CREATE TRIGGER `delet_ressource` BEFORE DELETE ON `t_ressource_ress` FOR EACH ROW BEGIN
    -- Supprimer les participations liées aux réservations de cette ressource
    DELETE FROM t_participation_res 
    WHERE res_id IN (
        SELECT res_id 
        FROM t_reservation_res
        WHERE ress_id = OLD.ress_id
    );

    -- Supprimer les lignes dans t_concerantion_con
    DELETE FROM t_concerantion_con
    WHERE ress_id = OLD.ress_id;

    -- Supprimer les réservations liées
    DELETE FROM t_reservation_res
    WHERE ress_id = OLD.ress_id;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `get_image` BEFORE INSERT ON `t_ressource_ress` FOR EACH ROW BEGIN
IF NEW.ress_image is NULL OR new.ress_image ='' THEN 
SET NEW.ress_image=CONCAT('dawnload.jpg');
   END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `t_ville_vil`
--

CREATE TABLE `t_ville_vil` (
  `vil_codePostal` int(11) NOT NULL,
  `vil_nom` varchar(80) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `t_ville_vil`
--

INSERT INTO `t_ville_vil` (`vil_codePostal`, `vil_nom`) VALUES
(6000, 'Nice'),
(13000, 'Marseille'),
(22300, 'Lannion'),
(29200, 'Brest'),
(29280, 'Plouzané'),
(31000, 'Toulouse'),
(33000, 'Bordeaux'),
(35000, 'Rennes'),
(44000, 'Nantes'),
(56100, 'Lorient'),
(69000, 'Lyon'),
(75000, 'Paris');

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `vue_reservations`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `vue_reservations` (
`cpt_pseudo` varchar(150)
,`ress_nom_jeux` varchar(80)
,`res_date` date
,`res_heure_debut` time
,`res_heure_fin` time
,`participants` mediumtext
,`res_id` int(11)
);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `vue_reservations_jour`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `vue_reservations_jour` (
`ress_nom_jeux` varchar(80)
,`res_date` date
,`res_heure_debut` time
,`res_heure_fin` time
,`participants` mediumtext
,`responsable` varchar(150)
);

-- --------------------------------------------------------

--
-- Structure de la vue `vue_reservations`
--
DROP TABLE IF EXISTS `vue_reservations`;

CREATE ALGORITHM=UNDEFINED DEFINER=`e22301417sql`@`%` SQL SECURITY DEFINER VIEW `vue_reservations`  AS SELECT `t_participation_res`.`cpt_pseudo` AS `cpt_pseudo`, `t_ressource_ress`.`ress_nom_jeux` AS `ress_nom_jeux`, `t_reservation_res`.`res_date` AS `res_date`, `t_reservation_res`.`res_heure_debut` AS `res_heure_debut`, `t_reservation_res`.`res_heure_fin` AS `res_heure_fin`, (select group_concat(`c2`.`cpt_pseudo` separator ', ') from (`t_participation_res` `i2` join `t_compte_cpt` `c2` on(`i2`.`cpt_pseudo` = `c2`.`cpt_pseudo`)) where `i2`.`res_id` = `t_reservation_res`.`res_id`) AS `participants`, `t_reservation_res`.`res_id` AS `res_id` FROM ((((`t_ressource_ress` join `t_reservation_res` on(`t_ressource_ress`.`ress_id` = `t_reservation_res`.`ress_id`)) join `t_participation_res` on(`t_reservation_res`.`res_id` = `t_participation_res`.`res_id`)) join `t_compte_cpt` on(`t_participation_res`.`cpt_pseudo` = `t_compte_cpt`.`cpt_pseudo`)) join `t_profile_pfl` on(`t_participation_res`.`cpt_pseudo` = `t_profile_pfl`.`cpt_pseudo`)) WHERE `t_reservation_res`.`res_date` >= curdate() GROUP BY `t_reservation_res`.`res_id` ORDER BY `t_reservation_res`.`res_date` ASC, `t_reservation_res`.`res_heure_debut` ASC ;

-- --------------------------------------------------------

--
-- Structure de la vue `vue_reservations_jour`
--
DROP TABLE IF EXISTS `vue_reservations_jour`;

CREATE ALGORITHM=UNDEFINED DEFINER=`e22301417sql`@`%` SQL SECURITY DEFINER VIEW `vue_reservations_jour`  AS SELECT `t_ressource_ress`.`ress_nom_jeux` AS `ress_nom_jeux`, `t_reservation_res`.`res_date` AS `res_date`, `t_reservation_res`.`res_heure_debut` AS `res_heure_debut`, `t_reservation_res`.`res_heure_fin` AS `res_heure_fin`, (select group_concat(`c2`.`cpt_pseudo` separator ', ') from (`t_participation_res` `i2` join `t_compte_cpt` `c2` on(`i2`.`cpt_pseudo` = `c2`.`cpt_pseudo`)) where `i2`.`res_id` = `t_reservation_res`.`res_id`) AS `participants`, (select `t_participation_res`.`cpt_pseudo` from (`t_participation_res` join `t_compte_cpt` on(`t_participation_res`.`cpt_pseudo` = `t_compte_cpt`.`cpt_pseudo`)) where `t_participation_res`.`res_id` = `t_reservation_res`.`res_id` and `t_participation_res`.`role_personne` = 'organisateur' limit 1) AS `responsable` FROM (`t_ressource_ress` join `t_reservation_res` on(`t_ressource_ress`.`ress_id` = `t_reservation_res`.`ress_id`)) ORDER BY `t_ressource_ress`.`ress_nom_jeux` ASC ;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `t_actualite_act`
--
ALTER TABLE `t_actualite_act`
  ADD PRIMARY KEY (`act_id`),
  ADD KEY `fk_t_actualite_act_t_compte_cpt1_idx` (`cpt_pseudo`);

--
-- Index pour la table `t_compte_cpt`
--
ALTER TABLE `t_compte_cpt`
  ADD PRIMARY KEY (`cpt_pseudo`);

--
-- Index pour la table `t_concerantion_con`
--
ALTER TABLE `t_concerantion_con`
  ADD PRIMARY KEY (`ress_id`,`ind_id`),
  ADD KEY `fk_t_ressource_res_has_t_indisponible_ind_t_indisponible_in_idx` (`ind_id`),
  ADD KEY `fk_t_ressource_res_has_t_indisponible_ind_t_ressource_res1_idx` (`ress_id`);

--
-- Index pour la table `t_indisponible_ind`
--
ALTER TABLE `t_indisponible_ind`
  ADD PRIMARY KEY (`ind_id`),
  ADD KEY `fk_t_indisponible_ind_t_motif_mot1_idx` (`mot_id`);

--
-- Index pour la table `t_meeting_doc`
--
ALTER TABLE `t_meeting_doc`
  ADD PRIMARY KEY (`doc_id`),
  ADD KEY `fk_Meeting_Doc_Meeting1_idx` (`met_id`);

--
-- Index pour la table `t_meeting_met`
--
ALTER TABLE `t_meeting_met`
  ADD PRIMARY KEY (`met_id`);

--
-- Index pour la table `t_message_msg`
--
ALTER TABLE `t_message_msg`
  ADD PRIMARY KEY (`msg_code_verfication`),
  ADD KEY `fk_t_message_msg_t_compte_cpt1_idx` (`cpt_pseudo`);

--
-- Index pour la table `t_motif_mot`
--
ALTER TABLE `t_motif_mot`
  ADD PRIMARY KEY (`mot_id`);

--
-- Index pour la table `t_participation_met`
--
ALTER TABLE `t_participation_met`
  ADD PRIMARY KEY (`cpt_pseudo`,`met_id`),
  ADD KEY `fk_t_compte_cpt_has_t_meeting_met_t_meeting_met1_idx` (`met_id`),
  ADD KEY `fk_t_compte_cpt_has_t_meeting_met_t_compte_cpt1_idx` (`cpt_pseudo`);

--
-- Index pour la table `t_participation_res`
--
ALTER TABLE `t_participation_res`
  ADD PRIMARY KEY (`cpt_pseudo`,`res_id`),
  ADD KEY `fk_t_compte_cpt_has_t_reservation_res_t_reservation_res1_idx` (`res_id`),
  ADD KEY `fk_t_compte_cpt_has_t_reservation_res_t_compte_cpt1_idx` (`cpt_pseudo`);

--
-- Index pour la table `t_profile_pfl`
--
ALTER TABLE `t_profile_pfl`
  ADD PRIMARY KEY (`cpt_pseudo`),
  ADD KEY `fk_t_profile_pfl_t_compte_cpt1_idx` (`cpt_pseudo`),
  ADD KEY `fk_t_profile_pfl_t_ville_vil1_idx` (`vil_codePostal`);

--
-- Index pour la table `t_reservation_res`
--
ALTER TABLE `t_reservation_res`
  ADD PRIMARY KEY (`res_id`),
  ADD KEY `fk_Reservation_Ressource1_idx` (`ress_id`);

--
-- Index pour la table `t_ressource_ress`
--
ALTER TABLE `t_ressource_ress`
  ADD PRIMARY KEY (`ress_id`);

--
-- Index pour la table `t_ville_vil`
--
ALTER TABLE `t_ville_vil`
  ADD PRIMARY KEY (`vil_codePostal`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `t_actualite_act`
--
ALTER TABLE `t_actualite_act`
  MODIFY `act_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT pour la table `t_indisponible_ind`
--
ALTER TABLE `t_indisponible_ind`
  MODIFY `ind_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT pour la table `t_meeting_doc`
--
ALTER TABLE `t_meeting_doc`
  MODIFY `doc_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT pour la table `t_meeting_met`
--
ALTER TABLE `t_meeting_met`
  MODIFY `met_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT pour la table `t_motif_mot`
--
ALTER TABLE `t_motif_mot`
  MODIFY `mot_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT pour la table `t_reservation_res`
--
ALTER TABLE `t_reservation_res`
  MODIFY `res_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT pour la table `t_ressource_ress`
--
ALTER TABLE `t_ressource_ress`
  MODIFY `ress_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `t_actualite_act`
--
ALTER TABLE `t_actualite_act`
  ADD CONSTRAINT `fk_t_actualite_act_t_compte_cpt1` FOREIGN KEY (`cpt_pseudo`) REFERENCES `t_compte_cpt` (`cpt_pseudo`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `t_concerantion_con`
--
ALTER TABLE `t_concerantion_con`
  ADD CONSTRAINT `fk_t_ressource_res_has_t_indisponible_ind_t_indisponible_ind1` FOREIGN KEY (`ind_id`) REFERENCES `t_indisponible_ind` (`ind_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_t_ressource_res_has_t_indisponible_ind_t_ressource_res1` FOREIGN KEY (`ress_id`) REFERENCES `t_ressource_ress` (`ress_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `t_indisponible_ind`
--
ALTER TABLE `t_indisponible_ind`
  ADD CONSTRAINT `fk_t_indisponible_ind_t_motif_mot1` FOREIGN KEY (`mot_id`) REFERENCES `t_motif_mot` (`mot_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `t_meeting_doc`
--
ALTER TABLE `t_meeting_doc`
  ADD CONSTRAINT `fk_Meeting_Doc_Meeting1` FOREIGN KEY (`met_id`) REFERENCES `t_meeting_met` (`met_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `t_message_msg`
--
ALTER TABLE `t_message_msg`
  ADD CONSTRAINT `fk_t_message_msg_t_compte_cpt1` FOREIGN KEY (`cpt_pseudo`) REFERENCES `t_compte_cpt` (`cpt_pseudo`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `t_participation_met`
--
ALTER TABLE `t_participation_met`
  ADD CONSTRAINT `fk_t_compte_cpt_has_t_meeting_met_t_compte_cpt1` FOREIGN KEY (`cpt_pseudo`) REFERENCES `t_compte_cpt` (`cpt_pseudo`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_t_compte_cpt_has_t_meeting_met_t_meeting_met1` FOREIGN KEY (`met_id`) REFERENCES `t_meeting_met` (`met_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `t_participation_res`
--
ALTER TABLE `t_participation_res`
  ADD CONSTRAINT `fk_t_compte_cpt_has_t_reservation_res_t_compte_cpt1` FOREIGN KEY (`cpt_pseudo`) REFERENCES `t_compte_cpt` (`cpt_pseudo`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_t_compte_cpt_has_t_reservation_res_t_reservation_res1` FOREIGN KEY (`res_id`) REFERENCES `t_reservation_res` (`res_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `t_profile_pfl`
--
ALTER TABLE `t_profile_pfl`
  ADD CONSTRAINT `fk_t_profile_pfl_t_compte_cpt1` FOREIGN KEY (`cpt_pseudo`) REFERENCES `t_compte_cpt` (`cpt_pseudo`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_t_profile_pfl_t_ville_vil1` FOREIGN KEY (`vil_codePostal`) REFERENCES `t_ville_vil` (`vil_codePostal`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `t_reservation_res`
--
ALTER TABLE `t_reservation_res`
  ADD CONSTRAINT `fk_Reservation_Ressource1` FOREIGN KEY (`ress_id`) REFERENCES `t_ressource_ress` (`ress_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
