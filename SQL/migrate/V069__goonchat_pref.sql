--
-- Set default 'On' for 'GOONCHAT_ON in toggles_secondary'
-- 

UPDATE `ss13_player_preferences` SET `toggles_secondary` = `toggles_secondary` | 64;