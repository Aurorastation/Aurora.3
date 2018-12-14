--
-- Create the Documents database.
--

CREATE TABLE `ss13_documents` (
	`name` VARCHAR(100) NOT NULL COLLATE 'utf8_bin',
	`title` VARCHAR(26) NOT NULL COLLATE 'utf8_bin',
	`chance` FLOAT UNSIGNED NOT NULL DEFAULT '1',
	`content` VARCHAR(3072) NOT NULL COLLATE 'utf8_bin',
	`tags` VARCHAR(1024) NOT NULL COLLATE 'utf8_bin',
	PRIMARY KEY (`name`)
)
COLLATE='utf8_bin'
ENGINE=InnoDB
;
