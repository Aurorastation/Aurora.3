--
-- Removes the Random Job Option
--

UPDATE ss13_characters SET alternate_option = 0 WHERE alternate_option = 1;
UPDATE ss13_characters SET alternate_option = 1 WHERE alternate_option = 2;