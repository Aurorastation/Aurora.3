--
-- Implemented in PR #4026.
-- Adds a deleted_at column for mirrors.
-- Also adds indexes for speeding up search queries around the ban database.
--

ALTER TABLE `ss13_ban_mirrors`
  ADD `deleted_at` DATETIME NULL DEFAULT NULL AFTER `extra_info`;

CREATE INDEX `idx_mirrors_isbanned` ON `ss13_ban_mirrors` (
  `deleted_at`,
  `ckey`,
  `ip`,
  `computerid`
);

CREATE INDEX `idx_mirrors_select` ON `ss13_ban_mirrors` (
  `deleted_at`,
  `ban_id`
);

CREATE INDEX `idx_ban_isbanned` ON `ss13_ban` (
  `unbanned`,
  `bantype`,
  `expiration_time`,
  `ckey`,
  `computerid`,
  `ip`
);
