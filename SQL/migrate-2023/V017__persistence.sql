CREATE TABLE ss13_persistent_data (
    id INT NOT NULL AUTO_INCREMENT,
    author_ckey VARCHAR(32) NULL,
    type VARCHAR(128) NOT NULL,
    created_at DATETIME NOT NULL,
    expires_at DATETIME NOT NULL,
    content MEDIUMTEXT NOT NULL,
    x INT NULL,
    y INT NULL,
    z INT NULL,
    PRIMARY KEY (id),
    INDEX idx_expireDate (expires_at)
);
