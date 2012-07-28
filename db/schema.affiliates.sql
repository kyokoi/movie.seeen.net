DROP TABLE IF EXISTS `affiliates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `affiliates` (
  `id` int(11) NOT NULL auto_increment,
  `movie_id` int(11) NOT NULL,
  `name` varchar(255) collate utf8_unicode_ci NOT NULL default '',
  `url` varchar(255) collate utf8_unicode_ci NOT NULL default '',
  `order_by` int(11) NOT NULL default 1,
  `negative` tinyint(1) default '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

