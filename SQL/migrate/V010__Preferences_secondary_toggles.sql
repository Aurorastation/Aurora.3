--
-- Implemented in PR #3653.
-- Renames parallax toggles to a more generic name.
--

ALTER TABLE `ss13_player_preferences`
  CHANGE `parallax_toggles` `toggles_secondary` INT(11) NULL DEFAULT NULL;