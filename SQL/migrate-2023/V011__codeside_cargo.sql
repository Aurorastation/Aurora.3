--
-- Creates a new cargo order table for use with new codeside cargo (#20030)
--

ALTER TABLE ss13_cargo_orderlog
    ADD INDEX (order_id);

CREATE TABLE  IF NOT EXISTS `cargo_item_order_log` (
    id SERIAL PRIMARY KEY, -- Automatically creates an auto-incrementing unique identifier
    cargo_orderlog_id INT(11), -- Replace INT with the correct data type for this column if needed
    item_name VARCHAR(255) NOT NULL, -- Replace VARCHAR(255) with the correct data type/length
    amount INT NOT NULL, -- Replace INT with the correct data type if needed
    FOREIGN KEY (cargo_orderlog_id) REFERENCES ss13_cargo_orderlog (order_id) ON DELETE CASCADE
);
