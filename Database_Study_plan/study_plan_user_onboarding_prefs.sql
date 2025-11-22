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
-- Table structure for table `user_onboarding_prefs`
--

DROP TABLE IF EXISTS `user_onboarding_prefs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_onboarding_prefs` (
  `onboarding_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `preferred_study_times` json DEFAULT NULL,
  `min_session_duration` int DEFAULT '25',
  `max_session_duration` int DEFAULT '120',
  `preferred_duration` int DEFAULT '50',
  `preferred_days` json DEFAULT NULL,
  `short_break_duration` int DEFAULT '5',
  `long_break_duration` int DEFAULT '15',
  `sessions_before_long_break` int DEFAULT '4',
  `workload_level` enum('light','moderate','heavy') DEFAULT 'moderate',
  `weekly_study_hours` int DEFAULT '15',
  `primary_goal` varchar(50) DEFAULT NULL,
  `specific_target` text,
  `onboarding_step` int DEFAULT '1',
  `is_completed` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`onboarding_id`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `user_onboarding_prefs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `user_onboarding_prefs_chk_1` CHECK ((`min_session_duration` <= `max_session_duration`)),
  CONSTRAINT `user_onboarding_prefs_chk_2` CHECK ((`weekly_study_hours` between 5 and 40))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_onboarding_prefs`
--

LOCK TABLES `user_onboarding_prefs` WRITE;
/*!40000 ALTER TABLE `user_onboarding_prefs` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_onboarding_prefs` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-11-23  2:41:25
