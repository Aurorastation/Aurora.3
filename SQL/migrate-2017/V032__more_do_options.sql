--
-- Adds alt_title logging to the ss13_characters_log
--

ALTER TABLE `ss13_characters_log`
	ADD COLUMN `alt_title` VARCHAR(32) NULL DEFAULT NULL AFTER `job_name`;
