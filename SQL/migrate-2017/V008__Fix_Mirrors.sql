--
-- A patch to fix a field in ss13_ban_mirrors.
--

ALTER TABLE `ss13_ban_mirrors` CHANGE `id` `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT;
