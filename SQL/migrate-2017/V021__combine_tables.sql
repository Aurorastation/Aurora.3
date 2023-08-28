--
-- Combines the ss13_admin and ss13_player table
--
ALTER TABLE `ss13_player`
	ADD COLUMN `rank` VARCHAR(32) NULL DEFAULT NULL AFTER `migration_status`,
	ADD COLUMN `flags` INT(32) UNSIGNED NOT NULL DEFAULT '0',
	ADD COLUMN `discord_id` VARCHAR(45) NULL DEFAULT NULL AFTER `flags`;

UPDATE `ss13_admin`
SET `flags` = 0
WHERE `rank` = "Removed";

UPDATE `ss13_player`
INNER JOIN `ss13_admin` ON ss13_admin.ckey = ss13_player.ckey
SET
	ss13_player.rank = ss13_admin.rank,
	ss13_player.flags = ss13_admin.flags,
	ss13_player.discord_id = ss13_admin.discord_id;

UPDATE `ss13_player`
SET `rank` = NULL
WHERE `rank` = "Removed";

ALTER TABLE `ss13_admin`
	DROP FOREIGN KEY `ckey`;

SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
DROP TABLE `ss13_admin`;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;