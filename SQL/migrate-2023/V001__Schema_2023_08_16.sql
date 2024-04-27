-- --------------------------------------------------------
-- Server version:               10.4.30-MariaDB-1:10.4.30+maria~ubu1804-log - mariadb.org binary distribution
-- Server OS:                    debian-linux-gnu
-- HeidiSQL Version:             12.3.0.6589
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping structure for table schema_version
CREATE TABLE IF NOT EXISTS `schema_version` (
  `installed_rank` int(11) NOT NULL,
  `version` varchar(50) DEFAULT NULL,
  `description` varchar(200) NOT NULL,
  `type` varchar(20) NOT NULL,
  `script` varchar(1000) NOT NULL,
  `checksum` int(11) DEFAULT NULL,
  `installed_by` varchar(100) NOT NULL,
  `installed_on` timestamp NOT NULL DEFAULT current_timestamp(),
  `execution_time` int(11) NOT NULL,
  `success` tinyint(1) NOT NULL,
  PRIMARY KEY (`installed_rank`),
  KEY `schema_version_s_idx` (`success`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_admins
CREATE TABLE IF NOT EXISTS `ss13_admins` (
  `ckey` varchar(50) NOT NULL,
  `rank` text NOT NULL,
  `flags` int(11) NOT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`ckey`),
  CONSTRAINT `FK_ss13_admins_ss13_player_ckey` FOREIGN KEY (`ckey`) REFERENCES `ss13_player` (`ckey`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_antag_log
CREATE TABLE IF NOT EXISTS `ss13_antag_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ckey` varchar(32) NOT NULL,
  `char_id` int(11) DEFAULT NULL,
  `game_id` varchar(50) NOT NULL,
  `char_name` varchar(50) DEFAULT NULL,
  `datetime` datetime NOT NULL DEFAULT current_timestamp(),
  `special_role_name` varchar(50) NOT NULL,
  `special_role_added` time NOT NULL,
  `special_role_removed` time DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_ss13_antag_log_ss13_characters` (`char_id`),
  KEY `FK_ss13_antag_log_ss13_player` (`ckey`),
  CONSTRAINT `FK_ss13_antag_log_ss13_characters` FOREIGN KEY (`char_id`) REFERENCES `ss13_characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_ss13_antag_log_ss13_player` FOREIGN KEY (`ckey`) REFERENCES `ss13_player` (`ckey`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_api_commands
CREATE TABLE IF NOT EXISTS `ss13_api_commands` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `command` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQUE command` (`command`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_api_tokens
CREATE TABLE IF NOT EXISTS `ss13_api_tokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `token` varchar(100) NOT NULL,
  `ip` varchar(16) DEFAULT NULL,
  `creator` varchar(50) NOT NULL,
  `description` varchar(100) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_api_token_command
CREATE TABLE IF NOT EXISTS `ss13_api_token_command` (
  `command_id` int(11) NOT NULL,
  `token_id` int(11) NOT NULL,
  PRIMARY KEY (`command_id`,`token_id`),
  KEY `token_id` (`token_id`),
  CONSTRAINT `function_id` FOREIGN KEY (`command_id`) REFERENCES `ss13_api_commands` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `token_id` FOREIGN KEY (`token_id`) REFERENCES `ss13_api_tokens` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_ban
CREATE TABLE IF NOT EXISTS `ss13_ban` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `bantime` datetime NOT NULL,
  `serverip` varchar(32) NOT NULL,
  `game_id` varchar(32) DEFAULT NULL,
  `bantype` varchar(32) NOT NULL,
  `reason` mediumtext NOT NULL,
  `job` varchar(32) DEFAULT NULL,
  `duration` int(11) NOT NULL,
  `rounds` int(11) DEFAULT NULL,
  `expiration_time` datetime NOT NULL,
  `ckey` varchar(32) NOT NULL,
  `computerid` varchar(32) NOT NULL,
  `ip` varchar(32) NOT NULL,
  `a_ckey` varchar(32) NOT NULL,
  `a_computerid` varchar(32) NOT NULL,
  `a_ip` varchar(32) NOT NULL,
  `who` mediumtext NOT NULL,
  `adminwho` mediumtext NOT NULL,
  `edits` mediumtext DEFAULT NULL,
  `unbanned` tinyint(1) DEFAULT NULL,
  `unbanned_datetime` datetime DEFAULT NULL,
  `unbanned_reason` mediumtext DEFAULT NULL,
  `unbanned_ckey` varchar(32) DEFAULT NULL,
  `unbanned_computerid` varchar(32) DEFAULT NULL,
  `unbanned_ip` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_ban_isbanned` (`unbanned`,`bantype`,`expiration_time`,`ckey`,`computerid`,`ip`),
  KEY `FK_ss13_ban_ss13_player_ckey` (`ckey`),
  KEY `FK_ss13_ban_ss13_player_a_ckey` (`a_ckey`),
  CONSTRAINT `FK_ss13_ban_ss13_player_a_ckey` FOREIGN KEY (`a_ckey`) REFERENCES `ss13_player` (`ckey`) ON UPDATE CASCADE,
  CONSTRAINT `FK_ss13_ban_ss13_player_ckey` FOREIGN KEY (`ckey`) REFERENCES `ss13_player` (`ckey`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_ban_mirrors
CREATE TABLE IF NOT EXISTS `ss13_ban_mirrors` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ban_id` int(10) unsigned NOT NULL,
  `ckey` varchar(32) NOT NULL,
  `ip` varchar(32) NOT NULL,
  `computerid` varchar(32) NOT NULL,
  `datetime` datetime NOT NULL,
  `source` enum('legacy','conninfo','isbanned') NOT NULL,
  `extra_info` mediumtext DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_mirrors_isbanned` (`deleted_at`,`ckey`,`ip`,`computerid`),
  KEY `idx_mirrors_select` (`deleted_at`,`ban_id`),
  KEY `FK_ss13_ban_mirrors_ss13_ban` (`ban_id`),
  CONSTRAINT `FK_ss13_ban_mirrors_ss13_ban` FOREIGN KEY (`ban_id`) REFERENCES `ss13_ban` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_cargo_categories
CREATE TABLE IF NOT EXISTS `ss13_cargo_categories` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `display_name` varchar(100) NOT NULL,
  `description` varchar(300) NOT NULL,
  `icon` varchar(50) NOT NULL,
  `price_modifier` float unsigned NOT NULL DEFAULT 1,
  `order_by` varchar(5) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_cargo_items
CREATE TABLE IF NOT EXISTS `ss13_cargo_items` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `supplier` varchar(50) NOT NULL DEFAULT 'nt',
  `description` varchar(300) DEFAULT NULL,
  `categories` longtext NOT NULL,
  `price` int(11) NOT NULL,
  `items` longtext DEFAULT NULL,
  `item_mul` int(10) unsigned NOT NULL DEFAULT 1,
  `access` int(10) unsigned NOT NULL DEFAULT 0,
  `container_type` varchar(50) NOT NULL DEFAULT 'crate',
  `groupable` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `order_by` varchar(5) DEFAULT NULL,
  `error_message` text DEFAULT NULL,
  `created_by` varchar(50) DEFAULT NULL,
  `approved_by` varchar(50) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `approved_at` datetime DEFAULT NULL,
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_supplier` (`name`,`supplier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_cargo_orderlog
CREATE TABLE IF NOT EXISTS `ss13_cargo_orderlog` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `game_id` varchar(50) NOT NULL DEFAULT '',
  `order_id` int(11) NOT NULL,
  `status` varchar(50) NOT NULL DEFAULT '',
  `price` int(11) NOT NULL DEFAULT 0,
  `ordered_by_id` int(11) DEFAULT NULL,
  `ordered_by` varchar(128) DEFAULT NULL,
  `authorized_by_id` int(11) DEFAULT NULL,
  `authorized_by` varchar(128) DEFAULT NULL,
  `received_by_id` int(11) DEFAULT NULL,
  `received_by` varchar(128) DEFAULT NULL,
  `paid_by_id` int(11) DEFAULT NULL,
  `paid_by` varchar(128) DEFAULT NULL,
  `time_submitted` time DEFAULT NULL,
  `time_approved` time DEFAULT NULL,
  `time_shipped` time DEFAULT NULL,
  `time_delivered` time DEFAULT NULL,
  `time_paid` time DEFAULT NULL,
  `reason` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_cargo_orderlog_items
CREATE TABLE IF NOT EXISTS `ss13_cargo_orderlog_items` (
  `cargo_orderlog_id` int(11) unsigned NOT NULL,
  `cargo_item_id` int(11) unsigned NOT NULL,
  `amount` int(11) NOT NULL,
  PRIMARY KEY (`cargo_orderlog_id`,`cargo_item_id`) USING BTREE,
  KEY `index_orderlog_id` (`cargo_orderlog_id`) USING BTREE,
  KEY `index_item_id` (`cargo_item_id`) USING BTREE,
  CONSTRAINT `FK_ss13_cargo_orderlog_items_ss13_cargo_items` FOREIGN KEY (`cargo_item_id`) REFERENCES `ss13_cargo_items` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_ss13_cargo_orderlog_items_ss13_cargo_orderlog` FOREIGN KEY (`cargo_orderlog_id`) REFERENCES `ss13_cargo_orderlog` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_cargo_suppliers
CREATE TABLE IF NOT EXISTS `ss13_cargo_suppliers` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `short_name` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` varchar(300) NOT NULL,
  `tag_line` varchar(300) NOT NULL,
  `shuttle_time` int(11) unsigned NOT NULL,
  `shuttle_price` int(11) unsigned NOT NULL,
  `available` tinyint(4) unsigned NOT NULL DEFAULT 1,
  `price_modifier` float unsigned NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Schlüssel 2` (`short_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_ccia_actions
CREATE TABLE IF NOT EXISTS `ss13_ccia_actions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` mediumtext NOT NULL,
  `type` enum('injunction','suspension','reprimand','demotion','other') NOT NULL,
  `issuedby` varchar(255) NOT NULL,
  `details` mediumtext NOT NULL,
  `url` varchar(255) NOT NULL,
  `expires_at` date DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_ccia_action_char
CREATE TABLE IF NOT EXISTS `ss13_ccia_action_char` (
  `action_id` int(10) unsigned NOT NULL,
  `char_id` int(11) NOT NULL,
  PRIMARY KEY (`action_id`,`char_id`),
  KEY `ccia_action_char_char_id_foreign` (`char_id`),
  CONSTRAINT `ccia_action_char_action_id_foreign` FOREIGN KEY (`action_id`) REFERENCES `ss13_ccia_actions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ccia_action_char_char_id_foreign` FOREIGN KEY (`char_id`) REFERENCES `ss13_characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_ccia_general_notice_list
CREATE TABLE IF NOT EXISTS `ss13_ccia_general_notice_list` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `message` mediumtext NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `automatic` tinyint(4) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_ccia_reports
CREATE TABLE IF NOT EXISTS `ss13_ccia_reports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `report_date` date NOT NULL,
  `title` varchar(200) NOT NULL,
  `public_topic` varchar(200) DEFAULT NULL,
  `internal_topic` varchar(200) DEFAULT NULL,
  `game_id` varchar(20) DEFAULT NULL,
  `status` enum('new','in progress','review required','approved','rejected','completed') NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_ccia_reports_transcripts
CREATE TABLE IF NOT EXISTS `ss13_ccia_reports_transcripts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `report_id` int(11) NOT NULL,
  `character_id` int(11) NOT NULL,
  `interviewer` varchar(100) NOT NULL,
  `antag_involvement` tinyint(4) NOT NULL DEFAULT 0,
  `antag_involvement_text` longtext DEFAULT NULL,
  `text` longtext DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `report_id` (`report_id`),
  KEY `character_id` (`character_id`),
  CONSTRAINT `FK_ss13_ccia_reports_transcripts_ss13_characters` FOREIGN KEY (`character_id`) REFERENCES `ss13_characters` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `report_id` FOREIGN KEY (`report_id`) REFERENCES `ss13_ccia_reports` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_characters
CREATE TABLE IF NOT EXISTS `ss13_characters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ckey` varchar(32) NOT NULL,
  `name` varchar(128) DEFAULT NULL,
  `metadata` varchar(512) DEFAULT NULL,
  `be_special_role` mediumtext DEFAULT NULL,
  `gender` varchar(32) DEFAULT NULL,
  `pronouns` varchar(12) DEFAULT NULL,
  `floating_chat_color` char(7) DEFAULT NULL,
  `speech_bubble_type` varchar(16) DEFAULT NULL,
  `primary_radio_slot` char(9) DEFAULT 'Left Ear',
  `age` int(11) DEFAULT NULL,
  `species` varchar(32) DEFAULT NULL,
  `height` int(3) NOT NULL DEFAULT 0,
  `language` varchar(50) DEFAULT NULL,
  `hair_colour` varchar(7) DEFAULT NULL,
  `facial_colour` varchar(7) DEFAULT NULL,
  `grad_colour` varchar(7) DEFAULT NULL,
  `skin_tone` int(11) DEFAULT NULL,
  `skin_colour` varchar(7) DEFAULT NULL,
  `tail_style` varchar(20) DEFAULT NULL,
  `hair_style` varchar(32) DEFAULT NULL,
  `facial_style` varchar(32) DEFAULT NULL,
  `gradient_style` varchar(32) DEFAULT NULL,
  `eyes_colour` varchar(7) DEFAULT NULL,
  `all_underwear` longtext DEFAULT NULL CHECK (json_valid(`all_underwear`)),
  `all_underwear_metadata` longtext DEFAULT NULL CHECK (json_valid(`all_underwear_metadata`)),
  `backbag` int(11) DEFAULT NULL,
  `backbag_style` int(11) DEFAULT NULL,
  `backbag_color` int(11) DEFAULT NULL,
  `backbag_strap` int(11) DEFAULT NULL,
  `pda_choice` int(11) DEFAULT NULL,
  `headset_choice` tinyint(4) DEFAULT NULL,
  `b_type` varchar(32) DEFAULT NULL,
  `spawnpoint` varchar(32) DEFAULT NULL,
  `jobs` mediumtext DEFAULT NULL,
  `alternate_option` tinyint(1) DEFAULT NULL,
  `alternate_titles` mediumtext DEFAULT NULL,
  `disabilities` mediumtext DEFAULT NULL,
  `home_system` mediumtext DEFAULT NULL,
  `citizenship` mediumtext DEFAULT NULL,
  `faction` mediumtext DEFAULT NULL,
  `religion` mediumtext DEFAULT NULL,
  `economic_status` enum('Wealthy','Well-off','Average','Underpaid','Poor','Impoverished') DEFAULT NULL,
  `culture` varchar(128) DEFAULT NULL,
  `origin` varchar(128) DEFAULT NULL,
  `psionics` longtext DEFAULT NULL,
  `accent` varchar(50) DEFAULT NULL,
  `autohiss` tinyint(4) NOT NULL DEFAULT 0,
  `bgstate` varchar(20) DEFAULT NULL,
  `uplink_location` mediumtext DEFAULT NULL,
  `organs_data` mediumtext DEFAULT NULL,
  `organs_robotic` mediumtext DEFAULT NULL,
  `body_markings` mediumtext DEFAULT NULL,
  `gear` mediumtext DEFAULT NULL,
  `gear_slot` tinyint(4) DEFAULT NULL,
  `deleted_by` enum('player','staff') DEFAULT NULL,
  `deleted_reason` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ss13_characters_ckey` (`ckey`),
  KEY `ss13_characteres_name` (`name`),
  CONSTRAINT `ss13_characters_fk_ckey` FOREIGN KEY (`ckey`) REFERENCES `ss13_player` (`ckey`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_characters_custom_items
CREATE TABLE IF NOT EXISTS `ss13_characters_custom_items` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `char_id` int(11) NOT NULL,
  `item_path` varchar(255) NOT NULL,
  `item_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `req_titles` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `additional_data` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `FK_ss13_characters_custom_items_ss13_characters` (`char_id`) USING BTREE,
  CONSTRAINT `FK_ss13_characters_custom_items_ss13_characters` FOREIGN KEY (`char_id`) REFERENCES `ss13_characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_characters_flavour
CREATE TABLE IF NOT EXISTS `ss13_characters_flavour` (
  `char_id` int(11) NOT NULL,
  `signature` text DEFAULT NULL,
  `signature_font` text DEFAULT NULL,
  `records_employment` mediumtext DEFAULT NULL,
  `records_medical` mediumtext DEFAULT NULL,
  `records_security` mediumtext DEFAULT NULL,
  `records_exploit` mediumtext DEFAULT NULL,
  `records_ccia` mediumtext DEFAULT NULL,
  `flavour_general` mediumtext DEFAULT NULL,
  `flavour_head` mediumtext DEFAULT NULL,
  `flavour_face` mediumtext DEFAULT NULL,
  `flavour_eyes` mediumtext DEFAULT NULL,
  `flavour_torso` mediumtext DEFAULT NULL,
  `flavour_arms` mediumtext DEFAULT NULL,
  `flavour_hands` mediumtext DEFAULT NULL,
  `flavour_legs` mediumtext DEFAULT NULL,
  `flavour_feet` mediumtext DEFAULT NULL,
  `robot_default` mediumtext DEFAULT NULL,
  `robot_standard` mediumtext DEFAULT NULL,
  `robot_engineering` mediumtext DEFAULT NULL,
  `robot_construction` mediumtext DEFAULT NULL,
  `robot_medical` mediumtext DEFAULT NULL,
  `robot_rescue` mediumtext DEFAULT NULL,
  `robot_mining` mediumtext DEFAULT NULL,
  `robot_custodial` mediumtext DEFAULT NULL,
  `robot_service` mediumtext DEFAULT NULL,
  `robot_clerical` mediumtext DEFAULT NULL,
  `robot_security` mediumtext DEFAULT NULL,
  `robot_research` mediumtext DEFAULT NULL,
  PRIMARY KEY (`char_id`),
  CONSTRAINT `ss13_flavour_fk_char_id` FOREIGN KEY (`char_id`) REFERENCES `ss13_characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;



-- Dumping structure for table ss13_characters_ipc_tags
CREATE TABLE IF NOT EXISTS `ss13_characters_ipc_tags` (
  `char_id` int(11) NOT NULL,
  `tag_status` tinyint(1) NOT NULL DEFAULT 0,
  `serial_number` varchar(12) DEFAULT NULL,
  `ownership_status` enum('Self Owned','Company Owned','Privately Owned') DEFAULT 'Company Owned',
  PRIMARY KEY (`char_id`),
  CONSTRAINT `char_id` FOREIGN KEY (`char_id`) REFERENCES `ss13_characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_characters_log
CREATE TABLE IF NOT EXISTS `ss13_characters_log` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `char_id` int(11) NOT NULL,
  `game_id` varchar(50) NOT NULL,
  `datetime` datetime NOT NULL DEFAULT current_timestamp(),
  `job_name` varchar(32) DEFAULT NULL,
  `alt_title` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ss13_charlog_fk_char_id` (`char_id`),
  CONSTRAINT `ss13_charlog_fk_char_id` FOREIGN KEY (`char_id`) REFERENCES `ss13_characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_character_incidents
CREATE TABLE IF NOT EXISTS `ss13_character_incidents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `char_id` int(11) NOT NULL,
  `UID` varchar(32) NOT NULL,
  `datetime` varchar(50) NOT NULL,
  `notes` mediumtext NOT NULL,
  `charges` mediumtext NOT NULL,
  `evidence` mediumtext NOT NULL,
  `arbiters` mediumtext NOT NULL,
  `brig_sentence` int(11) NOT NULL DEFAULT 0,
  `fine` int(11) NOT NULL DEFAULT 0,
  `felony` int(11) NOT NULL DEFAULT 0,
  `created_by` varchar(50) DEFAULT NULL,
  `deleted_by` varchar(50) DEFAULT NULL,
  `game_id` varchar(50) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UID_char_id` (`char_id`,`UID`),
  CONSTRAINT `FK_ss13_character_incidents_ss13_characters` FOREIGN KEY (`char_id`) REFERENCES `ss13_characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_connection_log
CREATE TABLE IF NOT EXISTS `ss13_connection_log` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ckey` varchar(32) NOT NULL,
  `datetime` datetime NOT NULL,
  `serverip` varchar(32) NOT NULL,
  `ip` varchar(18) NOT NULL,
  `computerid` varchar(32) NOT NULL,
  `byond_version` int(10) DEFAULT NULL,
  `byond_build` int(10) DEFAULT NULL,
  `game_id` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_customsynths
CREATE TABLE IF NOT EXISTS `ss13_customsynths` (
  `synthname` varchar(128) NOT NULL,
  `synthckey` varchar(32) NOT NULL,
  `synthicon` varchar(26) NOT NULL,
  `aichassisicon` varchar(100) NOT NULL,
  `aiholoicon` varchar(100) NOT NULL,
  `paiicon` varchar(100) NOT NULL,
  PRIMARY KEY (`synthname`),
  KEY `fk_ss13_custom_synths_ss13_players` (`synthckey`),
  CONSTRAINT `fk_ss13_custom_synths_ss13_players` FOREIGN KEY (`synthckey`) REFERENCES `ss13_player` (`ckey`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_death
CREATE TABLE IF NOT EXISTS `ss13_death` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pod` varchar(255) DEFAULT NULL COMMENT 'Place of death',
  `coord` varchar(255) DEFAULT NULL COMMENT 'X, Y, Z POD',
  `tod` datetime NOT NULL COMMENT 'Time of death',
  `job` varchar(255) DEFAULT NULL,
  `special` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `ckey` varchar(32) DEFAULT NULL,
  `char_id` int(11) DEFAULT NULL,
  `laname` varchar(255) DEFAULT NULL COMMENT 'Last attacker name',
  `lackey` varchar(32) DEFAULT NULL COMMENT 'Last attacker key',
  `gender` varchar(255) DEFAULT NULL,
  `bruteloss` int(11) NOT NULL,
  `brainloss` int(11) NOT NULL,
  `fireloss` int(11) NOT NULL,
  `oxyloss` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_ss13_death_ss13_player` (`ckey`),
  KEY `FK_ss13_death_ss13_player_lackey` (`lackey`),
  KEY `FK_ss13_death_ss13_characters` (`char_id`),
  CONSTRAINT `FK_ss13_death_ss13_characters` FOREIGN KEY (`char_id`) REFERENCES `ss13_characters` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `FK_ss13_death_ss13_player` FOREIGN KEY (`ckey`) REFERENCES `ss13_player` (`ckey`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_ss13_death_ss13_player_lackey` FOREIGN KEY (`lackey`) REFERENCES `ss13_player` (`ckey`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_documents
CREATE TABLE IF NOT EXISTS `ss13_documents` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `title` varchar(26) NOT NULL,
  `chance` float unsigned NOT NULL DEFAULT 1,
  `content` varchar(3072) NOT NULL,
  `tags` longtext NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_feedback
CREATE TABLE IF NOT EXISTS `ss13_feedback` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `time` datetime NOT NULL,
  `game_id` varchar(32) NOT NULL,
  `var_name` varchar(32) NOT NULL,
  `var_value` int(16) DEFAULT NULL,
  `details` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_forms
CREATE TABLE IF NOT EXISTS `ss13_forms` (
  `form_id` int(11) NOT NULL AUTO_INCREMENT,
  `id` varchar(4) NOT NULL,
  `name` varchar(50) NOT NULL,
  `department` varchar(32) NOT NULL,
  `data` mediumtext NOT NULL,
  `info` mediumtext DEFAULT NULL,
  PRIMARY KEY (`form_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_ipintel
CREATE TABLE IF NOT EXISTS `ss13_ipintel` (
  `ip` varbinary(16) NOT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `intel` double NOT NULL DEFAULT 0,
  PRIMARY KEY (`ip`),
  KEY `idx_ipintel` (`ip`,`intel`,`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_law
CREATE TABLE IF NOT EXISTS `ss13_law` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `law_id` varchar(4) NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` varchar(500) NOT NULL,
  `min_fine` int(10) unsigned NOT NULL DEFAULT 0,
  `max_fine` int(10) unsigned NOT NULL DEFAULT 0,
  `min_brig_time` int(10) unsigned NOT NULL DEFAULT 0,
  `max_brig_time` int(10) unsigned NOT NULL DEFAULT 0,
  `severity` int(10) unsigned DEFAULT 0,
  `felony` int(10) unsigned NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQUE LAW` (`law_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_library
CREATE TABLE IF NOT EXISTS `ss13_library` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `author` mediumtext NOT NULL,
  `title` mediumtext NOT NULL,
  `content` mediumtext NOT NULL,
  `category` mediumtext NOT NULL,
  `uploadtime` datetime NOT NULL,
  `uploader` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_ss13_library_ss13_player` (`uploader`),
  CONSTRAINT `FK_ss13_library_ss13_player` FOREIGN KEY (`uploader`) REFERENCES `ss13_player` (`ckey`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_notes
CREATE TABLE IF NOT EXISTS `ss13_notes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `adddate` datetime NOT NULL,
  `game_id` varchar(50) DEFAULT NULL,
  `ckey` varchar(32) NOT NULL,
  `ip` varchar(18) DEFAULT NULL,
  `computerid` varchar(32) DEFAULT NULL,
  `a_ckey` varchar(32) NOT NULL,
  `content` mediumtext NOT NULL,
  `visible` tinyint(1) NOT NULL DEFAULT 1,
  `edited` tinyint(1) NOT NULL DEFAULT 0,
  `lasteditor` varchar(32) DEFAULT NULL,
  `lasteditdate` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_ss13_notes_ss13_player_ckey` (`ckey`),
  KEY `FK_ss13_notes_ss13_player_a_ckey` (`a_ckey`),
  CONSTRAINT `FK_ss13_notes_ss13_player_a_ckey` FOREIGN KEY (`a_ckey`) REFERENCES `ss13_player` (`ckey`) ON UPDATE CASCADE,
  CONSTRAINT `FK_ss13_notes_ss13_player_ckey` FOREIGN KEY (`ckey`) REFERENCES `ss13_player` (`ckey`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_player
CREATE TABLE IF NOT EXISTS `ss13_player` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ckey` varchar(32) NOT NULL,
  `firstseen` datetime NOT NULL,
  `lastseen` datetime NOT NULL,
  `ip` varchar(18) DEFAULT NULL,
  `computerid` varchar(32) DEFAULT NULL,
  `byond_version` int(10) DEFAULT NULL,
  `byond_build` int(10) DEFAULT NULL,
  `lastadminrank` varchar(32) NOT NULL DEFAULT 'Player',
  `whitelist_status` int(11) unsigned NOT NULL DEFAULT 0,
  `account_join_date` date DEFAULT NULL,
  `migration_status` tinyint(1) DEFAULT 0,
  `discord_id` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ckey` (`ckey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_player_linking
CREATE TABLE IF NOT EXISTS `ss13_player_linking` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `forum_id` int(11) NOT NULL,
  `forum_username_short` varchar(255) NOT NULL,
  `forum_username` varchar(255) NOT NULL,
  `player_ckey` varchar(255) NOT NULL,
  `status` enum('new','confirmed','rejected','linked') NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_ss13_player_linking_ss13_player` (`player_ckey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_player_notifications
CREATE TABLE IF NOT EXISTS `ss13_player_notifications` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ckey` varchar(50) NOT NULL,
  `type` enum('player_greeting','player_greeting_chat','admin','ccia') NOT NULL,
  `message` mediumtext NOT NULL,
  `created_by` varchar(50) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `acked_by` varchar(50) DEFAULT NULL,
  `acked_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_ss13_player_notifications_ss13_player` (`ckey`),
  KEY `FK_ss13_player_notifications_ss13_player_2` (`created_by`),
  CONSTRAINT `FK_ss13_player_notifications_ss13_player` FOREIGN KEY (`ckey`) REFERENCES `ss13_player` (`ckey`) ON UPDATE CASCADE,
  CONSTRAINT `FK_ss13_player_notifications_ss13_player_2` FOREIGN KEY (`created_by`) REFERENCES `ss13_player` (`ckey`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_player_pai
CREATE TABLE IF NOT EXISTS `ss13_player_pai` (
  `ckey` varchar(32) NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `description` mediumtext DEFAULT NULL,
  `role` mediumtext DEFAULT NULL,
  `comments` mediumtext DEFAULT NULL,
  PRIMARY KEY (`ckey`),
  CONSTRAINT `player_pai_fk_ckey` FOREIGN KEY (`ckey`) REFERENCES `ss13_player` (`ckey`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_player_preferences
CREATE TABLE IF NOT EXISTS `ss13_player_preferences` (
  `ckey` varchar(32) NOT NULL,
  `ooccolor` mediumtext DEFAULT NULL,
  `clientfps` int(11) DEFAULT 0,
  `lastchangelog` mediumtext DEFAULT NULL,
  `UI_style` mediumtext DEFAULT NULL,
  `current_character` int(11) DEFAULT 0,
  `toggles` int(11) DEFAULT 0,
  `UI_style_color` mediumtext DEFAULT NULL,
  `UI_style_alpha` int(11) DEFAULT 255,
  `sfx_toggles` int(11) DEFAULT 0,
  `lastmotd` mediumtext DEFAULT NULL,
  `lastmemo` mediumtext DEFAULT NULL,
  `language_prefixes` mediumtext DEFAULT NULL,
  `toggles_secondary` int(11) DEFAULT NULL,
  `parallax_speed` int(11) DEFAULT NULL,
  `tgui_fancy` int(1) NOT NULL DEFAULT 1,
  `tgui_lock` int(1) NOT NULL DEFAULT 0,
  `skin_theme` varchar(32) DEFAULT 'Light',
  `tooltip_style` enum('Midnight','Plasmafire','Retro','Slimecore','Operative','Clockwork') DEFAULT 'Midnight',
  PRIMARY KEY (`ckey`),
  CONSTRAINT `player_preferences_fk_ckey` FOREIGN KEY (`ckey`) REFERENCES `ss13_player` (`ckey`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_poll_option
CREATE TABLE IF NOT EXISTS `ss13_poll_option` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pollid` int(11) NOT NULL,
  `text` varchar(255) NOT NULL,
  `percentagecalc` tinyint(1) NOT NULL DEFAULT 1,
  `minval` int(3) DEFAULT NULL,
  `maxval` int(3) DEFAULT NULL,
  `descmin` varchar(32) DEFAULT NULL,
  `descmid` varchar(32) DEFAULT NULL,
  `descmax` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_ss13_poll_option_ss13_poll_question` (`pollid`),
  CONSTRAINT `FK_ss13_poll_option_ss13_poll_question` FOREIGN KEY (`pollid`) REFERENCES `ss13_poll_question` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_poll_question
CREATE TABLE IF NOT EXISTS `ss13_poll_question` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `polltype` varchar(16) NOT NULL DEFAULT 'OPTION',
  `starttime` datetime NOT NULL,
  `endtime` datetime NOT NULL,
  `question` varchar(255) NOT NULL,
  `multiplechoiceoptions` int(11) DEFAULT NULL,
  `adminonly` tinyint(1) DEFAULT 0,
  `publicresult` tinyint(1) NOT NULL DEFAULT 0,
  `viewtoken` varchar(50) DEFAULT NULL,
  `createdby_ckey` varchar(50) DEFAULT NULL,
  `createdby_ip` varchar(50) DEFAULT NULL,
  `link` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_poll_textreply
CREATE TABLE IF NOT EXISTS `ss13_poll_textreply` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `datetime` datetime NOT NULL,
  `pollid` int(11) NOT NULL,
  `ckey` varchar(32) NOT NULL,
  `ip` varchar(18) NOT NULL,
  `replytext` mediumtext NOT NULL,
  `adminrank` varchar(32) NOT NULL DEFAULT 'Player',
  PRIMARY KEY (`id`),
  KEY `FK_ss13_poll_textreply_ss13_player` (`ckey`),
  KEY `FK_ss13_poll_textreply_ss13_poll_question` (`pollid`),
  CONSTRAINT `FK_ss13_poll_textreply_ss13_player` FOREIGN KEY (`ckey`) REFERENCES `ss13_player` (`ckey`) ON UPDATE CASCADE,
  CONSTRAINT `FK_ss13_poll_textreply_ss13_poll_question` FOREIGN KEY (`pollid`) REFERENCES `ss13_poll_question` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_poll_vote
CREATE TABLE IF NOT EXISTS `ss13_poll_vote` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `datetime` datetime NOT NULL,
  `pollid` int(11) NOT NULL,
  `optionid` int(11) NOT NULL,
  `ckey` varchar(255) NOT NULL,
  `ip` varchar(16) NOT NULL,
  `adminrank` varchar(32) NOT NULL,
  `rating` int(2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_ss13_poll_vote_ss13_player` (`ckey`),
  KEY `FK_ss13_poll_vote_ss13_poll_question` (`pollid`),
  KEY `FK_ss13_poll_vote_ss13_poll_option` (`optionid`),
  CONSTRAINT `FK_ss13_poll_vote_ss13_player` FOREIGN KEY (`ckey`) REFERENCES `ss13_player` (`ckey`) ON UPDATE CASCADE,
  CONSTRAINT `FK_ss13_poll_vote_ss13_poll_option` FOREIGN KEY (`optionid`) REFERENCES `ss13_poll_option` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_ss13_poll_vote_ss13_poll_question` FOREIGN KEY (`pollid`) REFERENCES `ss13_poll_question` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_population
CREATE TABLE IF NOT EXISTS `ss13_population` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `playercount` int(11) DEFAULT NULL,
  `admincount` int(11) DEFAULT NULL,
  `time` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_stickyban
CREATE TABLE IF NOT EXISTS `ss13_stickyban` (
  `ckey` varchar(32) NOT NULL,
  `reason` varchar(2048) NOT NULL,
  `banning_admin` varchar(32) NOT NULL,
  `datetime` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`ckey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_stickyban_matched_cid
CREATE TABLE IF NOT EXISTS `ss13_stickyban_matched_cid` (
  `stickyban` varchar(32) NOT NULL,
  `matched_cid` varchar(32) NOT NULL,
  `first_matched` datetime NOT NULL DEFAULT current_timestamp(),
  `last_matched` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`stickyban`,`matched_cid`),
  CONSTRAINT `FK_ss13_stickyban_matched_cid_ss13_stickyban` FOREIGN KEY (`stickyban`) REFERENCES `ss13_stickyban` (`ckey`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_stickyban_matched_ckey
CREATE TABLE IF NOT EXISTS `ss13_stickyban_matched_ckey` (
  `stickyban` varchar(32) NOT NULL,
  `matched_ckey` varchar(32) NOT NULL,
  `first_matched` datetime NOT NULL DEFAULT current_timestamp(),
  `last_matched` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `exempt` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`stickyban`,`matched_ckey`),
  CONSTRAINT `FK_ss13_stickyban_matched_ckey_ss13_stickyban` FOREIGN KEY (`stickyban`) REFERENCES `ss13_stickyban` (`ckey`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_stickyban_matched_ip
CREATE TABLE IF NOT EXISTS `ss13_stickyban_matched_ip` (
  `stickyban` varchar(32) NOT NULL,
  `matched_ip` int(10) unsigned NOT NULL,
  `first_matched` datetime NOT NULL DEFAULT current_timestamp(),
  `last_matched` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`stickyban`,`matched_ip`),
  CONSTRAINT `FK_ss13_stickyban_matched_ip_ss13_stickyban` FOREIGN KEY (`stickyban`) REFERENCES `ss13_stickyban` (`ckey`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_syndie_contracts
CREATE TABLE IF NOT EXISTS `ss13_syndie_contracts` (
  `contract_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `contractee_id` int(11) NOT NULL,
  `contractee_name` varchar(255) NOT NULL,
  `status` enum('new','open','mod-nok','completed','closed','reopened','canceled') NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` mediumtext NOT NULL,
  `reward_credits` int(11) DEFAULT NULL,
  `reward_other` mediumtext DEFAULT NULL,
  `completer_id` int(11) DEFAULT NULL,
  `completer_name` mediumtext DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`contract_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_syndie_contracts_comments
CREATE TABLE IF NOT EXISTS `ss13_syndie_contracts_comments` (
  `comment_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `contract_id` int(11) unsigned NOT NULL,
  `commentor_id` int(11) unsigned NOT NULL,
  `commentor_name` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `comment` mediumtext NOT NULL,
  `image_name` varchar(255) NOT NULL,
  `type` enum('mod-author','mod-ooc','ic','ic-comprep','ic-failrep','ic-cancel','ooc') NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `report_status` enum('waiting-approval','accepted','rejected') DEFAULT NULL,
  PRIMARY KEY (`comment_id`),
  KEY `contract_id` (`contract_id`),
  CONSTRAINT `contract_id` FOREIGN KEY (`contract_id`) REFERENCES `ss13_syndie_contracts` (`contract_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_syndie_contracts_comments_completers
CREATE TABLE IF NOT EXISTS `ss13_syndie_contracts_comments_completers` (
  `user_id` int(11) NOT NULL,
  `comment_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`user_id`,`comment_id`),
  KEY `comment_id` (`comment_id`),
  CONSTRAINT `comment_id` FOREIGN KEY (`comment_id`) REFERENCES `ss13_syndie_contracts_comments` (`comment_id`) ON DELETE CASCADE,
  CONSTRAINT `user_id` FOREIGN KEY (`user_id`) REFERENCES `ss13_player` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_syndie_contracts_comments_objectives
CREATE TABLE IF NOT EXISTS `ss13_syndie_contracts_comments_objectives` (
  `objective_id` int(10) unsigned NOT NULL,
  `comment_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`objective_id`,`comment_id`),
  KEY `comments_comment_id` (`comment_id`),
  CONSTRAINT `comments_comment_id` FOREIGN KEY (`comment_id`) REFERENCES `ss13_syndie_contracts_comments` (`comment_id`) ON DELETE CASCADE,
  CONSTRAINT `objectives_objective_id` FOREIGN KEY (`objective_id`) REFERENCES `ss13_syndie_contracts_objectives` (`objective_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_syndie_contracts_objectives
CREATE TABLE IF NOT EXISTS `ss13_syndie_contracts_objectives` (
  `objective_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `contract_id` int(11) NOT NULL,
  `status` enum('open','closed','deleted') NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` mediumtext NOT NULL,
  `reward_credits` int(11) DEFAULT NULL,
  `reward_credits_update` int(11) DEFAULT NULL,
  `reward_other` mediumtext DEFAULT NULL,
  `reward_other_update` mediumtext DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`objective_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_syndie_contracts_subscribers
CREATE TABLE IF NOT EXISTS `ss13_syndie_contracts_subscribers` (
  `contract_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`contract_id`,`user_id`),
  CONSTRAINT `syndie_contracts_subscribers_contract_id_foreign` FOREIGN KEY (`contract_id`) REFERENCES `ss13_syndie_contracts` (`contract_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_tickets
CREATE TABLE IF NOT EXISTS `ss13_tickets` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `game_id` varchar(32) NOT NULL,
  `message_count` int(11) NOT NULL,
  `admin_count` int(11) NOT NULL,
  `admin_list` mediumtext NOT NULL,
  `opened_by` varchar(32) NOT NULL,
  `taken_by` varchar(32) DEFAULT NULL,
  `closed_by` varchar(32) NOT NULL,
  `response_delay` int(11) NOT NULL,
  `opened_at` datetime NOT NULL,
  `closed_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tickets_fk_opened` (`opened_by`),
  KEY `tickets_fk_taken` (`taken_by`),
  KEY `tickets_fk_closed` (`closed_by`),
  CONSTRAINT `tickets_fk_closed` FOREIGN KEY (`closed_by`) REFERENCES `ss13_player` (`ckey`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tickets_fk_opened` FOREIGN KEY (`opened_by`) REFERENCES `ss13_player` (`ckey`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tickets_fk_taken` FOREIGN KEY (`taken_by`) REFERENCES `ss13_player` (`ckey`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_warnings
CREATE TABLE IF NOT EXISTS `ss13_warnings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `time` datetime NOT NULL,
  `game_id` varchar(50) DEFAULT NULL,
  `severity` tinyint(1) DEFAULT 0,
  `reason` mediumtext NOT NULL,
  `notes` mediumtext DEFAULT NULL,
  `ckey` varchar(32) NOT NULL,
  `computerid` varchar(32) NOT NULL,
  `ip` varchar(32) NOT NULL,
  `a_ckey` varchar(32) NOT NULL,
  `a_computerid` varchar(32) DEFAULT NULL,
  `a_ip` varchar(32) DEFAULT NULL,
  `acknowledged` tinyint(1) DEFAULT 0,
  `expired` tinyint(1) DEFAULT 0,
  `visible` tinyint(1) DEFAULT 1,
  `edited` tinyint(1) DEFAULT 0,
  `lasteditor` varchar(32) DEFAULT NULL,
  `lasteditdate` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_ss13_warnings_ss13_player_ckey` (`ckey`),
  KEY `FK_ss13_warnings_ss13_player_a_ckey` (`a_ckey`),
  CONSTRAINT `FK_ss13_warnings_ss13_player_a_ckey` FOREIGN KEY (`a_ckey`) REFERENCES `ss13_player` (`ckey`) ON UPDATE CASCADE,
  CONSTRAINT `FK_ss13_warnings_ss13_player_ckey` FOREIGN KEY (`ckey`) REFERENCES `ss13_player` (`ckey`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_webhooks
CREATE TABLE IF NOT EXISTS `ss13_webhooks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `url` longtext NOT NULL,
  `tags` longtext NOT NULL,
  `mention` varchar(32) DEFAULT NULL,
  `dateadded` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_web_sso
CREATE TABLE IF NOT EXISTS `ss13_web_sso` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ckey` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `ip` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_whitelist_log
CREATE TABLE IF NOT EXISTS `ss13_whitelist_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `datetime` datetime NOT NULL,
  `user` varchar(32) NOT NULL,
  `action_method` varchar(32) NOT NULL DEFAULT 'Game Server',
  `action` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Dumping structure for table ss13_whitelist_statuses
CREATE TABLE IF NOT EXISTS `ss13_whitelist_statuses` (
  `flag` int(10) unsigned NOT NULL,
  `status_name` varchar(32) NOT NULL,
  `subspecies` tinyint(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`status_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
