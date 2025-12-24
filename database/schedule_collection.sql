CREATE TABLE IF NOT EXISTS `schedule_collection` (
  `collection_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `collection_name` varchar(100) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`collection_id`),
  FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
ALTER TABLE `user_schedule` 
ADD COLUMN `collection_id` int NOT NULL AFTER `user_id`,
ADD CONSTRAINT `fk_schedule_collection` FOREIGN KEY (`collection_id`) REFERENCES `schedule_collection` (`collection_id`) ON DELETE CASCADE;