--
-- Fixes prefs not saving because lastmotd and lastmemo don't exist.
--
ALTER TABLE `ss13_player_preferences` DROP COLUMN `lastmotd`, DROP COLUMN `lastmemo`;
