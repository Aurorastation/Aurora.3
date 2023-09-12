--
-- Implemented in PR #11967.
-- Renames NanoTrasen Relation into Economic Status.
--

ALTER TABLE `ss13_characters` ADD COLUMN `economic_status` ENUM('Wealthy', 'Well-off', 'Average', 'Underpaid', 'Poor') DEFAULT "Average" AFTER `religion`;

UPDATE `ss13_characters` SET `economic_status` = 'Wealthy' WHERE nt_relation = 'Loyal';
UPDATE `ss13_characters` SET `economic_status` = 'well-off' WHERE nt_relation = 'Supportive';
UPDATE `ss13_characters` SET `economic_status` = 'Average' WHERE nt_relation = 'Neutral';
UPDATE `ss13_characters` SET `economic_status` = 'Underpaid' WHERE nt_relation = 'Skeptical';
UPDATE `ss13_characters` SET `economic_status` = 'Poor' WHERE nt_relation = 'Opposed';

ALTER TABLE `ss13_characters` DROP COLUMN `nt_relation`;