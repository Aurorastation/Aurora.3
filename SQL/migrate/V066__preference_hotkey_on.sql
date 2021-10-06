--
-- Set default 'On' for 'HOTKEY_DEFAULT in toggles_secondary'
-- 

UPDATE `ss13_player_preferences` SET `toggles_secondary` = `toggles_secondary` | 32;