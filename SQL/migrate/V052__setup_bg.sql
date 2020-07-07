--
-- Adds support for character setup backgrounds in #9300
-- 

ALTER TABLE `ss13_characters`
	ADD COLUMN `bgstate` VARCHAR(20) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `accent`; 