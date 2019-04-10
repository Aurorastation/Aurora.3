CREATE TABLE `ss13_webhooks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `url` longtext NOT NULL,
  `tags` longtext NOT NULL,
  `mention` varchar(32),
  `dateadded` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
);
