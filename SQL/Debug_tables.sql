-- These are tables used only for debugging/profiling.
-- They are not needed for normal server running.

CREATE TABLE `ss13dbg_lighting` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`time` INT(11) NULL DEFAULT NULL COMMENT 'World time (in ticks)',
	`type` VARCHAR(50) NULL DEFAULT NULL COMMENT 'The type of the update.',
	`name` VARCHAR(50) NULL DEFAULT NULL COMMENT 'The callee\'s name.',
	`loc_name` VARCHAR(50) NULL DEFAULT NULL COMMENT 'The callee\'s location.',
	`x` INT(11) NULL DEFAULT NULL,
	`y` INT(11) NULL DEFAULT NULL,
	`z` INT(11) NULL DEFAULT NULL,
	PRIMARY KEY (`id`)
)
COLLATE='utf8_general_ci'
ENGINE=MEMORY;