--
-- Add a new theme style field
-- 

ALTER TABLE `ss13_player_preferences`
	ADD COLUMN `theme_style` char(7) DEFAULT "Light"