--
-- Implemented in PR #10540.
-- Adds a `headset_choice` column for headset type preferences.
--

ALTER TABLE `ss13_characters`
	ADD COLUMN `headset_choice` TINYINT NULL DEFAULT NULL AFTER `pda_choice`;
