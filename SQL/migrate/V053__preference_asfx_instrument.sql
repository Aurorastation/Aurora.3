--
-- Set default 'On' for 'asfx_instruments'
-- 

UPDATE `ss13_player_preferences` SET `asfx_togs` = `asfx_togs` | 128;
ALTER TABLE `ss13_player_preferences`
	ALTER `asfx_togs` SET DEFAULT '128';