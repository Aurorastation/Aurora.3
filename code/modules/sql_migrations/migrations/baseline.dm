
/datum/sql_migration/v001
	version = 1
	migration_data = list({"CREATE TABLE `ss13_migrations` (
		`version_number` INT UNSIGNED NOT NULL,
		`is_successful` TINYINT(1) DEFAULT '0',
		PRIMARY KEY (`version_number`)
	) ENGINE=InnoDB DEFAULT CHARSET=utf8"})
