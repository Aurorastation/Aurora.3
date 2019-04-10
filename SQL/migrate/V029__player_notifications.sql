--
-- Notifications for Players
--
CREATE TABLE `ss13_player_notifications` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
	`ckey` VARCHAR(50) NOT NULL COLLATE 'utf8_bin',
	`type` ENUM('player_greeting','player_greeting_chat','admin','ccia') NOT NULL COLLATE 'utf8_bin',
	`message` VARCHAR(50) NOT NULL COLLATE 'utf8_bin',
	`created_by` VARCHAR(50) NOT NULL COLLATE 'utf8_bin',
	`created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`acked_by` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_bin',
	`acked_at` DATETIME NULL DEFAULT NULL,
	PRIMARY KEY (`id`)
)
COLLATE='utf8_bin'
ENGINE=InnoDB;