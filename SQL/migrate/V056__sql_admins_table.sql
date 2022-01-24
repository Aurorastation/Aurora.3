--
-- Adds the ss13_admins SQL table again.
--

CREATE TABLE `ss13_admins` (
  `ckey` VARCHAR(50) NOT NULL,
  `rank` TEXT NOT NULL,
  `flags` INT NOT NULL,
  `status` TINYINT NOT NULL DEFAULT 1,
  PRIMARY KEY (`ckey`),
  CONSTRAINT `FK_ss13_admins_ss13_player_ckey` FOREIGN KEY(`ckey`) REFERENCES  `ss13_player` (`ckey`) ON UPDATE CASCADE
) ENGINE=InnoDB COLLATE='utf8mb4_unicode_ci';

ALTER TABLE `ss13_player`
  DROP COLUMN `rank`,
  DROP COLUMN `flags`;

DROP TABLE `ss13_admin_log`;
