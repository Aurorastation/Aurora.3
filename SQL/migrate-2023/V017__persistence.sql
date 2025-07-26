CREATE TABLE ss13_persistent_data (
    id INT NOT NULL AUTO_INCREMENT,
    author_ckey VARCHAR(32) NOT NULL,
    type VARCHAR(32) NOT NULL,
    created_date DATETIME NOT NULL,
    modified_date DATETIME NOT NULL,
    expire_date DATETIME NULL,
    content JSON NOT NULL,
    PRIMARY KEY (id),
    INDEX idx_expireDate (expireDate)
);
