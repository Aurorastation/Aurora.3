--
-- Implemented in PR #21853.
-- Increased size limit for skills column to 512
--

ALTER TABLE `ss13_characters` MODIFY COLUMN `skills` VARCHAR(512);
