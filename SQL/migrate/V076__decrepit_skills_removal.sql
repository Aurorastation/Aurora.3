--
-- Implemented in PR #14591.
-- Removes the decrepit, unused skills in the loadout.
-- 

ALTER TABLE `ss13_characters` DROP COLUMN `skills`, `skill_specialization`;