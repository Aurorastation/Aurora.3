--
-- Implemented in PR #13400.
-- Add cultures and origins
--

ALTER TABLE `ss13_characters` ADD COLUMN `culture` AFTER `economic_status`;
ALTER TABLE `ss13_characters` ADD COLUMN `origin` AFTER `culture`;
