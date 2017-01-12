CREATE DATABASE `spacestation13` /*!40100 DEFAULT CHARACTER SET utf8 */;

CREATE TABLE `ss13_admin` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ckey` varchar(32) CHARACTER SET latin1 NOT NULL,
  `rank` varchar(32) CHARACTER SET latin1 NOT NULL DEFAULT 'Administrator',
  `level` int(2) NOT NULL DEFAULT '0',
  `flags` int(16) NOT NULL DEFAULT '0',
  `discord_id` varchar(45) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `ss13_admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `datetime` datetime NOT NULL,
  `adminckey` varchar(32) CHARACTER SET latin1 NOT NULL,
  `adminip` varchar(18) CHARACTER SET latin1 NOT NULL,
  `log` text CHARACTER SET latin1 NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `ss13_api_commands` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`command` VARCHAR(50) NOT NULL COLLATE 'utf8_bin',
	`description` VARCHAR(255) NULL DEFAULT NULL COLLATE 'utf8_bin',
	PRIMARY KEY (`id`),
	UNIQUE INDEX `UNIQUE command` (`command`)
)
COLLATE='utf8_bin'
ENGINE=InnoDB;


CREATE TABLE `ss13_api_tokens` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`token` VARCHAR(100) NOT NULL COLLATE 'utf8_bin',
	`ip` VARCHAR(16) NULL DEFAULT NULL COLLATE 'utf8_bin',
	`creator` VARCHAR(50) NOT NULL COLLATE 'utf8_bin',
	`description` VARCHAR(100) NOT NULL COLLATE 'utf8_bin',
	`created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`deleted_at` DATETIME NULL DEFAULT NULL,
	PRIMARY KEY (`id`)
)
COLLATE='utf8_bin'
ENGINE=InnoDB;

CREATE TABLE `ss13_api_token_command` (
	`command_id` INT(11) NOT NULL,
	`token_id` INT(11) NOT NULL,
	PRIMARY KEY (`command_id`, `token_id`),
	INDEX `token_id` (`token_id`),
	CONSTRAINT `function_id` FOREIGN KEY (`command_id`) REFERENCES `ss13_api_commands` (`id`) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT `token_id` FOREIGN KEY (`token_id`) REFERENCES `ss13_api_tokens` (`id`) ON UPDATE CASCADE ON DELETE CASCADE
)
COLLATE='utf8_bin'
ENGINE=InnoDB;



CREATE TABLE `ss13_ban` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bantime` datetime NOT NULL,
  `serverip` varchar(32) CHARACTER SET latin1 NOT NULL,
  `bantype` varchar(32) CHARACTER SET latin1 NOT NULL,
  `reason` text CHARACTER SET latin1 NOT NULL,
  `job` varchar(32) CHARACTER SET latin1 DEFAULT NULL,
  `duration` int(11) NOT NULL,
  `rounds` int(11) DEFAULT NULL,
  `expiration_time` datetime NOT NULL,
  `ckey` varchar(32) CHARACTER SET latin1 NOT NULL,
  `computerid` varchar(32) CHARACTER SET latin1 NOT NULL,
  `ip` varchar(32) CHARACTER SET latin1 NOT NULL,
  `a_ckey` varchar(32) CHARACTER SET latin1 NOT NULL,
  `a_computerid` varchar(32) CHARACTER SET latin1 NOT NULL,
  `a_ip` varchar(32) CHARACTER SET latin1 NOT NULL,
  `who` text CHARACTER SET latin1 NOT NULL,
  `adminwho` text CHARACTER SET latin1 NOT NULL,
  `edits` text CHARACTER SET latin1,
  `unbanned` tinyint(1) DEFAULT NULL,
  `unbanned_datetime` datetime DEFAULT NULL,
  `unbanned_reason` text CHARACTER SET latin1 DEFAULT NULL,
  `unbanned_ckey` varchar(32) CHARACTER SET latin1 DEFAULT NULL,
  `unbanned_computerid` varchar(32) CHARACTER SET latin1 DEFAULT NULL,
  `unbanned_ip` varchar(32) CHARACTER SET latin1 DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `ss13_ban_mirrors` (
  `ban_mirror_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ban_id` int(10) unsigned NOT NULL,
  `player_ckey` varchar(32) NOT NULL,
  `ban_mirror_ip` varchar(32) NOT NULL,
  `ban_mirror_computerid` varchar(32) NOT NULL,
  `ban_mirror_datetime` datetime NOT NULL,
  PRIMARY KEY (`ban_mirror_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `ss13_player` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ckey` varchar(32) CHARACTER SET latin1 NOT NULL,
  `firstseen` datetime NOT NULL,
  `lastseen` datetime NOT NULL,
  `ip` varchar(18) CHARACTER SET latin1 NOT NULL,
  `computerid` varchar(32) CHARACTER SET latin1 NOT NULL,
  `lastadminrank` varchar(32) CHARACTER SET latin1 NOT NULL DEFAULT 'Player',
  `whitelist_status` int(11) unsigned NOT NULL DEFAULT '0',
  `migration_status` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `ckey` (`ckey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `ss13_characters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ckey` varchar(32) NOT NULL,
  `name` varchar(128) NULL DEFAULT NULL,
  `metadata` varchar(512) NULL DEFAULT NULL,
  `be_special_role` text NULL DEFAULT NULL,
  `gender` varchar(32) NULL DEFAULT NULL,
  `age` int(11) NULL DEFAULT NULL,
  `species` varchar(32) NULL DEFAULT NULL,
  `language` text NULL DEFAULT NULL,
  `hair_colour` varchar(7) NULL DEFAULT NULL,
  `facial_colour` varchar(7) NULL DEFAULT NULL,
  `skin_tone` int(11) NULL DEFAULT NULL,
  `skin_colour` varchar(7) NULL DEFAULT NULL,
  `hair_style` varchar(32) NULL DEFAULT NULL,
  `facial_style` varchar(32) NULL DEFAULT NULL,
  `eyes_colour` varchar(7) NULL DEFAULT NULL,
  `underwear` varchar(32) NULL DEFAULT NULL,
  `undershirt` varchar(32) NULL DEFAULT NULL,
  `socks` varchar(32) NULL DEFAULT NULL,
  `backbag` int(11) NULL DEFAULT NULL,
  `b_type` varchar(32) NULL DEFAULT NULL,
  `spawnpoint` varchar(32) NULL DEFAULT NULL,
  `jobs` text NULL DEFAULT NULL,
  `alternate_option` tinyint(1) DEFAULT NULL,
  `alternate_titles` text NULL DEFAULT NULL,
  `disabilities` int(11) DEFAULT '0',
  `skills` text NULL DEFAULT NULL,
  `skill_specialization` text NULL DEFAULT NULL,
  `home_system` text NULL DEFAULT NULL,
  `citizenship` text NULL DEFAULT NULL,
  `faction` text NULL DEFAULT NULL,
  `religion` text NULL DEFAULT NULL,
  `nt_relation` text NULL DEFAULT NULL,
  `uplink_location` text NULL DEFAULT NULL,
  `organs_data` text NULL DEFAULT NULL,
  `organs_robotic` text NULL DEFAULT NULL,
  `gear` text NULL DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ss13_characters_ckey` (`ckey`),
  KEY `ss13_characteres_name` (`name`),
  CONSTRAINT `ss13_characters_fk_ckey` FOREIGN KEY (`ckey`) REFERENCES `ss13_player` (`ckey`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `ss13_characters_flavour` (
  `char_id` int(11) NOT NULL,
  `records_employment` text NULL DEFAULT NULL,
  `records_medical` text NULL DEFAULT NULL,
  `records_security` text NULL DEFAULT NULL,
  `records_exploit` text NULL DEFAULT NULL,
  `records_ccia` text NULL DEFAULT NULL,
  `flavour_general` text NULL DEFAULT NULL,
  `flavour_head` text NULL DEFAULT NULL,
  `flavour_face` text NULL DEFAULT NULL,
  `flavour_eyes` text NULL DEFAULT NULL,
  `flavour_torso` text NULL DEFAULT NULL,
  `flavour_arms` text NULL DEFAULT NULL,
  `flavour_hands` text NULL DEFAULT NULL,
  `flavour_legs` text NULL DEFAULT NULL,
  `flavour_feet` text NULL DEFAULT NULL,
  `robot_default` text NULL DEFAULT NULL,
  `robot_standard` text NULL DEFAULT NULL,
  `robot_engineering` text NULL DEFAULT NULL,
  `robot_construction` text NULL DEFAULT NULL,
  `robot_medical` text NULL DEFAULT NULL,
  `robot_rescue` text NULL DEFAULT NULL,
  `robot_miner` text NULL DEFAULT NULL,
  `robot_custodial` text NULL DEFAULT NULL,
  `robot_service` text NULL DEFAULT NULL,
  `robot_clerical` text NULL DEFAULT NULL,
  `robot_security` text NULL DEFAULT NULL,
  `robot_research` text NULL DEFAULT NULL,
  PRIMARY KEY (`char_id`),
  CONSTRAINT `ss13_flavour_fk_char_id` FOREIGN KEY (`char_id`) REFERENCES `ss13_characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

CREATE TABLE `ss13_characters_log` (
	`id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`char_id` INT(11) NOT NULL,
	`game_id` VARCHAR(50) NOT NULL,
	`datetime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`job_name` VARCHAR(32) NOT NULL,
	`special_role` VARCHAR(32) NULL DEFAULT NULL,
	PRIMARY KEY (`id`),
	CONSTRAINT `ss13_charlog_fk_char_id` FOREIGN KEY (`char_id`) REFERENCES `ss13_characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `ss13_connection_log` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ckey` varchar(32) NOT NULL,
  `datetime` datetime NOT NULL,
  `serverip` varchar(32) NOT NULL,
  `ip` varchar(18) NOT NULL,
  `computerid` varchar(32) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `ss13_contest_participants` (
  `player_ckey` varchar(32) NOT NULL,
  `character_id` int(10) unsigned NOT NULL,
  `contest_faction` enum('INDEP','SLF','BIS','ASI','PSIS','HSH','TCD') NOT NULL DEFAULT 'INDEP'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `ss13_contest_reports` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `player_ckey` varchar(32) NOT NULL,
  `character_id` int(10) unsigned DEFAULT NULL,
  `character_faction` enum('INDEP','SLF','BIS','ASI','PSIS','HSH','TCD') NOT NULL DEFAULT 'INDEP',
  `objective_type` text NOT NULL,
  `objective_side` enum('pro_synth','anti_synth') NOT NULL,
  `objective_outcome` tinyint(1) DEFAULT '0',
  `objective_datetime` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `ss13_customitems` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ckey` varchar(32) CHARACTER SET latin1 NOT NULL,
  `real_name` varchar(32) CHARACTER SET latin1 NOT NULL,
  `item` varchar(124) CHARACTER SET latin1 NOT NULL,
  `job` text CHARACTER SET latin1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `ss13_death` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pod` text CHARACTER SET latin1 NOT NULL COMMENT 'Place of death',
  `coord` text CHARACTER SET latin1 NOT NULL COMMENT 'X, Y, Z POD',
  `tod` datetime NOT NULL COMMENT 'Time of death',
  `job` text CHARACTER SET latin1 NOT NULL,
  `special` text CHARACTER SET latin1 NOT NULL,
  `name` text CHARACTER SET latin1 NOT NULL,
  `byondkey` text CHARACTER SET latin1 NOT NULL,
  `laname` text CHARACTER SET latin1 NOT NULL COMMENT 'Last attacker name',
  `lakey` text CHARACTER SET latin1 NOT NULL COMMENT 'Last attacker key',
  `gender` text CHARACTER SET latin1 NOT NULL,
  `bruteloss` int(11) NOT NULL,
  `brainloss` int(11) NOT NULL,
  `fireloss` int(11) NOT NULL,
  `oxyloss` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `ss13_directives` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) CHARACTER SET latin1 NOT NULL,
  `data` text CHARACTER SET latin1 NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `ss13_feedback` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `time` datetime NOT NULL,
  `game_id` varchar(32) NOT NULL,
  `var_name` varchar(32) CHARACTER SET latin1 NOT NULL,
  `var_value` int(16) DEFAULT NULL,
  `details` text CHARACTER SET latin1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `ss13_forms` (
  `form_id` int(11) NOT NULL AUTO_INCREMENT,
  `id` varchar(4) CHARACTER SET latin1 NOT NULL,
  `name` varchar(50) CHARACTER SET latin1 NOT NULL,
  `department` varchar(32) CHARACTER SET latin1 NOT NULL,
  `data` text CHARACTER SET latin1 NOT NULL,
  `info` text CHARACTER SET latin1,
  PRIMARY KEY (`form_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `ss13_library` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `author` text CHARACTER SET latin1 NOT NULL,
  `title` text CHARACTER SET latin1 NOT NULL,
  `content` text CHARACTER SET latin1 NOT NULL,
  `category` text CHARACTER SET latin1 NOT NULL,
  `uploadtime` datetime NOT NULL,
  `uploader` varchar(32) CHARACTER SET latin1 NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `ss13_news` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `publishtime` int(11) NOT NULL,
  `channel` varchar(64) CHARACTER SET latin1 NOT NULL,
  `author` varchar(64) CHARACTER SET latin1 NOT NULL,
  `title` varchar(64) CHARACTER SET latin1 DEFAULT NULL,
  `body` text CHARACTER SET latin1 NOT NULL,
  `notpublishing` tinyint(1) DEFAULT '0',
  `approved` tinyint(1) DEFAULT '0',
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `uploadip` varchar(18) CHARACTER SET latin1 NOT NULL,
  `uploadtime` datetime NOT NULL,
  `approvetime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `ss13_notes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `adddate` datetime NOT NULL,
  `ckey` varchar(32) CHARACTER SET latin1 NOT NULL,
  `ip` varchar(18) CHARACTER SET latin1 DEFAULT NULL,
  `computerid` varchar(32) CHARACTER SET latin1 DEFAULT NULL,
  `a_ckey` varchar(32) CHARACTER SET latin1 NOT NULL,
  `content` text CHARACTER SET latin1 NOT NULL,
  `visible` tinyint(1) NOT NULL DEFAULT '1',
  `edited` tinyint(1) NOT NULL DEFAULT '0',
  `lasteditor` varchar(32) CHARACTER SET latin1 DEFAULT NULL,
  `lasteditdate` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `ss13_player_linking` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `forum_id` int(11) NOT NULL,
  `forum_username_short` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `forum_username` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `player_ckey` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `status` enum('new','confirmed','rejected','linked') COLLATE utf8_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `ss13_player_preferences` (
  `ckey` varchar(32) NOT NULL,
  `ooccolor` text NULL DEFAULT NULL,
  `lastchangelog` text NULL DEFAULT NULL,
  `UI_style` text NULL DEFAULT NULL,
  `current_character` int(11) NULL DEFAULT NULL,
  `toggles` int(11) DEFAULT '0',
  `UI_style_color` text NULL DEFAULT NULL,
  `UI_style_alpha` int(11) NULL DEFAULT '255',
  `asfx_togs` int(11) DEFAULT '0',
  `lastmotd` text NULL DEFAULT NULL,
  `lastmemo` text NULL DEFAULT NULL,
  `language_prefixes` text NULL DEFAULT NULL,
  PRIMARY KEY (`ckey`),
  CONSTRAINT `player_preferences_fk_ckey` FOREIGN KEY (`ckey`) REFERENCES `ss13_player` (`ckey`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `ss13_poll_option` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pollid` int(11) NOT NULL,
  `text` varchar(255) CHARACTER SET latin1 NOT NULL,
  `percentagecalc` tinyint(1) NOT NULL DEFAULT '1',
  `minval` int(3) DEFAULT NULL,
  `maxval` int(3) DEFAULT NULL,
  `descmin` varchar(32) CHARACTER SET latin1 DEFAULT NULL,
  `descmid` varchar(32) CHARACTER SET latin1 DEFAULT NULL,
  `descmax` varchar(32) CHARACTER SET latin1 DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `ss13_poll_question` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `polltype` varchar(16) CHARACTER SET latin1 NOT NULL DEFAULT 'OPTION',
  `starttime` datetime NOT NULL,
  `endtime` datetime NOT NULL,
  `question` varchar(255) CHARACTER SET latin1 NOT NULL,
  `multiplechoiceoptions` int(11) DEFAULT NULL,
  `adminonly` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `ss13_poll_textreply` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `datetime` datetime NOT NULL,
  `pollid` int(11) NOT NULL,
  `ckey` varchar(32) CHARACTER SET latin1 NOT NULL,
  `ip` varchar(18) CHARACTER SET latin1 NOT NULL,
  `replytext` text CHARACTER SET latin1 NOT NULL,
  `adminrank` varchar(32) CHARACTER SET latin1 NOT NULL DEFAULT 'Player',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `ss13_poll_vote` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `datetime` datetime NOT NULL,
  `pollid` int(11) NOT NULL,
  `optionid` int(11) NOT NULL,
  `ckey` varchar(255) CHARACTER SET latin1 NOT NULL,
  `ip` varchar(16) CHARACTER SET latin1 NOT NULL,
  `adminrank` varchar(32) CHARACTER SET latin1 NOT NULL,
  `rating` int(2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `ss13_population` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `playercount` int(11) DEFAULT NULL,
  `admincount` int(11) DEFAULT NULL,
  `time` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=69279 DEFAULT CHARSET=utf8;

CREATE TABLE `ss13_privacy` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `datetime` datetime NOT NULL,
  `ckey` varchar(32) CHARACTER SET latin1 NOT NULL,
  `option` varchar(128) CHARACTER SET latin1 NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `ss13_syndie_contracts` (
  `contract_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `contractee_id` int(11) NOT NULL,
  `contractee_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `status` enum('new','open','mod-nok','completed','closed','reopened','canceled') COLLATE utf8_unicode_ci NOT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `description` text COLLATE utf8_unicode_ci NOT NULL,
  `reward_credits` int(11) DEFAULT NULL,
  `reward_other` text COLLATE utf8_unicode_ci,
  `completer_id` int(11) DEFAULT NULL,
  `completer_name` text COLLATE utf8_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`contract_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `ss13_syndie_contracts_comments` (
  `comment_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `contract_id` int(11) NOT NULL,
  `commentor_id` int(11) NOT NULL,
  `commentor_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `comment` text COLLATE utf8_unicode_ci NOT NULL,
  `image_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `type` enum('mod-author','mod-ooc','ic','ic-comprep','ic-failrep','ic-cancel','ooc') COLLATE utf8_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`comment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `ss13_syndie_contracts_subscribers` (
  `contract_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`contract_id`,`user_id`),
  CONSTRAINT `syndie_contracts_subscribers_contract_id_foreign` FOREIGN KEY (`contract_id`) REFERENCES `ss13_syndie_contracts` (`contract_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `ss13_warnings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `time` datetime NOT NULL,
  `severity` tinyint(1) DEFAULT '0',
  `reason` text CHARACTER SET latin1 NOT NULL,
  `notes` text CHARACTER SET latin1,
  `ckey` varchar(32) CHARACTER SET latin1 NOT NULL,
  `computerid` varchar(32) CHARACTER SET latin1 NOT NULL,
  `ip` varchar(32) CHARACTER SET latin1 NOT NULL,
  `a_ckey` varchar(32) CHARACTER SET latin1 NOT NULL,
  `a_computerid` varchar(32) DEFAULT NULL,
  `a_ip` varchar(32) DEFAULT NULL,
  `acknowledged` tinyint(1) DEFAULT '0',
  `expired` tinyint(1) DEFAULT '0',
  `visible` tinyint(1) DEFAULT '1',
  `edited` tinyint(1) DEFAULT '0',
  `lasteditor` varchar(32) CHARACTER SET latin1 DEFAULT NULL,
  `lasteditdate` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `ss13_web_sso` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ckey` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `ip` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `ss13_whitelist_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `datetime` datetime NOT NULL,
  `user` varchar(32) NOT NULL,
  `action_method` varchar(32) NOT NULL DEFAULT 'Game Server',
  `action` mediumtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `ss13_whitelist_statuses` (
  `flag` int(10) unsigned NOT NULL,
  `status_name` varchar(32) NOT NULL,
  `subspecies` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`status_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `ss13_stats_ie` (
  `ckey` varchar(32) NOT NULL,
  `IsIE` tinyint(4) NOT NULL,
  `IsEdge` tinyint(4) NOT NULL,
  `EdgeHtmlVersion` int(11) NOT NULL,
  `TrueVersion` tinyint(4) NOT NULL,
  `ActingVersion` tinyint(4) NOT NULL,
  `CompatibilityMode` tinyint(4) NOT NULL,
  `DateUpdated` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ckey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `ss13_character_incidents` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`char_id` INT(11) NOT NULL,
	`UID` VARCHAR(32) NOT NULL COLLATE 'utf8_bin',
	`datetime` VARCHAR(50) NOT NULL COLLATE 'utf8_bin',
	`notes` TEXT NOT NULL COLLATE 'utf8_bin',
	`charges` TEXT NOT NULL COLLATE 'utf8_bin',
	`evidence` TEXT NOT NULL COLLATE 'utf8_bin',
	`arbiters` TEXT NOT NULL COLLATE 'utf8_bin',
	`brig_sentence` INT(11) NOT NULL DEFAULT '0',
	`fine` INT(11) NOT NULL DEFAULT '0',
	`felony` INT(11) NOT NULL DEFAULT '0',
	`created_by` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_bin',
	`deleted_by` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_bin',
	`game_id` VARCHAR(50) NOT NULL COLLATE 'utf8_bin',
	`created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`deleted_at` DATETIME NULL DEFAULT NULL,
	PRIMARY KEY (`id`),
	UNIQUE INDEX `UID_char_id` (`char_id`, `UID`)
) COLLATE='utf8_bin' ENGINE=InnoDB;

CREATE TABLE `discord_channels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `channel_group` varchar(32) NOT NULL,
  `channel_id` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `ss13_ccia_actions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` text COLLATE utf8_unicode_ci NOT NULL,
  `type` enum('injunction','suspension','warning','other') COLLATE utf8_unicode_ci NOT NULL,
  `issuedby` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `details` text COLLATE utf8_unicode_ci NOT NULL,
  `url` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `expires_at` date DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `ss13_ccia_action_char` (
  `action_id` int(10) unsigned NOT NULL,
  `char_id` int(11) NOT NULL,
  PRIMARY KEY (`action_id`,`char_id`),
  KEY `ccia_action_char_char_id_foreign` (`char_id`),
  CONSTRAINT `ccia_action_char_action_id_foreign` FOREIGN KEY (`action_id`) REFERENCES `ss13_ccia_actions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ccia_action_char_char_id_foreign` FOREIGN KEY (`char_id`) REFERENCES `ss13_characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `ss13_ccia_general_notice_list` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `message` text COLLATE utf8_unicode_ci NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `ss13_player_pai` (
  `ckey` VARCHAR(32) NOT NULL,
  `name` VARCHAR(50) NULL DEFAULT NULL,
  `description` TEXT NULL DEFAULT NULL,
  `role` TEXT NULL DEFAULT NULL,
  `comments` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`ckey`),
  CONSTRAINT `player_pai_fk_ckey` FOREIGN KEY (`ckey`) REFERENCES `ss13_player` (`ckey`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
