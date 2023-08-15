--
-- Cleans up the database
--

-- This is specifically created for the current Aurorastation Database.
-- IF YOU RUN THIS ON YOUR DOWNSTREAM SERVER IT IS STRONGLY ADVICED TO EXECUTE THIS IN A TEST SYTEM FIRST AND FIX POTENTIAL ERRORS

-- Delete unused git_pull tables
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS `ss13_git_pull_todo_stats`;
DROP TABLE IF EXISTS `ss13_git_pull_todos`;
DROP TABLE IF EXISTS `ss13_git_pull_requests`;
DROP TABLE IF EXISTS `ss13_santa`;
DROP TABLE IF EXISTS `ss13_contest_participants`;
DROP TABLE IF EXISTS `ss13_contest_reports`;
DROP TABLE IF EXISTS `ss13_directives`;


-- Fix data issues
UPDATE ss13_ban SET expiration_time = bantime WHERE expiration_time = 0;
UPDATE ss13_library SET uploadtime = "2015-04-26" WHERE uploadtime = 0;
UPDATE
	ss13_news_stories
SET
	publish_at = created_at,
	publish_until = DATE_ADD(created_at, INTERVAL 7 DAY),
	ic_timestamp = DATE_ADD(created_at, INTERVAL 442 YEAR)
WHERE
	publish_at = 0 OR
	publish_until = 0 OR
	ic_timestamp = 0;

-- Update charset and collation
ALTER TABLE `discord_bans`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;
ALTER TABLE `discord_bans`
	ALTER `user_id` DROP DEFAULT,
	ALTER `user_name` DROP DEFAULT,
	ALTER `server_id` DROP DEFAULT,
	ALTER `ban_type` DROP DEFAULT;
ALTER TABLE `discord_bans`
	CHANGE COLUMN `user_id` `user_id` VARCHAR(45) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `id`,
	CHANGE COLUMN `user_name` `user_name` VARCHAR(45) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `user_id`,
	CHANGE COLUMN `server_id` `server_id` VARCHAR(45) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `user_name`,
	CHANGE COLUMN `ban_type` `ban_type` VARCHAR(45) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `server_id`,
	CHANGE COLUMN `ban_reason` `ban_reason` LONGTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `ban_duration`,
	CHANGE COLUMN `admin_id` `admin_id` VARCHAR(45) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `expiration_time`,
	CHANGE COLUMN `admin_name` `admin_name` VARCHAR(45) NULL DEFAULT 'BOREALIS' COLLATE 'utf8mb4_unicode_ci' AFTER `admin_id`;

ALTER TABLE `discord_channels`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;
ALTER TABLE `discord_channels`
	ALTER `channel_group` DROP DEFAULT;
ALTER TABLE `discord_channels`
	CHANGE COLUMN `channel_group` `channel_group` VARCHAR(32) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `id`,
	CHANGE COLUMN `channel_id` `channel_id` MEDIUMTEXT NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `channel_group`,
	CHANGE COLUMN `server_id` `server_id` VARCHAR(45) NOT NULL DEFAULT '' COLLATE 'utf8mb4_unicode_ci' AFTER `pin_flag`;

ALTER TABLE `discord_log`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;
ALTER TABLE `discord_log`
	CHANGE COLUMN `action` `action` MEDIUMTEXT NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `action_time`,
	CHANGE COLUMN `admin_id` `admin_id` VARCHAR(45) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `action`,
	CHANGE COLUMN `user_id` `user_id` VARCHAR(45) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `admin_id`;

ALTER TABLE `discord_strikes`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;
ALTER TABLE `discord_strikes`
	ALTER `user_id` DROP DEFAULT,
	ALTER `user_name` DROP DEFAULT,
	ALTER `admin_id` DROP DEFAULT,
	ALTER `admin_name` DROP DEFAULT;
ALTER TABLE `discord_strikes`
	CHANGE COLUMN `user_id` `user_id` VARCHAR(45) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `id`,
	CHANGE COLUMN `user_name` `user_name` VARCHAR(45) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `user_id`,
	CHANGE COLUMN `action_type` `action_type` VARCHAR(45) NOT NULL DEFAULT 'WARNING' COLLATE 'utf8mb4_unicode_ci' AFTER `user_name`,
	CHANGE COLUMN `admin_id` `admin_id` VARCHAR(45) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `strike_time`,
	CHANGE COLUMN `admin_name` `admin_name` VARCHAR(45) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `admin_id`;

ALTER TABLE `discord_subscribers`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;
ALTER TABLE `discord_subscribers`
	ALTER `user_id` DROP DEFAULT;
ALTER TABLE `discord_subscribers`
	CHANGE COLUMN `user_id` `user_id` VARCHAR(45) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `id`;

ALTER TABLE `ss13_admin_log`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;
ALTER TABLE `ss13_admin_log`
	ALTER `adminckey` DROP DEFAULT,
	ALTER `adminip` DROP DEFAULT;
ALTER TABLE `ss13_admin_log`
	CHANGE COLUMN `adminckey` `adminckey` VARCHAR(32) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `datetime`,
	CHANGE COLUMN `adminip` `adminip` VARCHAR(18) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `adminckey`,
	CHANGE COLUMN `log` `log` MEDIUMTEXT NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `adminip`;

ALTER TABLE `ss13_antag_log`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;
ALTER TABLE `ss13_antag_log`
	ALTER `ckey` DROP DEFAULT,
	ALTER `game_id` DROP DEFAULT,
	ALTER `special_role_name` DROP DEFAULT;
ALTER TABLE `ss13_antag_log`
	CHANGE COLUMN `ckey` `ckey` VARCHAR(32) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `id`,
	CHANGE COLUMN `game_id` `game_id` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `char_id`,
	CHANGE COLUMN `char_name` `char_name` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `game_id`,
	CHANGE COLUMN `special_role_name` `special_role_name` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `datetime`;

ALTER TABLE `ss13_api_commands`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;
ALTER TABLE `ss13_api_commands`
	ALTER `command` DROP DEFAULT;
ALTER TABLE `ss13_api_commands`
	CHANGE COLUMN `command` `command` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `id`,
	CHANGE COLUMN `description` `description` VARCHAR(255) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `command`;

ALTER TABLE `ss13_api_tokens`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;
ALTER TABLE `ss13_api_tokens`
	ALTER `token` DROP DEFAULT,
	ALTER `creator` DROP DEFAULT,
	ALTER `description` DROP DEFAULT;
ALTER TABLE `ss13_api_tokens`
	CHANGE COLUMN `token` `token` VARCHAR(100) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `id`,
	CHANGE COLUMN `ip` `ip` VARCHAR(16) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `token`,
	CHANGE COLUMN `creator` `creator` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `ip`,
	CHANGE COLUMN `description` `description` VARCHAR(100) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `creator`;

ALTER TABLE `ss13_api_token_command`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;

ALTER TABLE `ss13_ban`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;
ALTER TABLE `ss13_ban`
	ALTER `serverip` DROP DEFAULT,
	ALTER `bantype` DROP DEFAULT,
	ALTER `ckey` DROP DEFAULT,
	ALTER `computerid` DROP DEFAULT,
	ALTER `ip` DROP DEFAULT,
	ALTER `a_ckey` DROP DEFAULT,
	ALTER `a_computerid` DROP DEFAULT,
	ALTER `a_ip` DROP DEFAULT;
ALTER TABLE `ss13_ban`
	CHANGE COLUMN `serverip` `serverip` VARCHAR(32) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `bantime`,
	CHANGE COLUMN `bantype` `bantype` VARCHAR(32) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `serverip`,
	CHANGE COLUMN `reason` `reason` MEDIUMTEXT NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `bantype`,
	CHANGE COLUMN `job` `job` VARCHAR(32) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `reason`,
	CHANGE COLUMN `ckey` `ckey` VARCHAR(32) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `expiration_time`,
	CHANGE COLUMN `computerid` `computerid` VARCHAR(32) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `ckey`,
	CHANGE COLUMN `ip` `ip` VARCHAR(32) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `computerid`,
	CHANGE COLUMN `a_ckey` `a_ckey` VARCHAR(32) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `ip`,
	CHANGE COLUMN `a_computerid` `a_computerid` VARCHAR(32) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `a_ckey`,
	CHANGE COLUMN `a_ip` `a_ip` VARCHAR(32) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `a_computerid`,
	CHANGE COLUMN `who` `who` MEDIUMTEXT NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `a_ip`,
	CHANGE COLUMN `adminwho` `adminwho` MEDIUMTEXT NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `who`,
	CHANGE COLUMN `edits` `edits` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `adminwho`,
	CHANGE COLUMN `unbanned_reason` `unbanned_reason` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `unbanned_datetime`,
	CHANGE COLUMN `unbanned_ckey` `unbanned_ckey` VARCHAR(32) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `unbanned_reason`,
	CHANGE COLUMN `unbanned_computerid` `unbanned_computerid` VARCHAR(32) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `unbanned_ckey`,
	CHANGE COLUMN `unbanned_ip` `unbanned_ip` VARCHAR(32) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `unbanned_computerid`;

ALTER TABLE `ss13_ban_mirrors`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;
ALTER TABLE `ss13_ban_mirrors`
	ALTER `ckey` DROP DEFAULT,
	ALTER `ip` DROP DEFAULT,
	ALTER `computerid` DROP DEFAULT,
	ALTER `source` DROP DEFAULT;
ALTER TABLE `ss13_ban_mirrors`
	CHANGE COLUMN `ckey` `ckey` VARCHAR(32) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `ban_id`,
	CHANGE COLUMN `ip` `ip` VARCHAR(32) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `ckey`,
	CHANGE COLUMN `computerid` `computerid` VARCHAR(32) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `ip`,
	CHANGE COLUMN `source` `source` ENUM('legacy','conninfo','isbanned') NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `datetime`,
	CHANGE COLUMN `extra_info` `extra_info` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `source`;

ALTER TABLE `ss13_cargo_categories`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;
ALTER TABLE `ss13_cargo_categories`
	ALTER `name` DROP DEFAULT,
	ALTER `display_name` DROP DEFAULT,
	ALTER `description` DROP DEFAULT,
	ALTER `icon` DROP DEFAULT;
ALTER TABLE `ss13_cargo_categories`
	CHANGE COLUMN `name` `name` VARCHAR(100) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `id`,
	CHANGE COLUMN `display_name` `display_name` VARCHAR(100) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `name`,
	CHANGE COLUMN `description` `description` VARCHAR(300) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `display_name`,
	CHANGE COLUMN `icon` `icon` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `description`,
	CHANGE COLUMN `order_by` `order_by` VARCHAR(5) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `price_modifier`;

ALTER TABLE `ss13_cargo_items`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;
ALTER TABLE `ss13_cargo_items`
	CHANGE COLUMN `name` `name` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `id`,
	CHANGE COLUMN `supplier` `supplier` VARCHAR(50) NOT NULL DEFAULT 'nt' COLLATE 'utf8mb4_unicode_ci' AFTER `name`,
	CHANGE COLUMN `description` `description` VARCHAR(300) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `supplier`,
	CHANGE COLUMN `container_type` `container_type` VARCHAR(50) NOT NULL DEFAULT 'crate' COLLATE 'utf8mb4_unicode_ci' AFTER `access`,
	CHANGE COLUMN `order_by` `order_by` VARCHAR(5) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `groupable`,
	CHANGE COLUMN `created_by` `created_by` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `order_by`,
	CHANGE COLUMN `approved_by` `approved_by` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `created_by`,
	DROP COLUMN `suppliers_old`,
	DROP COLUMN `path_old`;
ALTER TABLE `ss13_cargo_items`
	ALTER `categories` DROP DEFAULT;
ALTER TABLE `ss13_cargo_items`
	CHANGE COLUMN `categories` `categories` JSON NOT NULL AFTER `description`,
	CHANGE COLUMN `items` `items` JSON NULL DEFAULT NULL AFTER `price`;

ALTER TABLE `ss13_cargo_suppliers`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;
ALTER TABLE `ss13_cargo_suppliers`
	ALTER `short_name` DROP DEFAULT,
	ALTER `name` DROP DEFAULT,
	ALTER `description` DROP DEFAULT,
	ALTER `tag_line` DROP DEFAULT;
ALTER TABLE `ss13_cargo_suppliers`
	CHANGE COLUMN `short_name` `short_name` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `id`,
	CHANGE COLUMN `name` `name` VARCHAR(100) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `short_name`,
	CHANGE COLUMN `description` `description` VARCHAR(300) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `name`,
	CHANGE COLUMN `tag_line` `tag_line` VARCHAR(300) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `description`;

ALTER TABLE `ss13_ccia_actions`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;
ALTER TABLE `ss13_ccia_actions`
	ALTER `type` DROP DEFAULT,
	ALTER `issuedby` DROP DEFAULT,
	ALTER `url` DROP DEFAULT;
ALTER TABLE `ss13_ccia_actions`
	CHANGE COLUMN `title` `title` MEDIUMTEXT NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `id`,
	CHANGE COLUMN `type` `type` ENUM('injunction','suspension','reprimand','demotion','other') NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `title`,
	CHANGE COLUMN `issuedby` `issuedby` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `type`,
	CHANGE COLUMN `details` `details` MEDIUMTEXT NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `issuedby`,
	CHANGE COLUMN `url` `url` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `details`;

ALTER TABLE `ss13_ccia_action_char`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;

ALTER TABLE `ss13_ccia_general_notice_list`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;
ALTER TABLE `ss13_ccia_general_notice_list`
	ALTER `title` DROP DEFAULT;
ALTER TABLE `ss13_ccia_general_notice_list`
	CHANGE COLUMN `title` `title` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `id`,
	CHANGE COLUMN `message` `message` MEDIUMTEXT NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `title`;

ALTER TABLE `ss13_ccia_reports`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;
ALTER TABLE `ss13_ccia_reports`
	ALTER `title` DROP DEFAULT,
	ALTER `status` DROP DEFAULT;
ALTER TABLE `ss13_ccia_reports`
	CHANGE COLUMN `title` `title` VARCHAR(200) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `report_date`,
	CHANGE COLUMN `status` `status` ENUM('new','in progress','review required','approved','rejected','completed') NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `title`;

ALTER TABLE `ss13_ccia_reports_transcripts`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;
ALTER TABLE `ss13_ccia_reports_transcripts`
	ALTER `interviewer` DROP DEFAULT;
ALTER TABLE `ss13_ccia_reports_transcripts`
	CHANGE COLUMN `interviewer` `interviewer` VARCHAR(100) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `character_id`,
	CHANGE COLUMN `text` `text` LONGTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `character_id`;

ALTER TABLE `ss13_customsynths`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;
ALTER TABLE `ss13_customsynths`
	ALTER `synthname` DROP DEFAULT,
	ALTER `synthckey` DROP DEFAULT,
	ALTER `synthicon` DROP DEFAULT,
	ALTER `aichassisicon` DROP DEFAULT,
	ALTER `aiholoicon` DROP DEFAULT,
	ALTER `paiicon` DROP DEFAULT;
ALTER TABLE `ss13_customsynths`
	CHANGE COLUMN `synthname` `synthname` VARCHAR(128) NOT NULL COLLATE 'utf8mb4_unicode_ci' FIRST,
	CHANGE COLUMN `synthckey` `synthckey` VARCHAR(32) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `synthname`,
	CHANGE COLUMN `synthicon` `synthicon` VARCHAR(26) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `synthckey`,
	CHANGE COLUMN `aichassisicon` `aichassisicon` VARCHAR(100) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `synthicon`,
	CHANGE COLUMN `aiholoicon` `aiholoicon` VARCHAR(100) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `aichassisicon`,
	CHANGE COLUMN `paiicon` `paiicon` VARCHAR(100) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `aiholoicon`;

ALTER TABLE `ss13_player`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;
ALTER TABLE `ss13_player`
	ALTER `ckey` DROP DEFAULT,
	ALTER `ip` DROP DEFAULT,
	ALTER `computerid` DROP DEFAULT;
ALTER TABLE `ss13_player`
	CHANGE COLUMN `ckey` `ckey` VARCHAR(32) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `id`,
	CHANGE COLUMN `ip` `ip` VARCHAR(18) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `lastseen`,
	CHANGE COLUMN `computerid` `computerid` VARCHAR(32) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `ip`,
	CHANGE COLUMN `lastadminrank` `lastadminrank` VARCHAR(32) NOT NULL DEFAULT 'Player' COLLATE 'utf8mb4_unicode_ci' AFTER `byond_build`,
	CHANGE COLUMN `rank` `rank` VARCHAR(32) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `migration_status`,
	CHANGE COLUMN `discord_id` `discord_id` VARCHAR(45) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `flags`;

ALTER TABLE `ss13_characters`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;
ALTER TABLE `ss13_characters`
	ALTER `ckey` DROP DEFAULT;
ALTER TABLE `ss13_characters`
	CHANGE COLUMN `ckey` `ckey` VARCHAR(32) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `id`,
	CHANGE COLUMN `name` `name` VARCHAR(128) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `ckey`,
	CHANGE COLUMN `metadata` `metadata` VARCHAR(512) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `name`,
	CHANGE COLUMN `be_special_role` `be_special_role` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `metadata`,
	CHANGE COLUMN `gender` `gender` VARCHAR(32) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `be_special_role`,
	CHANGE COLUMN `species` `species` VARCHAR(32) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `age`,
	CHANGE COLUMN `language` `language` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `species`,
	CHANGE COLUMN `hair_colour` `hair_colour` VARCHAR(7) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `language`,
	CHANGE COLUMN `facial_colour` `facial_colour` VARCHAR(7) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `hair_colour`,
	CHANGE COLUMN `skin_colour` `skin_colour` VARCHAR(7) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `skin_tone`,
	CHANGE COLUMN `hair_style` `hair_style` VARCHAR(32) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `skin_colour`,
	CHANGE COLUMN `facial_style` `facial_style` VARCHAR(32) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `hair_style`,
	CHANGE COLUMN `eyes_colour` `eyes_colour` VARCHAR(7) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `facial_style`,
	CHANGE COLUMN `underwear` `underwear` VARCHAR(32) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `eyes_colour`,
	CHANGE COLUMN `undershirt` `undershirt` VARCHAR(32) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `underwear`,
	CHANGE COLUMN `socks` `socks` VARCHAR(32) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `undershirt`,
	CHANGE COLUMN `b_type` `b_type` VARCHAR(32) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `backbag_style`,
	CHANGE COLUMN `spawnpoint` `spawnpoint` VARCHAR(32) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `b_type`,
	CHANGE COLUMN `jobs` `jobs` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `spawnpoint`,
	CHANGE COLUMN `alternate_titles` `alternate_titles` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `alternate_option`,
	CHANGE COLUMN `disabilities` `disabilities` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `alternate_titles`,
	CHANGE COLUMN `skills` `skills` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `disabilities`,
	CHANGE COLUMN `skill_specialization` `skill_specialization` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `skills`,
	CHANGE COLUMN `home_system` `home_system` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `skill_specialization`,
	CHANGE COLUMN `citizenship` `citizenship` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `home_system`,
	CHANGE COLUMN `faction` `faction` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `citizenship`,
	CHANGE COLUMN `religion` `religion` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `faction`,
	CHANGE COLUMN `nt_relation` `nt_relation` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `religion`,
	CHANGE COLUMN `uplink_location` `uplink_location` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `nt_relation`,
	CHANGE COLUMN `organs_data` `organs_data` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `uplink_location`,
	CHANGE COLUMN `organs_robotic` `organs_robotic` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `organs_data`,
	CHANGE COLUMN `body_markings` `body_markings` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `organs_robotic`,
	CHANGE COLUMN `gear` `gear` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `body_markings`;

ALTER TABLE `ss13_characters_flavour`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;
ALTER TABLE `ss13_characters_flavour`
	CHANGE COLUMN `signature` `signature` TEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `char_id`,
	CHANGE COLUMN `signature_font` `signature_font` TEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `signature`,
	CHANGE COLUMN `records_employment` `records_employment` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `signature_font`,
	CHANGE COLUMN `records_medical` `records_medical` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `records_employment`,
	CHANGE COLUMN `records_security` `records_security` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `records_medical`,
	CHANGE COLUMN `records_exploit` `records_exploit` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `records_security`,
	CHANGE COLUMN `records_ccia` `records_ccia` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `records_exploit`,
	CHANGE COLUMN `flavour_general` `flavour_general` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `records_ccia`,
	CHANGE COLUMN `flavour_head` `flavour_head` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `flavour_general`,
	CHANGE COLUMN `flavour_face` `flavour_face` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `flavour_head`,
	CHANGE COLUMN `flavour_eyes` `flavour_eyes` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `flavour_face`,
	CHANGE COLUMN `flavour_torso` `flavour_torso` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `flavour_eyes`,
	CHANGE COLUMN `flavour_arms` `flavour_arms` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `flavour_torso`,
	CHANGE COLUMN `flavour_hands` `flavour_hands` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `flavour_arms`,
	CHANGE COLUMN `flavour_legs` `flavour_legs` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `flavour_hands`,
	CHANGE COLUMN `flavour_feet` `flavour_feet` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `flavour_legs`,
	CHANGE COLUMN `robot_default` `robot_default` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `flavour_feet`,
	CHANGE COLUMN `robot_standard` `robot_standard` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `robot_default`,
	CHANGE COLUMN `robot_engineering` `robot_engineering` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `robot_standard`,
	CHANGE COLUMN `robot_construction` `robot_construction` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `robot_engineering`,
	CHANGE COLUMN `robot_medical` `robot_medical` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `robot_construction`,
	CHANGE COLUMN `robot_rescue` `robot_rescue` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `robot_medical`,
	CHANGE COLUMN `robot_mining` `robot_mining` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `robot_rescue`,
	CHANGE COLUMN `robot_custodial` `robot_custodial` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `robot_mining`,
	CHANGE COLUMN `robot_service` `robot_service` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `robot_custodial`,
	CHANGE COLUMN `robot_clerical` `robot_clerical` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `robot_service`,
	CHANGE COLUMN `robot_security` `robot_security` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `robot_clerical`,
	CHANGE COLUMN `robot_research` `robot_research` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `robot_security`;

ALTER TABLE `ss13_characters_log`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;
ALTER TABLE `ss13_characters_log`
	ALTER `game_id` DROP DEFAULT;
ALTER TABLE `ss13_characters_log`
	CHANGE COLUMN `game_id` `game_id` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `char_id`,
	CHANGE COLUMN `job_name` `job_name` VARCHAR(32) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `datetime`,
	CHANGE COLUMN `alt_title` `alt_title` VARCHAR(32) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `job_name`;

ALTER TABLE `ss13_character_incidents`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;
ALTER TABLE `ss13_character_incidents`
	ALTER `UID` DROP DEFAULT,
	ALTER `datetime` DROP DEFAULT,
	ALTER `game_id` DROP DEFAULT;
ALTER TABLE `ss13_character_incidents`
	CHANGE COLUMN `UID` `UID` VARCHAR(32) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `char_id`,
	CHANGE COLUMN `datetime` `datetime` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `UID`,
	CHANGE COLUMN `notes` `notes` MEDIUMTEXT NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `datetime`,
	CHANGE COLUMN `charges` `charges` MEDIUMTEXT NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `notes`,
	CHANGE COLUMN `evidence` `evidence` MEDIUMTEXT NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `charges`,
	CHANGE COLUMN `arbiters` `arbiters` MEDIUMTEXT NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `evidence`,
	CHANGE COLUMN `created_by` `created_by` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `felony`,
	CHANGE COLUMN `deleted_by` `deleted_by` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `created_by`,
	CHANGE COLUMN `game_id` `game_id` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `deleted_by`;

ALTER TABLE `ss13_connection_log`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;
ALTER TABLE `ss13_connection_log`
	ALTER `ckey` DROP DEFAULT,
	ALTER `serverip` DROP DEFAULT,
	ALTER `ip` DROP DEFAULT,
	ALTER `computerid` DROP DEFAULT;
ALTER TABLE `ss13_connection_log`
	CHANGE COLUMN `ckey` `ckey` VARCHAR(32) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `id`,
	CHANGE COLUMN `serverip` `serverip` VARCHAR(32) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `datetime`,
	CHANGE COLUMN `ip` `ip` VARCHAR(18) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `serverip`,
	CHANGE COLUMN `computerid` `computerid` VARCHAR(32) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `ip`,
	CHANGE COLUMN `game_id` `game_id` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `byond_build`;

ALTER TABLE `ss13_death`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;
ALTER TABLE `ss13_death`
	CHANGE COLUMN `pod` `pod` MEDIUMTEXT NOT NULL COMMENT 'Place of death' COLLATE 'utf8mb4_unicode_ci' AFTER `id`,
	CHANGE COLUMN `coord` `coord` MEDIUMTEXT NOT NULL COMMENT 'X, Y, Z POD' COLLATE 'utf8mb4_unicode_ci' AFTER `pod`,
	CHANGE COLUMN `job` `job` MEDIUMTEXT NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `tod`,
	CHANGE COLUMN `special` `special` MEDIUMTEXT NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `job`,
	CHANGE COLUMN `name` `name` MEDIUMTEXT NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `special`,
	CHANGE COLUMN `byondkey` `byondkey` MEDIUMTEXT NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `name`,
	CHANGE COLUMN `laname` `laname` MEDIUMTEXT NOT NULL COMMENT 'Last attacker name' COLLATE 'utf8mb4_unicode_ci' AFTER `byondkey`,
	CHANGE COLUMN `lakey` `lakey` MEDIUMTEXT NOT NULL COMMENT 'Last attacker key' COLLATE 'utf8mb4_unicode_ci' AFTER `laname`,
	CHANGE COLUMN `gender` `gender` MEDIUMTEXT NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `lakey`;

ALTER TABLE `ss13_documents`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;
ALTER TABLE `ss13_documents`
	ALTER `name` DROP DEFAULT,
	ALTER `title` DROP DEFAULT,
	ALTER `content` DROP DEFAULT;
ALTER TABLE `ss13_documents`
	CHANGE COLUMN `name` `name` VARCHAR(100) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `id`,
	CHANGE COLUMN `title` `title` VARCHAR(26) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `name`,
	CHANGE COLUMN `content` `content` VARCHAR(3072) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `chance`,
	CHANGE COLUMN `tags` `tags` LONGTEXT NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `content`;

ALTER TABLE `ss13_feedback`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;
ALTER TABLE `ss13_feedback`
	ALTER `game_id` DROP DEFAULT,
	ALTER `var_name` DROP DEFAULT;
ALTER TABLE `ss13_feedback`
	CHANGE COLUMN `game_id` `game_id` VARCHAR(32) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `time`,
	CHANGE COLUMN `var_name` `var_name` VARCHAR(32) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `game_id`,
	CHANGE COLUMN `details` `details` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `var_value`;

ALTER TABLE `ss13_forms`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;
ALTER TABLE `ss13_forms`
	ALTER `id` DROP DEFAULT,
	ALTER `name` DROP DEFAULT,
	ALTER `department` DROP DEFAULT;
ALTER TABLE `ss13_forms`
	CHANGE COLUMN `id` `id` VARCHAR(4) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `form_id`,
	CHANGE COLUMN `name` `name` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `id`,
	CHANGE COLUMN `department` `department` VARCHAR(32) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `name`,
	CHANGE COLUMN `data` `data` MEDIUMTEXT NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `department`,
	CHANGE COLUMN `info` `info` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `data`;

ALTER TABLE `ss13_ipc_tracking`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;
ALTER TABLE `ss13_ipc_tracking`
	ALTER `player_ckey` DROP DEFAULT,
	ALTER `character_name` DROP DEFAULT;
ALTER TABLE `ss13_ipc_tracking`
	CHANGE COLUMN `player_ckey` `player_ckey` VARCHAR(32) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `id`,
	CHANGE COLUMN `character_name` `character_name` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `player_ckey`;

ALTER TABLE `ss13_ipintel`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;

ALTER TABLE `ss13_law`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;
ALTER TABLE `ss13_law`
	ALTER `law_id` DROP DEFAULT,
	ALTER `name` DROP DEFAULT,
	ALTER `description` DROP DEFAULT;
ALTER TABLE `ss13_law`
	CHANGE COLUMN `law_id` `law_id` VARCHAR(4) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `id`,
	CHANGE COLUMN `name` `name` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `law_id`,
	CHANGE COLUMN `description` `description` VARCHAR(500) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `name`;

ALTER TABLE `ss13_library`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;
ALTER TABLE `ss13_library`
	ALTER `uploader` DROP DEFAULT;
ALTER TABLE `ss13_library`
	CHANGE COLUMN `author` `author` MEDIUMTEXT NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `id`,
	CHANGE COLUMN `title` `title` MEDIUMTEXT NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `author`,
	CHANGE COLUMN `content` `content` MEDIUMTEXT NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `title`,
	CHANGE COLUMN `category` `category` MEDIUMTEXT NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `content`,
	CHANGE COLUMN `uploader` `uploader` VARCHAR(32) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `uploadtime`;

ALTER TABLE `ss13_news_channels`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;
ALTER TABLE `ss13_news_channels`
	ALTER `name` DROP DEFAULT,
	ALTER `author` DROP DEFAULT,
	ALTER `created_by` DROP DEFAULT;
ALTER TABLE `ss13_news_channels`
	CHANGE COLUMN `name` `name` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `id`,
	CHANGE COLUMN `author` `author` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `name`,
	CHANGE COLUMN `announcement` `announcement` VARCHAR(200) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `is_admin_channel`,
	CHANGE COLUMN `created_by` `created_by` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `announcement`;

ALTER TABLE `ss13_news_stories`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;
ALTER TABLE `ss13_news_stories`
	ALTER `author` DROP DEFAULT,
	ALTER `created_by` DROP DEFAULT;
ALTER TABLE `ss13_news_stories`
	CHANGE COLUMN `author` `author` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `channel_id`,
	CHANGE COLUMN `body` `body` MEDIUMTEXT NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `author`,
	CHANGE COLUMN `message_type` `message_type` VARCHAR(50) NOT NULL DEFAULT 'Story' COLLATE 'utf8mb4_unicode_ci' AFTER `body`,
	CHANGE COLUMN `url` `url` VARCHAR(250) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `publish_until`,
	CHANGE COLUMN `created_by` `created_by` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `ic_timestamp`,
	CHANGE COLUMN `approved_by` `approved_by` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `created_at`;

ALTER TABLE `ss13_notes`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;
ALTER TABLE `ss13_notes`
	ALTER `ckey` DROP DEFAULT,
	ALTER `a_ckey` DROP DEFAULT;
ALTER TABLE `ss13_notes`
	CHANGE COLUMN `ckey` `ckey` VARCHAR(32) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `adddate`,
	CHANGE COLUMN `ip` `ip` VARCHAR(18) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `ckey`,
	CHANGE COLUMN `computerid` `computerid` VARCHAR(32) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `ip`,
	CHANGE COLUMN `a_ckey` `a_ckey` VARCHAR(32) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `computerid`,
	CHANGE COLUMN `content` `content` MEDIUMTEXT NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `a_ckey`,
	CHANGE COLUMN `lasteditor` `lasteditor` VARCHAR(32) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `edited`;

ALTER TABLE `ss13_player_linking`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;
ALTER TABLE `ss13_player_linking`
	ALTER `forum_username_short` DROP DEFAULT,
	ALTER `forum_username` DROP DEFAULT,
	ALTER `player_ckey` DROP DEFAULT,
	ALTER `status` DROP DEFAULT;
ALTER TABLE `ss13_player_linking`
	CHANGE COLUMN `forum_username_short` `forum_username_short` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `forum_id`,
	CHANGE COLUMN `forum_username` `forum_username` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `forum_username_short`,
	CHANGE COLUMN `player_ckey` `player_ckey` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `forum_username`,
	CHANGE COLUMN `status` `status` ENUM('new','confirmed','rejected','linked') NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `player_ckey`;

ALTER TABLE `ss13_player_notifications`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;
ALTER TABLE `ss13_player_notifications`
	ALTER `ckey` DROP DEFAULT,
	ALTER `type` DROP DEFAULT,
	ALTER `message` DROP DEFAULT,
	ALTER `created_by` DROP DEFAULT;
ALTER TABLE `ss13_player_notifications`
	CHANGE COLUMN `ckey` `ckey` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `id`,
	CHANGE COLUMN `type` `type` ENUM('player_greeting','player_greeting_chat','admin','ccia') NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `ckey`,
	CHANGE COLUMN `message` `message` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `type`,
	CHANGE COLUMN `created_by` `created_by` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `message`,
	CHANGE COLUMN `acked_by` `acked_by` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `created_at`;

ALTER TABLE `ss13_player_pai`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;
ALTER TABLE `ss13_player_pai`
	ALTER `ckey` DROP DEFAULT;
ALTER TABLE `ss13_player_pai`
	CHANGE COLUMN `ckey` `ckey` VARCHAR(32) NOT NULL COLLATE 'utf8mb4_unicode_ci' FIRST,
	CHANGE COLUMN `name` `name` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `ckey`,
	CHANGE COLUMN `description` `description` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `name`,
	CHANGE COLUMN `role` `role` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `description`,
	CHANGE COLUMN `comments` `comments` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `role`;

ALTER TABLE `ss13_player_preferences`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;
ALTER TABLE `ss13_player_preferences`
	ALTER `ckey` DROP DEFAULT;
ALTER TABLE `ss13_player_preferences`
	CHANGE COLUMN `ckey` `ckey` VARCHAR(32) NOT NULL COLLATE 'utf8mb4_unicode_ci' FIRST,
	CHANGE COLUMN `ooccolor` `ooccolor` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `ckey`,
	CHANGE COLUMN `lastchangelog` `lastchangelog` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `ooccolor`,
	CHANGE COLUMN `UI_style` `UI_style` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `lastchangelog`,
	CHANGE COLUMN `UI_style_color` `UI_style_color` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `toggles`,
	CHANGE COLUMN `lastmotd` `lastmotd` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `asfx_togs`,
	CHANGE COLUMN `lastmemo` `lastmemo` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `lastmotd`,
	CHANGE COLUMN `language_prefixes` `language_prefixes` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `lastmemo`,
	CHANGE COLUMN `html_UI_style` `html_UI_style` VARCHAR(32) NULL DEFAULT 'Nano' COLLATE 'utf8mb4_unicode_ci' AFTER `parallax_speed`;


ALTER TABLE `ss13_poll_option`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;
ALTER TABLE `ss13_poll_option`
	ALTER `text` DROP DEFAULT;
ALTER TABLE `ss13_poll_option`
	CHANGE COLUMN `text` `text` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `pollid`,
	CHANGE COLUMN `descmin` `descmin` VARCHAR(32) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `maxval`,
	CHANGE COLUMN `descmid` `descmid` VARCHAR(32) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `descmin`,
	CHANGE COLUMN `descmax` `descmax` VARCHAR(32) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `descmid`;

ALTER TABLE `ss13_poll_question`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;
ALTER TABLE `ss13_poll_question`
	ALTER `question` DROP DEFAULT;
ALTER TABLE `ss13_poll_question`
	CHANGE COLUMN `polltype` `polltype` VARCHAR(16) NOT NULL DEFAULT 'OPTION' COLLATE 'utf8mb4_unicode_ci' AFTER `id`,
	CHANGE COLUMN `question` `question` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `endtime`,
	CHANGE COLUMN `viewtoken` `viewtoken` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `publicresult`,
	CHANGE COLUMN `createdby_ckey` `createdby_ckey` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `viewtoken`,
	CHANGE COLUMN `createdby_ip` `createdby_ip` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `createdby_ckey`,
	CHANGE COLUMN `link` `link` VARCHAR(250) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `createdby_ip`;

ALTER TABLE `ss13_poll_textreply`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;
ALTER TABLE `ss13_poll_textreply`
	ALTER `ckey` DROP DEFAULT,
	ALTER `ip` DROP DEFAULT;
ALTER TABLE `ss13_poll_textreply`
	CHANGE COLUMN `ckey` `ckey` VARCHAR(32) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `pollid`,
	CHANGE COLUMN `ip` `ip` VARCHAR(18) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `ckey`,
	CHANGE COLUMN `replytext` `replytext` MEDIUMTEXT NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `ip`,
	CHANGE COLUMN `adminrank` `adminrank` VARCHAR(32) NOT NULL DEFAULT 'Player' COLLATE 'utf8mb4_unicode_ci' AFTER `replytext`;

ALTER TABLE `ss13_poll_vote`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;
ALTER TABLE `ss13_poll_vote`
	ALTER `ckey` DROP DEFAULT,
	ALTER `ip` DROP DEFAULT,
	ALTER `adminrank` DROP DEFAULT;
ALTER TABLE `ss13_poll_vote`
	CHANGE COLUMN `ckey` `ckey` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `optionid`,
	CHANGE COLUMN `ip` `ip` VARCHAR(16) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `ckey`,
	CHANGE COLUMN `adminrank` `adminrank` VARCHAR(32) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `ip`;

ALTER TABLE `ss13_population`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;

ALTER TABLE `ss13_syndie_contracts`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;
ALTER TABLE `ss13_syndie_contracts`
	ALTER `contractee_name` DROP DEFAULT,
	ALTER `status` DROP DEFAULT,
	ALTER `title` DROP DEFAULT;
ALTER TABLE `ss13_syndie_contracts`
	CHANGE COLUMN `contractee_name` `contractee_name` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `contractee_id`,
	CHANGE COLUMN `status` `status` ENUM('new','open','mod-nok','completed','closed','reopened','canceled') NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `contractee_name`,
	CHANGE COLUMN `title` `title` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `status`,
	CHANGE COLUMN `description` `description` MEDIUMTEXT NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `title`,
	CHANGE COLUMN `reward_other` `reward_other` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `reward_credits`,
	CHANGE COLUMN `completer_name` `completer_name` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `completer_id`;

ALTER TABLE `ss13_syndie_contracts_comments`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;
ALTER TABLE `ss13_syndie_contracts_comments`
	ALTER `commentor_name` DROP DEFAULT,
	ALTER `title` DROP DEFAULT,
	ALTER `image_name` DROP DEFAULT,
	ALTER `type` DROP DEFAULT;
ALTER TABLE `ss13_syndie_contracts_comments`
	CHANGE COLUMN `commentor_name` `commentor_name` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `commentor_id`,
	CHANGE COLUMN `title` `title` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `commentor_name`,
	CHANGE COLUMN `comment` `comment` MEDIUMTEXT NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `title`,
	CHANGE COLUMN `image_name` `image_name` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `comment`,
	CHANGE COLUMN `type` `type` ENUM('mod-author','mod-ooc','ic','ic-comprep','ic-failrep','ic-cancel','ooc') NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `image_name`,
	CHANGE COLUMN `report_status` `report_status` ENUM('waiting-approval','accepted','rejected') NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `deleted_at`;

ALTER TABLE `ss13_syndie_contracts_comments_completers`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;

ALTER TABLE `ss13_syndie_contracts_comments_objectives`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;

ALTER TABLE `ss13_syndie_contracts_objectives`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;
ALTER TABLE `ss13_syndie_contracts_objectives`
	ALTER `status` DROP DEFAULT,
	ALTER `title` DROP DEFAULT;
ALTER TABLE `ss13_syndie_contracts_objectives`
	CHANGE COLUMN `status` `status` ENUM('open','closed','deleted') NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `contract_id`,
	CHANGE COLUMN `title` `title` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `status`,
	CHANGE COLUMN `description` `description` MEDIUMTEXT NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `title`,
	CHANGE COLUMN `reward_other` `reward_other` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `reward_credits_update`,
	CHANGE COLUMN `reward_other_update` `reward_other_update` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `reward_other`;

ALTER TABLE `ss13_syndie_contracts_subscribers`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;

ALTER TABLE `ss13_tickets`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;
ALTER TABLE `ss13_tickets`
	ALTER `game_id` DROP DEFAULT,
	ALTER `opened_by` DROP DEFAULT,
	ALTER `closed_by` DROP DEFAULT;
ALTER TABLE `ss13_tickets`
	CHANGE COLUMN `game_id` `game_id` VARCHAR(32) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `id`,
	CHANGE COLUMN `admin_list` `admin_list` MEDIUMTEXT NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `admin_count`,
	CHANGE COLUMN `opened_by` `opened_by` VARCHAR(32) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `admin_list`,
	CHANGE COLUMN `taken_by` `taken_by` VARCHAR(32) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `opened_by`,
	CHANGE COLUMN `closed_by` `closed_by` VARCHAR(32) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `taken_by`;

ALTER TABLE `ss13_warnings`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;
ALTER TABLE `ss13_warnings`
	ALTER `ckey` DROP DEFAULT,
	ALTER `computerid` DROP DEFAULT,
	ALTER `ip` DROP DEFAULT,
	ALTER `a_ckey` DROP DEFAULT;
ALTER TABLE `ss13_warnings`
	CHANGE COLUMN `reason` `reason` MEDIUMTEXT NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `severity`,
	CHANGE COLUMN `notes` `notes` MEDIUMTEXT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `reason`,
	CHANGE COLUMN `ckey` `ckey` VARCHAR(32) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `notes`,
	CHANGE COLUMN `computerid` `computerid` VARCHAR(32) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `ckey`,
	CHANGE COLUMN `ip` `ip` VARCHAR(32) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `computerid`,
	CHANGE COLUMN `a_ckey` `a_ckey` VARCHAR(32) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `ip`,
	CHANGE COLUMN `a_computerid` `a_computerid` VARCHAR(32) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `a_ckey`,
	CHANGE COLUMN `a_ip` `a_ip` VARCHAR(32) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `a_computerid`,
	CHANGE COLUMN `lasteditor` `lasteditor` VARCHAR(32) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `edited`;

ALTER TABLE `ss13_webhooks`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;
ALTER TABLE `ss13_webhooks`
	CHANGE COLUMN `url` `url` LONGTEXT NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `id`,
	CHANGE COLUMN `tags` `tags` LONGTEXT NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `url`,
	CHANGE COLUMN `mention` `mention` VARCHAR(32) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `tags`;

ALTER TABLE `ss13_web_sso`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;
ALTER TABLE `ss13_web_sso`
	ALTER `ckey` DROP DEFAULT,
	ALTER `token` DROP DEFAULT,
	ALTER `ip` DROP DEFAULT;
ALTER TABLE `ss13_web_sso`
	CHANGE COLUMN `ckey` `ckey` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `id`,
	CHANGE COLUMN `token` `token` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `ckey`,
	CHANGE COLUMN `ip` `ip` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `token`;

ALTER TABLE `ss13_whitelist_log`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;
ALTER TABLE `ss13_whitelist_log`
	ALTER `user` DROP DEFAULT;
ALTER TABLE `ss13_whitelist_log`
	CHANGE COLUMN `user` `user` VARCHAR(32) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `datetime`,
	CHANGE COLUMN `action_method` `action_method` VARCHAR(32) NOT NULL DEFAULT 'Game Server' COLLATE 'utf8mb4_unicode_ci' AFTER `user`,
	CHANGE COLUMN `action` `action` LONGTEXT NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `action_method`;

ALTER TABLE `ss13_whitelist_statuses`
	COLLATE='utf8mb4_unicode_ci',
	CONVERT TO CHARSET utf8mb4;
ALTER TABLE `ss13_whitelist_statuses`
	ALTER `status_name` DROP DEFAULT;
ALTER TABLE `ss13_whitelist_statuses`
	CHANGE COLUMN `status_name` `status_name` VARCHAR(32) NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `flag`;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;

-- Allows the char name of the antag log to be nulled
ALTER TABLE `ss13_antag_log`
	ALTER `char_name` DROP DEFAULT;
ALTER TABLE `ss13_antag_log`
	CHANGE COLUMN `char_name` `char_name` VARCHAR(50) NULL AFTER `game_id`;

-- Allows ip and computerid in the ss13_player table to be nulled
ALTER TABLE `ss13_player`
	ALTER `ip` DROP DEFAULT,
	ALTER `computerid` DROP DEFAULT;
ALTER TABLE `ss13_player`
	CHANGE COLUMN `ip` `ip` VARCHAR(18) NULL COLLATE 'utf8mb4_unicode_ci' AFTER `lastseen`,
	CHANGE COLUMN `computerid` `computerid` VARCHAR(32) NULL COLLATE 'utf8mb4_unicode_ci' AFTER `ip`;

-- Allows the ss13_library uploader to be nulled
ALTER TABLE `ss13_library`
	CHANGE COLUMN `uploader` `uploader` VARCHAR(32) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `uploadtime`;

-- Add/Update forein keys for ckeys
ALTER TABLE `ss13_admin_log`
	ADD CONSTRAINT `FK_ss13_admin_log_ss13_player` FOREIGN KEY (`adminckey`) REFERENCES `ss13_player` (`ckey`) ON UPDATE CASCADE;

ALTER TABLE `ss13_antag_log`
	ADD CONSTRAINT `FK_ss13_antag_log_ss13_player` FOREIGN KEY (`ckey`) REFERENCES `ss13_player` (`ckey`) ON UPDATE CASCADE;


INSERT INTO ss13_player (ckey, firstseen, lastseen, ip, computerid)
SELECT ss13_ban.ckey, ss13_ban.bantime AS first, ss13_ban.bantime AS last, ss13_ban.computerid, ss13_ban.ip
FROM ss13_ban
LEFT JOIN ss13_player
  ON ss13_player.ckey = ss13_ban.ckey
WHERE ss13_player.ckey IS NULL
ON DUPLICATE KEY UPDATE byond_version = null;

ALTER TABLE `ss13_ban`
	ADD CONSTRAINT `FK_ss13_ban_ss13_player_ckey` FOREIGN KEY (`ckey`) REFERENCES `ss13_player` (`ckey`) ON UPDATE CASCADE;

ALTER TABLE `ss13_ban`
	ADD CONSTRAINT `FK_ss13_ban_ss13_player_a_ckey` FOREIGN KEY (`a_ckey`) REFERENCES `ss13_player` (`ckey`) ON UPDATE CASCADE;

ALTER TABLE `ss13_ccia_reports_transcripts`
	ADD CONSTRAINT `FK_ss13_ccia_reports_transcripts_ss13_characters` FOREIGN KEY (`character_id`) REFERENCES `ss13_characters` (`id`) ON UPDATE CASCADE;

ALTER TABLE `ss13_ipc_tracking`
	ADD CONSTRAINT `FK_ss13_ipc_tracking_ss13_player` FOREIGN KEY (`player_ckey`) REFERENCES `ss13_player` (`ckey`) ON UPDATE CASCADE;


UPDATE `ss13_library` SET `uploader` = NULL WHERE `uploader` = "";
UPDATE `ss13_library` SET `uploader` = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(`uploader`),' ',''),'_',''),'-',''),'.',''),'@','');

ALTER TABLE `ss13_library`
	ADD CONSTRAINT `FK_ss13_library_ss13_player` FOREIGN KEY (`uploader`) REFERENCES `ss13_player` (`ckey`) ON UPDATE CASCADE;


UPDATE `ss13_notes` SET `ckey` = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(`ckey`),' ',''),'_',''),'-',''),'.',''),'@','');

INSERT INTO ss13_player (ckey, firstseen, lastseen, ip, computerid)
SELECT ss13_notes.ckey, ss13_notes.adddate AS first, ss13_notes.adddate AS lst, ss13_notes.computerid, ss13_notes.ip
FROM ss13_notes
LEFT JOIN ss13_player
  ON ss13_player.ckey = ss13_notes.ckey
WHERE ss13_player.ckey IS NULL
ON DUPLICATE KEY UPDATE ss13_player.byond_version = NULL;

ALTER TABLE `ss13_notes`
	ADD CONSTRAINT `FK_ss13_notes_ss13_player_ckey` FOREIGN KEY (`ckey`) REFERENCES `ss13_player` (`ckey`) ON UPDATE CASCADE;

UPDATE `ss13_notes` SET `a_ckey` = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(`a_ckey`),' ',''),'_',''),'-',''),'.',''),'@','');

ALTER TABLE `ss13_notes`
	ADD CONSTRAINT `FK_ss13_notes_ss13_player_a_ckey` FOREIGN KEY (`a_ckey`) REFERENCES `ss13_player` (`ckey`) ON UPDATE CASCADE;

ALTER TABLE `ss13_player_notifications`
	ADD CONSTRAINT `FK_ss13_player_notifications_ss13_player` FOREIGN KEY (`ckey`) REFERENCES `ss13_player` (`ckey`) ON UPDATE CASCADE;

ALTER TABLE `ss13_poll_textreply`
	ADD CONSTRAINT `FK_ss13_poll_textreply_ss13_player` FOREIGN KEY (`ckey`) REFERENCES `ss13_player` (`ckey`) ON UPDATE CASCADE;

ALTER TABLE `ss13_poll_vote`
	ADD CONSTRAINT `FK_ss13_poll_vote_ss13_player` FOREIGN KEY (`ckey`) REFERENCES `ss13_player` (`ckey`) ON UPDATE CASCADE;

ALTER TABLE `ss13_warnings`
	ADD CONSTRAINT `FK_ss13_warnings_ss13_player_ckey` FOREIGN KEY (`ckey`) REFERENCES `ss13_player` (`ckey`) ON UPDATE CASCADE;

ALTER TABLE `ss13_warnings`
	ADD CONSTRAINT `FK_ss13_warnings_ss13_player_a_ckey` FOREIGN KEY (`a_ckey`) REFERENCES `ss13_player` (`ckey`) ON UPDATE CASCADE;
