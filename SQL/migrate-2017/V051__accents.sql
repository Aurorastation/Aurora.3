--
-- Adds support for accents as a character option in PR #9196.
-- 

ALTER TABLE `ss13_characters`
	ADD COLUMN `accent` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `religion`;