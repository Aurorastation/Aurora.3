--
-- Implemented in PR #22502.
-- Adds character birthdates for deriving character age.
--

ALTER TABLE `ss13_characters`
  ADD COLUMN `birthdate` VARCHAR(16) DEFAULT NULL AFTER `age`;
