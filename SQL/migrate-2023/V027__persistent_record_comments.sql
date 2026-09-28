CREATE TABLE `ss13_character_record_comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `char_id` int(11) NOT NULL,
  `UID` varchar(32) NOT NULL,
  `record_type` varchar(16) NOT NULL,
  `body` mediumtext NOT NULL,
  `author` varchar(100) NOT NULL,
  `created_by` varchar(32) DEFAULT NULL,
  `updated_by` varchar(32) DEFAULT NULL,
  `deleted_by` varchar(32) DEFAULT NULL,
  `game_id` varchar(50) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UID_char_id` (`char_id`, `UID`),
  KEY `record_type` (`record_type`),
  CONSTRAINT `FK_ss13_character_record_comments_ss13_characters`
    FOREIGN KEY (`char_id`) REFERENCES `ss13_characters` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
