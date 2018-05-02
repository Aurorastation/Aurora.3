--
-- RReadds the unique index (previously on path)
-- Done in a separate migration to prevent locking up the previous migration if duplicate itemnames are in the db
-- Implemented in #4435
--

ALTER TABLE `ss13_cargo_items`
	ADD UNIQUE INDEX `name_supplier` (`name`, `supplier`);