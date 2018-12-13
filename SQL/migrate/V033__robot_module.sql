--
-- Adds alt_title logging to the ss13_characters_log
--

ALTER TABLE `ss13_characters_flavour`
	RENAME COLUMN `robot_miner` TO `robot_mining`;
