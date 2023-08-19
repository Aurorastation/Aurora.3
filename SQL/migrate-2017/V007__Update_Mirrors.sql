--
-- Implemented in PR #3119.
-- Renames some tables in the mirrors table to make it more readable.
-- Adds more useful data points.
--

ALTER TABLE `ss13_ban_mirrors`
  CHANGE `ban_mirror_id` `id` INT(10) UNSIGNED NOT NULL,
  CHANGE `player_ckey` `ckey` VARCHAR(32) NOT NULL,
  CHANGE `ban_mirror_ip` `ip` VARCHAR(32) NOT NULL,
  CHANGE `ban_mirror_computerid` `computerid` VARCHAR(32) NOT NULL,
  CHANGE `ban_mirror_datetime` `datetime` DATETIME NOT NULL,
  ADD `source` ENUM('legacy', 'conninfo', 'isbanned') NOT NULL AFTER `datetime`,
  ADD `extra_info` TEXT NULL DEFAULT NULL AFTER `source`;
