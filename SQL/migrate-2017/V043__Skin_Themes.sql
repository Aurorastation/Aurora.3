--
-- Adds HTML style value to the player preferences table.
--

ALTER TABLE `ss13_player_preferences`
	ADD `skin_theme` VARCHAR(32) DEFAULT 'Light';
