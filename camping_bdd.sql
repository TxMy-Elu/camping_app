-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le : mar. 22 oct. 2024 à 07:49
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
-- Base de données : `camping`
--

DELIMITER $$

--
-- Procédures
--

-- Updated Procedure ajoutAct
DROP PROCEDURE IF EXISTS `ajoutAct` $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ajoutAct` (IN `id_ani` INT, IN `id_cre` INT)
BEGIN
    INSERT INTO relation1 (id_compte, id_creneaux)
    VALUES (id_ani, id_cre);
END$$

-- Updated Procedure ajoutCreneau
DROP PROCEDURE IF EXISTS `ajoutCreneau` $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ajoutCreneau` (IN `dh` DATETIME, IN `id_animation` INT, IN `id_l` INT, IN `duree` INT, IN `id_ani` INT, IN `places_totales` INT, IN `global_id` INT)
BEGIN
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

DROP FUNCTION IF EXISTS `checkAjout` $$
CREATE DEFINER=`root`@`localhost` FUNCTION `checkAjout` (`dh` DATETIME, `duree` INT, `id_ani` INT) RETURNS TINYINT(1)
BEGIN
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
    `id` INT NOT NULL AUTO_INCREMENT,
    `nom` VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
    `descriptif` VARCHAR(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `compte`
--

DROP TABLE IF EXISTS `compte`;
CREATE TABLE IF NOT EXISTS `compte` (
    `id_compte` INT NOT NULL AUTO_INCREMENT,
    `nom` VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
    `prenom` VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
    `email` VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
    `password` VARCHAR(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
    `role` VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
    `absences` INT NOT NULL DEFAULT 0,
    `bloque` BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (`id_compte`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `creneaux`
--

DROP TABLE IF EXISTS `creneaux`;
CREATE TABLE IF NOT EXISTS `creneaux` (
    `id_creneaux` INT NOT NULL AUTO_INCREMENT,
    `date_heure` DATETIME NOT NULL,
    `id` INT NOT NULL,
    `id_lieu` INT NOT NULL,
    `Duree` INT NOT NULL,
    `places_totales` INT NOT NULL,
    `places_prises` INT NOT NULL,
    `id_global` INT NOT NULL,
    PRIMARY KEY (`id_creneaux`),
    KEY `Creneaux_animation_FK` (`id`),
    KEY `Creneaux_lieu0_FK` (`id_lieu`)
) ENGINE=InnoDB AUTO_INCREMENT=142 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `lieu`
--

DROP TABLE IF EXISTS `lieu`;
CREATE TABLE IF NOT EXISTS `lieu` (
    `id_lieu` INT NOT NULL AUTO_INCREMENT,
    `libelle` VARCHAR(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
    PRIMARY KEY (`id_lieu`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `relation1`
--

DROP TABLE IF EXISTS `relation1`;
CREATE TABLE IF NOT EXISTS `relation1` (
    `id_relation` INT NOT NULL AUTO_INCREMENT,
    `id_compte` INT NOT NULL,
    `id_creneaux` INT NOT NULL,
    PRIMARY KEY (`id_relation`),
    UNIQUE KEY `unique_compte_creneaux` (`id_compte`, `id_creneaux`),
    KEY `relation1_Creneaux0_FK` (`id_creneaux`)
) ENGINE=InnoDB AUTO_INCREMENT=127 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `inscription`
--

DROP TABLE IF EXISTS `inscription`;
CREATE TABLE IF NOT EXISTS `inscription` (
    `id_inscription` INT NOT NULL AUTO_INCREMENT,
    `id_compte` INT NOT NULL,
    `id_creneaux` INT NOT NULL,
    `date_inscription` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `liste_attente` BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (`id_inscription`),
    KEY `inscription_compte_FK` (`id_compte`),
    KEY `inscription_creneaux_FK` (`id_creneaux`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- --------------------------------------------------------

--
-- Structure de la tbale 'membre'
--

DROP TABLE IF EXISTS `membre`;
CREATE TABLE IF NOT EXISTS `membre` (
    `id_membre` INT NOT NULL AUTO_INCREMENT,
    `prenom` VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
    `nom` VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
    `age` INT NOT NULL,
    `id_compte` INT NOT NULL,
    PRIMARY KEY (`id_membre`),
    KEY `membre_compte_FK` (`id_compte`),
    CONSTRAINT `membre_compte_FK` FOREIGN KEY (`id_compte`) REFERENCES `compte` (`id_compte`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
-- Contraintes pour la table `relation1`
--
ALTER TABLE `relation1`
    ADD CONSTRAINT `relation1_compte_FK` FOREIGN KEY (`id_compte`) REFERENCES `compte` (`id_compte`),
    ADD CONSTRAINT `relation1_Creneaux0_FK` FOREIGN KEY (`id_creneaux`) REFERENCES `creneaux` (`id_creneaux`);

--
-- Contraintes pour la table `inscription`
--
ALTER TABLE `inscription`
    ADD CONSTRAINT `inscription_compte_FK` FOREIGN KEY (`id_compte`) REFERENCES `compte` (`id_compte`),
    ADD CONSTRAINT `inscription_creneaux_FK` FOREIGN KEY (`id_creneaux`) REFERENCES `creneaux` (`id_creneaux`);

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;