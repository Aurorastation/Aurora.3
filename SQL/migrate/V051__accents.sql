--
-- Adds support for accents as a character option in PR #9196.
-- 

ALTER TABLE `ss13_characters`
	ADD COLUMN `accent` TEXT NULL DEFAULT NULL AFTER `religion`;