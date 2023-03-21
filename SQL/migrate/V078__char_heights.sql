--
-- Adds character heights
--

ALTER TABLE `ss13_characters` ADD COLUMN `char_height` INT(3) NOT NULL DEFAULT 0 AFTER `species`
