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
  KEY `comment_page` (`char_id`, `record_type`, `deleted_at`, `created_at`, `id`),
  KEY `created_by` (`created_by`),
  KEY `updated_by` (`updated_by`),
  KEY `deleted_by` (`deleted_by`),
  CONSTRAINT `FK_ss13_character_record_comments_ss13_player_created_by`
    FOREIGN KEY (`created_by`) REFERENCES `ss13_player` (`ckey`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `FK_ss13_character_record_comments_ss13_player_updated_by`
    FOREIGN KEY (`updated_by`) REFERENCES `ss13_player` (`ckey`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `FK_ss13_character_record_comments_ss13_player_deleted_by`
    FOREIGN KEY (`deleted_by`) REFERENCES `ss13_player` (`ckey`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `FK_ss13_character_record_comments_ss13_characters`
    FOREIGN KEY (`char_id`) REFERENCES `ss13_characters` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
