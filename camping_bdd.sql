-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le : jeu. 12 déc. 2024 à 09:33
-- Version du serveur : 8.3.0
-- Version de PHP : 8.2.18

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `camping_dev`
--

DELIMITER $$
--
-- Procédures
--
DROP PROCEDURE IF EXISTS `ajoutAct`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ajoutAct` (IN `id_ani` INT, IN `id_cre` INT)   BEGIN
    INSERT INTO relation1 (id_compte, id_creneaux)
    VALUES (id_ani, id_cre);
END$$

DROP PROCEDURE IF EXISTS `ajoutCreneau`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ajoutCreneau` (IN `dh` DATETIME, IN `id_animation` INT, IN `id_l` INT, IN `duree` INT, IN `id_ani` INT, IN `places_totales` INT, IN `global_id` INT)   BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE last_id INT;

    WHILE i < duree DO
        INSERT INTO creneaux (date_heure, id, id_lieu, Duree, places_totales, places_prises, id_global)
        VALUES (dh, id_animation, id_l, duree, places_totales, 0, global_id);

        -- Retrieve the last inserted ID
        SET last_id = LAST_INSERT_ID();

        -- Call ajoutAct with the last inserted ID and the hour
        CALL ajoutAct(id_ani, last_id);

        SET dh = DATE_ADD(dh, INTERVAL 1 HOUR);
        SET i = i + 1;
    END WHILE;
END$$

--
-- Fonctions
--
DROP FUNCTION IF EXISTS `checkAjout`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `checkAjout` (`dh` DATETIME, `duree` INT, `id_ani` INT) RETURNS TINYINT(1)  BEGIN
    DECLARE verif BOOLEAN DEFAULT TRUE;
    DECLARE i INT DEFAULT 0;
    DECLARE nbheures INT DEFAULT 0;
    DECLARE date_only VARCHAR(255);

    WHILE i < duree DO
        IF EXISTS (SELECT * FROM creneaux WHERE date_heure = dh) THEN
            SET verif = FALSE;
        END IF;

        SET dh = DATE_ADD(dh, INTERVAL 1 HOUR);
        SET i = i + 1;
    END WHILE;

    SET date_only = DATE_FORMAT(dh, '%Y-%m-%d');
    SET date_only = CONCAT(date_only, '%');

    SELECT COUNT(*) + duree
    INTO nbheures
    FROM relation1
    INNER JOIN creneaux ON relation1.id_creneaux = creneaux.id_creneaux
    WHERE id_compte = id_ani
    AND date_heure LIKE date_only;

    IF nbheures > 7 THEN
        SET verif = FALSE;
    END IF;

    RETURN verif;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `animation`
--

DROP TABLE IF EXISTS `animation`;
CREATE TABLE IF NOT EXISTS `animation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `descriptif` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `animation`
--

INSERT INTO `animation` (`id`, `nom`, `descriptif`) VALUES
(51, 'volley', 'volley');

-- --------------------------------------------------------

--
-- Structure de la table `compte`
--

DROP TABLE IF EXISTS `compte`;
CREATE TABLE IF NOT EXISTS `compte` (
  `id_compte` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `prenom` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `role` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `absences` int NOT NULL DEFAULT '0',
  `bloque` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_compte`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `compte`
--

INSERT INTO `compte` (`id_compte`, `nom`, `prenom`, `email`, `password`, `role`, `absences`, `bloque`) VALUES
(4, 'doguet', 'tom', 'admin', '1606', 'animateur', 2, 1),
(5, 'lilo', 'liol', 'admin', '1606', 'client', 1, 0),
(6, 'over', 'over', 'over', '1478', 'client', 0, 0),
(7, 'oui', 'oui', 'oui', '1234', 'client', 0, 0),
(8, 'test', 'test', 'test', '1234', 'client', 0, 0);

--
-- Déclencheurs `compte`
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
-- Structure de la table `creneaux`
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
) ENGINE=InnoDB AUTO_INCREMENT=150 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `creneaux`
--

INSERT INTO `creneaux` (`id_creneaux`, `date_heure`, `id`, `id_lieu`, `Duree`, `places_totales`, `places_prises`, `id_global`) VALUES
(142, '2024-11-28 14:00:00', 51, 51, 2, 16, 4, 1),
(143, '2024-11-28 15:00:00', 51, 51, 2, 16, 4, 1),
(146, '2024-11-28 16:00:00', 51, 51, 2, 16, 0, 2),
(147, '2024-11-28 17:00:00', 51, 51, 2, 16, 0, 2),
(148, '2024-11-29 10:00:00', 51, 51, 2, 7, 2, 3),
(149, '2024-11-29 11:00:00', 51, 51, 2, 7, 2, 3);

-- --------------------------------------------------------

--
-- Structure de la table `inscription`
--

DROP TABLE IF EXISTS `inscription`;
CREATE TABLE IF NOT EXISTS `inscription` (
  `id_inscription` int NOT NULL AUTO_INCREMENT,
  `id_compte` int NOT NULL,
  `id_creneaux` int NOT NULL,
  `date_inscription` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `liste_attente` BOOLEAN NOT NULL DEFAULT FALSE,
  `est_valide` BOOLEAN NOT NULL DEFAULT TRUE,
  PRIMARY KEY (`id_inscription`),
  KEY `inscription_compte_FK` (`id_compte`),
  KEY `inscription_creneaux_FK` (`id_creneaux`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `inscription`
--

INSERT INTO `inscription` (`id_inscription`, `id_compte`, `id_creneaux`, `date_inscription`, `liste_attente`) VALUES
(7, 6, 142, '2024-07-03 00:00:00', 0),
(8, 8, 142, '2024-07-03 00:00:00', 0);

--
-- Déclencheurs `inscription`
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
-- Structure de la table `lieu`
--

DROP TABLE IF EXISTS `lieu`;
CREATE TABLE IF NOT EXISTS `lieu` (
  `id_lieu` int NOT NULL AUTO_INCREMENT,
  `libelle` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id_lieu`)
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `lieu`
--

INSERT INTO `lieu` (`id_lieu`, `libelle`) VALUES
(51, 'gym');

-- --------------------------------------------------------

--
-- Structure de la table `membre`
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
-- Structure de la table `relation1`
--

DROP TABLE IF EXISTS `relation1`;
CREATE TABLE IF NOT EXISTS `relation1` (
  `id_relation` int NOT NULL AUTO_INCREMENT,
  `id_compte` int NOT NULL,
  `id_creneaux` int NOT NULL,
  PRIMARY KEY (`id_relation`),
  UNIQUE KEY `unique_compte_creneaux` (`id_compte`,`id_creneaux`),
  KEY `relation1_Creneaux0_FK` (`id_creneaux`)
) ENGINE=InnoDB AUTO_INCREMENT=135 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `relation1`
--

INSERT INTO `relation1` (`id_relation`, `id_compte`, `id_creneaux`) VALUES
(127, 4, 142),
(128, 4, 143),
(131, 4, 146),
(132, 4, 147),
(133, 4, 148),
(134, 4, 149);

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `creneaux`
--
ALTER TABLE `creneaux`
  ADD CONSTRAINT `Creneaux_animation_FK` FOREIGN KEY (`id`) REFERENCES `animation` (`id`),
  ADD CONSTRAINT `Creneaux_lieu0_FK` FOREIGN KEY (`id_lieu`) REFERENCES `lieu` (`id_lieu`);

--
-- Contraintes pour la table `inscription`
--
ALTER TABLE `inscription`
  ADD CONSTRAINT `inscription_compte_FK` FOREIGN KEY (`id_compte`) REFERENCES `compte` (`id_compte`),
  ADD CONSTRAINT `inscription_creneaux_FK` FOREIGN KEY (`id_creneaux`) REFERENCES `creneaux` (`id_creneaux`);

--
-- Contraintes pour la table `membre`
--
ALTER TABLE `membre`
  ADD CONSTRAINT `membre_compte_FK` FOREIGN KEY (`id_compte`) REFERENCES `compte` (`id_compte`);

--
-- Contraintes pour la table `relation1`
--
ALTER TABLE `relation1`
  ADD CONSTRAINT `relation1_compte_FK` FOREIGN KEY (`id_compte`) REFERENCES `compte` (`id_compte`),
  ADD CONSTRAINT `relation1_Creneaux0_FK` FOREIGN KEY (`id_creneaux`) REFERENCES `creneaux` (`id_creneaux`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
