ALTER TABLE `ss13_characters`
  ADD COLUMN `starting_funds` ENUM('Bank Account', 'Cash Bundle', 'Cash Bundle (50%)', 'Charge Card', 'Charge Card (50%)', 'Adhomian Knuckles', 'Adhomian Knuckles (50%)') NOT NULL DEFAULT 'Bank Account' AFTER `economic_status`;
