--
-- Adds a new table to load news from
--
CREATE TABLE `ss13_news_channels` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(50) NOT NULL,
	`author` VARCHAR(50) NOT NULL,
	`locked` TINYINT(3) UNSIGNED NOT NULL DEFAULT '1',
	`is_admin_channel` TINYINT(3) UNSIGNED NOT NULL DEFAULT '1',
	`announcement` VARCHAR(200) NOT NULL,
	`created_by` VARCHAR(50) NOT NULL,
	`created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`deleted_at` DATETIME NULL DEFAULT NULL,
	PRIMARY KEY (`id`)
)
ENGINE=InnoDB;

CREATE TABLE `ss13_news_stories` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`channel_id` INT(11) NOT NULL,
	`author` VARCHAR(50) NOT NULL,
	`body` TEXT NOT NULL,
	`message_type` VARCHAR(50) NOT NULL DEFAULT 'Story',
	`is_admin_message` TINYINT(3) UNSIGNED NOT NULL DEFAULT '1',
	`time_stamp` DATETIME NULL DEFAULT NULL,
	`created_by` VARCHAR(50) NOT NULL,
	`created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`deleted_at` DATETIME NULL DEFAULT NULL,
	PRIMARY KEY (`id`),
	INDEX `FK_ss13_news_stories_ss13_news_channels` (`channel_id`),
	CONSTRAINT `FK_ss13_news_stories_ss13_news_channels` FOREIGN KEY (`channel_id`) REFERENCES `ss13_news_channels` (`id`)
)
ENGINE=InnoDB;