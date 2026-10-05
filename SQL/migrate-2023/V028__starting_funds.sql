ALTER TABLE `ss13_characters`
  ADD COLUMN `starting_funds` ENUM('Bank Account', 'Cash Bundle', '50/50 Cash Bundle/Bank Account', 'Charge Card', '50/50 Charge Card/Bank Account', 'Adhomian Knuckles', '50/50 Adhomian Knuckles/Bank Account') NOT NULL DEFAULT 'Bank Account' AFTER `economic_status`;
