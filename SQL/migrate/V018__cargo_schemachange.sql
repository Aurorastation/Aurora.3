--
-- Changes the Cargo Schema to allow grouping multiple items into one virtual item
-- Implemented in #4435
--

ALTER TABLE `ss13_cargo_items`
	DROP INDEX `path`;

ALTER TABLE `ss13_cargo_items`
	ADD COLUMN `supplier` VARCHAR(50) NOT NULL DEFAULT 'nt' AFTER `name`,
	ADD COLUMN `price` INT(11) NOT NULL AFTER `categories`,
	ADD COLUMN `items` TEXT NULL COMMENT 'JSON list of all the items and their attributes' AFTER `price`,
	CHANGE COLUMN `suppliers` `suppliers_old` TEXT NULL COMMENT 'JSON list of suppliers' COLLATE 'utf8_bin' AFTER `deleted_at`,
	CHANGE COLUMN `amount` `amount_old` INT(10) UNSIGNED NOT NULL DEFAULT '1' AFTER `suppliers_old`,
	CHANGE COLUMN `path` `path_old` VARCHAR(150) NOT NULL COLLATE 'utf8_bin' AFTER `amount_old`;

ALTER TABLE `ss13_cargo_items`
	ADD UNIQUE INDEX `name_supplier_path_old` (`name`, `supplier`);