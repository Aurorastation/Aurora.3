--
-- Implemented in PR #17607.
-- Adds suit sensor prefs.
--
ALTER TABLE `ss13_characters` ADD COLUMN `sensor_setting` INT(11) DEFAULT NULL
ALTER TABLE `ss13_characters` ADD COLUMN `sensors_locked` INT(11) DEFAULT NULL
