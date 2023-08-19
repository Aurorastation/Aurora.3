--
-- Adds HTML style value to the player preferences table.
--

ALTER TABLE `ss13_ccia_actions`
	CHANGE COLUMN `type` `type` ENUM('injunction','suspension','warning','reprimand','demotion','other') NOT NULL COLLATE 'utf8_unicode_ci' AFTER `title`;

UPDATE ss13_ccia_actions SET type = "reprimand" WHERE type = "warning";

ALTER TABLE `ss13_ccia_actions`
	CHANGE COLUMN `type` `type` ENUM('injunction','suspension','reprimand','demotion','other') NOT NULL COLLATE 'utf8_unicode_ci' AFTER `title`;