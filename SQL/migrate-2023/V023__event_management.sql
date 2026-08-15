-- PR: -----------

CREATE TABLE `ss13_arcs` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(64) NOT NULL UNIQUE,
    `description` VARCHAR(512) NOT NULL,
    `started_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `finished_at` DATETIME NULL
);

CREATE TABLE `ss13_arc_decisions` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `arc_id` INT NOT NULL,
    `decision` VARCHAR(128) NOT NULL,
    `result` VARCHAR(512) NOT NULL,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `game_id` VARCHAR(30) NOT NULL,
    CONSTRAINT `fk_arc_decisions_arcs` FOREIGN KEY (`arc_id`) REFERENCES `ss13_arcs` (`id`)
);
