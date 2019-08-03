--
-- Create the Custom Synths database.
--

CREATE TABLE `ss13_customsynths` (
	`id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`synthckey` varchar(32) NOT NULL,
	`synthicon` VARCHAR(26) NOT NULL,
	`ainame` VARCHAR(100) NOT NULL,
	`aichassisicon` VARCHAR(100) NOT NULL,
	`aiholoicon` VARCHAR(100) NOT NULL,
	`paiicon` VARCHAR(100) NOT NULL,
	PRIMARY KEY (`id`),
    CONSTRAINT `fk_ss13_custom_synths_ss13_players` FOREIGN KEY (`synthckey`) REFERENCES `ss13_player` (`ckey`) ON DELETE CASCADE ON UPDATE CASCADE
)
COLLATE='utf8_bin'
ENGINE=InnoDB
;
