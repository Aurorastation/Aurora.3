--
-- Adds a column for single coordinate instead of mashing them into one column
--
ALTER TABLE `ss13_death`
  ADD COLUMN `loc_x` INT NULL AFTER `oxyloss`,
  ADD COLUMN `loc_y` INT NULL AFTER `loc_x`,
  ADD COLUMN `loc_z` INT NULL AFTER `loc_y`;
