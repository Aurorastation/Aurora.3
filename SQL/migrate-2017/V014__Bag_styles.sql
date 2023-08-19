--
-- Implemented in PR #4099.
-- Adds a `backbag_style` column for bag preferences.
--

ALTER TABLE `ss13_characters`
	ADD COLUMN `backbag_style` INT(11) NULL DEFAULT NULL AFTER `backbag`;
