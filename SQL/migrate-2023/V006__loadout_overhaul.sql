--
-- Overhauls the way the loadout is stored
--
-- --------------------------------------------------------
-- Server version:               10.11.5
-- Server OS:                    debian-linux-gnu
-- HeidiSQL Version:             12.3.0.6589
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- Dumping structure for procedure convert_characters_gear
DELIMITER //
CREATE PROCEDURE `convert_characters_gear`(
    IN `parameter_char_id` INT
)
    MODIFIES SQL DATA
    SQL SECURITY INVOKER
    COMMENT 'Converts the character gear from the V1 (only one gear set) and V2 (multiple gear sets) storage formats to the ss13_characters_gear table'
BEGIN
    DECLARE info_gear_version VARCHAR(50) DEFAULT NULL;
    DECLARE value_fetch_geardata MEDIUMTEXT DEFAULT NULL;

   DECLARE EXIT HANDLER FOR SQLEXCEPTION
     BEGIN
         ROLLBACK;
     END;

    SELECT gear INTO value_fetch_geardata FROM ss13_characters WHERE id = parameter_char_id;

    IF JSON_VALID(value_fetch_geardata) THEN
        SET info_gear_version = "valid json";

        IF JSON_CONTAINS_PATH(value_fetch_geardata, 'one', '$.1','$.2','$.3') THEN
            SET info_gear_version = "version 2";

            START TRANSACTION;
                DELETE FROM ss13_characters_gear WHERE char_id = parameter_char_id;

                IF JSON_CONTAINS_PATH(value_fetch_geardata, 'one', '$.1') THEN
                    CALL `convert_characters_gear_step2`(parameter_char_id, 1, JSON_EXTRACT(value_fetch_geardata, '$.1'));
                END IF;

                IF JSON_CONTAINS_PATH(value_fetch_geardata, 'one', '$.2') THEN
                    CALL `convert_characters_gear_step2`(parameter_char_id, 2, JSON_EXTRACT(value_fetch_geardata, '$.2'));
                END IF;

                IF JSON_CONTAINS_PATH(value_fetch_geardata, 'one', '$.3') THEN
                    CALL `convert_characters_gear_step2`(parameter_char_id, 3, JSON_EXTRACT(value_fetch_geardata, '$.3'));
                END IF;
            COMMIT;

        ELSE
            SET info_gear_version = "version 1";
            START TRANSACTION;
                DELETE FROM ss13_characters_gear WHERE char_id = parameter_char_id;
                CALL `convert_characters_gear_step2`(parameter_char_id, 1, value_fetch_geardata);
            COMMIT;
        END IF;

    ELSE
        SET info_gear_version = "invalid";
    END IF;

END//
DELIMITER ;

-- Dumping structure for procedure convert_characters_gear_all
DELIMITER //
CREATE PROCEDURE `convert_characters_gear_all`()
    MODIFIES SQL DATA
    SQL SECURITY INVOKER
    COMMENT 'Runs convert_characters_gear for all characters'
BEGIN
  DECLARE done BOOLEAN DEFAULT FALSE;
  DECLARE _id BIGINT UNSIGNED;
  DECLARE cur CURSOR FOR SELECT id FROM ss13_characters;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done := TRUE;

  OPEN cur;

  charLoop: LOOP
    FETCH cur INTO _id;
    IF done THEN
      LEAVE charLoop;
    END IF;
    CALL convert_characters_gear(_id);
  END LOOP charLoop;

  CLOSE cur;
END//
DELIMITER ;

-- Dumping structure for procedure convert_characters_gear_step2
DELIMITER //
CREATE PROCEDURE `convert_characters_gear_step2`(
    IN `parameter_char_id` INT,
    IN `parameter_gear_slot_id` INT,
    IN `parameter_gear_string` MEDIUMTEXT
)
    MODIFIES SQL DATA
    SQL SECURITY INVOKER
    COMMENT 'Converts a characters gear to the new (v3) storage system. Requires a char id, the current gear_slot and and the gear string to convert'
BEGIN
    INSERT INTO ss13_characters_gear (char_id, slot, NAME, tweaks)
    SELECT
        parameter_char_id AS char_id,
        parameter_gear_slot_id AS gear_slot,
        JSON_UNQUOTE(JSON_EXTRACT(JSON_KEYS(parameter_gear_string), CONCAT('$[', geardata.rowid-1, ']'))) AS gearname,
        IF(STRCMP(geardata.geartweaks,'null')=0,NULL,geardata.geartweaks)
    FROM JSON_TABLE(parameter_gear_string, '$.*' COLUMNS (
         rowid FOR ORDINALITY,
        geartweaks JSON PATH '$'
    )) geardata;
END//
DELIMITER ;

-- Dumping structure for table ss13_characters_gear
CREATE TABLE IF NOT EXISTS `ss13_characters_gear` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `char_id` int(11) NOT NULL,
  `slot` tinyint(4) NOT NULL,
  `name` varchar(255) NOT NULL,
  `tweaks` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `char_id_gear_slot` (`char_id`,`slot`) USING BTREE,
  CONSTRAINT `fk_ss13_characters_char_id` FOREIGN KEY (`char_id`) REFERENCES `ss13_characters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `json_valid_tweaks` CHECK (json_valid(`tweaks`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data exporting was unselected.

-- Dumping structure for procedure update_character_gear
DELIMITER //
CREATE PROCEDURE `update_character_gear`(
    IN `parameter_char_id` INT,
    IN `parameter_gear_slot_id` INT,
    IN `parameter_gear_string` MEDIUMTEXT
)
    MODIFIES SQL DATA
    SQL SECURITY INVOKER
    COMMENT 'Updates a specific gear slot of a character to the supplied gear string'
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
     BEGIN
         ROLLBACK;
     END;

    START TRANSACTION;

    DELETE FROM ss13_characters_gear WHERE char_id = parameter_char_id AND slot = parameter_gear_slot_id;

    INSERT INTO ss13_characters_gear (char_id, slot, NAME, tweaks)
    SELECT
        parameter_char_id AS char_id,
        parameter_gear_slot_id AS gear_slot,
        JSON_UNQUOTE(JSON_EXTRACT(JSON_KEYS(parameter_gear_string), CONCAT('$[', geardata.rowid-1, ']'))) AS gearname,
        IF(STRCMP(geardata.geartweaks,'null')=0,NULL,geardata.geartweaks)
    FROM JSON_TABLE(parameter_gear_string, '$.*' COLUMNS (
         rowid FOR ORDINALITY,
        geartweaks JSON PATH '$'
    )) geardata;

    COMMIT;
END//
DELIMITER ;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
