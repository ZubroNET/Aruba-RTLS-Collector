-- phpMyAdmin SQL Dump
-- version 4.7.7
-- https://www.phpmyadmin.net/
--
-- Počítač: vsrvr19.zubro.net
-- Vytvořeno: Čtv 08. bře 2018, 17:19
-- Verze serveru: 10.2.12-MariaDB-log
-- Verze PHP: 5.6.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Databáze: `wmb_rtls`
--

-- --------------------------------------------------------

--
-- Struktura tabulky `ar_ap_notification`
--

CREATE TABLE `ar_ap_notification` (
  `id` smallint(5) NOT NULL,
  `msg_id` varchar(12) NOT NULL,
  `ap_eth_mac_addr` char(12) NOT NULL,
  `ts` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Struktura tabulky `ar_station_report`
--

CREATE TABLE `ar_station_report` (
  `ap` smallint(5) NOT NULL,
  `sta_eth_mac` char(12) NOT NULL,
  `mon_bssid` char(12) NOT NULL,
  `ts` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Struktura tabulky `mac_blacklist`
--

CREATE TABLE `mac_blacklist` (
  `oui` varchar(9) NOT NULL,
  `id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Struktura tabulky `mac_registry`
--

CREATE TABLE `mac_registry` (
  `registry` set('MA-L','MA-M','MA-S','') NOT NULL,
  `assignment` varchar(9) NOT NULL,
  `organization` varchar(128) NOT NULL,
  `address` varchar(512) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Struktura tabulky `organization_blacklist`
--

CREATE TABLE `organization_blacklist` (
  `id` int(11) NOT NULL,
  `organization` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Spouště `organization_blacklist`
--
DELIMITER $$
CREATE TRIGGER `update_mac_blacklist_after_insert` AFTER INSERT ON `organization_blacklist` FOR EACH ROW INSERT IGNORE INTO mac_blacklist SELECT mac_registry.assignment,organization_blacklist.id 
FROM mac_registry,organization_blacklist WHERE mac_registry.organization = organization_blacklist.organization
$$
DELIMITER ;

--
-- Klíče pro exportované tabulky
--

--
-- Klíče pro tabulku `ar_ap_notification`
--
ALTER TABLE `ar_ap_notification`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ap_eth_mac_addr` (`ap_eth_mac_addr`);

--
-- Klíče pro tabulku `ar_station_report`
--
ALTER TABLE `ar_station_report`
  ADD UNIQUE KEY `only_one_row_per_sta_in_ts` (`sta_eth_mac`,`ts`),
  ADD KEY `sta_eth_mac` (`sta_eth_mac`),
  ADD KEY `mon_bssid` (`mon_bssid`),
  ADD KEY `ap` (`ap`);

--
-- Klíče pro tabulku `mac_blacklist`
--
ALTER TABLE `mac_blacklist`
  ADD UNIQUE KEY `oui` (`oui`);

--
-- Klíče pro tabulku `mac_registry`
--
ALTER TABLE `mac_registry`
  ADD KEY `assignment` (`assignment`),
  ADD KEY `organization` (`organization`);

--
-- Klíče pro tabulku `organization_blacklist`
--
ALTER TABLE `organization_blacklist`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT pro tabulky
--

--
-- AUTO_INCREMENT pro tabulku `ar_ap_notification`
--
ALTER TABLE `ar_ap_notification`
  MODIFY `id` smallint(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=84;

--
-- AUTO_INCREMENT pro tabulku `organization_blacklist`
--
ALTER TABLE `organization_blacklist`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=61;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
