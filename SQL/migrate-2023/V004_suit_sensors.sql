--
-- Implemented in PR #17607.
-- Adds suit sensor prefs.
--
ALTER TABLE `ss13_player_preferences` ADD `sensor_setting` INT(11) DEFAULT NULL
ALTER TABLE `ss13_player_preferences` ADD `sensors_locked` INT(11) DEFAULT NULL
