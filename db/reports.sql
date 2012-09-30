CREATE TABLE `reports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `author_id` int(11) DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  `status` tinyint(1) DEFAULT '0',
  `resolver_id` int(11) DEFAULT NULL,
  `negative` tinyint(1) DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci
