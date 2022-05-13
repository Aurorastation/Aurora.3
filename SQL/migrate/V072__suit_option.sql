--
-- Implemented in PR #10540.
-- Adds a `suit` column for toggling jobspawn suits.
--

ALTER TABLE `ss13_characters`
	ADD COLUMN `suit_choice` TINYINT NULL DEFAULT NULL AFTER `headset_choice`;
