--
-- Implemented in PR #4429
--

ALTER TABLE `ss13_poll_question`
	ADD COLUMN `createdby_ckey` VARCHAR(50) NULL DEFAULT NULL AFTER `adminonly`,
	ADD COLUMN `createdby_ip` VARCHAR(50) NULL DEFAULT NULL AFTER `createdby_ckey`,
	ADD COLUMN `publicresult` TINYINT(1) NOT NULL DEFAULT '0' AFTER `adminonly`,
	ADD COLUMN `viewtoken` VARCHAR(50) NULL DEFAULT NULL AFTER `publicresult`;
