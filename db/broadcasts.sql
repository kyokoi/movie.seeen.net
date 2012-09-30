CREATE TABLE `broadcasts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `movie_id` int(11) DEFAULT NULL,
  `program` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `provider` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `onair_at` datetime NOT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  `negative` tinyint(1) DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci
