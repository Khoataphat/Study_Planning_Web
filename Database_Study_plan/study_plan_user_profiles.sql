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
-- Table structure for table `user_profiles`
--

DROP TABLE IF EXISTS `user_profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_profiles` (
  `profile_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `year_of_study` int DEFAULT NULL,
  `personality_type` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `preferred_study_time` enum('morning','afternoon','evening','night') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `learning_style` enum('visual','auditory','kinesthetic') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `focus_duration` int DEFAULT '90',
  `goal` text COLLATE utf8mb4_unicode_ci,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`profile_id`),
  KEY `fk_user_profiles_user` (`user_id`),
  CONSTRAINT `fk_user_profiles_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `user_profiles_chk_1` CHECK ((`year_of_study` between 1 and 10))
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_profiles`
--

LOCK TABLES `user_profiles` WRITE;
/*!40000 ALTER TABLE `user_profiles` DISABLE KEYS */;
INSERT INTO `user_profiles` VALUES (1,1,1,'INTJ','morning','visual',90,'Improve grades','2025-11-16 19:03:56'),(2,2,2,'ENFP','evening','auditory',60,'Balance schedule','2025-11-16 19:03:56'),(3,3,3,'ISTP','afternoon','kinesthetic',120,'Prepare for exam','2025-11-16 19:03:56'),(4,4,1,'ENTJ','night','visual',80,'Top class ranking','2025-11-16 19:03:56'),(5,5,4,'INFP','morning','auditory',70,'Reduce stress','2025-11-16 19:03:56'),(6,6,2,'ESFJ','afternoon','visual',100,'More free time','2025-11-16 19:03:56'),(7,7,1,'ISFP','evening','kinesthetic',45,'Improve focus','2025-11-16 19:03:56'),(8,8,3,'ESTJ','morning','visual',110,'Graduate early','2025-11-16 19:03:56'),(9,9,4,'ENFJ','afternoon','auditory',90,'Master difficult subjects','2025-11-16 19:03:56'),(10,10,3,'INTP','night','visual',130,'Research project','2025-11-16 19:03:56');
/*!40000 ALTER TABLE `user_profiles` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-11-23  2:41:23
