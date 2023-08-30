--
-- Renaming colomn because we are fixing spelling
--

ALTER TABLE `ss13_characters_flavour`
    CHANGE COLUMN `robot_miner` `robot_mining` TEXT NULL DEFAULT NULL AFTER `robot_rescue`;
