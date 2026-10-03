-- Adds the character quirk selection and migrates the retired disability list
-- into the canonical path-keyed quirk format used by character preferences.
ALTER TABLE `ss13_characters`
  ADD COLUMN `quirks` LONGTEXT DEFAULT NULL AFTER `skills`,
  ADD CONSTRAINT `chk_quirks_json_valid` CHECK (`quirks` IS NULL OR JSON_VALID(`quirks`));

UPDATE `ss13_characters`
SET `quirks` = JSON_OBJECT()
WHERE `disabilities` IS NOT NULL
  AND JSON_VALID(`disabilities`)
  AND JSON_TYPE(`disabilities`) = 'ARRAY';

UPDATE `ss13_characters` SET `quirks` = JSON_SET(`quirks`, '$."/singleton/quirk/nearsighted"', TRUE) WHERE JSON_CONTAINS(`disabilities`, JSON_QUOTE('Nearsightedness'), '$');
UPDATE `ss13_characters` SET `quirks` = JSON_SET(`quirks`, '$."/singleton/quirk/stutter"', TRUE) WHERE JSON_CONTAINS(`disabilities`, JSON_QUOTE('Stuttering'), '$');
UPDATE `ss13_characters` SET `quirks` = JSON_SET(`quirks`, '$."/singleton/quirk/deuteranopia"', TRUE) WHERE JSON_CONTAINS(`disabilities`, JSON_QUOTE('Deuteranopia'), '$');
UPDATE `ss13_characters` SET `quirks` = JSON_SET(`quirks`, '$."/singleton/quirk/protanopia"', TRUE) WHERE JSON_CONTAINS(`disabilities`, JSON_QUOTE('Protanopia'), '$');
UPDATE `ss13_characters` SET `quirks` = JSON_SET(`quirks`, '$."/singleton/quirk/tritanopia"', TRUE) WHERE JSON_CONTAINS(`disabilities`, JSON_QUOTE('Tritanopia'), '$');
UPDATE `ss13_characters` SET `quirks` = JSON_SET(`quirks`, '$."/singleton/quirk/total_colorblind"', TRUE) WHERE JSON_CONTAINS(`disabilities`, JSON_QUOTE('Total Colorblindness'), '$');
UPDATE `ss13_characters` SET `quirks` = JSON_SET(`quirks`, '$."/singleton/quirk/deaf"', TRUE) WHERE JSON_CONTAINS(`disabilities`, JSON_QUOTE('Deafness'), '$');
UPDATE `ss13_characters` SET `quirks` = JSON_SET(`quirks`, '$."/singleton/quirk/asthma"', TRUE) WHERE JSON_CONTAINS(`disabilities`, JSON_QUOTE('Asthma'), '$');
UPDATE `ss13_characters` SET `quirks` = JSON_SET(`quirks`, '$."/singleton/quirk/hemophilia"', TRUE) WHERE JSON_CONTAINS(`disabilities`, JSON_QUOTE('Hemophilia'), '$');
UPDATE `ss13_characters` SET `quirks` = JSON_SET(`quirks`, '$."/singleton/quirk/hemophilia/major"', TRUE) WHERE JSON_CONTAINS(`disabilities`, JSON_QUOTE('Major Hemophilia'), '$');

UPDATE `ss13_characters` SET `quirks` = JSON_SET(`quirks`, '$."/singleton/quirk/organ_scarring/brain"', TRUE) WHERE JSON_CONTAINS(`disabilities`, JSON_QUOTE('Scarred Organ: Brain'), '$');
UPDATE `ss13_characters` SET `quirks` = JSON_SET(`quirks`, '$."/singleton/quirk/organ_scarring/eyes"', TRUE) WHERE JSON_CONTAINS(`disabilities`, JSON_QUOTE('Scarred Organ: Eyes'), '$');
UPDATE `ss13_characters` SET `quirks` = JSON_SET(`quirks`, '$."/singleton/quirk/organ_scarring/lungs"', TRUE) WHERE JSON_CONTAINS(`disabilities`, JSON_QUOTE('Scarred Organ: Lungs'), '$');
UPDATE `ss13_characters` SET `quirks` = JSON_SET(`quirks`, '$."/singleton/quirk/organ_scarring/liver"', TRUE) WHERE JSON_CONTAINS(`disabilities`, JSON_QUOTE('Scarred Organ: Liver'), '$');
UPDATE `ss13_characters` SET `quirks` = JSON_SET(`quirks`, '$."/singleton/quirk/organ_scarring/kidneys"', TRUE) WHERE JSON_CONTAINS(`disabilities`, JSON_QUOTE('Scarred Organ: Kidneys'), '$');
UPDATE `ss13_characters` SET `quirks` = JSON_SET(`quirks`, '$."/singleton/quirk/organ_scarring/stomach"', TRUE) WHERE JSON_CONTAINS(`disabilities`, JSON_QUOTE('Scarred Organ: Stomach'), '$');
UPDATE `ss13_characters` SET `quirks` = JSON_SET(`quirks`, '$."/singleton/quirk/organ_scarring/appendix"', TRUE) WHERE JSON_CONTAINS(`disabilities`, JSON_QUOTE('Scarred Organ: Appendix'), '$');

UPDATE `ss13_characters` SET `quirks` = JSON_SET(`quirks`, '$."/singleton/quirk/broken/left_arm"', TRUE) WHERE JSON_CONTAINS(`disabilities`, JSON_QUOTE('Broken Limb: Left Arm'), '$');
UPDATE `ss13_characters` SET `quirks` = JSON_SET(`quirks`, '$."/singleton/quirk/broken/right_arm"', TRUE) WHERE JSON_CONTAINS(`disabilities`, JSON_QUOTE('Broken Limb: Right Arm'), '$');
UPDATE `ss13_characters` SET `quirks` = JSON_SET(`quirks`, '$."/singleton/quirk/broken/left_hand"', TRUE) WHERE JSON_CONTAINS(`disabilities`, JSON_QUOTE('Broken Limb: Left Hand'), '$');
UPDATE `ss13_characters` SET `quirks` = JSON_SET(`quirks`, '$."/singleton/quirk/broken/right_hand"', TRUE) WHERE JSON_CONTAINS(`disabilities`, JSON_QUOTE('Broken Limb: Right Hand'), '$');
UPDATE `ss13_characters` SET `quirks` = JSON_SET(`quirks`, '$."/singleton/quirk/broken/left_leg"', TRUE) WHERE JSON_CONTAINS(`disabilities`, JSON_QUOTE('Broken Limb: Left Leg'), '$');
UPDATE `ss13_characters` SET `quirks` = JSON_SET(`quirks`, '$."/singleton/quirk/broken/right_leg"', TRUE) WHERE JSON_CONTAINS(`disabilities`, JSON_QUOTE('Broken Limb: Right Leg'), '$');
UPDATE `ss13_characters` SET `quirks` = JSON_SET(`quirks`, '$."/singleton/quirk/broken/left_foot"', TRUE) WHERE JSON_CONTAINS(`disabilities`, JSON_QUOTE('Broken Limb: Left Foot'), '$');
UPDATE `ss13_characters` SET `quirks` = JSON_SET(`quirks`, '$."/singleton/quirk/broken/right_foot"', TRUE) WHERE JSON_CONTAINS(`disabilities`, JSON_QUOTE('Broken Limb: Right Foot'), '$');

UPDATE `ss13_characters` SET `quirks` = JSON_SET(`quirks`, '$."/singleton/quirk/psi_sensitivity"', 'High') WHERE JSON_CONTAINS(`disabilities`, JSON_QUOTE('High Psi-sensitivity'), '$');
UPDATE `ss13_characters` SET `quirks` = JSON_SET(`quirks`, '$."/singleton/quirk/psi_sensitivity"', 'Low') WHERE JSON_CONTAINS(`disabilities`, JSON_QUOTE('Low Psi-sensitivity'), '$');
UPDATE `ss13_characters` SET `quirks` = JSON_SET(`quirks`, '$."/singleton/quirk/photosensitivity"', TRUE) WHERE JSON_CONTAINS(`disabilities`, JSON_QUOTE('Photosensitivity'), '$');
UPDATE `ss13_characters` SET `quirks` = JSON_SET(`quirks`, '$."/singleton/quirk/nyctophobia"', TRUE) WHERE JSON_CONTAINS(`disabilities`, JSON_QUOTE('Nyctophobia'), '$');
