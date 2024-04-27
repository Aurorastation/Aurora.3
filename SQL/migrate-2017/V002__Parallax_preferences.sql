--
-- Adds parallax related preferences toggles for the player preferences table.
--

ALTER TABLE `ss13_player_preferences`
	ADD `parallax_toggles` INT(11) NULL DEFAULT NULL,
	ADD `parallax_speed` INT(11) NULL DEFAULT NULL;
