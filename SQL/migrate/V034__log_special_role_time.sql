--
-- Adds alt_title logging to the ss13_characters_log
--

ALTER TABLE `ss13_characters_log`
	ADD COLUMN `special_role_time` TIME NULL DEFAULT NULL AFTER `special_role`;

