--
-- Complimentary of PR #7127
--

ALTER TABLE `ss13_player_preferences`
    ADD `clientfps` INT DEFAULT '0' AFTER `ooccolor`;
