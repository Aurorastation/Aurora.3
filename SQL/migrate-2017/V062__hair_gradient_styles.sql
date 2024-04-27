--
-- Implemented in PR #10718.
-- Adds a `Hair Gradient Style and Hair Gradient Color` columns for hair gradient preferences.
--

ALTER TABLE `ss13_characters`
	ADD COLUMN `grad_colour` varchar(7) DEFAULT NULL AFTER `facial_colour`,
  ADD COLUMN `gradient_style` varchar(32) DEFAULT NULL AFTER `facial_style`;
