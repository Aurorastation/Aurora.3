--
-- Implemented in PR #4429
--

ALTER TABLE `ss13_poll_question`
	ADD COLUMN `createdby_ckey` VARCHAR(50) NULL DEFAULT NULL AFTER `adminonly`,
	ADD COLUMN `createdby_ip` VARCHAR(50) NULL DEFAULT NULL AFTER `createdby_ckey`;
