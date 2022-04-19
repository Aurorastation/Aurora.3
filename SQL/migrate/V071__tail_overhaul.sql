--
-- Implemented in PR #numberhere.
-- Adds the ability for players to select their species' tail, instead of each species only having one stock type of tail.
--

ALTER TABLE `ss13_characters`
	ADD COLUMN `tail_style` varchar(12) DEFAULT NULL AFTER `skin_colour`
