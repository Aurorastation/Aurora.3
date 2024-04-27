--
-- Implemented in PR #16169.
-- Adds a speech bubble pref.
-- 

ALTER TABLE `ss13_characters` ADD COLUMN `speech_bubble_type` VARCHAR(16) DEFAULT NULL AFTER `floating_chat_color`;