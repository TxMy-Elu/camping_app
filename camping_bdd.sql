-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Mar 15, 2025 at 12:26 PM
-- Server version: 9.1.0
-- PHP Version: 8.2.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `camping_dev`
--

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `ajoutAct`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ajoutAct` (IN `id_ani` INT, IN `id_cre` INT)   BEGIN
    INSERT INTO relation1 (id_compte, id_creneaux)
    VALUES (id_ani, id_cre);
END$$

DROP PROCEDURE IF EXISTS `ajoutCreneau`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ajoutCreneau` (IN `dh` DATETIME, IN `id_animation` INT, IN `id_l` INT, IN `duree` INT, IN `id_ani` INT)   BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE last_id INT;

    WHILE i < duree DO
            INSERT INTO creneaux (date_heure, id, id_lieu, Duree, places_totales, places_prises)
            VALUES (dh, id_animation, id_l, duree, 0, 0);

            -- Récupérer le dernier ID inséré
            SET last_id = LAST_INSERT_ID();

            -- Appeler ajoutAct avec le dernier ID inséré et l'heure
            CALL ajoutAct(id_ani, last_id);

            SET dh = DATE_ADD(dh, INTERVAL 1 HOUR);
            SET i = i + 1;
        END WHILE;
END$$

--
-- Functions
--
DROP FUNCTION IF EXISTS `checkAjout`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `checkAjout` (`dh` DATETIME, `duree` INT, `id_ani` INT) RETURNS TINYINT(1)  BEGIN
    DECLARE verif BOOLEAN DEFAULT TRUE;
    DECLARE i INT DEFAULT 0;
    DECLARE nbheures INT DEFAULT 0;
    DECLARE date_only VARCHAR(255);

    WHILE i < duree
        DO
            IF EXISTS (SELECT * FROM creneaux WHERE date_heure = dh) THEN
                SET verif = FALSE;
            END IF;

            SET dh = DATE_ADD(dh, INTERVAL 1 HOUR);
            SET i = i + 1;
    END WHILE;

    SET date_only = DATE_FORMAT(dh, '%Y-%m-%d');

    SET date_only = CONCAT(date_only, '%');

    SELECT COUNT(*)+duree into nbheures FROM relation1 inner join creneaux on relation1.id_creneaux = creneaux.id_creneaux WHERE id_compte = id_ani AND date_heure like date_only;
    IF nbheures > 7 THEN
       SET verif = FALSE;
    END IF;

    return verif;
end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `animation`
--

DROP TABLE IF EXISTS `animation`;
CREATE TABLE IF NOT EXISTS `animation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `descriptif` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `animation`
--

INSERT INTO `animation` (`id`, `nom`, `descriptif`) VALUES
(1, 'Randonnée', 'Randonnée guidée dans les sentiers du camping'),
(2, 'VTT', 'Parcours VTT pour tous niveaux'),
(3, 'Balade à cheval', 'Promenade à cheval avec moniteur'),
(4, 'Course d\'orientation', 'Découverte de la nature en s\'amusant'),
(5, 'Piscine', 'Accès à la piscine chauffée'),
(6, 'Kayak', 'Initiation et balade en kayak'),
(7, 'Paddle', 'Session de stand-up paddle'),
(8, 'Pédalo', 'Balade en pédalo sur le lac'),
(9, 'Volley', 'Tournois et sessions libres de volleyball'),
(10, 'Tennis', 'Cours de tennis tous niveaux'),
(11, 'Ping-pong', 'Tournois de tennis de table'),
(12, 'Pétanque', 'Tournois de pétanque'),
(13, 'Mini-golf', 'Parcours 18 trous en famille'),
(14, 'Soirée karaoké', 'Soirée musicale et conviviale'),
(15, 'Spectacle', 'Spectacle de variétés'),
(16, 'Cinéma plein air', 'Projection de film en extérieur'),
(17, 'Cours de danse', 'Initiation à différents styles de danse'),
(18, 'Yoga', 'Session de yoga en plein air'),
(19, 'Spa', 'Accès à l\'espace bien-être'),
(20, 'Club enfants', 'Activités ludiques pour les 4-12 ans');

-- --------------------------------------------------------

--
-- Table structure for table `compte`
--

DROP TABLE IF EXISTS `compte`;
CREATE TABLE IF NOT EXISTS `compte` (
  `id_compte` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `prenom` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `role` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `absences` int NOT NULL DEFAULT '0',
  `bloque` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_compte`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `compte`
--

INSERT INTO `compte` (`id_compte`, `nom`, `prenom`, `email`, `password`, `role`, `absences`, `bloque`) VALUES
(1, 'Martin', 'Thomas', 'thomas.martin@example.com', '$2a$10$XdQzV09a.CgRhw3XMhZwZuHT/Q.lXFW8MKs7TTgHMrU9n7QIV9n6m', 'admin', 0, 0), /* pwd: admin123 */
(2, 'Dubois', 'Sophie', 'sophie.dubois@example.com', '$2a$10$RcLSFGMS3Y5ZTBN3Lck/suSJF90PgOgNcMzRgIk1gSCnGtc8dRoRK', 'animateur', 1, 0), /* pwd: password123 */
(3, 'Leroy', 'Antoine', 'antoine.leroy@example.com', '$2a$10$l9GpPV3JXKg/lOQvc4Yz/ui1JU5aJGQT0hQZpJuEfxWLmzTwm7Gk.', 'client', 0, 0), /* pwd: secure456 */
(4, 'Moreau', 'Julie', 'julie.moreau@example.com', '$2a$10$nL7lUzL2n8w3YK2D4XBGQ.TRmzX3i.YGNZ4Ay1Xh2TKIwASLBjlBS', 'animateur', 0, 0), /* pwd: julie2023 */
(5, 'Petit', 'Lucas', 'lucas.petit@example.com', '$2a$10$5mwzHVWH5mhyxnuHZG9Xn.zHyxXNVBMB3xQI0Wa2wGKV1IWLEwN22', 'client', 0, 0), /* pwd: test1234 */
(6, 'Lefebvre', 'Emma', 'emma.lefebvre@example.com', '$2a$10$gMWYx0JO7OtyR2Jui2g2Hu3tWe9UVBWbFJODJXBvWoWsZKUlC1gXu', 'client', 2, 0), /* pwd: emma2023 */
(7, 'Garcia', 'Hugo', 'hugo.garcia@example.com', '$2a$10$Xx5UUfxC6.v2UYoFB7nBdugcI8mdhABUxNgGNJrWPFQ3ewA6oQcA6', 'animateur', 0, 1), /* pwd: hugo7890 */
(8, 'Fournier', 'Chloe', 'chloe.fournier@example.com', '$2a$10$iJMB0d5PoQxAh7kIEuNvwOPu4.6A0wSJDGMK.gqWTXMRuK9hT/Z32', 'client', 0, 0), /* pwd: chloe456 */
(9, 'Dupont', 'Maxime', 'maxime.dupont@example.com', '$2a$10$jNfLKE8V9HkNBBbXoWMr9.F0FbJTB5BkX/jWA9c0pRrAWKgPr3xqq', 'admin', 0, 0), /* pwd: admin2023 */
(10, 'Roux', 'Camille', 'camille.roux@example.com', '$2a$10$H1c4TRKqWBBFiPgr1/0gUuQCnBQyvjOcCbXnlLHCvBG.kKP2CZyma', 'animateur', 1, 0); /* pwd: camille123 */
--
-- Triggers `compte`
--
DROP TRIGGER IF EXISTS `bloquer_user`;
DELIMITER $$
CREATE TRIGGER `bloquer_user` AFTER UPDATE ON `compte` FOR EACH ROW BEGIN
    IF NEW.bloque = TRUE THEN
        DELETE FROM inscription WHERE id_compte = NEW.id_compte;
    END IF;
    END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `creneaux`
--

DROP TABLE IF EXISTS `creneaux`;
CREATE TABLE IF NOT EXISTS `creneaux` (
  `id_creneaux` int NOT NULL AUTO_INCREMENT,
  `date_heure` datetime NOT NULL,
  `id` int NOT NULL,
  `id_lieu` int NOT NULL,
  `Duree` int NOT NULL,
  `places_totales` int NOT NULL,
  `places_prises` int NOT NULL,
  `id_global` int NOT NULL,
  PRIMARY KEY (`id_creneaux`),
  KEY `Creneaux_animation_FK` (`id`),
  KEY `Creneaux_lieu0_FK` (`id_lieu`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `creneaux`
--

INSERT INTO `creneaux` (`id_creneaux`, `date_heure`, `id`, `id_lieu`, `Duree`, `places_totales`, `places_prises`, `id_global`) VALUES
(1, '2025-07-01 08:00:00', 18, 1, 1, 15, 1, 1001),
(2, '2025-07-01 09:00:00', 1, 4, 2, 12, 0, 1002),
(3, '2025-07-01 11:00:00', 9, 1, 1, 12, 0, 1003),
(4, '2025-07-01 14:00:00', 5, 2, 2, 30, 0, 1004),
(5, '2024-07-01 16:00:00', 10, 5, 1, 8, 0, 1005),
(6, '2024-07-01 17:00:00', 20, 8, 1, 15, 0, 1006),
(7, '2024-07-01 08:00:00', 7, 3, 1, 8, 0, 1007),
(8, '2024-07-01 09:00:00', 2, 4, 2, 10, 0, 1008),
(9, '2024-07-01 11:00:00', 12, 10, 1, 16, 0, 1009),
(10, '2024-07-01 14:00:00', 19, 7, 2, 6, 0, 1010),
(11, '2024-07-01 16:00:00', 13, 9, 1, 20, 0, 1011),
(12, '2024-07-01 17:00:00', 17, 6, 1, 15, 0, 1012),
(13, '2024-07-01 08:00:00', 3, 4, 2, 8, 0, 1013),
(14, '2024-07-01 10:00:00', 4, 4, 2, 15, 0, 1014),
(15, '2024-07-01 14:00:00', 6, 3, 2, 8, 0, 1015),
(16, '2024-07-01 16:00:00', 11, 1, 1, 12, 0, 1016),
(17, '2024-07-01 17:00:00', 15, 6, 1, 100, 0, 1017);

-- --------------------------------------------------------

--
-- Table structure for table `inscription`
--

DROP TABLE IF EXISTS `inscription`;
CREATE TABLE IF NOT EXISTS `inscription` (
  `id_inscription` int NOT NULL AUTO_INCREMENT,
  `id_compte` int NOT NULL,
  `id_creneaux` int NOT NULL,
  `date_inscription` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `liste_attente` tinyint(1) NOT NULL DEFAULT '0',
  `est_valide` tinyint(1) NOT NULL DEFAULT '1',
  `estAbs` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_inscription`),
  KEY `inscription_compte_FK` (`id_compte`),
  KEY `inscription_creneaux_FK` (`id_creneaux`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `inscription`
--
DROP TRIGGER IF EXISTS `gerer_liste_attente`;
DELIMITER $$
CREATE TRIGGER `gerer_liste_attente` AFTER DELETE ON `inscription` FOR EACH ROW BEGIN
    DECLARE count_waiting_list INT;

    -- Check if there is anyone on the waiting list
    SELECT COUNT(*) INTO count_waiting_list
    FROM inscription
    WHERE id_creneaux = OLD.id_creneaux AND liste_attente = true;

    IF count_waiting_list > 0 THEN
        -- Move the first person from the waiting list to the main list
        UPDATE inscription
        SET liste_attente = false
        WHERE id_inscription = (
            SELECT id_inscription
            FROM inscription
            WHERE id_creneaux = OLD.id_creneaux AND liste_attente = true
            ORDER BY date_inscription ASC
            LIMIT 1
        );
    ELSE
        -- Update the creneaux with the new placesPrises
        UPDATE creneaux
        SET places_prises = places_prises - 1
        WHERE id_global = OLD.id_creneaux;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `lieu`
--

DROP TABLE IF EXISTS `lieu`;
CREATE TABLE IF NOT EXISTS `lieu` (
  `id_lieu` int NOT NULL AUTO_INCREMENT,
  `libelle` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id_lieu`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `lieu`
--

INSERT INTO `lieu` (`id_lieu`, `libelle`) VALUES
(1, 'Terrain multisports'),
(2, 'Piscine'),
(3, 'Lac'),
(4, 'Sentiers'),
(5, 'Courts de tennis'),
(6, 'Salle de spectacle'),
(7, 'Espace bien-être'),
(8, 'Club enfants'),
(9, 'Mini-golf'),
(10, 'Terrain de pétanque');

-- --------------------------------------------------------

--
-- Table structure for table `membre`
--

DROP TABLE IF EXISTS `membre`;
CREATE TABLE IF NOT EXISTS `membre` (
  `id_membre` int NOT NULL AUTO_INCREMENT,
  `prenom` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `nom` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `age` int NOT NULL,
  `id_compte` int NOT NULL,
  PRIMARY KEY (`id_membre`),
  KEY `membre_compte_FK` (`id_compte`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `relation1`
--

DROP TABLE IF EXISTS `relation1`;
CREATE TABLE IF NOT EXISTS `relation1` (
  `id_relation` int NOT NULL AUTO_INCREMENT,
  `id_compte` int NOT NULL,
  `id_creneaux` int NOT NULL,
  PRIMARY KEY (`id_relation`),
  UNIQUE KEY `unique_compte_creneaux` (`id_compte`,`id_creneaux`),
  KEY `relation1_Creneaux0_FK` (`id_creneaux`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `creneaux`
--
ALTER TABLE `creneaux`
  ADD CONSTRAINT `Creneaux_animation_FK` FOREIGN KEY (`id`) REFERENCES `animation` (`id`),
  ADD CONSTRAINT `Creneaux_lieu0_FK` FOREIGN KEY (`id_lieu`) REFERENCES `lieu` (`id_lieu`);

--
-- Constraints for table `inscription`
--
ALTER TABLE `inscription`
  ADD CONSTRAINT `inscription_compte_FK` FOREIGN KEY (`id_compte`) REFERENCES `compte` (`id_compte`),
  ADD CONSTRAINT `inscription_creneaux_FK` FOREIGN KEY (`id_creneaux`) REFERENCES `creneaux` (`id_creneaux`);

--
-- Constraints for table `membre`
--
ALTER TABLE `membre`
  ADD CONSTRAINT `membre_compte_FK` FOREIGN KEY (`id_compte`) REFERENCES `compte` (`id_compte`);

--
-- Constraints for table `relation1`
--
ALTER TABLE `relation1`
  ADD CONSTRAINT `relation1_compte_FK` FOREIGN KEY (`id_compte`) REFERENCES `compte` (`id_compte`),
  ADD CONSTRAINT `relation1_Creneaux0_FK` FOREIGN KEY (`id_creneaux`) REFERENCES `creneaux` (`id_creneaux`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
