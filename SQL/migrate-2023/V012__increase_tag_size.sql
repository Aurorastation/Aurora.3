--
-- Increases IPC tag size to 20
--

ALTER TABLE `ss13_characters_ipc_tags` ALTER COLUMN `machine_serial_number` VARCHAR(20);
