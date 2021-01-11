--
-- Implemented in PR #10957.
-- Adds the option to have one of your eyes missing.
--

ALTER TABLE `ss13_characters`
	ADD COLUMN `eyes_option` varchar(7) DEFAULT NULL AFTER `eyes_colour`;