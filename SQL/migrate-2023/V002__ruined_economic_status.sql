--
-- Implemented in PR #17227.
-- Adds the ruined economic status to the database.
--
ALTER TABLE `ss13_characters` MODIFY COLUMN `economic_status` ENUM('Wealthy', 'Well-off', 'Average', 'Underpaid', 'Poor', 'Impoverished', 'Ruined');
