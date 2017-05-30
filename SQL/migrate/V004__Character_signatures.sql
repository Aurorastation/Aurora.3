--
-- Implemented in PR #2098.
-- Adds character signature fields to the database.
--

ALTER TABLE `ss13_characters_flavour`
	ADD `signature` TINYTEXT NULL DEFAULT NULL AFTER `char_id`,
	ADD `signature_font` TINYTEXT NULL DEFAULT NULL AFTER `signature`;
