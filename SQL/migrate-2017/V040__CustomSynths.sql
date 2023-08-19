--
-- Create the Custom Synths database.
--

CREATE TABLE `ss13_customsynths` (
    `synthname` VARCHAR(128) NOT NULL,
    `synthckey` varchar(32) CHARACTER SET latin1 NOT NULL,
    `synthicon` VARCHAR(26) NOT NULL,
    `aichassisicon` VARCHAR(100) NOT NULL,
    `aiholoicon` VARCHAR(100) NOT NULL,
    `paiicon` VARCHAR(100) NOT NULL,
    PRIMARY KEY (`synthname`),
    CONSTRAINT `fk_ss13_custom_synths_ss13_players` FOREIGN KEY (`synthckey`) REFERENCES `ss13_player` (`ckey`) ON DELETE CASCADE ON UPDATE CASCADE
)
ENGINE=InnoDB
;
