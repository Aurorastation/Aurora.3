--
-- Implemented in PR #21853.
-- Changed skills column to TEXT to prevent size overflow
--

ALTER TABLE `ss13_characters` MODIFY COLUMN `skills` TEXT;
