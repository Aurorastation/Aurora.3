--
-- Fixes death saving again by removing the foreign key constraints on the ckeys. (sometimes chey can contain things that arnt ckeys. i.e. @ckey when someone aghosts)
--
ALTER TABLE `ss13_death`
	DROP FOREIGN KEY `FK_ss13_death_ss13_characters`;
ALTER TABLE `ss13_death`
	DROP FOREIGN KEY `FK_ss13_death_ss13_player`,
	DROP FOREIGN KEY `FK_ss13_death_ss13_player_lackey`,
	ADD CONSTRAINT `FK_ss13_death_ss13_characters_char_id` FOREIGN KEY (`char_id`) REFERENCES `ss13_characters` (`id`) ON UPDATE CASCADE ON DELETE SET NULL;
