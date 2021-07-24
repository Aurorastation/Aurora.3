--
-- Implemented in PR #11967.
-- Renames NanoTrasen Relation into Economic Status.
--

ALTER TABLE `ss13_characters`
	DROP COLUMN `nt_relation`,
	ADD COLUMN `economic_status` ENUM('Wealthy', 'Well-off', 'Average', 'Underpaid', 'Poor') DEFAULT "Average" AFTER `religion`;