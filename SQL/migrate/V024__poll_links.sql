--
-- Allows to add a link to the poll
--

ALTER TABLE `ss13_poll_question`
  ADD COLUMN `link` VARCHAR(250) NULL DEFAULT NULL AFTER `createdby_ip`;
