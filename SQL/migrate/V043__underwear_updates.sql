--
-- Adds support for underwear updates in PR #6973.
-- This collates all underwear data into one column, with an additional column for custom colours.
-- 

ALTER TABLE `ss13_characters`
	CHANGE COLUMN `underwear` `all_underwear` VARCHAR(32) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `eyes_colour`,
	DROP COLUMN `undershirt`,
	DROP COLUMN `socks`,
	ADD COLUMN `all_underwear_metadata` VARCHAR(7) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `all_underwear`;