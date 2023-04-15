--
-- Implemented in PR #14716.
-- Clear unused "SOUND_AMBIENCE" (0x4) flag from "prefs.toggles".
-- Rename "asfx_togs" to "sfx_toggles".
-- 

UPDATE `ss13_player_preferences` SET `toggles` = `toggles` & ~0x4;
ALTER TABLE `ss13_player_preferences` CHANGE COLUMN `asfx_togs` `sfx_toggles` INT(11) NULL DEFAULT '0' AFTER `UI_style_alpha`;