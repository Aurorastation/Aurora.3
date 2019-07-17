--
-- Adds tables to store ccia interviews
--

CREATE TABLE `ss13_ccia_reports` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`report_date` DATE NOT NULL,
	`title` VARCHAR(200) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`status` ENUM('new','approved','rejected','completed') NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`deleted_at` DATETIME NULL DEFAULT NULL,
	PRIMARY KEY (`id`)
)
COLLATE='utf8mb4_unicode_ci'
ENGINE=InnoDB
;

CREATE TABLE `ss13_ccia_reports_transcripts` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`report_id` INT(11) NOT NULL,
	`character_id` INT(11) NOT NULL,
	`interviewer` VARCHAR(100) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`text` LONGTEXT NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`deleted_at` DATETIME NULL DEFAULT NULL,
	PRIMARY KEY (`id`),
	INDEX `report_id` (`report_id`),
	INDEX `character_id` (`character_id`),
	CONSTRAINT `report_id` FOREIGN KEY (`report_id`) REFERENCES `ss13_ccia_reports` (`id`) ON UPDATE CASCADE ON DELETE CASCADE
)
COLLATE='utf8mb4_unicode_ci'
ENGINE=InnoDB
;
