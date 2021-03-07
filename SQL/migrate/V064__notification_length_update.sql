--
-- Increase the message length of the ss13_player_notifications
--

ALTER TABLE `ss13_player_notifications`
	CHANGE COLUMN `message` `message` MEDIUMTEXT NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `type`;
