-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: localhost    Database: library_management
-- ------------------------------------------------------
-- Server version	8.4.2

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
-- Table structure for table `books`
--

DROP TABLE IF EXISTS `books`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `books` (
  `Book_Id` int NOT NULL AUTO_INCREMENT,
  `Title` varchar(255) NOT NULL,
  `Author` varchar(255) DEFAULT NULL,
  `Genre` varchar(50) DEFAULT NULL,
  `Published_Year` int DEFAULT NULL,
  `Available` tinyint(1) DEFAULT '1',
  `Created_At` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Book_Id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `books`
--

LOCK TABLES `books` WRITE;
/*!40000 ALTER TABLE `books` DISABLE KEYS */;
INSERT INTO `books` VALUES (1,'The Catcher in the Rye','J.D. Salinger','Fiction',1951,1,'2024-11-16 23:51:35'),(2,'Brave New World','Aldous Huxley','Dystopian',1932,1,'2024-11-16 23:51:35'),(3,'War and Peace','Leo Tolstoy','Historical Fiction',1869,1,'2024-11-16 23:51:35'),(4,'The Hobbit','J.R.R. Tolkien','Fantasy',1937,1,'2024-11-16 23:51:35'),(5,'The Alchemist','Paulo Coelho','Philosophical',1988,1,'2024-11-16 23:51:35'),(6,'Crime and Punishment','Fyodor Dostoevsky','Psychological Fiction',1866,1,'2024-11-16 23:51:35'),(7,'The Lord of the Rings','J.R.R. Tolkien','Fantasy',1954,1,'2024-11-16 23:51:35'),(8,'Harry Potter and the Philosopher\'s Stone','J.K. Rowling','Fantasy',1997,1,'2024-11-16 23:51:35');
/*!40000 ALTER TABLE `books` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employees`
--

DROP TABLE IF EXISTS `employees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employees` (
  `Employee_Id` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) NOT NULL,
  `Position` varchar(100) DEFAULT NULL,
  `Hire_Date` date DEFAULT NULL,
  `Email` varchar(100) DEFAULT NULL,
  `Phone` varchar(20) DEFAULT NULL,
  `Address` varchar(255) DEFAULT NULL,
  `Created_At` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Employee_Id`),
  UNIQUE KEY `Email` (`Email`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employees`
--

LOCK TABLES `employees` WRITE;
/*!40000 ALTER TABLE `employees` DISABLE KEYS */;
INSERT INTO `employees` VALUES (1,'Clara Miller','Archivist','2020-07-12','clara.m@library.com','+3456789012','789 Literature Rd, Citytown','2024-11-16 23:51:35'),(2,'David Brown','IT Specialist','2019-11-30','david.b@library.com','+4567890123','321 Tech Blvd, Citytown','2024-11-16 23:51:35'),(3,'Eva White','Librarian','2023-01-15','eva.w@library.com','+5678901234','654 History Ln, Citytown','2024-11-16 23:51:35'),(4,'George King','Assistant Librarian','2020-08-22','george.k@library.com','+6789012345','987 Fiction Ave, Citytown','2024-11-16 23:51:35'),(5,'Hannah Scott','Event Coordinator','2021-05-10','hannah.s@library.com','+7890123456','321 Book Rd, Citytown','2024-11-16 23:51:35'),(6,'Isaac Newton','Technical Staff','2020-03-01','isaac.n@library.com','+8901234567','456 Science St, Citytown','2024-11-16 23:51:35'),(7,'Julia Roberts','Research Assistant','2022-09-15','julia.r@library.com','+9012345678','789 Archive St, Citytown','2024-11-16 23:51:35'),(8,'Kevin Parker','HR Manager','2021-11-01','kevin.p@library.com','+1234567809','123 Manager Blvd, Citytown','2024-11-16 23:51:35');
/*!40000 ALTER TABLE `employees` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `loans`
--

DROP TABLE IF EXISTS `loans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `loans` (
  `Loan_Id` int NOT NULL AUTO_INCREMENT,
  `Book_Id` int NOT NULL,
  `Reader_Id` int NOT NULL,
  `Employee_Id` int NOT NULL,
  `Loan_Date` date DEFAULT (curdate()),
  `Return_Due_Date` date NOT NULL,
  `Return_Date` date DEFAULT NULL,
  `Status` enum('returned','overdue','on loan') DEFAULT 'on loan',
  `Created_At` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Loan_Id`),
  KEY `Book_Id` (`Book_Id`),
  KEY `Reader_Id` (`Reader_Id`),
  KEY `Employee_Id` (`Employee_Id`),
  CONSTRAINT `loans_ibfk_1` FOREIGN KEY (`Book_Id`) REFERENCES `books` (`Book_Id`) ON DELETE CASCADE,
  CONSTRAINT `loans_ibfk_2` FOREIGN KEY (`Reader_Id`) REFERENCES `readers` (`Reader_Id`) ON DELETE CASCADE,
  CONSTRAINT `loans_ibfk_3` FOREIGN KEY (`Employee_Id`) REFERENCES `employees` (`Employee_Id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `loans`
--

LOCK TABLES `loans` WRITE;
/*!40000 ALTER TABLE `loans` DISABLE KEYS */;
INSERT INTO `loans` VALUES (1,1,1,1,'2023-11-01','2023-11-15',NULL,'overdue','2024-11-16 23:51:35'),(2,2,2,2,'2023-11-03','2023-11-17',NULL,'returned','2024-11-16 23:51:35'),(3,1,1,1,'2023-11-01','2023-11-15',NULL,'overdue','2024-11-16 23:51:35'),(4,2,2,2,'2023-11-03','2023-11-17',NULL,'returned','2024-11-16 23:51:35'),(5,3,3,3,'2023-11-05','2023-11-19',NULL,'overdue','2024-11-16 23:51:35'),(6,4,4,4,'2023-11-07','2023-11-21',NULL,'overdue','2024-11-16 23:51:35'),(7,5,5,5,'2023-11-09','2023-11-23',NULL,'returned','2024-11-16 23:51:35'),(8,6,6,6,'2023-11-11','2023-11-25',NULL,'overdue','2024-11-16 23:51:35'),(9,7,7,7,'2023-11-13','2023-11-27',NULL,'overdue','2024-11-16 23:51:35'),(10,8,8,8,'2023-11-15','2023-11-29',NULL,'overdue','2024-11-16 23:51:35');
/*!40000 ALTER TABLE `loans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `overduebooks`
--

DROP TABLE IF EXISTS `overduebooks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `overduebooks` (
  `Overdue_Id` int NOT NULL AUTO_INCREMENT,
  `Loan_Id` int DEFAULT NULL,
  `Reader_Id` int DEFAULT NULL,
  `Overdue_Days` int DEFAULT NULL,
  `Fine_Amount` decimal(10,2) DEFAULT NULL,
  `Calculated_Date` date DEFAULT (curdate()),
  `Payment_Status` enum('paid','unpaid') DEFAULT 'unpaid',
  `Created_At` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Overdue_Id`),
  UNIQUE KEY `Loan_Id` (`Loan_Id`),
  CONSTRAINT `overduebooks_ibfk_1` FOREIGN KEY (`Loan_Id`) REFERENCES `loans` (`Loan_Id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `overduebooks`
--

LOCK TABLES `overduebooks` WRITE;
/*!40000 ALTER TABLE `overduebooks` DISABLE KEYS */;
INSERT INTO `overduebooks` VALUES (1,1,NULL,368,132.48,'2024-11-17','unpaid','2024-11-16 23:51:37'),(2,3,NULL,368,132.48,'2024-11-17','unpaid','2024-11-16 23:51:37'),(3,5,NULL,364,131.04,'2024-11-17','unpaid','2024-11-16 23:51:37'),(4,6,NULL,362,130.32,'2024-11-17','unpaid','2024-11-16 23:51:37'),(5,8,NULL,358,128.88,'2024-11-17','unpaid','2024-11-16 23:51:37'),(6,9,NULL,356,128.16,'2024-11-17','unpaid','2024-11-16 23:51:37'),(7,10,NULL,354,127.44,'2024-11-17','unpaid','2024-11-16 23:51:37');
/*!40000 ALTER TABLE `overduebooks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `readers`
--

DROP TABLE IF EXISTS `readers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `readers` (
  `Reader_Id` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) NOT NULL,
  `Registration_Date` date DEFAULT (curdate()),
  `Email` varchar(100) DEFAULT NULL,
  `Phone` varchar(20) DEFAULT NULL,
  `Address` varchar(255) DEFAULT NULL,
  `Created_At` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Reader_Id`),
  UNIQUE KEY `Email` (`Email`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `readers`
--

LOCK TABLES `readers` WRITE;
/*!40000 ALTER TABLE `readers` DISABLE KEYS */;
INSERT INTO `readers` VALUES (1,'Michael Adams','2023-04-10','michael.adams@example.com','+9998887777','333 Pine St, Citytown','2024-11-16 23:51:35'),(2,'Sarah Lee','2023-05-25','sarah.lee@example.com','+5554443333','444 Cedar Ln, Citytown','2024-11-16 23:51:35'),(3,'Tom Walker','2023-06-15','tom.walker@example.com','+2223334444','555 Spruce Rd, Citytown','2024-11-16 23:51:35'),(4,'Natalie Green','2023-07-20','natalie.green@example.com','+3332221111','666 Oak St, Citytown','2024-11-16 23:51:35'),(5,'Oliver Black','2023-08-05','oliver.black@example.com','+7776665555','777 Willow Dr, Citytown','2024-11-16 23:51:35'),(6,'Sophia Grey','2023-09-10','sophia.grey@example.com','+1113335555','888 Aspen Ave, Citytown','2024-11-16 23:51:35'),(7,'Daniel Carter','2023-10-01','daniel.carter@example.com','+2224446666','999 Redwood Ln, Citytown','2024-11-16 23:51:35'),(8,'Ella White','2023-10-15','ella.white@example.com','+3335557777','101 Maple Blvd, Citytown','2024-11-16 23:51:35');
/*!40000 ALTER TABLE `readers` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-11-17  2:52:37
