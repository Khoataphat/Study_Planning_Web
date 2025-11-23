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
-- Table structure for table `onboarding_config`
--

DROP TABLE IF EXISTS `onboarding_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `onboarding_config` (
  `config_id` int NOT NULL AUTO_INCREMENT,
  `config_type` enum('study_time','duration','day','workload','goal') NOT NULL,
  `config_key` varchar(50) NOT NULL,
  `config_value` varchar(100) NOT NULL,
  `display_order` int DEFAULT '0',
  `description` text,
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`config_id`)
) ENGINE=InnoDB AUTO_INCREMENT=76 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `onboarding_config`
--

LOCK TABLES `onboarding_config` WRITE;
/*!40000 ALTER TABLE `onboarding_config` DISABLE KEYS */;
INSERT INTO `onboarding_config` VALUES (1,'study_time','morning','Morning (6AM - 12PM)',1,'Study in the morning',1),(2,'study_time','afternoon','Afternoon (12PM - 6PM)',2,'Study in the afternoon',1),(3,'study_time','evening','Evening (6PM - 10PM)',3,'Study in the evening',1),(4,'study_time','night','Night (10PM - 6AM)',4,'Study at night',1),(5,'duration','25','25 minutes',1,'Suitable for Pomodoro technique',1),(6,'duration','45','45 minutes',2,'Standard duration',1),(7,'duration','60','1 hour',3,'Short study session',1),(8,'duration','90','1.5 hours',4,'Average study session',1),(9,'duration','120','2 hours',5,'Long study session',1),(10,'duration','180','3 hours',6,'Intensive study session',1),(11,'day','Mon','Monday',1,'Monday',1),(12,'day','Tue','Tuesday',2,'Tuesday',1),(13,'day','Wed','Wednesday',3,'Wednesday',1),(14,'day','Thu','Thursday',4,'Thursday',1),(15,'day','Fri','Friday',5,'Friday',1),(16,'day','Sat','Saturday',6,'Saturday',1),(17,'day','Sun','Sunday',7,'Sunday',1),(18,'workload','light','Light (10-15 hours/week)',1,'Suitable for busy students',1),(19,'workload','moderate','Moderate (15-25 hours/week)',2,'Balance between study and rest',1),(20,'workload','heavy','Heavy (25-35 hours/week)',3,'High intensity for important goals',1),(21,'goal','exam_prep','Exam Preparation',1,'Prepare for final exams, certifications',1),(22,'goal','skill_improvement','Skill Improvement',2,'Enhance professional skills',1),(23,'goal','grade_boost','Grade Improvement',3,'Improve GPA, academic ranking',1),(24,'goal','balance','Life Balance',4,'Balance between study and personal life',1),(25,'goal','project','Project Completion',5,'Focus on personal projects',1),(26,'study_time','morning','Morning (6AM - 12PM)',1,'Study in the morning',1),(27,'study_time','afternoon','Afternoon (12PM - 6PM)',2,'Study in the afternoon',1),(28,'study_time','evening','Evening (6PM - 10PM)',3,'Study in the evening',1),(29,'study_time','night','Night (10PM - 6AM)',4,'Study at night',1),(30,'duration','25','25 minutes',1,'Suitable for Pomodoro technique',1),(31,'duration','45','45 minutes',2,'Standard duration',1),(32,'duration','60','1 hour',3,'Short study session',1),(33,'duration','90','1.5 hours',4,'Average study session',1),(34,'duration','120','2 hours',5,'Long study session',1),(35,'duration','180','3 hours',6,'Intensive study session',1),(36,'day','Mon','Monday',1,'Monday',1),(37,'day','Tue','Tuesday',2,'Tuesday',1),(38,'day','Wed','Wednesday',3,'Wednesday',1),(39,'day','Thu','Thursday',4,'Thursday',1),(40,'day','Fri','Friday',5,'Friday',1),(41,'day','Sat','Saturday',6,'Saturday',1),(42,'day','Sun','Sunday',7,'Sunday',1),(43,'workload','light','Light (10-15 hours/week)',1,'Suitable for busy students',1),(44,'workload','moderate','Moderate (15-25 hours/week)',2,'Balance between study and rest',1),(45,'workload','heavy','Heavy (25-35 hours/week)',3,'High intensity for important goals',1),(46,'goal','exam_prep','Exam Preparation',1,'Prepare for final exams, certifications',1),(47,'goal','skill_improvement','Skill Improvement',2,'Enhance professional skills',1),(48,'goal','grade_boost','Grade Improvement',3,'Improve GPA, academic ranking',1),(49,'goal','balance','Life Balance',4,'Balance between study and personal life',1),(50,'goal','project','Project Completion',5,'Focus on personal projects',1),(51,'study_time','morning','Morning (6AM - 12PM)',1,'Study in the morning',1),(52,'study_time','afternoon','Afternoon (12PM - 6PM)',2,'Study in the afternoon',1),(53,'study_time','evening','Evening (6PM - 10PM)',3,'Study in the evening',1),(54,'study_time','night','Night (10PM - 6AM)',4,'Study at night',1),(55,'duration','25','25 minutes',1,'Suitable for Pomodoro technique',1),(56,'duration','45','45 minutes',2,'Standard duration',1),(57,'duration','60','1 hour',3,'Short study session',1),(58,'duration','90','1.5 hours',4,'Average study session',1),(59,'duration','120','2 hours',5,'Long study session',1),(60,'duration','180','3 hours',6,'Intensive study session',1),(61,'day','Mon','Monday',1,'Monday',1),(62,'day','Tue','Tuesday',2,'Tuesday',1),(63,'day','Wed','Wednesday',3,'Wednesday',1),(64,'day','Thu','Thursday',4,'Thursday',1),(65,'day','Fri','Friday',5,'Friday',1),(66,'day','Sat','Saturday',6,'Saturday',1),(67,'day','Sun','Sunday',7,'Sunday',1),(68,'workload','light','Light (10-15 hours/week)',1,'Suitable for busy students',1),(69,'workload','moderate','Moderate (15-25 hours/week)',2,'Balance between study and rest',1),(70,'workload','heavy','Heavy (25-35 hours/week)',3,'High intensity for important goals',1),(71,'goal','exam_prep','Exam Preparation',1,'Prepare for final exams, certifications',1),(72,'goal','skill_improvement','Skill Improvement',2,'Enhance professional skills',1),(73,'goal','grade_boost','Grade Improvement',3,'Improve GPA, academic ranking',1),(74,'goal','balance','Life Balance',4,'Balance between study and personal life',1),(75,'goal','project','Project Completion',5,'Focus on personal projects',1);
/*!40000 ALTER TABLE `onboarding_config` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-11-23  2:41:24
