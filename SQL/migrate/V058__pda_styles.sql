--
-- Implemented in PR #10319.
-- Adds a `pda_choice` column for PDA type preferences.
--

ALTER TABLE `ss13_characters`
	ADD COLUMN `pda_choice` INT(11) NULL DEFAULT NULL AFTER `backbag_style`;
