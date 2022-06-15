--
-- Implemented in PR #???
-- Adds the impoverished option to the economic status in the database so it saves correctly.
--

ALTER TABLE `ss13_characters` CHANGE COLUMN `economic_status` ENUM('Wealthy', 'Well-off', 'Average', 'Underpaid', 'Poor', 'Impoverished');