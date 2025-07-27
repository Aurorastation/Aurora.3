CREATE TABLE ss13_persistent_data (
    id INT NOT NULL AUTO_INCREMENT,
    author_ckey VARCHAR(32) NOT NULL,
    type VARCHAR(32) NOT NULL,
    created_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL,
    expires_at DATETIME NULL,
    content JSON NOT NULL,
    PRIMARY KEY (id),
    INDEX idx_expireDate (expireDate)
);
