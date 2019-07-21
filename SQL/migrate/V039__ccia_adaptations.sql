--
-- Further Changes to the CCIA Report Tables
--

-- Add the new columns
ALTER TABLE `ss13_ccia_reports`
	ADD COLUMN `public_topic` VARCHAR(200) NULL DEFAULT NULL AFTER `title`,
	ADD COLUMN `internal_topic` VARCHAR(200) NULL DEFAULT NULL AFTER `public_topic`,
	ADD COLUMN `game_id` VARCHAR(20) NOT NULL AFTER `internal_topic`;

ALTER TABLE `ss13_ccia_reports_transcripts`
	ADD COLUMN `antag_involvement` TINYINT NOT NULL AFTER `interviewer`;

-- Update the status
ALTER TABLE `ss13_ccia_reports`
	ALTER `status` DROP DEFAULT;
ALTER TABLE `ss13_ccia_reports`
	CHANGE COLUMN `status` `status` ENUM('new','in progress','review required','approved','rejected','completed') NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `game_id`;
