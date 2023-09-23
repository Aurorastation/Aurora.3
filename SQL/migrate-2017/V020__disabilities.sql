--
-- Adds different disabilities into the loadout
-- Implemented in #4485
--
ALTER TABLE `ss13_characters`
    CHANGE COLUMN `disabilities` `disabilities` TEXT NULL DEFAULT NULL AFTER `alternate_titles`;
    
UPDATE `ss13_characters` SET `disabilities` = NULL WHERE `disabilities` = 0;

UPDATE `ss13_characters` SET `disabilities` = "[\"Nearsightedness\"]" WHERE `disabilities` = 1;
