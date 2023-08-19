--
-- Combines the ss13_admin and ss13_player table
--
ALTER TABLE `ss13_cargo_items`
	ADD COLUMN `created_by` VARCHAR(50) NULL DEFAULT NULL AFTER `order_by`,
	ADD COLUMN `approved_by` VARCHAR(50) NULL DEFAULT NULL AFTER `created_by`,
	ADD COLUMN `approved_at` DATETIME NULL DEFAULT NULL AFTER `created_at`;

UPDATE ss13_cargo_items SET approved_at = NOW()