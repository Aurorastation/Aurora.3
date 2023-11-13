--
-- Adds support for underwear updates in PR #6973.
-- This collates all underwear data into one column, with an additional column for custom colours.
-- 

ALTER TABLE `ss13_characters`
	ADD COLUMN `all_underwear` JSON NULL DEFAULT NULL AFTER `eyes_colour`,
	DROP COLUMN `underwear`,
	DROP COLUMN `undershirt`,
	DROP COLUMN `socks`,
	ADD COLUMN `all_underwear_metadata` JSON NULL DEFAULT NULL AFTER `all_underwear`;
