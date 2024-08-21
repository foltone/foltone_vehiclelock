CREATE TABLE IF NOT EXISTS `key_vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` varchar(255) DEFAULT NULL,
  `plate` varchar(255) DEFAULT NULL,
  `label` varchar(255) DEFAULT NULL,
  `temporary` tinyint(1) DEFAULT NULL,
  `job` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=latin1;
