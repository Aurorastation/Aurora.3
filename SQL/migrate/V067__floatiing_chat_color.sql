--
-- Add a new floating chat color field
-- 

ALTER TABLE `ss13_characters`
	ADD COLUMN `floating_chat_color` char(7) DEFAULT NULL AFTER `pronouns`