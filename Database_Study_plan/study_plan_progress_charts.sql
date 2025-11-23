-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: localhost    Database: study_plan
-- ------------------------------------------------------
-- Server version	8.0.41

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `progress_charts`
--

DROP TABLE IF EXISTS `progress_charts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `progress_charts` (
  `chart_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `chart_type` enum('line','bar','pie','radar','heatmap') COLLATE utf8mb4_unicode_ci NOT NULL,
  `chart_title` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `chart_config` json NOT NULL,
  `data_source` enum('study_analytics','tasks','sessions','subjects') COLLATE utf8mb4_unicode_ci NOT NULL,
  `timeframe` enum('daily','weekly','monthly','yearly') COLLATE utf8mb4_unicode_ci DEFAULT 'weekly',
  `is_public` tinyint(1) DEFAULT '0',
  `display_order` int DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`chart_id`),
  KEY `idx_progress_charts_user` (`user_id`,`display_order`),
  CONSTRAINT `progress_charts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `progress_charts`
--

LOCK TABLES `progress_charts` WRITE;
/*!40000 ALTER TABLE `progress_charts` DISABLE KEYS */;
INSERT INTO `progress_charts` VALUES (1,1,'line','Weekly Learning Progress','{\"type\": \"line\", \"options\": {\"responsive\": true}}','study_analytics','weekly',0,1,'2025-11-21 04:35:23','2025-11-21 04:35:23'),(2,1,'bar','Study Time Distribution','{\"type\": \"bar\", \"options\": {\"responsive\": true}}','sessions','weekly',0,2,'2025-11-21 04:35:23','2025-11-21 04:35:23');
/*!40000 ALTER TABLE `progress_charts` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-11-23  2:41:26
