--
-- Rework Connection Logging
--
ALTER TABLE `ss13_connection_log`
  CHANGE COLUMN `ckey` `ckey` VARCHAR(32) NULL COLLATE 'utf8mb4_unicode_ci' AFTER `id`,
  CHANGE COLUMN `ip` `ip` VARCHAR(18) NULL COLLATE 'utf8mb4_unicode_ci' AFTER `serverip`,
  CHANGE COLUMN `computerid` `computerid` VARCHAR(32) NULL COLLATE 'utf8mb4_unicode_ci' AFTER `ip`,
  ADD COLUMN `status` VARCHAR(50) NULL DEFAULT NULL AFTER `game_id`;

