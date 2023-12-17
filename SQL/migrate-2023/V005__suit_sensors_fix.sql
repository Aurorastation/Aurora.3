--
-- Fix suit sensor prefs.
--
ALTER TABLE `ss13_characters` CHANGE COLUMN `sensor_setting` `sensor_setting` VARCHAR(50) NULL DEFAULT NULL AFTER `headset_choice`;
