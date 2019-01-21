--
-- Adds a new table specifically for tracking antagonist assignments
--

ALTER TABLE `ss13_characters_log`
	DROP COLUMN `special_role`;

CREATE TABLE `ss13_antag_log` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`ckey` VARCHAR(32) NOT NULL,
	`char_id` INT(11) NULL DEFAULT NULL,
	`game_id` VARCHAR(50) NOT NULL,
	`char_name` VARCHAR(50) NOT NULL,
	`datetime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`special_role_name` VARCHAR(50) NOT NULL,
	`special_role_added` TIME NOT NULL,
	`special_role_removed` TIME NULL DEFAULT NULL,
	PRIMARY KEY (`id`),
	INDEX `FK_ss13_antag_log_ss13_characters` (`char_id`),
	CONSTRAINT `FK_ss13_antag_log_ss13_characters` FOREIGN KEY (`char_id`) REFERENCES `ss13_characters` (`id`) ON UPDATE CASCADE ON DELETE CASCADE
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB;