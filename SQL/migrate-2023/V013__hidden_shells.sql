--
-- Adds hidden shell status
--

ALTER TABLE `ss13_characters_ipc_tags` ADD COLUMN `hidden_status` TINYINT(1) NOT NULL DEFAULT 0 AFTER `ownership_status`
