---
--- Adds the ss13_admins SQL table again.
---

CREATE TABLE `ss13_admins` (
  `ckey` VARCHAR(50) NOT NULL,
  `rank` TEXT NOT NULL,
  `flags` INT NOT NULL,
  CONSTRAINT `FK_ss13_admins_ss13_player_ckey` FOREIGN KEY(`ckey`) REFERENCES  `ss13_player` (`ckey`) ON UPDATE CASCADE
) ENGINE=InnoDB COLLATE='utf8mb4_unicode_ci';