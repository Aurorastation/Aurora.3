-- Adds the character quirk selection and migrates the retired disability list.
ALTER TABLE `ss13_characters`
  ADD COLUMN `quirks` LONGTEXT DEFAULT NULL AFTER `skills`,
  ADD CONSTRAINT `chk_quirks_json_valid` CHECK (`quirks` IS NULL OR JSON_VALID(`quirks`));

UPDATE `ss13_characters`
SET `quirks` = `disabilities`
WHERE `disabilities` IS NOT NULL AND JSON_VALID(`disabilities`);
