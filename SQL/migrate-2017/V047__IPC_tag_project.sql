--
-- Reworks how IPC tags work in PR #6973.
-- This drops the old ss13_ipc_tracking table in favour of ss13_characters_ipc_tags with new fresh information.
-- 

DROP TABLE `ss13_ipc_tracking`;

CREATE TABLE `ss13_characters_ipc_tags` (
  `char_id` int(11) NOT NULL,
  `tag_status` tinyint(1) NOT NULL DEFAULT '0',
  `serial_number` varchar(12) DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
  `ownership_status` enum('Self Owned','Company Owned','Privately Owned') DEFAULT 'Company Owned' COLLATE 'utf8mb4_unicode_ci',
  PRIMARY KEY (`char_id`),
  CONSTRAINT `char_id` FOREIGN KEY (`char_id`) REFERENCES `ss13_characters` (`id`) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB COLLATE='utf8mb4_unicode_ci';