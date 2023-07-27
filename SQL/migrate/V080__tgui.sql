--
-- Adds tgui prefs
--

ALTER TABLE `ss13_player_preferences` ADD COLUMN `tgui_fancy` INT(1) NOT NULL DEFAULT 1 AFTER `html_UI_style`;
ALTER TABLE `ss13_player_preferences` ADD COLUMN `tgui_lock` INT(1) NOT NULL DEFAULT 0 AFTER `tgui_fancy`;
ALTER TABLE `ss13_player_preferences` DROP COLUMN `html_UI_style`;
