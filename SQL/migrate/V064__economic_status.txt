--
-- Implemented in PR #11334.
-- Renames NanoTrasen Relation into Economic Status.
--

ALTER TABLE `ss13_characters`
    DROP COLUMN `nt_relation`,
	ADD COLUMN `economic_status` MEDIUMTEXT DEFAULT "Average" AFTER `religion`