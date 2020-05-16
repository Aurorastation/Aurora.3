--
-- Adds support for loadout slots in PR #8813.
-- 

ALTER TABLE `ss13_characters`
    ADD COLUMN `gear_slot` TINYINT NULL DEFAULT NULL AFTER `gear`;
