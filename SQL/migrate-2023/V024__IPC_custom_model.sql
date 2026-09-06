--
-- Adds IPC custom model flavor text field in Character Setup

ALTER TABLE `ss13_characters_ipc_tags` ADD COLUMN `custom_model` varchar(20) DEFAULT NULL AFTER `hidden_status`;
