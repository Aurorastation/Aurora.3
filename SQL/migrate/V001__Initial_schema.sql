-- ------------------------------------------------------------
-- These are BOREALIS' tables. Some are actively used ingame,
-- hence why they're bundled in here.
-- ------------------------------------------------------------

--
-- BOREALIS' table for bans
--

CREATE TABLE `discord_bans` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` varchar(45) NOT NULL,
  `user_name` varchar(45) NOT NULL,
  `server_id` varchar(45) NOT NULL,
  `ban_type` varchar(45) NOT NULL,
  `ban_duration` int(11) NOT NULL DEFAULT '-1',
  `ban_reason` longtext,
  `ban_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expiration_time` datetime NOT NULL,
  `admin_id` varchar(45) DEFAULT NULL,
  `admin_name` varchar(45) DEFAULT 'BOREALIS',
  `ban_lifted` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- BOREALIS' table for channels
--

CREATE TABLE `discord_channels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `channel_group` varchar(32) NOT NULL,
  `channel_id` text NOT NULL,
  `pin_flag` int(11) NOT NULL DEFAULT '0',
  `server_id` varchar(45) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- BOREALIS' table for logs
--

CREATE TABLE `discord_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `action_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `action` text NOT NULL,
  `admin_id` varchar(45) DEFAULT NULL,
  `user_id` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- BOREALIS' table for strikes
--

CREATE TABLE `discord_strikes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` varchar(45) NOT NULL,
  `user_name` varchar(45) NOT NULL,
  `action_type` varchar(45) NOT NULL DEFAULT 'WARNING',
  `strike_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `admin_id` varchar(45) NOT NULL,
  `admin_name` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- BOREALIS' table for subscriptions
--

CREATE TABLE `discord_subscribers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` varchar(45) NOT NULL,
  `once` tinyint(1) NOT NULL DEFAULT '0',
  `subscribed_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expired_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ------------------------------------------------------------
-- SS13 tables begin here. All of these are actively used.
-- Note that some are used by the WebInterface, but if so,
-- it's done in support of ingame systems.
-- ------------------------------------------------------------

--
-- Table for admin rank alterations
--

CREATE TABLE `ss13_admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `datetime` datetime NOT NULL,
  `adminckey` varchar(32) CHARACTER SET latin1 NOT NULL,
  `adminip` varchar(18) CHARACTER SET latin1 NOT NULL,
  `log` text CHARACTER SET latin1 NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table for the server-supported API/world.Topic commands
--

CREATE TABLE `ss13_api_commands` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `command` varchar(50) COLLATE utf8_bin NOT NULL,
  `description` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQUE command` (`command`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Table for auth tokens for world.Topic
--

CREATE TABLE `ss13_api_tokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `token` varchar(100) COLLATE utf8_bin NOT NULL,
  `ip` varchar(16) COLLATE utf8_bin DEFAULT NULL,
  `creator` varchar(50) COLLATE utf8_bin NOT NULL,
  `description` varchar(100) COLLATE utf8_bin NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Table to describe which tokens can access what commands for world.Topic
--

CREATE TABLE `ss13_api_token_command` (
  `command_id` int(11) NOT NULL,
  `token_id` int(11) NOT NULL,
  PRIMARY KEY (`command_id`,`token_id`),
  KEY `token_id` (`token_id`),
  CONSTRAINT `function_id` FOREIGN KEY (`command_id`) REFERENCES `ss13_api_commands` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `token_id` FOREIGN KEY (`token_id`) REFERENCES `ss13_api_tokens` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Table for bans issued
--

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
  `unbanned_reason` text,
  `unbanned_ckey` varchar(32) CHARACTER SET latin1 DEFAULT NULL,
  `unbanned_computerid` varchar(32) CHARACTER SET latin1 DEFAULT NULL,
  `unbanned_ip` varchar(32) CHARACTER SET latin1 DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table for ban-mirroring, used to catch ban dodgers
--

CREATE TABLE `ss13_ban_mirrors` (
  `ban_mirror_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ban_id` int(10) unsigned NOT NULL,
  `player_ckey` varchar(32) NOT NULL,
  `ban_mirror_ip` varchar(32) NOT NULL,
  `ban_mirror_computerid` varchar(32) NOT NULL,
  `ban_mirror_datetime` datetime NOT NULL,
  PRIMARY KEY (`ban_mirror_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table for housing CCIA notices to be sent mid-round
--

CREATE TABLE `ss13_ccia_general_notice_list` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `message` text COLLATE utf8_unicode_ci NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Table for player information
--

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

--
-- Table for linking requests between the Web-Interface and game server
--

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

--
-- Table for player personal-AI preferences
--

CREATE TABLE `ss13_player_pai` (
  `ckey` varchar(32) NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `description` text,
  `role` text,
  `comments` text,
  PRIMARY KEY (`ckey`),
  CONSTRAINT `player_pai_fk_ckey` FOREIGN KEY (`ckey`) REFERENCES `ss13_player` (`ckey`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table for general player preferences
--

CREATE TABLE `ss13_player_preferences` (
  `ckey` varchar(32) NOT NULL,
  `ooccolor` text,
  `lastchangelog` text,
  `UI_style` text,
  `current_character` int(11) DEFAULT '0',
  `toggles` int(11) DEFAULT '0',
  `UI_style_color` text,
  `UI_style_alpha` int(11) DEFAULT '255',
  `asfx_togs` int(11) DEFAULT '0',
  `lastmotd` text,
  `lastmemo` text,
  `language_prefixes` text,
  PRIMARY KEY (`ckey`),
  CONSTRAINT `player_preferences_fk_ckey` FOREIGN KEY (`ckey`) REFERENCES `ss13_player` (`ckey`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table for holding admin ranks
--

CREATE TABLE `ss13_admin` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ckey` varchar(32) CHARACTER SET latin1 NOT NULL,
  `rank` varchar(32) CHARACTER SET latin1 NOT NULL DEFAULT 'Administrator',
  `level` int(2) NOT NULL DEFAULT '0',
  `flags` int(16) NOT NULL DEFAULT '0',
  `discord_id` varchar(45) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQUE` (`ckey`),
  CONSTRAINT `ckey` FOREIGN KEY (`ckey`) REFERENCES `ss13_player` (`ckey`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table for initial character data
--

CREATE TABLE `ss13_characters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ckey` varchar(32) NOT NULL,
  `name` varchar(128) DEFAULT NULL,
  `metadata` varchar(512) DEFAULT NULL,
  `be_special_role` text,
  `gender` varchar(32) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `species` varchar(32) DEFAULT NULL,
  `language` varchar(50) DEFAULT NULL,
  `hair_colour` varchar(7) DEFAULT NULL,
  `facial_colour` varchar(7) DEFAULT NULL,
  `skin_tone` int(11) DEFAULT NULL,
  `skin_colour` varchar(7) DEFAULT NULL,
  `hair_style` varchar(32) DEFAULT NULL,
  `facial_style` varchar(32) DEFAULT NULL,
  `eyes_colour` varchar(7) DEFAULT NULL,
  `underwear` varchar(32) DEFAULT NULL,
  `undershirt` varchar(32) DEFAULT NULL,
  `socks` varchar(32) DEFAULT NULL,
  `backbag` int(11) DEFAULT NULL,
  `b_type` varchar(32) DEFAULT NULL,
  `spawnpoint` varchar(32) DEFAULT NULL,
  `jobs` text,
  `alternate_option` tinyint(1) DEFAULT NULL,
  `alternate_titles` text,
  `disabilities` int(11) DEFAULT '0',
  `skills` text,
  `skill_specialization` text,
  `home_system` text,
  `citizenship` text,
  `faction` text,
  `religion` text,
  `nt_relation` text,
  `uplink_location` text,
  `organs_data` text,
  `organs_robotic` text,
  `gear` text,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ss13_characters_ckey` (`ckey`),
  KEY `ss13_characteres_name` (`name`),
  CONSTRAINT `ss13_characters_fk_ckey` FOREIGN KEY (`ckey`) REFERENCES `ss13_player` (`ckey`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table for character flavour text
--

CREATE TABLE `ss13_characters_flavour` (
  `char_id` int(11) NOT NULL,
  `records_employment` text,
  `records_medical` text,
  `records_security` text,
  `records_exploit` text,
  `records_ccia` text,
  `flavour_general` text,
  `flavour_head` text,
  `flavour_face` text,
  `flavour_eyes` text,
  `flavour_torso` text,
  `flavour_arms` text,
  `flavour_hands` text,
  `flavour_legs` text,
  `flavour_feet` text,
  `robot_default` text,
  `robot_standard` text,
  `robot_engineering` text,
  `robot_construction` text,
  `robot_medical` text,
  `robot_rescue` text,
  `robot_miner` text,
  `robot_custodial` text,
  `robot_service` text,
  `robot_clerical` text,
  `robot_security` text,
  `robot_research` text,
  PRIMARY KEY (`char_id`),
  CONSTRAINT `ss13_flavour_fk_char_id` FOREIGN KEY (`char_id`) REFERENCES `ss13_characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

--
-- Table for housing IC criminal records
--

CREATE TABLE `ss13_character_incidents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `char_id` int(11) NOT NULL,
  `UID` varchar(32) COLLATE utf8_bin NOT NULL,
  `datetime` varchar(50) COLLATE utf8_bin NOT NULL,
  `notes` text COLLATE utf8_bin NOT NULL,
  `charges` text COLLATE utf8_bin NOT NULL,
  `evidence` text COLLATE utf8_bin NOT NULL,
  `arbiters` text COLLATE utf8_bin NOT NULL,
  `brig_sentence` int(11) NOT NULL DEFAULT '0',
  `fine` int(11) NOT NULL DEFAULT '0',
  `felony` int(11) NOT NULL DEFAULT '0',
  `created_by` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `deleted_by` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `game_id` varchar(50) COLLATE utf8_bin NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UID_char_id` (`char_id`,`UID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Table for logging which characters have joined rounds when
--

CREATE TABLE `ss13_characters_log` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `char_id` int(11) NOT NULL,
  `game_id` varchar(50) NOT NULL,
  `datetime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `job_name` varchar(32) DEFAULT NULL,
  `special_role` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ss13_charlog_fk_char_id` (`char_id`),
  CONSTRAINT `ss13_charlog_fk_char_id` FOREIGN KEY (`char_id`) REFERENCES `ss13_characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table for CCIA actions taken against characters
--

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

--
-- Bridge table between `ss13_ccia_actions` and `ss13_characters`
--

CREATE TABLE `ss13_ccia_action_char` (
  `action_id` int(10) unsigned NOT NULL,
  `char_id` int(11) NOT NULL,
  PRIMARY KEY (`action_id`,`char_id`),
  KEY `ccia_action_char_char_id_foreign` (`char_id`),
  CONSTRAINT `ccia_action_char_action_id_foreign` FOREIGN KEY (`action_id`) REFERENCES `ss13_ccia_actions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ccia_action_char_char_id_foreign` FOREIGN KEY (`char_id`) REFERENCES `ss13_characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Table for logging player connections
--

CREATE TABLE `ss13_connection_log` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ckey` varchar(32) NOT NULL,
  `datetime` datetime NOT NULL,
  `serverip` varchar(32) NOT NULL,
  `ip` varchar(18) NOT NULL,
  `computerid` varchar(32) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table for antag contest participants
--

CREATE TABLE `ss13_contest_participants` (
  `player_ckey` varchar(32) NOT NULL,
  `character_id` int(10) unsigned NOT NULL,
  `contest_faction` enum('INDEP','SLF','BIS','ASI','PSIS','HSH','TCD') NOT NULL DEFAULT 'INDEP'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table for antag contenst reports
--

CREATE TABLE `ss13_contest_reports` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `player_ckey` varchar(32) NOT NULL,
  `character_id` int(10) unsigned DEFAULT NULL,
  `character_faction` enum('INDEP','SLF','BIS','ASI','PSIS','HSH','TCD') NOT NULL DEFAULT 'INDEP',
  `objective_type` text NOT NULL,
  `objective_side` enum('pro_synth','anti_synth') NOT NULL,
  `objective_outcome` tinyint(1) DEFAULT '0',
  `objective_datetime` datetime NOT NULL,
  `duplicate` int(1) unsigned DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table for death statistics
--

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

--
-- Table for housing station directives
--

CREATE TABLE `ss13_directives` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) CHARACTER SET latin1 NOT NULL,
  `data` text CHARACTER SET latin1 NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table for round statistics
--

CREATE TABLE `ss13_feedback` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `time` datetime NOT NULL,
  `game_id` varchar(32) NOT NULL,
  `var_name` varchar(32) CHARACTER SET latin1 NOT NULL,
  `var_value` int(16) DEFAULT NULL,
  `details` text CHARACTER SET latin1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table for ingame forms
--

CREATE TABLE `ss13_forms` (
  `form_id` int(11) NOT NULL AUTO_INCREMENT,
  `id` varchar(4) CHARACTER SET latin1 NOT NULL,
  `name` varchar(50) CHARACTER SET latin1 NOT NULL,
  `department` varchar(32) CHARACTER SET latin1 NOT NULL,
  `data` text CHARACTER SET latin1 NOT NULL,
  `info` text CHARACTER SET latin1,
  PRIMARY KEY (`form_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table for tracking IPC implants
--

CREATE TABLE `ss13_ipc_tracking` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `player_ckey` varchar(32) NOT NULL,
  `character_name` varchar(255) NOT NULL,
  `tag_status` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table for the ingame library
--

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

--
-- Table for player notes
--

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

--
-- Table for ingame poll options
--

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

--
-- Table for ingame poll questions
--

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

--
-- Table for ingame poll text/freeform replies
--

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

--
-- Table for ingame poll votes
--

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

--
-- Table for tracking ingame population counts
--

CREATE TABLE `ss13_population` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `playercount` int(11) DEFAULT NULL,
  `admincount` int(11) DEFAULT NULL,
  `time` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table for player privacy preferences
--

CREATE TABLE `ss13_privacy` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `datetime` datetime NOT NULL,
  `ckey` varchar(32) CHARACTER SET latin1 NOT NULL,
  `option` varchar(128) CHARACTER SET latin1 NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table for ingame santa clause event
--

CREATE TABLE `ss13_santa` (
  `character_name` varchar(32) NOT NULL,
  `participation_status` tinyint(1) NOT NULL DEFAULT '1',
  `is_assigned` tinyint(1) NOT NULL DEFAULT '0',
  `mark_name` varchar(32) DEFAULT NULL,
  `character_gender` varchar(32) NOT NULL,
  `character_species` varchar(32) NOT NULL,
  `character_job` varchar(32) NOT NULL,
  `character_like` mediumtext NOT NULL,
  `gift_assigned` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`character_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table for syndicate contracts
--

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

--
-- Table for comments to syndicate contracts
--

CREATE TABLE `ss13_syndie_contracts_comments` (
  `comment_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `contract_id` int(11) unsigned NOT NULL,
  `commentor_id` int(11) unsigned NOT NULL,
  `commentor_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `comment` text COLLATE utf8_unicode_ci NOT NULL,
  `image_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `type` enum('mod-author','mod-ooc','ic','ic-comprep','ic-failrep','ic-cancel','ooc') COLLATE utf8_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `report_status` enum('waiting-approval','accepted','rejected') COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`comment_id`),
  KEY `contract_id` (`contract_id`),
  CONSTRAINT `contract_id` FOREIGN KEY (`contract_id`) REFERENCES `ss13_syndie_contracts` (`contract_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Bridge table between contract comment data and player table
--

CREATE TABLE `ss13_syndie_contracts_comments_completers` (
  `user_id` int(11) NOT NULL,
  `comment_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`user_id`,`comment_id`),
  KEY `comment_id` (`comment_id`),
  CONSTRAINT `comment_id` FOREIGN KEY (`comment_id`) REFERENCES `ss13_syndie_contracts_comments` (`comment_id`) ON DELETE CASCADE,
  CONSTRAINT `user_id` FOREIGN KEY (`user_id`) REFERENCES `ss13_player` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Table for individual contract objectives
--

CREATE TABLE `ss13_syndie_contracts_objectives` (
  `objective_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `contract_id` int(11) NOT NULL,
  `status` enum('open','closed','deleted') COLLATE utf8_unicode_ci NOT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `description` text COLLATE utf8_unicode_ci NOT NULL,
  `reward_credits` int(11) DEFAULT NULL,
  `reward_credits_update` int(11) DEFAULT NULL,
  `reward_other` text COLLATE utf8_unicode_ci,
  `reward_other_update` text COLLATE utf8_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`objective_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Bridge table between contract objectives and comments
--

CREATE TABLE `ss13_syndie_contracts_comments_objectives` (
  `objective_id` int(10) unsigned NOT NULL,
  `comment_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`objective_id`,`comment_id`),
  KEY `comments_comment_id` (`comment_id`),
  CONSTRAINT `comments_comment_id` FOREIGN KEY (`comment_id`) REFERENCES `ss13_syndie_contracts_comments` (`comment_id`) ON DELETE CASCADE,
  CONSTRAINT `objectives_objective_id` FOREIGN KEY (`objective_id`) REFERENCES `ss13_syndie_contracts_objectives` (`objective_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Table for contract subscribers
--

CREATE TABLE `ss13_syndie_contracts_subscribers` (
  `contract_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`contract_id`,`user_id`),
  CONSTRAINT `syndie_contracts_subscribers_contract_id_foreign` FOREIGN KEY (`contract_id`) REFERENCES `ss13_syndie_contracts` (`contract_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Table for player warnings
--

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

--
-- Table for housing tokens for the WebInterface SSO from within the game
--

CREATE TABLE `ss13_web_sso` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ckey` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `ip` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Table for logging whitelist alterations
--

CREATE TABLE `ss13_whitelist_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `datetime` datetime NOT NULL,
  `user` varchar(32) NOT NULL,
  `action_method` varchar(32) NOT NULL DEFAULT 'Game Server',
  `action` mediumtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table for storing whitelist bitkeys
--

CREATE TABLE `ss13_whitelist_statuses` (
  `flag` int(10) unsigned NOT NULL,
  `status_name` varchar(32) NOT NULL,
  `subspecies` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`status_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
