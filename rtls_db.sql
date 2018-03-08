CREATE TABLE `ar_ap_notification` (
  `id` smallint(5) NOT NULL,
  `msg_id` varchar(12) NOT NULL,
  `ap_eth_mac_addr` char(12) NOT NULL,
  `ts` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `ar_station_report` (
  `ap` smallint(5) NOT NULL,
  `sta_eth_mac` char(12) NOT NULL,
  `mon_bssid` char(12) NOT NULL,
  `ts` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `mac_blacklist` (
  `oui` varchar(9) NOT NULL,
  `id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `mac_registry` (
  `registry` set('MA-L','MA-M','MA-S','') NOT NULL,
  `assignment` varchar(9) NOT NULL,
  `organization` varchar(128) NOT NULL,
  `address` varchar(512) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `organization_blacklist` (
  `id` int(11) NOT NULL,
  `organization` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DELIMITER $$
CREATE TRIGGER `update_mac_blacklist_after_insert` AFTER INSERT ON `organization_blacklist` FOR EACH ROW INSERT IGNORE INTO mac_blacklist SELECT mac_registry.assignment,organization_blacklist.id 
FROM mac_registry,organization_blacklist WHERE mac_registry.organization = organization_blacklist.organization
$$
DELIMITER ;

ALTER TABLE `ar_ap_notification`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ap_eth_mac_addr` (`ap_eth_mac_addr`);

ALTER TABLE `ar_station_report`
  ADD UNIQUE KEY `only_one_row_per_sta_in_ts` (`sta_eth_mac`,`ts`),
  ADD KEY `sta_eth_mac` (`sta_eth_mac`),
  ADD KEY `mon_bssid` (`mon_bssid`),
  ADD KEY `ap` (`ap`);

ALTER TABLE `mac_blacklist`
  ADD UNIQUE KEY `oui` (`oui`);

ALTER TABLE `mac_registry`
  ADD KEY `assignment` (`assignment`),
  ADD KEY `organization` (`organization`);

ALTER TABLE `organization_blacklist`
  ADD PRIMARY KEY (`id`);
