--
-- Adds a game_id column to the connection log
--

ALTER TABLE `ss13_connection_log`
	ADD COLUMN `game_id` VARCHAR(50) NULL DEFAULT NULL AFTER `byond_build`;