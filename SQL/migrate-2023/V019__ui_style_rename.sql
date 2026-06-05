--
-- Rename the UI_style column to ui_style
--

ALTER TABLE `ss13_player_preferences`
	CHANGE COLUMN `UI_style` `ui_style` MEDIUMTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `lastchangelog`,
	CHANGE COLUMN `UI_style_color` `ui_style_color` MEDIUMTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci' AFTER `toggles`,
	CHANGE COLUMN `UI_style_alpha` `ui_style_alpha` INT(11) NULL DEFAULT '255' AFTER `ui_style_color`;
