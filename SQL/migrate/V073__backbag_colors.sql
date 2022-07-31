--
-- Implemented in PR #.
-- Adds Backbag colors.
--

ALTER TABLE `ss13_characters`
	ADD COLUMN `backbag_color` INT(11) NULL DEFAULT NULL AFTER `backbag_style`;

