-- Updates to existing objects table
ALTER TABLE `ss13_persistent_objects` MODIFY COLUMN `x` INT NOT NULL;
ALTER TABLE `ss13_persistent_objects` MODIFY COLUMN `y` INT NOT NULL;
ALTER TABLE `ss13_persistent_objects` MODIFY COLUMN `z` INT NOT NULL;
ALTER TABLE `ss13_persistent_objects` MODIFY COLUMN `content` MEDIUMTEXT NULL;

-- New persistent content types - Generics and records
CREATE TABLE `ss13_persistent_type_definitions` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `type` VARCHAR(128) NOT NULL UNIQUE,
    `description` VARCHAR(256) NOT NULL,
    `definition_type` INT NOT NULL COMMENT '1 = GENERIC, 2 = HISTORY'
);

CREATE TABLE `ss13_persistent_generics` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `type` INT NOT NULL,
    `attribute` VARCHAR(64) NULL,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `expires_at` DATETIME NOT NULL,
    `content` MEDIUMTEXT NOT NULL,
    CONSTRAINT `fk_generics_type_definition` FOREIGN KEY (`type`) REFERENCES `ss13_persistent_type_definitions` (`id`),
    CONSTRAINT `unique_generics_type_attribute` UNIQUE (`type`, `attribute`),
    INDEX `idx_generics_attribute` (`attribute`),
    INDEX `idx_generics_expires_at` (`expires_at`)
);

CREATE TABLE `ss13_persistent_history` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `type` INT NOT NULL,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `attribute` VARCHAR(64) NULL,
    `value` VARCHAR(64) NOT NULL,
    `game_id` VARCHAR(30) NOT NULL,
    CONSTRAINT `fk_history_type_definition` FOREIGN KEY (`type`) REFERENCES `ss13_persistent_type_definitions` (`id`),
    CONSTRAINT `unique_history_created_value` UNIQUE (`created_at`, `value`),
    INDEX `idx_history_created_at` (`created_at`),
    INDEX `idx_history_attribute` (`attribute`)
);
