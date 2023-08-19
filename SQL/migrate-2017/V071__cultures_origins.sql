--
-- Implemented in PR #13400.
-- Add cultures and origins
--

ALTER TABLE `ss13_characters` ADD COLUMN `culture` VARCHAR(48) DEFAULT NULL AFTER `economic_status`;
ALTER TABLE `ss13_characters` ADD COLUMN `origin` VARCHAR(48) DEFAULT NULL AFTER `culture`;
