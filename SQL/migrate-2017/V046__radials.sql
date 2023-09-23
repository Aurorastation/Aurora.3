--
-- Adds support for underwear updates in PR #8710.
-- What else do you think this does?
-- 

ALTER TABLE `ss13_player_preferences`
    ADD `tooltip_style` ENUM('Midnight', 'Plasmafire', 'Retro', 'Slimecore', 'Operative', 'Clockwork') NULL DEFAULT 'Midnight';
