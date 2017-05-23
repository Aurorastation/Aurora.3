--
-- Adds the IP intel database table.
--

CREATE TABLE `ss13_ipintel` (
  `ip` int(10) unsigned NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `intel` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`ip`),
  KEY `idx_ipintel` (`ip`,`intel`,`date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
