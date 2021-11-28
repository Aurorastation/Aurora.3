--
-- Adds a deleted_by and deleted reason to ss13_characters in preparation for player-permitted un-delete
--

ALTER TABLE `ss13_characters`
	ADD COLUMN `deleted_by` ENUM('player','staff') NULL DEFAULT NULL AFTER `gear_slot`,
	ADD COLUMN `deleted_reason` TEXT NULL AFTER `deleted_by`;
