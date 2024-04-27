--
-- Implemented in PR #11207.
-- Adds the ability for players to select their character's pronouns, only affects what gender they appear as when examined and in visible messages.
--

ALTER TABLE `ss13_characters`
	ADD COLUMN `pronouns` varchar(12) DEFAULT NULL AFTER `gender`