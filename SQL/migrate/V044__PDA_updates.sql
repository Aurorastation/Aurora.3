--
-- Gives the ability to customise PDA styles and ringer options.
--

ALTER TABLE `ss13_characters`
	ADD COLUMN `pdachoice` INT(11) NULL DEFAULT NULL AFTER `backbag_style`,
	ADD COLUMN `pdaringer` INT(11) NULL DEFAULT NULL AFTER `pdachoice`,
	ADD COLUMN `pdatone` VARCHAR(128) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `pdaringer`,
	ADD COLUMN `pdanews` INT(11) NULL DEFAULT NULL AFTER `pdatone`,
	ADD COLUMN `pdanewstone` VARCHAR(128) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `pdanews`;