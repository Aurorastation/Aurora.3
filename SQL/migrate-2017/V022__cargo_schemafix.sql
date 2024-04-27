--
-- Allow null in path_old and set the default to null for suppliers_old and path_old
--
ALTER TABLE `ss13_cargo_items`
	CHANGE COLUMN `suppliers_old` `suppliers_old` TEXT NULL DEFAULT NULL COMMENT 'JSON list of suppliers' AFTER `deleted_at`,
	CHANGE COLUMN `path_old` `path_old` VARCHAR(150) NULL DEFAULT NULL AFTER `suppliers_old`;

