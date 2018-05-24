--
-- Serverside changes to allow News published by players
--
ALTER TABLE `ss13_news_stories`
	CHANGE COLUMN `time_stamp` `publish_at` DATETIME NULL DEFAULT NULL AFTER `is_admin_message`,
	ADD COLUMN `publish_until` DATETIME NULL DEFAULT NULL AFTER `publish_at`,
	ADD COLUMN `ic_timestamp` DATETIME NULL DEFAULT NULL AFTER `publish_until`,
	ADD COLUMN `approved_by` VARCHAR(50) NULL DEFAULT NULL AFTER `created_at`,
	ADD COLUMN `approved_at` DATETIME NULL DEFAULT NULL AFTER `approved_by`,
	ADD COLUMN `url` VARCHAR(250) NULL DEFAULT NULL AFTER `publish_until`;

ALTER TABLE `ss13_news_channels`
	CHANGE COLUMN `announcement` `announcement` VARCHAR(200) NULL DEFAULT NULL COLLATE 'utf8_bin' AFTER `is_admin_channel`;