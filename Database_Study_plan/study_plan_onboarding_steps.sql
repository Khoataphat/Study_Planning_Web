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
-- Table structure for table `onboarding_steps`
--

DROP TABLE IF EXISTS `onboarding_steps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `onboarding_steps` (
  `step_id` int NOT NULL AUTO_INCREMENT,
  `step_number` int NOT NULL,
  `step_title` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `step_type` enum('tutorial','setup','preference','goal_setting','system_intro') COLLATE utf8mb4_unicode_ci DEFAULT 'tutorial',
  `is_required` tinyint(1) DEFAULT '1',
  `estimated_duration_minutes` int DEFAULT '5',
  `display_order` int DEFAULT NULL,
  `component_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `config` json DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`step_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `onboarding_steps`
--

LOCK TABLES `onboarding_steps` WRITE;
/*!40000 ALTER TABLE `onboarding_steps` DISABLE KEYS */;
INSERT INTO `onboarding_steps` VALUES (1,1,'Welcome','Get familiar with the learning platform','system_intro',1,5,1,'WelcomeStep',NULL,'2025-11-21 04:35:14'),(2,2,'Profile Setup','Optimize your learning experience','setup',1,5,2,'ProfileSetup',NULL,'2025-11-21 04:35:14'),(3,3,'Learning Goals','Define your goals and learning direction','goal_setting',1,5,3,'GoalSetting',NULL,'2025-11-21 04:35:14'),(4,4,'Learning Preferences','Choose subjects of interest','preference',1,5,4,'SubjectPreference',NULL,'2025-11-21 04:35:14');
/*!40000 ALTER TABLE `onboarding_steps` ENABLE KEYS */;
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
