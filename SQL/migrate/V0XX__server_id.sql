--
-- Adds a server_id to the relevant tables
--
ALTER TABLE `ss13_ban`
	ADD COLUMN `server_id` TINYINT UNSIGNED NULL DEFAULT NULL AFTER `unbanned_ip`,
	ADD COLUMN `server_id_created` TINYINT UNSIGNED NULL DEFAULT NULL AFTER `server_id`;

ALTER TABLE `ss13_cargo_categories`
	ADD COLUMN `server_id` TINYINT UNSIGNED NULL DEFAULT NULL AFTER `deleted_at`;

ALTER TABLE `ss13_cargo_items`
	ADD COLUMN `server_id` TINYINT UNSIGNED NULL DEFAULT NULL AFTER `path_old`;

ALTER TABLE `ss13_cargo_suppliers`
	ADD COLUMN `server_id` TINYINT UNSIGNED NULL DEFAULT NULL AFTER `deleted_at`;

ALTER TABLE `ss13_character_incidents`
	ADD COLUMN `server_id` TINYINT UNSIGNED NULL DEFAULT NULL AFTER `deleted_at`,
	ADD COLUMN `server_id_created` TINYINT UNSIGNED NULL DEFAULT NULL AFTER `server_id`;

ALTER TABLE `ss13_connection_log`
	ADD COLUMN `server_id_created` TINYINT UNSIGNED NULL DEFAULT NULL AFTER `byond_build`;

ALTER TABLE `ss13_death`
	ADD COLUMN `server_id_created` TINYINT UNSIGNED NULL DEFAULT NULL AFTER `oxyloss`;

ALTER TABLE `ss13_feedback`
	ADD COLUMN `server_id_created` TINYINT UNSIGNED NULL DEFAULT NULL AFTER `details`;

ALTER TABLE `ss13_law`
	ADD COLUMN `server_id` TINYINT UNSIGNED NULL DEFAULT NULL AFTER `deleted_at`;

ALTER TABLE `ss13_news_channels`
	ADD COLUMN `server_id` TINYINT UNSIGNED NULL DEFAULT NULL AFTER `deleted_at`;

ALTER TABLE `ss13_news_stories`
	ADD COLUMN `server_id` TINYINT UNSIGNED NULL DEFAULT NULL AFTER `deleted_at`;

ALTER TABLE `ss13_notes`
	ADD COLUMN `server_id` TINYINT UNSIGNED NULL DEFAULT NULL AFTER `lasteditdate`,
	ADD COLUMN `server_id_created` TINYINT UNSIGNED NULL DEFAULT NULL AFTER `server_id`;

ALTER TABLE `ss13_population`
	ADD COLUMN `server_id_created` TINYINT UNSIGNED NULL DEFAULT NULL AFTER `time`;

ALTER TABLE `ss13_tickets`
	ADD COLUMN `server_id_created` TINYINT UNSIGNED NULL DEFAULT NULL AFTER `closed_at`;

ALTER TABLE `ss13_warnings`
	ADD COLUMN `server_id` TINYINT UNSIGNED NULL DEFAULT NULL AFTER `lasteditdate`,
	ADD COLUMN `server_id_created` TINYINT UNSIGNED NULL DEFAULT NULL AFTER `server_id`;