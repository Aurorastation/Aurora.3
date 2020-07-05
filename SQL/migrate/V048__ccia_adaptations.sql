--
-- Further Changes to the CCIA Report Tables
--

ALTER TABLE `ss13_ccia_reports`
	ALTER `status` DROP DEFAULT;
ALTER TABLE `ss13_ccia_reports`
	ADD COLUMN `public_topic` VARCHAR(200) NULL DEFAULT NULL AFTER `title`,
	ADD COLUMN `internal_topic` VARCHAR(200) NULL DEFAULT NULL AFTER `public_topic`,
	ADD COLUMN `game_id` VARCHAR(20) NULL DEFAULT NULL AFTER `internal_topic`;
ALTER TABLE `ss13_ccia_reports`
	CHANGE COLUMN `status` `status` ENUM('new','in progress','review required','approved','rejected','completed') NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `game_id`;

ALTER TABLE `ss13_ccia_reports_transcripts`
	ADD COLUMN `antag_involvement` TINYINT(4) NOT NULL DEFAULT '1' AFTER `interviewer`,
	ADD COLUMN `antag_involvement_text` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `antag_involvement`,
	CHANGE COLUMN `text` `text` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `antag_involvement_text`;
