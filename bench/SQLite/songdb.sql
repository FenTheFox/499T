DROP TABLE IF EXISTS `albums`;

CREATE TABLE `albums` (
  `id` int(11) NOT NULL DEFAULT '0',
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS `artists`;

CREATE TABLE `artists` (
  `id` varchar(20) NOT NULL DEFAULT '',
  `name` varchar(255) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS `songs`;

CREATE TABLE `songs` (
  `id` varchar(20) NOT NULL DEFAULT '',
  `duration` double DEFAULT NULL,
  `loudness` double DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `year` int(11) DEFAULT NULL,
  `albumid` int(11) NOT NULL,
  `artistid` varchar(20) NOT NULL,
  `ratings` int(11) DEFAULT NULL,
  `plays` int(11) DEFAULT NULL,
  `avg_rating_age` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `song_album` FOREIGN KEY (`albumid`) REFERENCES `albums` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `song_artist` FOREIGN KEY (`artistid`) REFERENCES `artists` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS `tags`;

CREATE TABLE `tags` (
  `songid` varchar(20) NOT NULL DEFAULT '',
  `tag` varchar(100) NOT NULL DEFAULT '',
  `weight` double DEFAULT NULL,
  PRIMARY KEY (`songid`,`tag`),
  CONSTRAINT `tags_songid` FOREIGN KEY (`songid`) REFERENCES `songs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` varchar(26) NOT NULL DEFAULT '',
  `name` varchar(26) NOT NULL,
  `password` varchar(20) NOT NULL,
  `age` int(11) DEFAULT NULL,
  `gender` varchar(20) DEFAULT NULL,
  `location` varchar(20) DEFAULT NULL,
  `plays` int(11) NOT NULL DEFAULT '0',
  `ratings` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS `usersongplays`;

CREATE TABLE `usersongplays` (
  `userid` varchar(255) NOT NULL DEFAULT '',
  `songid` varchar(20) NOT NULL DEFAULT '',
  `plays` int(11) DEFAULT NULL,
  PRIMARY KEY (`userid`,`songid`),
  CONSTRAINT `usp_userid` FOREIGN KEY (`userid`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `usp_songid` FOREIGN KEY (`songid`) REFERENCES `songs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS `usersongratings`;

CREATE TABLE `usersongratings` (
  `userid` varchar(26) NOT NULL,
  `songid` varchar(20) NOT NULL,
  `rating` int(11) DEFAULT NULL,
  PRIMARY KEY (`userid`,`songid`),
  CONSTRAINT `usr_userid` FOREIGN KEY (`userid`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `usr_songid` FOREIGN KEY (`songid`) REFERENCES `songs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
);