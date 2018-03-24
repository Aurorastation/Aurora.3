--
-- Implemented in PR #4432
-- Adds a table for gathering statistics regarding tickets.
--

CREATE TABLE `ss13_tickets` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `game_id` VARCHAR(32) NOT NULL,
  `message_count` INT(11) NOT NULL,
  `admin_count` INT(11) NOT NULL,
  `admin_list` TEXT NOT NULL,
  `opened_by` VARCHAR(32) NOT NULL,
  `taken_by` VARCHAR(32) NOT NULL,
  `closed_by` VARCHAR(32) NOT NULL,
  `response_delay` INT(11) NOT NULL,
  `opened_at` DATETIME NOT NULL,
  `closed_at` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `tickets_fk_opened` FOREIGN KEY (`opened_by`) REFERENCES `ss13_player` (`ckey`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tickets_fk_taken` FOREIGN KEY (`taken_by`) REFERENCES `ss13_player` (`ckey`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tickets_fk_closed` FOREIGN KEY (`closed_by`) REFERENCES `ss13_player` (`ckey`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
