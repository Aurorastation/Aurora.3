--
-- Implemented in PR #3653.
-- Renames parallax toggles to a more generic name.
--

ALTER TABLE `ss13_characters`
  CHANGE `parallax_togs` `toggles_secondary` INT(11) NULL DEFAULT NULL;