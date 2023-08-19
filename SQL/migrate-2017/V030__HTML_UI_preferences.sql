--
-- Adds HTML style value to the player preferences table.
--

ALTER TABLE `ss13_player_preferences`
	ADD `html_UI_style` VARCHAR(32) DEFAULT 'Nano';
