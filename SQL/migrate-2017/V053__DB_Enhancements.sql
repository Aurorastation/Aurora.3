--
-- Adds foreign keys to a few tables and add gameid to notes/warnings/bans
--

ALTER TABLE `ss13_poll_option`
	ADD CONSTRAINT `FK_ss13_poll_option_ss13_poll_question` FOREIGN KEY (`pollid`) REFERENCES `ss13_poll_question` (`id`) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE `ss13_poll_textreply`
	ADD CONSTRAINT `FK_ss13_poll_textreply_ss13_poll_question` FOREIGN KEY (`pollid`) REFERENCES `ss13_poll_question` (`id`) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE `ss13_poll_vote`
	ADD CONSTRAINT `FK_ss13_poll_vote_ss13_poll_question` FOREIGN KEY (`pollid`) REFERENCES `ss13_poll_question` (`id`) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE `ss13_poll_vote`
	ADD CONSTRAINT `FK_ss13_poll_vote_ss13_poll_option` FOREIGN KEY (`optionid`) REFERENCES `ss13_poll_option` (`id`) ON UPDATE CASCADE ON DELETE CASCADE;


UPDATE `ss13_death` SET `byondkey` = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(`byondkey`),' ',''),'_',''),'-',''),'.',''),'@','');
UPDATE `ss13_death` SET `lakey` = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(`lakey`),' ',''),'_',''),'-',''),'.',''),'@','');

ALTER TABLE `ss13_death`
	CHANGE COLUMN `pod` `pod` VARCHAR(255) NULL DEFAULT NULL COMMENT 'Place of death' COLLATE 'utf8mb4_unicode_ci' AFTER `id`,
	CHANGE COLUMN `coord` `coord` VARCHAR(255) NULL DEFAULT NULL COMMENT 'X, Y, Z POD' COLLATE 'utf8mb4_unicode_ci' AFTER `pod`,
	CHANGE COLUMN `job` `job` VARCHAR(255) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `tod`,
	CHANGE COLUMN `special` `special` VARCHAR(255) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `job`,
	CHANGE COLUMN `name` `name` VARCHAR(255) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `special`,
	CHANGE COLUMN `byondkey` `ckey` VARCHAR(32) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `name`,
	CHANGE COLUMN `laname` `laname` VARCHAR(255) NULL DEFAULT NULL COMMENT 'Last attacker name' COLLATE 'utf8mb4_unicode_ci' AFTER `ckey`,
	CHANGE COLUMN `lakey` `lackey` VARCHAR(32) NULL DEFAULT NULL COMMENT 'Last attacker key' COLLATE 'utf8mb4_unicode_ci' AFTER `laname`,
	CHANGE COLUMN `gender` `gender` VARCHAR(255) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `lackey`;

UPDATE ss13_death SET pod = NULL WHERE pod = '';
UPDATE ss13_death SET coord = NULL WHERE coord = '';
UPDATE ss13_death SET job = NULL WHERE job = '';
UPDATE ss13_death SET special = NULL WHERE special = '';
UPDATE ss13_death SET name = NULL WHERE name = '';
UPDATE ss13_death SET ckey = NULL WHERE ckey = '';
UPDATE ss13_death SET laname = NULL WHERE laname = '';
UPDATE ss13_death SET lackey = NULL WHERE lackey = '';
UPDATE ss13_death SET gender = NULL WHERE gender = '';

ALTER TABLE `ss13_death`
	ADD COLUMN `char_id` INT NULL DEFAULT NULL AFTER `ckey`;

ALTER TABLE `ss13_death`
	ADD CONSTRAINT `FK_ss13_death_ss13_player` FOREIGN KEY (`ckey`) REFERENCES `ss13_player` (`ckey`) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE `ss13_death`
	ADD CONSTRAINT `FK_ss13_death_ss13_player_lackey` FOREIGN KEY (`lackey`) REFERENCES `ss13_player` (`ckey`) ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE `ss13_death`
	ADD CONSTRAINT `FK_ss13_death_ss13_characters` FOREIGN KEY (`char_id`) REFERENCES `ss13_characters` (`id`) ON UPDATE CASCADE ON DELETE SET NULL;


ALTER TABLE `ss13_ban`
	CHANGE COLUMN `id` `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT FIRST;

ALTER TABLE `ss13_ban_mirrors`
	ADD CONSTRAINT `FK_ss13_ban_mirrors_ss13_ban` FOREIGN KEY (`ban_id`) REFERENCES `ss13_ban` (`id`) ON UPDATE CASCADE ON DELETE CASCADE;


ALTER TABLE `ss13_stickyban_matched_cid`
	ADD CONSTRAINT `FK_ss13_stickyban_matched_cid_ss13_stickyban` FOREIGN KEY (`stickyban`) REFERENCES `ss13_stickyban` (`ckey`) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE `ss13_stickyban_matched_ckey`
	ADD CONSTRAINT `FK_ss13_stickyban_matched_ckey_ss13_stickyban` FOREIGN KEY (`stickyban`) REFERENCES `ss13_stickyban` (`ckey`) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE `ss13_stickyban_matched_ip`
	ADD CONSTRAINT `FK_ss13_stickyban_matched_ip_ss13_stickyban` FOREIGN KEY (`stickyban`) REFERENCES `ss13_stickyban` (`ckey`) ON UPDATE CASCADE ON DELETE CASCADE;


ALTER TABLE `ss13_character_incidents`
	ADD CONSTRAINT `FK_ss13_character_incidents_ss13_characters` FOREIGN KEY (`char_id`) REFERENCES `ss13_characters` (`id`) ON UPDATE CASCADE ON DELETE CASCADE;


ALTER TABLE `ss13_player_notifications`
	ADD CONSTRAINT `FK_ss13_player_notifications_ss13_player_2` FOREIGN KEY (`created_by`) REFERENCES `ss13_player` (`ckey`) ON UPDATE CASCADE;


ALTER TABLE `ss13_ban`
	ADD COLUMN `game_id` VARCHAR(32) NULL DEFAULT NULL AFTER `serverip`;

ALTER TABLE `ss13_notes`
	ADD COLUMN `game_id` VARCHAR(50) NULL DEFAULT NULL AFTER `adddate`;

ALTER TABLE `ss13_warnings`
	ADD COLUMN `game_id` VARCHAR(50) NULL DEFAULT NULL AFTER `time`;
