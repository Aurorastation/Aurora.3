--
-- Implemented in PR #17471.
-- Adds TGUI Input prefs.
--
ALTER TABLE `ss13_player_preferences` ADD `tgui_inputs` INT(1) NOT NULL DEFAULT 1 AFTER `tooltip_style`;
ALTER TABLE `ss13_player_preferences` ADD `tgui_buttons_large` INT(1) NOT NULL DEFAULT 0 AFTER `tgui_inputs`;
ALTER TABLE `ss13_player_preferences` ADD `tgui_inputs_swapped` INT(1) NOT NULL DEFAULT 0 AFTER `tgui_buttons_large`;
