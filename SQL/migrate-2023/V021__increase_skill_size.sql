--
-- Implemented in PR #21853.
-- Changed skills column to TEXT to prevent size overflow
--

UPDATE `ss13_characters`
  SET `skills` = NULL
  WHERE `skills` IS NOT NULL AND NOT JSON_VALID(`skills`);

ALTER TABLE `ss13_characters`
  MODIFY COLUMN `skills` LONGTEXT DEFAULT NULL,
  ADD CONSTRAINT `chk_skills_json_valid` CHECK (`skills` IS NULL OR JSON_VALID(`skills`));
