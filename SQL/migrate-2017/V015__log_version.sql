--
-- Logs the byond version and byond build in the player table and the connection log.
--

ALTER TABLE `ss13_player`
	ADD COLUMN `byond_version` INT(10) NULL DEFAULT NULL AFTER `computerid`;
ALTER TABLE `ss13_player`
	ADD COLUMN `byond_build` INT(10) NULL DEFAULT NULL AFTER `byond_version`;

ALTER TABLE `ss13_connection_log`
	ADD COLUMN `byond_version` INT(10) NULL DEFAULT NULL AFTER `computerid`;
ALTER TABLE `ss13_connection_log`
	ADD COLUMN `byond_build` INT(10) NULL DEFAULT NULL AFTER `byond_version`;