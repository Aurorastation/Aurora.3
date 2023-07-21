--
-- Adds psionic prefs
--

ALTER TABLE `ss13_characters` ADD COLUMN `psionics` VARCHAR(128) DEFAULT null AFTER `origin`;
