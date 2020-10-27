---
--- Puts autohiss in character setup
---

ALTER TABLE `ss13_characters`
	ADD COLUMN `autohiss` TINYINT NOT NULL DEFAULT 0 AFTER `accent`;
