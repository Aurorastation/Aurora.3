ALTER TABLE `ss13_characters`
  ADD COLUMN `starting_funds` ENUM('Bank Account', 'Cash Bundle/Bank Account', 'Charge Card/Bank Account') NOT NULL DEFAULT 'Bank Account' AFTER `economic_status`;
