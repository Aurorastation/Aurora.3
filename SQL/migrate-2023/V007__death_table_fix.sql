--
-- Adds a column for single coordinate instead of mashing them into one column
--
ALTER TABLE `ss13_death`
  ADD COLUMN `loc_x` INT NULL AFTER `oxyloss`,
  ADD COLUMN `loc_y` INT NULL AFTER `loc_x`,
  ADD COLUMN `loc_z` INT NULL AFTER `loc_y`,
  ADD COLUMN `lachar_id` INT NULL DEFAULT NULL AFTER `lackey`,
  ADD CONSTRAINT `FK_ss13_death_ss13_characters_lachar_id` FOREIGN KEY (`lachar_id`) REFERENCES `ss13_characters` (`id`) ON UPDATE CASCADE ON DELETE CASCADE;
