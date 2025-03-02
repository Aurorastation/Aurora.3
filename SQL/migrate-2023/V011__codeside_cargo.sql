--
-- Creates a new cargo order table for use with new codeside cargo (#20030)
--

ALTER TABLE ss13_cargo_orderlog
    ADD INDEX (id);

CREATE TABLE  IF NOT EXISTS `ss13_cargo_item_orderlog` (
    id SERIAL PRIMARY KEY,
    cargo_orderlog_id INT(10) UNSIGNED NOT NULL,
    item_name VARCHAR(255) NOT NULL,
    amount INT NOT NULL,
    FOREIGN KEY (cargo_orderlog_id) REFERENCES ss13_cargo_orderlog (id) ON DELETE CASCADE
);
