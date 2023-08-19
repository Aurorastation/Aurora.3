--
-- Edit cultures and origins to have a higher character limit
--

ALTER TABLE `ss13_characters` MODIFY COLUMN `culture` VARCHAR(128);
ALTER TABLE `ss13_characters` MODIFY COLUMN `origin` VARCHAR(128);
