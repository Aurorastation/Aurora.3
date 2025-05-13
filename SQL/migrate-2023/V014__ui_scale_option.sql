ALTER TABLE `ss13_player_preferences` ADD COLUMN `tgui_say_light_mode` TINYINT(1) NOT NULL DEFAULT 0 AFTER `tgui_lock`;
ALTER TABLE `ss13_player_preferences` ADD COLUMN `ui_scale` TINYINT(1) NOT NULL DEFAULT 1 AFTER `tgui_say_light_mode`;
