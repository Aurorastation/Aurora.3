--
-- Set default 'On' for 'asfx_instruments'
-- 

UPDATE `ss13_characters` SET 'asfx_togs' = 'asfx_togs' | 128;
ALTER TABLE `ss13_characters`
	ALTER 'asfx_togs' SET DEFAULT '128';