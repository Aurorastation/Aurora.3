--
-- Implemented in PR #13400.
-- Add cultures and origins
--

ALTER TABLE `ss13_characters` ADD COLUMN `culture` CHAR(32) DEFAULT NULL AFTER `economic_status`;
ALTER TABLE `ss13_characters` ADD COLUMN `origin` CHAR(32) DEFAULT NULL AFTER `culture`;
