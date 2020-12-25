--
-- Implemented in PR TODO.
-- Adds a `ss13_characters_custom_items` table to replace the old custom item system.
--

CREATE TABLE `ss13_characters_custom_items` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
	`char_id` INT(11) NOT NULL,
	`item_path` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`item_data` LONGTEXT NOT NULL COLLATE 'utf8mb4_bin',
	`req_titles` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_bin',
	`additional_data` VARCHAR(255) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
	PRIMARY KEY (`id`) USING BTREE,
	INDEX `FK_ss13_characters_custom_items_ss13_characters` (`char_id`) USING BTREE,
	CONSTRAINT `FK_ss13_characters_custom_items_ss13_characters` FOREIGN KEY (`char_id`) REFERENCES `aurora_server`.`ss13_characters` (`id`) ON UPDATE CASCADE ON DELETE CASCADE
)
COLLATE='utf8mb4_unicode_ci'
ENGINE=InnoDB
;
