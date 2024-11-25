--
-- Fixes death saving again by removing the foreign key constraints on the ckeys. (sometimes chey can contain things that arnt ckeys. i.e. @ckey when someone aghosts)
--
CREATE TABLE cargo_item_order_log (
    id SERIAL PRIMARY KEY,
    cargo_orderlog_id,
    item_name,
    amount,
    FOREIGN KEY (cargo_orderlog_id) REFERENCES ss13_cargo_orderlog (order_id) ON DELETE CASCADE
);

