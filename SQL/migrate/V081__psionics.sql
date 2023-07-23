--
-- Adds psionic prefs
--

ALTER TABLE `ss13_characters` ADD COLUMN `psionics` LONGTEXT DEFAULT null AFTER `origin`;
