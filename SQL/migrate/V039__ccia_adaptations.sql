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
