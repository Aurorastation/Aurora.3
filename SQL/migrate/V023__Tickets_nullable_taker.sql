--
-- Fixes a bug by allowing the "Taken by" admin to be null.
--

ALTER TABLE `ss13_tickets`
  MODIFY `taken_by` VARCHAR(32) NULL DEFAULT NULL;
