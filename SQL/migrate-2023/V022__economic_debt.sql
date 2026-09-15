-- Adds some new economic statuses - Bankrupt, and various stages of debt.
--
ALTER TABLE `ss13_characters` MODIFY COLUMN `economic_status` ENUM('Wealthy', 'Well-off', 'Average', 'Underpaid', 'Poor', 'Impoverished', 'Ruined', 'Bankrupt', 'Minor Debt', 'Moderate Debt', 'Major Debt');
