--
-- Implemented in PR #2607.
-- Character body marking migration file
--

ALTER TABLE `ss13_characters`
  ADD `body_markings` TEXT NULL DEFAULT NULL AFTER `organs_robotic`;
