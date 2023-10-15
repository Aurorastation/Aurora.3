--
-- Implemented in PR #17607.
-- Adds suit sensor prefs.
--
ALTER TABLE `ss13_characters` ADD `sensor_setting` INT(11) DEFAULT NULL AFTER `headset_choice`;
ALTER TABLE `ss13_characters` ADD `sensors_locked` INT(11) DEFAULT NULL AFTER `sensor_setting`;
