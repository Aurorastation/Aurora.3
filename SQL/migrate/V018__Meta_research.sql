--
-- Adds the required tables for metaresearch.
--

CREATE TABLE `ss13_research_concepts` (
  `cid` varchar(45) NOT NULL,
  `level` varchar(45) NOT NULL,
  `progress` varchar(45) NOT NULL,
  `order_by` VARCHAR(5) NULL DEFAULT NULL COLLATE 'utf8_bin',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`cid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `ss13_research_data` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `points` varchar(45) NOT NULL,
  `round_id` varchar(45) NOT NULL,
  `daysuntilreset` varchar(45) NOT NULL,
  `order_by` VARCHAR(5) NULL DEFAULT NULL COLLATE 'utf8_bin',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `ss13_research_items` (
  `cid` varchar(45) NOT NULL,
  `unlocked` varchar(45) NOT NULL,
  `order_by` VARCHAR(5) NULL DEFAULT NULL COLLATE 'utf8_bin',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`cid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
