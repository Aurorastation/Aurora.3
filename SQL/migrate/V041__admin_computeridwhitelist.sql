--
-- Creates the table to whitelist admins based on their computerid
--

CREATE TABLE `ss13_admin_computerid` (
	`ckey` VARCHAR(32) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`computerid` VARCHAR(32) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	PRIMARY KEY (`ckey`, `computerid`)
)
COLLATE='utf8mb4_unicode_ci'
ENGINE=InnoDB
;

INSERT INTO ss13_admin_computerid (ckey,computerid) SELECT ckey, computerid FROM ss13_player WHERE rank != "player" ON DUPLICATE KEY UPDATE ss13_admin_computerid.ckey=ss13_admin_computerid.ckey;