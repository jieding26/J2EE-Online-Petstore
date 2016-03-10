# Host     : localhost
# Port     : 3306
# Database : jpetstore


SET FOREIGN_KEY_CHECKS=0;

DROP DATABASE IF EXISTS `jpetstore`;

CREATE DATABASE `jpetstore`;

USE `jpetstore`;

#
# Structure for the `account` table :
#

DROP TABLE IF EXISTS `account`;

CREATE TABLE `account` (
  `userid` varchar(80) NOT NULL,
  `email` varchar(80) NOT NULL,
  `firstname` varchar(80) NOT NULL,
  `lastname` varchar(80) NOT NULL,
  `status` varchar(2) DEFAULT NULL,
  `addr1` varchar(80) NOT NULL,
  `addr2` varchar(40) DEFAULT NULL,
  `city` varchar(80) NOT NULL,
  `state` varchar(80) NOT NULL,
  `zip` varchar(20) NOT NULL,
  `country` varchar(20) NOT NULL,
  `phone` varchar(80) NOT NULL,
  PRIMARY KEY (`userid`)
);

#
# Data for the `account` table
#

INSERT INTO `account` (`userid`, `email`, `firstname`, `lastname`, `status`, `addr1`, `addr2`, `city`, `state`, `zip`, `country`, `phone`) VALUES
  ('ACID','acid@yourdomain.com','ABC','XYX','OK','901 San Antonio Road','MS UCUP02-206','Palo Alto','CA','94303','USA','555-555-5555'),
  ('j2ee','yourname@yourdomain.com','ABC','XYX','OK','901 San Antonio Road','MS UCUP02-206','Palo Alto','CA','94303','USA','555-555-5555');

COMMIT;

#
# Structure for the `bannerdata` table :
#

DROP TABLE IF EXISTS `bannerdata`;

CREATE TABLE `bannerdata` (
  `favcategory` varchar(80) NOT NULL,
  `bannername` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`favcategory`)
);

#
# Data for the `bannerdata` table
#

INSERT INTO `bannerdata` (`favcategory`, `bannername`) VALUES
  ('BIRDS','<image src=\"../images/banner_birds.gif\">'),
  ('CATS','<image src=\"../images/banner_cats.gif\">'),
  ('DOGS','<image src=\"../images/banner_dogs.gif\">'),
  ('FISH','<image src=\"../images/banner_fish.gif\">'),
  ('PETPRODUCT','<image src=\"../images/banner_birds.gif\">'),
  ('REPTILES','<image src=\"../images/banner_reptiles.gif\">');

COMMIT;

#
# Structure for the `category` table :
#

DROP TABLE IF EXISTS `category`;

CREATE TABLE `category` (
  `catid` varchar(10) NOT NULL,
  `name` varchar(80) DEFAULT NULL,
  `descn` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`catid`)
);

#
# Data for the `category` table
#

INSERT INTO `category` (`catid`, `name`, `descn`) VALUES
  ('BIRDS','Birds','<image src=\"../images/birds_icon.gif\"><font size=\"5\" color=\"blue\"> Birds</font>'),
  ('CATS','Cats','<image src=\"../images/cats_icon.gif\"><font size=\"5\" color=\"blue\"> Cats</font>'),
  ('DOGS','Dogs','<image src=\"../images/dogs_icon.gif\"><font size=\"5\" color=\"blue\"> Dogs</font>'),
  ('FISH','Fish','<image src=\"../images/fish_icon.gif\"><font size=\"5\" color=\"blue\"> Fish</font>'),
  ('PETPRODUCT','Pet products','<image src=\"../images/fish_icon.gif\"><font size=\"5\" color=\"blue\"> Fish</font>'),
  ('REPTILES','Reptiles','<image src=\"../images/reptiles_icon.gif\"><font size=\"5\" color=\"blue\"> Reptiles</font>');

COMMIT;

#
# Structure for the `inventory` table :
#

DROP TABLE IF EXISTS `inventory`;

CREATE TABLE `inventory` (
  `itemid` varchar(10) NOT NULL,
  `qty` int(11) NOT NULL,
  PRIMARY KEY (`itemid`)
);

#
# Data for the `inventory` table
#

INSERT INTO `inventory` (`itemid`, `qty`) VALUES
  ('EST-01',9999),
  ('EST-02',9999),
  ('EST-03',10000),
  ('EST-04',9995),
  ('EST-05',10000),
  ('EST-06',9999),
  ('EST-07',10000),
  ('EST-08',9998),
  ('EST-09',10000),
  ('EST-10',10000),
  ('EST-11',10000),
  ('EST-12',10000),
  ('EST-13',10000),
  ('EST-14',10000),
  ('EST-15',9999),
  ('EST-16',9999),
  ('EST-17',10000),
  ('EST-18',9824),
  ('EST-19',10000),
  ('EST-20',9995),
  ('EST-21',10000),
  ('EST-22',10000),
  ('EST-23',10000),
  ('EST-24',10000),
  ('EST-25',10000),
  ('EST-26',10000),
  ('EST-27',10000),
  ('EST-28',10000),
  ('EST-29',1000),
  ('EST-30',997),
  ('EST-31',1000),
  ('EST-32',997),
  ('EST-33',1000),
  ('EST-34',1000),
  ('EST-35',998),
  ('EST-36',1000),
  ('EST-37',1000),
  ('EST-38',1000),
  ('EST-39',999),
  ('EST-40',1000),
  ('EST-41',1000),
  ('EST-42',1000),
  ('EST-43',1000),
  ('EST-44',997),
  ('EST-45',1000),
  ('EST-46',1000),
  ('EST-47',996),
  ('EST-48',1000);

COMMIT;

#
# Structure for the `product` table :
#

DROP TABLE IF EXISTS `product`;

CREATE TABLE `product` (
  `productid` varchar(10) NOT NULL,
  `category` varchar(10) NOT NULL,
  `name` varchar(80) DEFAULT NULL,
  `descn` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`productid`),
  KEY `productCat` (`category`),
  KEY `productName` (`name`),
  CONSTRAINT `fk_product_1` FOREIGN KEY (`category`) REFERENCES `category` (`catid`)
);

#
# Data for the `product` table
#

INSERT INTO `product` (`productid`, `category`, `name`, `descn`) VALUES
  ('AV-CB-01','BIRDS','Amazon Parrot','<image src=\"../images/bird4.gif\">Great companion for up to 75 years'),
  ('AV-SB-02','BIRDS','Finch','<image src=\"../images/bird1.gif\">Great stress reliever'),
  ('FI-FW-01','FISH','Koi','<image src=\"../images/fish3.gif\">Fresh Water fish from Japan'),
  ('FI-FW-02','FISH','Goldfish','<image src=\"../images/fish2.gif\">Fresh Water fish from China'),
  ('FI-SW-01','FISH','Angelfish','<image src=\"../images/fish1.jpg\">Salt Water fish from Australia'),
  ('FI-SW-02','FISH','Tiger Shark','<image src=\"../images/fish4.gif\">Salt Water fish from Australia'),
  ('FL-DLH-02','CATS','Persian','<image src=\"../images/cat1.gif\">Friendly house cat, doubles as a princess'),
  ('FL-DSH-01','CATS','Manx','<image src=\"../images/cat3.gif\">Great for reducing mouse populations'),
  ('K9-BD-01','DOGS','Bulldog','<image src=\"../images/dog2.gif\">Friendly dog from England'),
  ('K9-CW-01','DOGS','Chihuahua','<image src=\"../images/dog4.gif\">Great companion dog'),
  ('K9-DL-01','DOGS','Dalmation','<image src=\"../images/dog5.gif\">Great dog for a Fire Station'),
  ('K9-PO-02','DOGS','Poodle','<image src=\"../images/dog6.gif\">Cute dog from France'),
  ('K9-RT-01','DOGS','Golden Retriever','<image src=\"../images/dog1.gif\">Great family dog'),
  ('K9-RT-02','DOGS','Labrador Retriever','<image src=\"../images/dog5.gif\">Great hunting dog'),
  ('PP-BC-01','PETPRODUCT','Birds product - cage',NULL),
  ('PP-BF-01','PETPRODUCT','Birds Product - food',NULL),
  ('PP-CF-01','PETPRODUCT','Cats product - food',NULL),
  ('PP-CL-01','PETPRODUCT','Cats product - litter',NULL),
  ('PP-DC-01','PETPRODUCT','Dogs product - collar',NULL),
  ('PP-DF-01','PETPRODUCT','Dogs product - food',NULL),
  ('PP-FB-01','PETPRODUCT','Fish product - bowl',NULL),
  ('PP-FF-01','PETPRODUCT','Fish Product - food',NULL),
  ('PP-RF-01','PETPRODUCT','Reptiles product - food',NULL),
  ('PP-RT-01','PETPRODUCT','Reptiles product - tree hole',NULL),
  ('RP-LI-02','REPTILES','Iguana','<image src=\"../images/lizard2.gif\">Friendly green friend'),
  ('RP-SN-01','REPTILES','Rattlesnake','<image src=\"../images/lizard3.gif\">Doubles as a watch dog');

COMMIT;

#
# Structure for the `supplier` table :
#

DROP TABLE IF EXISTS `supplier`;

CREATE TABLE `supplier` (
  `suppid` int(11) NOT NULL,
  `name` varchar(80) DEFAULT NULL,
  `status` varchar(2) NOT NULL,
  `addr1` varchar(80) DEFAULT NULL,
  `addr2` varchar(80) DEFAULT NULL,
  `city` varchar(80) DEFAULT NULL,
  `state` varchar(80) DEFAULT NULL,
  `zip` varchar(5) DEFAULT NULL,
  `phone` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`suppid`)
);

#
# Data for the `supplier` table
#

INSERT INTO `supplier` (`suppid`, `name`, `status`, `addr1`, `addr2`, `city`, `state`, `zip`, `phone`) VALUES
  (1,'XYZ Pets','AC','600 Avon Way','','Los Angeles','CA','94024','212-947-0797'),
  (2,'ABC Pets','AC','700 Abalone Way','','San Francisco ','CA','94024','415-947-0797');

COMMIT;

#
# Structure for the `item` table :
#

DROP TABLE IF EXISTS `item`;

CREATE TABLE `item` (
  `itemid` varchar(10) NOT NULL,
  `productid` varchar(10) NOT NULL,
  `listprice` decimal(10,2) DEFAULT NULL,
  `unitcost` decimal(10,2) DEFAULT NULL,
  `supplier` int(11) DEFAULT NULL,
  `status` varchar(2) DEFAULT NULL,
  `attr1` varchar(80) DEFAULT NULL,
  `attr2` varchar(80) DEFAULT NULL,
  `attr3` varchar(80) DEFAULT NULL,
  `attr4` varchar(80) DEFAULT NULL,
  `attr5` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`itemid`),
  KEY `fk_item_2` (`supplier`),
  KEY `itemProd` (`productid`),
  CONSTRAINT `fk_item_1` FOREIGN KEY (`productid`) REFERENCES `product` (`productid`),
  CONSTRAINT `fk_item_2` FOREIGN KEY (`supplier`) REFERENCES `supplier` (`suppid`)
);

#
# Data for the `item` table
#

INSERT INTO `item` (`itemid`, `productid`, `listprice`, `unitcost`, `supplier`, `status`, `attr1`, `attr2`, `attr3`, `attr4`, `attr5`) VALUES
  ('EST-01','FI-SW-01',16.5,10,1,'P','Large',NULL,NULL,NULL,NULL),
  ('EST-02','FI-SW-01',16.5,10,1,'P','Small',NULL,NULL,NULL,NULL),
  ('EST-03','FI-SW-02',18.5,12,1,'P','Toothless',NULL,NULL,NULL,NULL),
  ('EST-04','FI-FW-01',18.5,12,1,'P','Spotted',NULL,NULL,NULL,NULL),
  ('EST-05','FI-FW-01',18.5,12,1,'P','Spotless',NULL,NULL,NULL,NULL),
  ('EST-06','K9-BD-01',18.5,12,1,'P','Male Adult',NULL,NULL,NULL,NULL),
  ('EST-07','K9-BD-01',18.5,12,1,'P','Female Puppy',NULL,NULL,NULL,NULL),
  ('EST-08','K9-PO-02',18.5,12,1,'P','Male Puppy',NULL,NULL,NULL,NULL),
  ('EST-09','K9-DL-01',18.5,12,1,'P','Spotless Male Puppy',NULL,NULL,NULL,NULL),
  ('EST-10','K9-DL-01',18.5,12,1,'P','Spotted Adult Female',NULL,NULL,NULL,NULL),
  ('EST-11','RP-SN-01',18.5,12,1,'P','Venomless',NULL,NULL,NULL,NULL),
  ('EST-12','RP-SN-01',18.5,12,1,'P','Rattleless',NULL,NULL,NULL,NULL),
  ('EST-13','RP-LI-02',18.5,12,1,'P','Green Adult',NULL,NULL,NULL,NULL),
  ('EST-14','FL-DSH-01',58.5,12,1,'P','Tailless',NULL,NULL,NULL,NULL),
  ('EST-15','FL-DSH-01',23.5,12,1,'P','With tail',NULL,NULL,NULL,NULL),
  ('EST-16','FL-DLH-02',93.5,12,1,'P','Adult Female',NULL,NULL,NULL,NULL),
  ('EST-17','FL-DLH-02',93.5,12,1,'P','Adult Male',NULL,NULL,NULL,NULL),
  ('EST-18','AV-CB-01',193.5,92,1,'P','Adult Male',NULL,NULL,NULL,NULL),
  ('EST-19','AV-SB-02',15.5,2,1,'P','Adult Male',NULL,NULL,NULL,NULL),
  ('EST-20','FI-FW-02',5.5,2,1,'P','Adult Male',NULL,NULL,NULL,NULL),
  ('EST-21','FI-FW-02',5.29,1,1,'P','Adult Female',NULL,NULL,NULL,NULL),
  ('EST-22','K9-RT-02',135.5,100,1,'P','Adult Male',NULL,NULL,NULL,NULL),
  ('EST-23','K9-RT-02',145.49,100,1,'P','Adult Female',NULL,NULL,NULL,NULL),
  ('EST-24','K9-RT-02',255.5,92,1,'P','Adult Male',NULL,NULL,NULL,NULL),
  ('EST-25','K9-RT-02',325.29,90,1,'P','Adult Female',NULL,NULL,NULL,NULL),
  ('EST-26','K9-CW-01',125.5,92,1,'P','Adult Male',NULL,NULL,NULL,NULL),
  ('EST-27','K9-CW-01',155.29,90,1,'P','Adult Female',NULL,NULL,NULL,NULL),
  ('EST-28','K9-RT-01',155.29,90,1,'P','Adult Female',NULL,NULL,NULL,NULL),
  ('EST-29','PP-BC-01',12.8,8,1,'p','Circular birdcage (green)',NULL,NULL,NULL,NULL),
  ('EST-30','PP-BC-01',12.8,8,1,'p','Circular birdcage (red)',NULL,NULL,NULL,NULL),
  ('EST-31','PP-BF-01',1.25,1.45,1,'P','Birds food (small Pack)',NULL,NULL,NULL,NULL),
  ('EST-32','PP-BF-01',2.5,1.45,1,'P','Birds food (Large Pack)',NULL,NULL,NULL,NULL),
  ('EST-33','PP-CF-01',3.25,4,1,'P','Cats food (small Pack)',NULL,NULL,NULL,NULL),
  ('EST-34','PP-CF-01',6.5,4,1,'P','Cats food (Large Pack)',NULL,NULL,NULL,NULL),
  ('EST-35','PP-CL-01',3.5,2,1,'P','Cats litter (small Pack)',NULL,NULL,NULL,NULL),
  ('EST-36','PP-CL-01',7,2,1,'P','Cats litter (Large Pack)',NULL,NULL,NULL,NULL),
  ('EST-37','PP-DC-01',12.5,8,1,'P','Dogs collar ((small)',NULL,NULL,NULL,NULL),
  ('EST-38','PP-DC-01',15.5,8,1,'P','Dogs collar ((Large)',NULL,NULL,NULL,NULL),
  ('EST-39','PP-DF-01',10.5,10,1,'P','Dogs food (small Pack)',NULL,NULL,NULL,NULL),
  ('EST-40','PP-DF-01',21,10,1,'P','Dogs food (Large Pack)',NULL,NULL,NULL,NULL),
  ('EST-41','PP-FB-01',4.5,2,1,'P','Fish bowl (square)',NULL,NULL,NULL,NULL),
  ('EST-42','PP-FB-01',4.5,2,1,'P','Fish bowl (circular)',NULL,NULL,NULL,NULL),
  ('EST-43','PP-FF-01',1.5,0.5,1,'P','Fish food  (small Pack)',NULL,NULL,NULL,NULL),
  ('EST-44','PP-FF-01',3,0.5,1,'P','Fish food  (Large Pack)',NULL,NULL,NULL,NULL),
  ('EST-45','PP-RF-01',4,2,1,'P','Reptiles food  (small Pack)',NULL,NULL,NULL,NULL),
  ('EST-46','PP-RF-01',8,2,1,'P','Reptiles food  (Large Pack)',NULL,NULL,NULL,NULL),
  ('EST-47','PP-RT-01',3,2,1,'P','Reptitles tree hole  (small)',NULL,NULL,NULL,NULL),
  ('EST-48','PP-RT-01',5.5,2,1,'P','Reptitles tree hole  (Large)',NULL,NULL,NULL,NULL);

COMMIT;

#
# Structure for the `lineitem` table :
#

DROP TABLE IF EXISTS `lineitem`;

CREATE TABLE `lineitem` (
  `orderid` int(11) NOT NULL,
  `linenum` int(11) NOT NULL,
  `itemid` varchar(10) NOT NULL,
  `quantity` int(11) NOT NULL,
  `unitprice` decimal(10,2) NOT NULL,
  PRIMARY KEY (`orderid`,`linenum`)
);

#
# Data for the `lineitem` table
#

INSERT INTO `lineitem` (`orderid`, `linenum`, `itemid`, `quantity`, `unitprice`) VALUES
  (100000,1,'EST-25',194,325.29),
  (100000,2,'EST-32',62,2.5),
  (100000,3,'EST-18',183,193.5),
  (100000,4,'EST-07',75,18.5),
  (100000,15780,'EST-45',26,4);

COMMIT;

#
# Structure for the `orders` table :
#

DROP TABLE IF EXISTS `orders`;

CREATE TABLE `orders` (
  `orderid` int(11) NOT NULL,
  `userid` varchar(80) NOT NULL,
  `orderdate` date NOT NULL,
  `shipaddr1` varchar(80) NOT NULL,
  `shipaddr2` varchar(80) DEFAULT NULL,
  `shipcity` varchar(80) NOT NULL,
  `shipstate` varchar(80) NOT NULL,
  `shipzip` varchar(20) NOT NULL,
  `shipcountry` varchar(20) NOT NULL,
  `billaddr1` varchar(80) NOT NULL,
  `billaddr2` varchar(80) DEFAULT NULL,
  `billcity` varchar(80) NOT NULL,
  `billstate` varchar(80) NOT NULL,
  `billzip` varchar(20) NOT NULL,
  `billcountry` varchar(20) NOT NULL,
  `courier` varchar(80) NOT NULL,
  `totalprice` decimal(10,2) NOT NULL,
  `billtofirstname` varchar(80) NOT NULL,
  `billtolastname` varchar(80) NOT NULL,
  `shiptofirstname` varchar(80) NOT NULL,
  `shiptolastname` varchar(80) NOT NULL,
  `creditcard` varchar(80) NOT NULL,
  `exprdate` varchar(7) NOT NULL,
  `cardtype` varchar(80) NOT NULL,
  `locale` varchar(80) NOT NULL,
  PRIMARY KEY (`orderid`)
);

#
# Structure for the `orderstatus` table :
#

DROP TABLE IF EXISTS `orderstatus`;

CREATE TABLE `orderstatus` (
  `orderid` int(11) NOT NULL,
  `linenum` int(11) NOT NULL,
  `timestamp` date NOT NULL,
  `status` varchar(2) NOT NULL,
  PRIMARY KEY (`orderid`,`linenum`)
);

#
# Structure for the `profile` table :
#

DROP TABLE IF EXISTS `profile`;

CREATE TABLE `profile` (
  `userid` varchar(80) NOT NULL,
  `langpref` varchar(80) NOT NULL,
  `favcategory` varchar(30) DEFAULT NULL,
  `mylistopt` tinyint(1) DEFAULT NULL,
  `banneropt` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`userid`)
);

#
# Data for the `profile` table
#

INSERT INTO `profile` (`userid`, `langpref`, `favcategory`, `mylistopt`, `banneropt`) VALUES
  ('ACID','english','CATS',1,1),
  ('j2ee','english','DOGS',1,1);

COMMIT;

#
# Structure for the `relationship` table :
#

DROP TABLE IF EXISTS `relationship`;

CREATE TABLE `relationship` (
  `relation` varchar(1000) NOT NULL
);

#
# Structure for the `sequence` table :
#

DROP TABLE IF EXISTS `sequence`;

CREATE TABLE `sequence` (
  `name` varchar(30) NOT NULL,
  `nextid` int(11) NOT NULL,
  PRIMARY KEY (`name`)
);

#
# Data for the `sequence` table
#

INSERT INTO `sequence` (`name`, `nextid`) VALUES
  ('linenum',5),
  ('ordernum',1);

COMMIT;

#
# Structure for the `signon` table :
#

DROP TABLE IF EXISTS `signon`;

CREATE TABLE `signon` (
  `username` varchar(25) NOT NULL,
  `password` varchar(25) NOT NULL,
  PRIMARY KEY (`username`)
);

#
# Data for the `signon` table
#

INSERT INTO `signon` (`username`, `password`) VALUES
  ('ACID','ACID'),
  ('j2ee','j2ee');

COMMIT;

