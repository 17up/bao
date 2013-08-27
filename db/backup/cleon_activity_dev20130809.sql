-- MySQL dump 10.13  Distrib 5.5.21, for osx10.6 (i386)
--
-- Host: localhost    Database: cleon_activity_dev
-- ------------------------------------------------------
-- Server version	5.5.21-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `click_tracking_logs`
--

DROP TABLE IF EXISTS `click_tracking_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `click_tracking_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `coupon_id` int(11) DEFAULT NULL,
  `category` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `clicked_hour` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `clicked_day` date DEFAULT NULL,
  `ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `original_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_click_tracking_logs_on_coupon_id` (`coupon_id`),
  KEY `index_click_tracking_logs_on_clicked_hour` (`clicked_hour`),
  KEY `index_click_tracking_logs_on_category` (`category`),
  KEY `index_click_tracking_logs_on_clicked_day` (`clicked_day`)
) ENGINE=InnoDB AUTO_INCREMENT=122 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `click_tracking_logs`
--

LOCK TABLES `click_tracking_logs` WRITE;
/*!40000 ALTER TABLE `click_tracking_logs` DISABLE KEYS */;
INSERT INTO `click_tracking_logs` VALUES (1,1,'cellphone',15,'2013-07-26 15:43:02','2013-07-26 15:43:02',NULL,NULL,NULL),(2,1,'weixin',15,'2013-07-26 15:43:13','2013-07-26 15:43:13',NULL,NULL,NULL),(3,1,'weibo',15,'2013-07-26 15:43:16','2013-07-26 15:43:16',NULL,NULL,NULL),(4,1,'weibo',15,'2013-07-26 15:43:27','2013-07-26 15:43:27',NULL,NULL,NULL),(5,1,'view',16,'2013-07-26 16:17:29','2013-07-26 16:17:29',NULL,NULL,NULL),(6,1,'view',16,'2013-07-26 16:17:59','2013-07-26 16:17:59',NULL,NULL,NULL),(7,1,'view',16,'2013-07-26 16:24:57','2013-07-26 16:24:57',NULL,NULL,NULL),(8,1,'view',16,'2013-07-26 16:31:09','2013-07-26 16:31:09','2013-07-26','127.0.0.1','http://localhost:3000/coupons/1'),(9,1,'view',16,'2013-07-26 16:51:13','2013-07-26 16:51:13','2013-07-26','127.0.0.1','http://localhost:3000/coupons/1'),(10,1,'view',16,'2013-07-26 16:51:28','2013-07-26 16:51:28','2013-07-26','127.0.0.1','http://localhost:3000/coupons/1'),(11,1,'view',16,'2013-07-26 16:52:03','2013-07-26 16:52:03','2013-07-26','127.0.0.1','http://localhost:3000/coupons/1'),(12,1,'view',16,'2013-07-26 16:53:33','2013-07-26 16:53:33','2013-07-26','127.0.0.1','http://localhost:3000/coupons/1'),(13,1,'view',16,'2013-07-26 16:54:08','2013-07-26 16:54:08','2013-07-26','127.0.0.1','http://localhost:3000/coupons/1'),(14,1,'view',21,'2013-08-04 21:26:58','2013-08-04 21:26:58','2013-08-04',NULL,NULL),(17,1,'cellphone',21,'2013-08-04 21:31:37','2013-08-04 21:31:37','2013-08-04',NULL,NULL),(19,1,'weibo',21,'2013-08-04 21:31:45','2013-08-04 21:31:45','2013-08-04',NULL,NULL),(20,1,'website',21,'2013-08-04 21:31:49','2013-08-04 21:31:49','2013-08-04',NULL,NULL),(21,1,'website',21,'2013-08-04 21:31:53','2013-08-04 21:31:53','2013-08-04',NULL,NULL),(22,1,'reservation',21,'2013-08-04 21:31:57','2013-08-04 21:31:57','2013-08-04',NULL,NULL),(31,1,'view',8,'2013-08-05 08:29:30','2013-08-05 08:29:30','2013-08-05',NULL,NULL),(32,1,'view',8,'2013-08-05 08:29:31','2013-08-05 08:29:31','2013-08-05',NULL,NULL),(33,1,'view',8,'2013-08-05 08:29:32','2013-08-05 08:29:32','2013-08-05',NULL,NULL),(34,1,'website',8,'2013-08-05 08:29:53','2013-08-05 08:29:53','2013-08-05',NULL,NULL),(35,1,'website',8,'2013-08-05 08:29:54','2013-08-05 08:29:54','2013-08-05',NULL,NULL),(36,1,'website',8,'2013-08-05 08:29:55','2013-08-05 08:29:55','2013-08-05',NULL,NULL),(37,1,'cellphone',8,'2013-08-05 08:51:12','2013-08-05 08:51:12','2013-08-05',NULL,NULL),(38,1,'cellphone',8,'2013-08-05 08:51:12','2013-08-05 08:51:12','2013-08-05',NULL,NULL),(39,1,'cellphone',8,'2013-08-05 08:51:13','2013-08-05 08:51:13','2013-08-05',NULL,NULL),(40,6,'view',8,'2013-08-05 08:51:27','2013-08-05 08:51:27','2013-08-05',NULL,NULL),(41,1,'cellphone',8,'2013-08-05 08:55:07','2013-08-05 08:55:07','2013-08-05',NULL,NULL),(42,1,'cellphone',8,'2013-08-05 08:55:08','2013-08-05 08:55:08','2013-08-05',NULL,NULL),(44,12,'website',8,'2013-08-05 08:55:28','2013-08-05 08:55:28','2013-08-05',NULL,NULL),(45,12,'website',8,'2013-08-05 08:55:29','2013-08-05 08:55:29','2013-08-05',NULL,NULL),(46,1,'phonecall',9,'2013-08-05 09:09:17','2013-08-05 09:09:17','2013-08-05',NULL,NULL),(47,1,'phonecall',9,'2013-08-05 09:09:18','2013-08-05 09:09:18','2013-08-05',NULL,NULL),(48,7,'view',9,'2013-08-05 09:22:32','2013-08-05 09:22:32','2013-08-05',NULL,NULL),(49,7,'view',9,'2013-08-05 09:22:33','2013-08-05 09:22:33','2013-08-05',NULL,NULL),(50,7,'view',9,'2013-08-05 09:22:34','2013-08-05 09:22:34','2013-08-05',NULL,NULL),(51,7,'view',9,'2013-08-05 09:22:35','2013-08-05 09:22:35','2013-08-05',NULL,NULL),(52,5,'view',9,'2013-08-05 09:22:41','2013-08-05 09:22:41','2013-08-05',NULL,NULL),(53,5,'view',9,'2013-08-05 09:22:42','2013-08-05 09:22:42','2013-08-05',NULL,NULL),(54,5,'view',9,'2013-08-05 09:22:42','2013-08-05 09:22:42','2013-08-05',NULL,NULL),(55,1,'view',9,'2013-08-05 09:43:03','2013-08-05 09:43:03','2013-08-05',NULL,NULL),(58,1,'weixin',10,'2013-08-05 10:30:43','2013-08-05 10:30:43','2013-08-05',NULL,NULL),(60,1,'weixin',10,'2013-08-05 10:41:27','2013-08-05 10:41:27','2013-08-05',NULL,NULL),(61,1,'weixin',10,'2013-08-05 10:41:28','2013-08-05 10:41:28','2013-08-05',NULL,NULL),(62,1,'weixin',10,'2013-08-05 10:41:29','2013-08-05 10:41:29','2013-08-05',NULL,NULL),(63,4,'view',11,'2013-08-05 11:01:01','2013-08-05 11:01:01','2013-08-05',NULL,NULL),(64,4,'view',11,'2013-08-05 11:01:02','2013-08-05 11:01:02','2013-08-05',NULL,NULL),(65,4,'view',11,'2013-08-05 11:01:03','2013-08-05 11:01:03','2013-08-05',NULL,NULL),(66,1,'cellphone',15,'2013-07-26 15:43:02','2013-07-26 15:43:02',NULL,NULL,NULL),(67,1,'weixin',15,'2013-07-26 15:43:13','2013-07-26 15:43:13',NULL,NULL,NULL),(68,1,'weibo',15,'2013-07-26 15:43:16','2013-07-26 15:43:16',NULL,NULL,NULL),(69,1,'weibo',15,'2013-07-26 15:43:27','2013-07-26 15:43:27',NULL,NULL,NULL),(70,1,'view',16,'2013-07-26 16:17:29','2013-07-26 16:17:29',NULL,NULL,NULL),(71,1,'view',16,'2013-07-26 16:17:59','2013-07-26 16:17:59',NULL,NULL,NULL),(72,1,'view',16,'2013-07-26 16:24:57','2013-07-26 16:24:57',NULL,NULL,NULL),(73,1,'view',16,'2013-07-26 16:31:09','2013-07-26 16:31:09','2013-07-26','127.0.0.1','http://localhost:3000/coupons/1'),(74,1,'view',16,'2013-07-26 16:51:13','2013-07-26 16:51:13','2013-07-26','127.0.0.1','http://localhost:3000/coupons/1'),(75,1,'view',16,'2013-07-26 16:51:28','2013-07-26 16:51:28','2013-07-26','127.0.0.1','http://localhost:3000/coupons/1'),(76,1,'view',16,'2013-07-26 16:52:03','2013-07-26 16:52:03','2013-07-26','127.0.0.1','http://localhost:3000/coupons/1'),(77,1,'view',16,'2013-07-26 16:53:33','2013-07-26 16:53:33','2013-07-26','127.0.0.1','http://localhost:3000/coupons/1'),(78,1,'view',16,'2013-07-26 16:54:08','2013-07-26 16:54:08','2013-07-26','127.0.0.1','http://localhost:3000/coupons/1'),(79,1,'view',21,'2013-08-04 21:26:58','2013-08-04 21:26:58','2013-08-04',NULL,NULL),(80,1,'cellphone',21,'2013-08-04 21:31:37','2013-08-04 21:31:37','2013-08-04',NULL,NULL),(81,1,'weibo',21,'2013-08-04 21:31:45','2013-08-04 21:31:45','2013-08-04',NULL,NULL),(82,1,'website',21,'2013-08-04 21:31:49','2013-08-04 21:31:49','2013-08-04',NULL,NULL),(83,1,'website',21,'2013-08-04 21:31:53','2013-08-04 21:31:53','2013-08-04',NULL,NULL),(84,1,'reservation',21,'2013-08-04 21:31:57','2013-08-04 21:31:57','2013-08-04',NULL,NULL),(85,1,'view',8,'2013-08-05 08:29:30','2013-08-05 08:29:30','2013-08-05',NULL,NULL),(86,1,'view',8,'2013-08-05 08:29:31','2013-08-05 08:29:31','2013-08-05',NULL,NULL),(87,1,'view',8,'2013-08-05 08:29:32','2013-08-05 08:29:32','2013-08-05',NULL,NULL),(88,1,'website',8,'2013-08-05 08:29:53','2013-08-05 08:29:53','2013-08-05',NULL,NULL),(89,1,'website',8,'2013-08-05 08:29:54','2013-08-05 08:29:54','2013-08-05',NULL,NULL),(90,1,'website',8,'2013-08-05 08:29:55','2013-08-05 08:29:55','2013-08-05',NULL,NULL),(91,1,'cellphone',8,'2013-08-05 08:51:12','2013-08-05 08:51:12','2013-08-05',NULL,NULL),(92,1,'cellphone',8,'2013-08-05 08:51:12','2013-08-05 08:51:12','2013-08-05',NULL,NULL),(93,1,'cellphone',8,'2013-08-05 08:51:13','2013-08-05 08:51:13','2013-08-05',NULL,NULL),(94,6,'view',8,'2013-08-05 08:51:27','2013-08-05 08:51:27','2013-08-05',NULL,NULL),(95,1,'cellphone',8,'2013-08-05 08:55:07','2013-08-05 08:55:07','2013-08-05',NULL,NULL),(96,1,'cellphone',8,'2013-08-05 08:55:08','2013-08-05 08:55:08','2013-08-05',NULL,NULL),(97,12,'website',8,'2013-08-05 08:55:28','2013-08-05 08:55:28','2013-08-05',NULL,NULL),(98,12,'website',8,'2013-08-05 08:55:29','2013-08-05 08:55:29','2013-08-05',NULL,NULL),(99,1,'phonecall',9,'2013-08-05 09:09:17','2013-08-05 09:09:17','2013-08-05',NULL,NULL),(100,1,'phonecall',9,'2013-08-05 09:09:18','2013-08-05 09:09:18','2013-08-05',NULL,NULL),(101,7,'view',9,'2013-08-05 09:22:32','2013-08-05 09:22:32','2013-08-05',NULL,NULL),(102,7,'view',9,'2013-08-05 09:22:33','2013-08-05 09:22:33','2013-08-05',NULL,NULL),(103,7,'view',9,'2013-08-05 09:22:34','2013-08-05 09:22:34','2013-08-05',NULL,NULL),(104,7,'view',9,'2013-08-05 09:22:35','2013-08-05 09:22:35','2013-08-05',NULL,NULL),(105,5,'view',9,'2013-08-05 09:22:41','2013-08-05 09:22:41','2013-08-05',NULL,NULL),(106,5,'view',9,'2013-08-05 09:22:42','2013-08-05 09:22:42','2013-08-05',NULL,NULL),(107,5,'view',9,'2013-08-05 09:22:42','2013-08-05 09:22:42','2013-08-05',NULL,NULL),(108,1,'view',9,'2013-08-05 09:43:03','2013-08-05 09:43:03','2013-08-05',NULL,NULL),(109,1,'weixin',10,'2013-08-05 10:30:43','2013-08-05 10:30:43','2013-08-05',NULL,NULL),(110,1,'weixin',10,'2013-08-05 10:41:27','2013-08-05 10:41:27','2013-08-05',NULL,NULL),(111,1,'weixin',10,'2013-08-05 10:41:28','2013-08-05 10:41:28','2013-08-05',NULL,NULL),(112,1,'weixin',10,'2013-08-05 10:41:29','2013-08-05 10:41:29','2013-08-05',NULL,NULL),(113,4,'view',11,'2013-08-05 11:01:01','2013-08-05 11:01:01','2013-08-05',NULL,NULL),(114,4,'view',11,'2013-08-05 11:01:02','2013-08-05 11:01:02','2013-08-05',NULL,NULL),(115,4,'view',11,'2013-08-05 11:01:03','2013-08-05 11:01:03','2013-08-05',NULL,NULL),(116,17,'view',8,'2013-08-09 08:46:36','2013-08-09 08:46:36','2013-08-09',NULL,NULL),(117,17,'view',8,'2013-08-09 08:46:37','2013-08-09 08:46:37','2013-08-09',NULL,NULL),(118,17,'view',8,'2013-08-09 08:46:38','2013-08-09 08:46:38','2013-08-09',NULL,NULL),(119,23,'view',8,'2013-08-09 08:49:30','2013-08-09 08:49:30','2013-08-09',NULL,NULL),(120,23,'view',8,'2013-08-09 08:49:31','2013-08-09 08:49:31','2013-08-09',NULL,NULL),(121,23,'view',8,'2013-08-09 08:49:31','2013-08-09 08:49:31','2013-08-09',NULL,NULL);
/*!40000 ALTER TABLE `click_tracking_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `click_tracking_stats`
--

DROP TABLE IF EXISTS `click_tracking_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `click_tracking_stats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `coupon_id` int(11) DEFAULT NULL,
  `category` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `clicked_day` date DEFAULT NULL,
  `total_count` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_click_tracking_stats_on_coupon_id` (`coupon_id`),
  KEY `index_click_tracking_stats_on_clicked_day` (`clicked_day`),
  KEY `index_click_tracking_stats_on_category` (`category`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `click_tracking_stats`
--

LOCK TABLES `click_tracking_stats` WRITE;
/*!40000 ALTER TABLE `click_tracking_stats` DISABLE KEYS */;
INSERT INTO `click_tracking_stats` VALUES (1,1,'cellphone','2013-07-26',1),(2,1,'weixin','2013-07-26',1),(3,1,'weibo','2013-07-26',2),(4,1,'view','2013-07-26',9);
/*!40000 ALTER TABLE `click_tracking_stats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `coupon_messages`
--

DROP TABLE IF EXISTS `coupon_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `coupon_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `coupon_id` int(11) DEFAULT NULL,
  `mobile` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `sms_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_coupon_messages_on_coupon_id` (`coupon_id`),
  KEY `index_coupon_messages_on_mobile` (`mobile`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coupon_messages`
--

LOCK TABLES `coupon_messages` WRITE;
/*!40000 ALTER TABLE `coupon_messages` DISABLE KEYS */;
INSERT INTO `coupon_messages` VALUES (1,1,'15026612137','2013-07-17 08:09:12','2013-07-17 08:09:12',NULL),(2,1,'15026612137','2013-07-17 08:10:01','2013-07-17 08:10:01',NULL),(3,2,'15026612137','2013-07-17 08:18:07','2013-07-17 08:18:07',NULL),(4,11,'15958183318','2013-07-17 08:23:07','2013-07-17 08:23:07',NULL),(5,11,'15958183318','2013-07-17 08:23:09','2013-07-17 08:23:09',NULL),(6,1,'15026612137','2013-07-17 08:41:06','2013-07-17 08:41:06',NULL),(7,1,'15026612137','2013-07-17 08:41:08','2013-07-17 08:41:08',NULL),(8,1,'15026612137','2013-07-17 08:43:31','2013-07-17 08:43:31',NULL),(9,1,'15026612137','2013-07-17 11:01:40','2013-07-17 11:01:40',NULL),(10,1,'15026612137','2013-07-17 11:03:06','2013-07-17 11:03:06',NULL),(11,1,'15026612137','2013-07-17 11:05:13','2013-07-17 11:05:13',NULL),(12,1,'15026612137','2013-07-17 11:06:40','2013-07-17 11:06:40',NULL),(13,1,'15026612137','2013-07-17 11:15:25','2013-07-17 11:15:25',NULL),(14,1,'15026612137','2013-07-17 11:16:51','2013-07-17 11:16:51',NULL),(15,1,'15026612137','2013-07-17 11:17:30','2013-07-17 11:17:30','1234'),(16,12,'15026612137','2013-07-18 01:58:40','2013-07-18 01:58:40',NULL),(17,2,'15026612137','2013-07-18 08:38:01','2013-07-18 08:38:01',NULL),(18,1,'15026612137','2013-07-18 20:53:14','2013-07-18 20:53:14',NULL),(19,1,'15026612137','2013-07-18 20:54:58','2013-07-18 20:54:58',NULL);
/*!40000 ALTER TABLE `coupon_messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `coupons`
--

DROP TABLE IF EXISTS `coupons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `coupons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `merchant_id` int(11) DEFAULT NULL,
  `branch_ids` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `logo` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `short_description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `full_description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `begin_on` date DEFAULT NULL,
  `end_on` date DEFAULT NULL,
  `weixin_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `price` int(11) DEFAULT '0',
  `status` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `weibo_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `weixin_logo` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `website` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cellphone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `photo` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `notice` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tag` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_recommend` tinyint(1) DEFAULT '0',
  `is_internet` tinyint(1) DEFAULT '0',
  `is_cps` tinyint(1) DEFAULT '0',
  `sms_content` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `no_detail` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_coupons_on_merchant_id` (`merchant_id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coupons`
--

LOCK TABLES `coupons` WRITE;
/*!40000 ALTER TABLE `coupons` DISABLE KEYS */;
INSERT INTO `coupons` VALUES (1,102,NULL,'yichayizuo_logo.jpg','消费两款夏日饮品即赠张靓颖最新EP及签名照、逸茶雅集茶礼','消费两款夏日饮品即赠“张靓颖《感谢》EP”CD一张，还有机会获得张靓颖签名照、逸茶雅集茶礼等丰富奖品','2013-07-18','2013-08-18','一茶一坐（上海）',63,'active','2013-08-05 09:02:03','2013-08-05 09:02:03','一茶一坐','1895752415','yichayizuo_weixin.png',NULL,NULL,NULL,'到店出示本页面或优惠券短信，即可享受优惠；<br>除特殊说明外，本优惠不能与其它优惠同时享受；<br>本优惠最终解释权归商家所有，如有疑问请与商家联系。','茶餐厅',0,0,0,'消费两款夏日饮品即赠“张靓颖《感谢》EP”CD一张，还有机会获得张靓颖签名照、逸茶雅集茶礼等丰富奖品',17,0),(2,191,NULL,'xuliushan_logo.jpg','鲜爽饮品外带第二杯半价','鲜爽饮品外带第二杯半价（不含鲜果汁）','2013-07-18','2013-09-30','银联微点',33,'active','2013-08-05 09:02:03','2013-08-05 09:02:03','许留山','2624398813','weidian_weixin.jpg',NULL,NULL,NULL,'到店出示本页面或优惠券短信，即可享受优惠；<br>除特殊说明外，本优惠不能与其它优惠同时享受；<br>本优惠最终解释权归商家所有，如有疑问请与商家联系。','甜品',0,0,0,'鲜爽饮品外带第二杯半价（不含鲜果汁）',16,0),(3,3459,NULL,'xishu_logo.jpg','购买“泡芙小姐”金砖泡芙，第二个半价','购买“泡芙小姐”金砖泡芙，第二个半价','2013-07-01','2013-07-31','西树泡芙（上海）',14,'active','2013-08-05 09:02:03','2013-08-05 09:02:03','西树泡芙','2567729890','xishu_weixin.png',NULL,NULL,NULL,'到店出示本页面或优惠券短信，即可享受优惠；<br>除特殊说明外，本优惠不能与其它优惠同时享受；<br>本优惠最终解释权归商家所有，如有疑问请与商家联系。','西式甜点',0,0,0,'购买“泡芙小姐”金砖泡芙，第二个半价',15,0),(4,7,NULL,'moti_logo.jpg','购买任意3款产品+1元，可得香蕉慕斯、椰子慕斯二选一','凡购买任意3款摩提产品+1元，可得香蕉慕斯、椰子慕斯二选一','2013-07-01','2013-07-31','摩提工房（上海）',18,'active','2013-08-05 09:02:03','2013-08-05 09:02:03','摩提工房','1969838191','moti_logo.jpg',NULL,NULL,NULL,'到店出示本页面或优惠券短信，即可享受优惠；<br>除特殊说明外，本优惠不能与其它优惠同时享受；<br>本优惠最终解释权归商家所有，如有疑问请与商家联系。','西式甜点',0,0,0,'凡购买任意3款摩提产品+1元，可得香蕉慕斯、椰子慕斯二选一',14,0),(5,376,NULL,'xinyadabao_logo.jpg','清凉一夏，特价优惠“传统冷面”10元起','清凉一夏，特价优惠“传统冷面”10元起','2013-07-18','2013-08-18','银联微点',15,'active','2013-08-05 09:02:03','2013-08-05 09:02:03','新亚大包','3535438140','weidian_weixin.jpg',NULL,NULL,NULL,'到店出示本页面或优惠券短信，即可享受优惠；<br>除特殊说明外，本优惠不能与其它优惠同时享受；<br>本优惠最终解释权归商家所有，如有疑问请与商家联系。','快餐',0,0,0,'清凉一夏，特价优惠“传统冷面”10元起',13,0),(6,3439,'3440;3441;3442;3443;3444','meichetang_logo.jpg','高级无水洗车仅需20元，其他汽车美容服务均半价优惠','高级无水洗车仅需20元，其他汽车美容服务均半价优惠于门店标准价','2013-07-18','2013-12-31','银联微点',70,'active','2013-08-05 09:02:03','2013-08-05 09:02:03','美车堂','1797992960','weidian_weixin.jpg',NULL,NULL,NULL,'到店出示本页面或优惠券短信，即可享受优惠；<br>除特殊说明外，本优惠不能与其它优惠同时享受；<br>本优惠最终解释权归商家所有，如有疑问请与商家联系。','汽车保养',0,0,0,'高级无水洗车仅需20元，其他汽车美容服务均半价优惠于门店标准价',12,0),(7,NULL,NULL,'dingcan_logo.jpg','百道免费招牌菜，你想吃，我敢送！','馋嘴牛蛙、水煮鱼、料理虾、酸汤肥牛等百道免费招牌菜，你想吃，我敢送！免费菜品，餐厅任选，尽在订餐小秘书\"霸王菜\"',NULL,NULL,'银联微点',0,'active','2013-08-05 09:02:03','2013-08-05 09:02:03','霸王菜','1782958742','weidian_weixin.jpg','http://57.cn/z60K8','021-57575777','dingcan_big1.jpg;dingcan_big2.jpg;dingcan_big3.jpg','本优惠最终解释权归商家所有，如有疑问请与商家联系。','APP应用',1,1,0,'馋嘴牛蛙、水煮鱼、料理虾、酸汤肥牛等百道免费招牌菜，你想吃，我敢送！免费菜品，餐厅任选，尽在订餐小秘书\"霸王菜\"，下载领取http://57.cn/z60K8',11,1),(8,4095,'4096','freeport_logo.jpg','办会员卡即享中小包不限时段免费欢唱2小时','自由港量贩KTV携手银联微点邀您免费欢唱！凭此页面办会员卡即享中小包不限时段免费欢唱2小时！','2013-07-20','2013-08-20','自由港KTV',50,'active','2013-08-05 09:02:03','2013-08-05 09:02:03','自由港','2146254112','freeport_weixin.jpg',NULL,NULL,NULL,'到店出示本页面或优惠券短信，即可享受优惠；<br>除特殊说明外，本优惠不能与其它优惠同时享受；<br>本优惠最终解释权归商家所有，如有疑问请与商家联系。','KTV',1,0,0,'自由港量贩KTV携手银联微点邀您免费欢唱！凭此短信办会员卡即享中小包不限时段免费欢唱2小时！',10,0),(9,3373,'3374','taipan_logo.jpg','160元以上项目8折优惠','160元以上项目8折优惠（促销项目除外）','2013-07-18','2013-10-18','东方大班上海店',178,'active','2013-08-05 09:02:03','2013-08-05 09:02:03','东方大班','2981424550','taipan_weixin.jpg',NULL,NULL,NULL,'到店出示本页面或优惠券短信，即可享受优惠；<br>除特殊说明外，本优惠不能与其它优惠同时享受；<br>本优惠最终解释权归商家所有，如有疑问请与商家联系。','美容/SPA',1,0,0,'160元以上项目8折优惠（促销项目除外）',9,0),(10,3371,'3372','kartworld_logo.jpg','暑期优惠，最低70元享原价150元娱乐车','暑期优惠，工作日原价150元娱乐车现价100元；学生凭本人有效学生证原价150元娱乐车现价70元','2013-07-01','2013-08-31','kartworld',154,'active','2013-08-05 09:02:03','2013-08-05 09:02:03','国际卡丁车世界','1882512382','kartworld_weixin.jpg',NULL,NULL,NULL,'到店出示本页面或优惠券短信，即可享受优惠；<br>除特殊说明外，本优惠不能与其它优惠同时享受；<br>本优惠最终解释权归商家所有，如有疑问请与商家联系。','运动健身',1,0,0,'暑期优惠，工作日原价150元娱乐车现价100元；学生凭本人有效学生证原价150元娱乐车现价70元',8,0),(11,3617,'3618','soul_logo.jpg','原价10980元豪华套系直降4000元，马上预约再返200元','原价10980元豪华套系直降4000元，再赠送价值1000元的惊喜礼一份；<br>免费升级韩国明星专属造型师（一对一服务）；<br>免费升级中方总监摄影师；<br>免费升级韩国水晶婚纱一套；<br>免费加拍拍摄花絮一组；<br>全额付款送10张精修','2013-07-01','2013-07-31','韩国首尔SUM婚纱摄影',8169,'active','2013-08-05 09:02:03','2013-08-05 09:02:03','韩国首尔婚纱摄影','2648239550','soul_weixin.jpg',NULL,NULL,NULL,'到店刷银行卡消费，购买优惠券指定商品，才可获得现金返利；<br>刷卡消费后15个工作日内，工作人员将把现金返利转账到您的银行卡中；<br>本优惠最终解释权归商家所有，如有疑问请与商家联系。','结婚',1,0,1,'原价10980元豪华套系直降4000元，再赠送价值1000元的惊喜礼一份；免费升级韩国明星专属造型师（一对一服务）；免费升级中方总监摄影师；免费升级韩国水晶婚纱一套；免费加拍拍摄花絮一组；全额付款送10张精修',6,0),(12,3445,'3446','yiai_logo.jpg','订购婚礼服务满10000元送1000元服务项目','三周年回馈活动，凡在活动时间内订购本公司婚礼服务项目满10000元，直送1000元婚礼服务项目','2013-07-15','2013-09-15','银联微点',0,'active','2013-08-05 09:02:03','2013-08-05 09:02:03','依爱婚庆婚典','3535438140','weidian_weixin.jpg',NULL,NULL,NULL,'到店出示本页面或优惠券短信，即可享受优惠；<br>除特殊说明外，本优惠不能与其它优惠同时享受；<br>本优惠最终解释权归商家所有，如有疑问请与商家联系。','结婚',1,0,0,'三周年回馈活动，凡在活动时间内订购本公司婚礼服务项目满10000元，直送1000元婚礼服务项目',5,0),(13,NULL,NULL,'591_logo.jpg','参加现代婚博会，送沙拉碗四件套','诚邀您参加8月3日现代婚博会，一站轻松搞定结婚，来就送沙拉碗四件套。索票请点击下方链接',NULL,NULL,'591结婚网',5236,'active','2013-08-05 09:02:03','2013-08-05 09:02:03','591结婚网','1827728065','591_weixin.jpg','http://v8n.cn/0412','021-32211002','591_big1.jpg;591_big2.jpg','本优惠最终解释权归商家所有，如有疑问请与商家联系。','结婚',1,1,0,'诚邀您参加8月3日现代婚博会，一站轻松搞定结婚，来就送沙拉碗四件套。索票请点击：v8n.cn/0412',4,1),(14,NULL,NULL,'CMBA_logo.jpg','公开课程免费试听，报名享9.5折','7月20-21日CMBA课程《企业发展战略与竞争战略》免费试听，7月27-28日DBA课程《股权投资战略与产业的资产证券化》免费试听，报名即可享受9.5折优惠',NULL,NULL,'银联微点',0,'active','2013-08-05 09:02:03','2013-08-05 09:02:03','上海交大CMBA','3535438140','weidian_weixin.jpg','http://www.sjtucmba.com','4008801896','CMBA_big1.jpg;CMBA_big2.jpg;CMBA_big3.jpg','本优惠最终解释权归商家所有，如有疑问请与商家联系。','教育培训',1,1,0,'7月20-21日CMBA课程《企业发展战略与竞争战略》免费试听，7月27-28日DBA课程《股权投资战略与产业的资产证券化》免费试听，报名即可享受9.5折优惠',2,1),(15,NULL,NULL,'weidian_logo.jpg','优质消费理念，全新生活态度，从微微一点开始','轻松添加银行卡，银联微点便成为您的特权app。上传您刷卡消费的POS照片，赚取奖励！从此刷卡消费有了新的惊喜',NULL,NULL,'银联微点',0,'active','2013-08-05 09:02:03','2013-08-05 09:02:03','银联微点','3535438140','weidian_weixin.jpg','http://www.unionpaysmart.com','4008620111','weidian_big1.jpg;weidian_big2.jpg;weidian_big3.jpg','本优惠最终解释权归商家所有，如有疑问请与商家联系。','APP应用',1,1,0,'轻松添加银行卡，银联微点便成为您的特权app。上传您刷卡消费的POS照片，赚取奖励！从此刷卡消费有了新的惊喜',1,0),(16,4537,'4538','feilingshe_logo.jpg','姐妹写真最多5折优惠，更送大量超值好礼','扉灵社摄影金秋活动开始啦！姐妹写真原价1000元每人，现优惠！两姐妹享8折，三姐妹享6折，四姐妹以上享对折！内外景结合拍摄原片120张，底片全送，每人提供3套服装3组造型，后期精修20张，每人赠送5寸杂志册一本。非双休日拍摄，赠送精修2张，每人送8寸水晶摆台一个。<br>官网：<a href=\'http://www.feelingshoot.net\' target=\'_blank\'>www.feelingshoot.net</a><br>QQ：387891991',NULL,NULL,'银联微点',7330,'active','2013-08-05 09:02:03','2013-08-05 09:02:03','扉灵社摄影工作室','1883817924','weidian_weixin.jpg',NULL,NULL,NULL,'到店出示本页面或优惠券短信，即可享受优惠；<br>除特殊说明外，本优惠不能与其它优惠同时享受；<br>本优惠最终解释权归商家所有，如有疑问请与商家联系。','个性写真',1,0,0,'金秋活动开始啦！姐妹写真最多5折优惠，更送大量超值好礼！54378911，莘庄地铁南广场。',7,0),(17,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'expired','2013-08-09 08:43:54','2013-08-09 08:43:54','阿赐测试1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,0),(18,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'expired','2013-08-09 08:44:29','2013-08-09 08:44:29','阿赐测试2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,0),(19,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'expired','2013-08-09 08:46:53','2013-08-09 08:46:53','阿赐测试3',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,0),(20,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'expired','2013-08-09 08:47:12','2013-08-09 08:47:12','阿赐测试4',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,0),(21,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'expired','2013-08-09 08:47:47','2013-08-09 08:47:47','阿赐测试5',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,0),(22,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'expired','2013-08-09 08:48:20','2013-08-09 08:48:20','阿赐测试6',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,0),(23,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'expired','2013-08-09 08:49:14','2013-08-09 08:49:14','阿赐测试7',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,NULL,NULL,0);
/*!40000 ALTER TABLE `coupons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `identify_codes`
--

DROP TABLE IF EXISTS `identify_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `identify_codes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mobile` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `code` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `status` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_identify_codes_on_code` (`code`),
  KEY `index_identify_codes_on_mobile` (`mobile`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `identify_codes`
--

LOCK TABLES `identify_codes` WRITE;
/*!40000 ALTER TABLE `identify_codes` DISABLE KEYS */;
INSERT INTO `identify_codes` VALUES (1,'','4555','active','2013-07-16 07:16:14','2013-07-16 07:16:14'),(2,'15026612137','4276','expired','2013-07-16 07:35:18','2013-07-16 07:35:41'),(3,'15026612137','8721','expired','2013-07-16 07:37:36','2013-07-16 07:37:50'),(4,'15026612137','4015','expired','2013-07-16 09:39:32','2013-07-16 09:39:44'),(5,'15958183318','1582','expired','2013-07-16 10:54:14','2013-07-17 03:39:04'),(6,'15026612137','2235','expired','2013-07-17 07:32:44','2013-07-17 07:33:05'),(7,'15026612137','3452','expired','2013-07-17 08:10:26','2013-07-17 08:10:52'),(8,'15026612137','3158','expired','2013-07-17 08:21:44','2013-07-17 08:22:03'),(9,'15958183318','5633','expired','2013-07-17 08:24:26','2013-07-17 08:25:26'),(10,'15958183318','3675','expired','2013-07-18 05:13:42','2013-07-18 05:14:07'),(11,'15026612137','8846','expired','2013-07-18 08:38:24','2013-07-18 08:38:42'),(12,'15026612137','3511','expired','2013-07-18 19:21:27','2013-07-18 19:21:37'),(13,'15026612137','0217','expired','2013-07-18 20:53:58','2013-07-18 20:54:08'),(14,'15026612137','6415','expired','2013-07-18 20:55:34','2013-07-18 20:55:45'),(15,'15026612137','6331','expired','2013-07-18 21:03:39','2013-07-18 21:03:49'),(16,'15026612137','2351','expired','2013-07-18 21:06:22','2013-07-18 21:06:31'),(17,'15026612137','3048','expired','2013-07-18 21:07:44','2013-07-18 21:07:55'),(18,'15026612137','4184','expired','2013-07-18 21:10:40','2013-07-18 21:10:54'),(19,'15026612137','1234','active','2013-08-05 11:15:45','2013-08-05 11:15:45');
/*!40000 ALTER TABLE `identify_codes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reservations`
--

DROP TABLE IF EXISTS `reservations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reservations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mobile` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sms_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `coupon_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_reservations_on_mobile` (`mobile`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reservations`
--

LOCK TABLES `reservations` WRITE;
/*!40000 ALTER TABLE `reservations` DISABLE KEYS */;
INSERT INTO `reservations` VALUES (1,'15026612137',NULL,'李恒赐','2013-07-16 07:35:41','2013-07-16 07:35:41',NULL),(2,'15026612137',NULL,'李恒赐','2013-07-16 07:37:50','2013-07-16 07:37:50',NULL),(3,'15026612137',NULL,'Henry','2013-07-16 09:39:44','2013-07-16 09:39:44',NULL),(4,'15958183318',NULL,'','2013-07-17 03:39:04','2013-07-17 03:39:04',NULL),(5,'15026612137',NULL,'阿赐','2013-07-17 07:33:05','2013-07-17 07:33:05',NULL),(6,'15026612137',NULL,'李恒赐','2013-07-17 08:10:52','2013-07-17 08:10:52',NULL),(7,'15026612137',NULL,'Henry','2013-07-17 08:22:03','2013-07-17 08:22:03',10),(8,'15958183318',NULL,'江潇俊','2013-07-17 08:25:26','2013-07-17 08:25:26',10),(9,'15958183318',NULL,'','2013-07-18 05:14:07','2013-07-18 05:14:07',10),(10,'15026612137',NULL,'阿赐','2013-07-18 08:38:42','2013-07-18 08:38:42',10),(11,'15026612137',NULL,'haha','2013-07-18 19:21:37','2013-07-18 19:21:37',10),(12,'15026612137',NULL,'henry 222','2013-07-18 20:55:45','2013-07-18 20:55:45',10),(13,'15026612137',NULL,'哇哈哈','2013-07-18 21:03:49','2013-07-18 21:03:49',10),(14,'15026612137',NULL,'嘿嘿嘿','2013-07-18 21:06:32','2013-07-18 21:06:32',10),(15,'15026612137',NULL,'嘿嘿嘿','2013-07-18 21:07:17','2013-07-18 21:07:17',10),(16,'15026612137',NULL,'abc','2013-07-18 21:07:55','2013-07-18 21:07:55',10),(17,'15026612137',NULL,'嘿嘿嘿','2013-07-18 21:08:10','2013-07-18 21:08:10',10),(18,'15026612137','1234','阿赐测试','2013-07-18 21:10:54','2013-07-18 21:10:54',10);
/*!40000 ALTER TABLE `reservations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schema_migrations`
--

LOCK TABLES `schema_migrations` WRITE;
/*!40000 ALTER TABLE `schema_migrations` DISABLE KEYS */;
INSERT INTO `schema_migrations` VALUES ('20130703005140'),('20130712061808'),('20130716045510'),('20130716053256'),('20130717075428'),('20130717080736'),('20130717081356'),('20130717105836'),('20130725033123'),('20130726024046'),('20130726030214'),('20130726081203');
/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-08-09 14:45:23
