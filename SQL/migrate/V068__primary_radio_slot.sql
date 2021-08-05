--
-- Add a new primary radio slot field
-- 

ALTER TABLE `ss13_characters`
	ADD COLUMN `primary_radio_slot` char(9) DEFAULT 'Left Ear' AFTER `floating_chat_color`