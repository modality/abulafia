-- phpMyAdmin SQL Dump
-- version 4.9.1
-- https://www.phpmyadmin.net/
--
-- Host: internal-db.s30817.gridserver.com
-- Generation Time: Nov 26, 2020 at 07:23 AM
-- Server version: 5.6.32-78.0
-- PHP Version: 7.3.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db30817_abulafia`
--

-- --------------------------------------------------------

--
-- Table structure for table `abulafia_entries2`
--

CREATE TABLE IF NOT EXISTS `abulafia_entries2` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `sgtable` varchar(128) NOT NULL DEFAULT '',
  `subtable` varchar(128) NOT NULL DEFAULT 'main',
  `serializedarray` mediumtext,
  PRIMARY KEY (`id`),
  KEY `sgtable` (`sgtable`),
  KEY `subtable` (`subtable`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
