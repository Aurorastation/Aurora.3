-- These are tables used only for debugging/profiling.
-- They are not needed for normal server operation.

CREATE TABLE `ss13dbg_lighting` (
	`id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`time` INT(11) UNSIGNED NULL DEFAULT NULL COMMENT 'World time (in ticks)',
	`tick_usage` DOUBLE UNSIGNED NULL DEFAULT NULL,
	`type` VARCHAR(32) NULL DEFAULT NULL COMMENT 'The type of the update.' COLLATE 'latin1_bin',
	`name` VARCHAR(50) NULL DEFAULT NULL COMMENT 'The callee\'s name.' COLLATE 'latin1_bin',
	`loc_name` VARCHAR(50) NULL DEFAULT NULL COMMENT 'The callee\'s location.' COLLATE 'latin1_bin',
	`x` SMALLINT(6) NULL DEFAULT NULL,
	`y` SMALLINT(6) NULL DEFAULT NULL,
	`z` SMALLINT(6) NULL DEFAULT NULL,
	PRIMARY KEY (`id`)
)
COLLATE='latin1_bin'
ENGINE=MEMORY
ROW_FORMAT=FIXED;
