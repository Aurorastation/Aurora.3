--
-- Adds the cargo logging tables
--

CREATE TABLE `ss13_cargo_orderlog` (
	`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
	`game_id` VARCHAR(50) NOT NULL DEFAULT '' COLLATE 'utf8mb4_unicode_ci',
	`order_id` INT(11) NOT NULL,
	`status` VARCHAR(50) NOT NULL DEFAULT '' COLLATE 'utf8mb4_unicode_ci',
	`price` INT(11) NOT NULL DEFAULT '0',
	`ordered_by_id` INT(11) NULL DEFAULT NULL,
	`ordered_by` VARCHAR(128) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
	`authorized_by_id` INT(11) NULL DEFAULT NULL,
	`authorized_by` VARCHAR(128) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
	`received_by_id` INT(11) NULL DEFAULT NULL,
	`received_by` VARCHAR(128) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
	`paid_by_id` INT(11) NULL DEFAULT NULL,
	`paid_by` VARCHAR(128) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
	`time_submitted` TIME NULL DEFAULT NULL,
	`time_approved` TIME NULL DEFAULT NULL,
	`time_shipped` TIME NULL DEFAULT NULL,
	`time_delivered` TIME NULL DEFAULT NULL,
	`time_paid` TIME NULL DEFAULT NULL,
	`reason` TEXT(65535) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='utf8mb4_unicode_ci'
ENGINE=InnoDB;

CREATE TABLE `ss13_cargo_orderlog_items` (
	`cargo_orderlog_id` INT(11) UNSIGNED NOT NULL,
	`cargo_item_id` INT(11) UNSIGNED NOT NULL,
	`amount` INT(11) NOT NULL,
	PRIMARY KEY (`cargo_orderlog_id`, `cargo_item_id`) USING BTREE,
	INDEX `index_orderlog_id` (`cargo_orderlog_id`) USING BTREE,
	INDEX `index_item_id` (`cargo_item_id`) USING BTREE,
	CONSTRAINT `FK_ss13_cargo_orderlog_items_ss13_cargo_items` FOREIGN KEY (`cargo_item_id`) REFERENCES `ss13_cargo_items` (`id`) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT `FK_ss13_cargo_orderlog_items_ss13_cargo_orderlog` FOREIGN KEY (`cargo_orderlog_id`) REFERENCES `ss13_cargo_orderlog` (`id`) ON UPDATE CASCADE ON DELETE CASCADE
)
COLLATE='utf8mb4_unicode_ci'
ENGINE=InnoDB;
