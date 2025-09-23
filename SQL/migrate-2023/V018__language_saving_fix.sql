--
-- Fixes saving a character with multiple languages with long names. PR #21262
--

ALTER TABLE `ss13_characters` MODIFY COLUMN `language` VARCHAR(75);
