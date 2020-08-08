--
-- Deleted Clerical, merged it into mining, so need to rename mining to Supply.
--

ALTER TABLE `ss13_characters_flavour`
    CHANGE COLUMN `robot_mining` `robot_supply` TEXT NULL DEFAULT NULL AFTER `robot_rescue`;
