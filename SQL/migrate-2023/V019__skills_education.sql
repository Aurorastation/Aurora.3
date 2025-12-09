--
-- Implemented in PR #?????.
-- Add education and skills.
--

ALTER TABLE `ss13_characters` ADD COLUMN `education` VARCHAR(48) DEFAULT NULL AFTER `origin`;
ALTER TABLE `ss13_characters` ADD COLUMN `skills` VARCHAR(256) DEFAULT NULL AFTER `education`;
ALTER TABLE `ss13_characters` DROP COLUMN `home_system`;
