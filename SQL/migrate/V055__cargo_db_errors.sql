--
-- Adds a column to ss13_cargo_items which enables the storage of load errors
--

ALTER TABLE `ss13_cargo_items`
	ADD COLUMN `error_message` TEXT NULL DEFAULT NULL AFTER `order_by`;
