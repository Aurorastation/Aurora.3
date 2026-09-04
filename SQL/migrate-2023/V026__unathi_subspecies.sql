--
-- PR #23092 renamed the standard Unathi species to Azaziba Unathi.
-- Migrate existing characters to the new species name before load validation.
--

UPDATE `ss13_characters`
  SET `species` = 'Azaziba Unathi'
  WHERE `species` = 'Unathi';
