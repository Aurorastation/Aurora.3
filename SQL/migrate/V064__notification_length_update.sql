--
-- Adds a deleted_by and deleted reason to ss13_characters in preparation for player-permitted un-delete
--

ALTER TABLE `ss13_player_notifications`
	CHANGE COLUMN `message` `message` MEDIUMTEXT NOT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `type`;
