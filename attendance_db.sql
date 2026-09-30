-- MySQL dump 10.13  Distrib 26.7.0, for Linux (x86_64)
--
-- Host: localhost    Database: attendance_db
-- ------------------------------------------------------
-- Server version	26.7.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ '81597da4-933e-11f1-8e5b-0242ac110002:1-325';

--
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin` (
  `admin_id` int NOT NULL AUTO_INCREMENT,
  `admin_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `section_name` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`admin_id`),
  UNIQUE KEY `section_name` (`section_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attendance_section`
--

DROP TABLE IF EXISTS `attendance_section`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `attendance_section` (
  `attendance_id` int NOT NULL AUTO_INCREMENT,
  `student_id` int NOT NULL,
  `dactor_id` int NOT NULL,
  `attendance_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`attendance_id`),
  KEY `student_id` (`student_id`),
  KEY `dactor_id` (`dactor_id`),
  CONSTRAINT `attendance_section_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `section_a_b_c` (`student_id`) ON DELETE CASCADE,
  CONSTRAINT `attendance_section_ibfk_2` FOREIGN KEY (`dactor_id`) REFERENCES `dactor` (`dactor_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attendance_section`
--

LOCK TABLES `attendance_section` WRITE;
/*!40000 ALTER TABLE `attendance_section` DISABLE KEYS */;
/*!40000 ALTER TABLE `attendance_section` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dactor`
--

DROP TABLE IF EXISTS `dactor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dactor` (
  `dactor_id` int NOT NULL AUTO_INCREMENT,
  `dactor_name` varchar(100) NOT NULL,
  PRIMARY KEY (`dactor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dactor`
--

LOCK TABLES `dactor` WRITE;
/*!40000 ALTER TABLE `dactor` DISABLE KEYS */;
/*!40000 ALTER TABLE `dactor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sbject`
--

DROP TABLE IF EXISTS `sbject`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sbject` (
  `sbject_id` int NOT NULL AUTO_INCREMENT,
  `sbject_name` varchar(100) NOT NULL,
  `dactor_id` int NOT NULL,
  PRIMARY KEY (`sbject_id`),
  KEY `dactor_id` (`dactor_id`),
  CONSTRAINT `sbject_ibfk_1` FOREIGN KEY (`dactor_id`) REFERENCES `dactor` (`dactor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sbject`
--

LOCK TABLES `sbject` WRITE;
/*!40000 ALTER TABLE `sbject` DISABLE KEYS */;
/*!40000 ALTER TABLE `sbject` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `scanner_admins`
--

DROP TABLE IF EXISTS `scanner_admins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `scanner_admins` (
  `admin_id` int NOT NULL AUTO_INCREMENT,
  `student_id` int NOT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`admin_id`),
  KEY `student_id` (`student_id`),
  CONSTRAINT `scanner_admins_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `section_student` (`student_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `scanner_admins`
--

LOCK TABLES `scanner_admins` WRITE;
/*!40000 ALTER TABLE `scanner_admins` DISABLE KEYS */;
INSERT INTO `scanner_admins` VALUES (1,15,'600000$0b7bf4425a1c970588efca5ff0c138c9$2f665e328bdb516da18954033f98bdebd1706d09a30a9bdbced22611f1664c78'),(2,39,'600000$a3bb76e62de5a4d8e3efca1c85384602$18e6f03dbe9487dc9ba1a1e482ec55657c9f0d2b9e30e643798e424d11a6ba0c'),(3,177,'600000$91a946f464253e10f7517e0edbed69f0$67b308d1bdfea7ea23a672a3fa272f35d97ce43b0321970a291d05685829d829'),(4,138,'600000$d3da5eade3a63f386f300a8ee8ab95e4$99eb903c5364abadf5fecc77b0f42c0733891e80b75e8b4b6291d3c6679ee124'),(5,15,'600000$0b7bf4425a1c970588efca5ff0c138c9$2f665e328bdb516da18954033f98bdebd1706d09a30a9bdbced22611f1664c78'),(6,39,'600000$a3bb76e62de5a4d8e3efca1c85384602$18e6f03dbe9487dc9ba1a1e482ec55657c9f0d2b9e30e643798e424d11a6ba0c'),(7,177,'600000$91a946f464253e10f7517e0edbed69f0$67b308d1bdfea7ea23a672a3fa272f35d97ce43b0321970a291d05685829d829'),(8,138,'600000$d3da5eade3a63f386f300a8ee8ab95e4$99eb903c5364abadf5fecc77b0f42c0733891e80b75e8b4b6291d3c6679ee124'),(9,15,'600000$0b7bf4425a1c970588efca5ff0c138c9$2f665e328bdb516da18954033f98bdebd1706d09a30a9bdbced22611f1664c78'),(10,39,'600000$a3bb76e62de5a4d8e3efca1c85384602$18e6f03dbe9487dc9ba1a1e482ec55657c9f0d2b9e30e643798e424d11a6ba0c'),(11,177,'600000$91a946f464253e10f7517e0edbed69f0$67b308d1bdfea7ea23a672a3fa272f35d97ce43b0321970a291d05685829d829'),(12,138,'600000$d3da5eade3a63f386f300a8ee8ab95e4$99eb903c5364abadf5fecc77b0f42c0733891e80b75e8b4b6291d3c6679ee124'),(13,15,'600000$0b7bf4425a1c970588efca5ff0c138c9$2f665e328bdb516da18954033f98bdebd1706d09a30a9bdbced22611f1664c78'),(14,39,'600000$a3bb76e62de5a4d8e3efca1c85384602$18e6f03dbe9487dc9ba1a1e482ec55657c9f0d2b9e30e643798e424d11a6ba0c'),(15,177,'600000$91a946f464253e10f7517e0edbed69f0$67b308d1bdfea7ea23a672a3fa272f35d97ce43b0321970a291d05685829d829'),(16,138,'600000$d3da5eade3a63f386f300a8ee8ab95e4$99eb903c5364abadf5fecc77b0f42c0733891e80b75e8b4b6291d3c6679ee124');
/*!40000 ALTER TABLE `scanner_admins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `section_a_b_c`
--

DROP TABLE IF EXISTS `section_a_b_c`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `section_a_b_c` (
  `student_id` int NOT NULL AUTO_INCREMENT,
  `student_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `section_student` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`student_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `section_a_b_c`
--

LOCK TABLES `section_a_b_c` WRITE;
/*!40000 ALTER TABLE `section_a_b_c` DISABLE KEYS */;
/*!40000 ALTER TABLE `section_a_b_c` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `section_student`
--

DROP TABLE IF EXISTS `section_student`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `section_student` (
  `student_id` int NOT NULL AUTO_INCREMENT,
  `student_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `section_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`student_id`)
) ENGINE=InnoDB AUTO_INCREMENT=333 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `section_student`
--

LOCK TABLES `section_student` WRITE;
/*!40000 ALTER TABLE `section_student` DISABLE KEYS */;
INSERT INTO `section_student` VALUES (1,'أحمد ماجد صبيح محمد','A'),(2,'أسمى وسام حسن خلاوي','A'),(3,'أواب اديب جمعه خضر','A'),(4,'أيلاف عبد القادر عباس علي','A'),(5,'إبراهيم عماد حسن ضاحي','A'),(6,'إبراهيم فاهم ياسين عبد ربه','A'),(7,'إبراهيم محمد غالب عبد الباقي','A'),(8,'إبراهيم محمد قاسم إبراهيم','A'),(9,'احمد إبراهيم فضل الله احمد','A'),(10,'احمد صادق عباس جاسر','A'),(11,'احمد صفاء سعيد كاظم','A'),(12,'احمد عباس عناد شعيب','A'),(13,'احمد عبد الخالق مخيبر نجم','A'),(14,'احمد عثمان سعيد رجب','A'),(15,'احمد فرات حسين موسى','A'),(16,'احمد كريم صالح احمد','A'),(17,'احمد لؤي هادي سلمان','A'),(18,'احمد مازن خضير محمد','A'),(19,'احمد محمد احمد محمود','A'),(20,'احمد محمد يوسف يعقوب','A'),(21,'الاء حسام محمد اديب محمد اديب','A'),(22,'الحسين حيدر حميد رشيد','A'),(23,'الطيب اياد رحيم عبد','A'),(24,'امير تسيار غبيش عبد الحسين','A'),(25,'أمير حيدر حسن خضير','A'),(26,'أمير دريد منصور','A'),(27,'أمير سرمد لطفي إسماعيل','A'),(28,'أمير علي جعفر طعمه','A'),(29,'أمير علي غالب محسن','A'),(30,'أمير عمار هادي صالح','A'),(31,'أمير عمار فوزي عطيه','A'),(32,'أمير مجيد خليل علي','A'),(33,'انمار بدر سمير خليفه','A'),(34,'انوار ماهر يعكوب يوسف','A'),(35,'اواب مهند فليح','A'),(36,'أيات مؤيد ناصر سلطان','A'),(37,'ايهم وليد احمد عاصي','A'),(38,'ايوب محمد جاسم محمد','A'),(39,'بركات عدنان دحام حمادي','A'),(40,'بسام محمد جعفر كاظم','A'),(41,'بكر محمد حجج جاسم','A'),(42,'بلال احمد حسين طلب','A'),(43,'بلال محمد جعفر وهيب','A'),(44,'بنين علي خلف حمد','A'),(45,'بهاء الدين علي جبار','A'),(46,'تانيا سالم صادق جعفر','A'),(47,'تبارك احمد حسين علي','A'),(48,'تسنيم عماد محمود عبد الله','A'),(49,'ثوبان صلاح اسعد محمد','A'),(50,'جعفر الطيار محسن علي عطية','A'),(51,'جعفر صادق ياسين حسين','A'),(52,'جعفر لطيف جبار صالح','A'),(53,'جعفر محمد علي جبار كاظم','A'),(54,'حارث فلاح حسن علوان','A'),(55,'حب الله علاء عودة جودة','A'),(56,'حر كميل سلمان جواد','A'),(57,'حسام احمد بلاسم كاطع','A'),(58,'حسام طارق ياسين خضر','A'),(59,'حسن جلال طالب محمد','A'),(60,'حسن عبد الرزاق عبد الامير حسون','A'),(61,'حسن عبد الكريم عوده السعدي','A'),(62,'حسن علي درويش خضر','A'),(63,'حسن علي يونس حسن','A'),(64,'حسن هاشم وليد يوسف','A'),(65,'حسن يحيى غافل علوان','A'),(66,'حسن يوسف حاتم ارزيعج','A'),(67,'حسين جعفر عبد الحسين جاسم','A'),(68,'حسين ريسان ياس خضر','A'),(69,'حسين سالم حسن مطر','A'),(70,'حسين سعدي فياض كاظم','A'),(71,'حسين ظفار هليل كريم','A'),(72,'حسين عادل كاظم عبيد','A'),(73,'حسين علاء خميس جفات','A'),(74,'حسين علوان عباس خضير','A'),(75,'حسين علي عبد جميغ','A'),(76,'حسين علي عطية زيدان','A'),(77,'حسين علي كعوك خلباص','A'),(78,'حسين فرات عبد الرسول مرهون','A'),(79,'حسين هيثم قاسم صغير','A'),(80,'حمزه عباس جاسم محمد','A'),(81,'حيدر سعد عباس سلمان','A'),(82,'حيدر علي حمزة ابراهيم','A'),(83,'حيدر محمد ماجد حيدر','A'),(84,'حيدر ميثم عوده عبد','A'),(85,'حيدر نهاد خالد عطيه','A'),(86,'حيدر وسام رزاق صيهود','A'),(87,'خالد ساير تبان مرعي','A'),(88,'خلدون وليد عمر محمود','A'),(89,'خليل واثق خليل خماس','A'),(90,'ديار احسان خلف جاسم','A'),(91,'دينا محمد قاسم كاظم','A'),(92,'ذوالفقار نصير ماجد جابر','A'),(93,'رامي خالد حاجم منفي','A'),(94,'رامي ظافر صبري مهدي','A'),(95,'رانيا سليم جواد كاظم','A'),(96,'رانيا غاندي اسماعيل حقي','A'),(97,'رشيد صالح رشيد صالح','A'),(98,'رضا اياد هادي رشيد','A'),(99,'رضا باسم محسن ناجي','A'),(100,'رضا حسن علي حسين','A'),(101,'رعد دحام منصور حسين','A'),(102,'رفل سعيد مجيد سعيد','A'),(103,'روان احمد طالب محمد','A'),(104,'روان عدي حاتم حسن','A'),(105,'زهراء جبار شنخ لفته','A'),(106,'زهراء سالم حسين عباس','A'),(107,'زهراء سيف علي فاضل','A'),(108,'زهراء صالح سرحان حمد الله','A'),(109,'زيد عدنان فاضل جواد','B'),(110,'زيد محمد قدوري محمود','B'),(111,'زيد محمد كريم لطيف','B'),(112,'زين العابدين علي عمران مهدي','B'),(113,'زين قيس مهدي عبود','B'),(114,'زينب حسين عيال جياد','B'),(115,'زينب رحيم قاسم كزار','B'),(116,'زينب سلام صدام مشتت','B'),(117,'زينة عدنان مهدي الربيعي','B'),(118,'زينه احمد حديد عارف','B'),(119,'سجاد حيدر عبد الواحد علوان','B'),(120,'سجاد سعدي محمود خلف','B'),(121,'سجاد طارق ناصر خير الله','B'),(122,'سجاد قاسم وراد حسون','B'),(123,'سجاد مؤيد حاكم عيسى','B'),(124,'سجاد هاني علي زاير حسين','B'),(125,'سجاد وائل سمير عليوي','B'),(126,'سجى صباح نوري محمد','B'),(127,'سراج الدين عماد يونس احمد','B'),(128,'سعد احمد فاضل فرحان','B'),(129,'سلوى حسام عبد الحسين عباس','B'),(130,'سيف الدين اركان حميد بنيان','B'),(131,'شهد باسم عبد كريم','B'),(132,'شيرين حيدر مانع','B'),(133,'صفا عمار عبد الحسين خضير','B'),(134,'صهيب سعيد هادي سعيد','B'),(135,'صهيب علي حبيب جابر','B'),(136,'ضاري صباح كاظم جوده','B'),(137,'ضي رائد هادي وهيب','B'),(138,'طه احمد غازي عاصي','B'),(139,'طه محمد صالح كاظم','B'),(140,'طيبة جمعة فحاط عظم','B'),(141,'طيبة اسماعيل جهيد جويد','B'),(142,'عباس علي سلمان حسن','B'),(143,'عباس عمار خلف كاظم','B'),(144,'عبد الرحمن ابراهيم لطيف عبد الله','B'),(145,'عبد الرحمن حسين بدر احمد','B'),(146,'عبد الرحمن فيصل غازي دهام','B'),(147,'عبد الرحمن محمد عبد العزيز شكر','B'),(148,'عبد العباس غانم عبد العباس عيسى','B'),(149,'عبد العزيز عمر واصف هامل','B'),(150,'عبد الله اسامة عبد الجبار شكر','B'),(151,'عبد الله انمار محمد صالح','B'),(152,'عبد الله اياد سلمان شلال','B'),(153,'عبد الله ايهاب امجد سلمان','B'),(154,'عبد الله عبد الحافظ كريم حسين','B'),(155,'عبد الله محمد سامي طه','B'),(156,'عبد الله مصطفى حميد رشيد','B'),(157,'عبد الله وسام علي عباس','B'),(158,'عبد المجيد مجول درويش مهنا','B'),(159,'عبد المهيمن صلاح فليح حسن','B'),(160,'عبدالله احمد حمدي عبد الرزاق','B'),(161,'عبدالله احمد خضير هلال','B'),(162,'علي احمد اسماعيل جاسم','B'),(163,'علي احمد عبد الخالق عبد الغني','B'),(164,'علي السجاد هيبت عبد الله كريم','B'),(165,'علي باسم عوده غانم','B'),(166,'علي برهان عبد الرحيم عبد الودود','B'),(167,'علي جاسم داود عبد الله','B'),(168,'علي حسين خالد شكر','B'),(169,'علي حسين عبد محمد','B'),(170,'علي حسين فاضل علي','B'),(171,'علي حسين محسون كاطع','B'),(172,'علي حميد جابر ياسر','B'),(173,'علي خماس راضي حاجم','B'),(174,'علي رياض هادي كطوف','B'),(175,'علي زهير قمر عبد الشهيد','B'),(176,'علي سمير مزعل عبد الحسين','B'),(177,' علي شرهان عطية عاتي','B'),(178,'علي ضياء عدنان جاسم','B'),(179,'علي طاهر عبد الزهره رمضان','B'),(180,'علي عمر حامد خضير','B'),(181,'علي فؤاد جبار طاهر','B'),(182,'علي قحطان عدنان راضي','B'),(183,'علي قاسم عبد الامير حوشان','B'),(184,'علي ماجد حسين عبود','B'),(185,'علي محمد خلف رسن','B'),(186,'علي محمد عادل حمزه','B'),(187,'علي محمد والي مريوش','B'),(188,'علي مسافر لفته حسين','B'),(189,'علي منير حبيب كاظم','B'),(190,'علي ميثم عمران مهدي','B'),(191,'علي هشام عبد الرحمن محمد','B'),(192,'عماد مثنى هاشم عباس','B'),(193,'عمار سالم محمد علوان','B'),(194,'عمر الفاروق هاشم طه محمد','B'),(195,'عمر صفاء معين لفتة','B'),(196,'عمر لؤي حاتم فرحان','B'),(197,'عمر محمد اسماعيل محمد','B'),(198,'عمران جبار عبد جديع','B'),(199,'عيسى حامد نوري عبد الكريم','B'),(200,'عيسى شكر عبد الله محمد','B'),(201,'غاده صادق كاظم تعبان','B'),(202,'غدير كمال جواد كاظم','B'),(203,'غسان عامر علي سريسح','B'),(204,'غيث عبد القادر صبحي صالح','B'),(205,'غيث عدي دروش علي','B'),(206,'غيث معمر نصيف جاسم','B'),(207,'فاطمه احمد زباري سلمان','B'),(208,'فاطمه حسن عبد الهادي عبد الامير','B'),(209,'فاطمه عمار خليل ابراهيم','B'),(210,'فجر فيصل فوزي جميل','B'),(211,'فدك الزهراء ثائر غازي معله','B'),(212,'فهد احمد علي فهد','B'),(213,'فهد احمد يوسف حميد','B'),(214,'فهد جلال عبد الامير عباس','B'),(215,'فهد عامر محمود احمد','B'),(216,'فيصل قتيبه قاسم مزعل','B'),(217,'قيس ستار يعقوب عذاب','B'),(218,'كرار ثامر جبوري عبد علي','B'),(219,'كرار حيدر عامر جاسم','B'),(220,'كرار علي صالح كاظم','B'),(221,'كرار عمر حميد محمد','B'),(222,'كرار فراس عبد الصاحب مهدي','B'),(223,'كرار محمد داود مجيد','B'),(224,'ليث خضير عباس عزيز','C'),(225,'ليث سعد احمد مرزوق','C'),(226,'ليث صباح جبار السامرائي','C'),(227,'لينا احمد عبد الصاحب هاشم','C'),(228,'مؤمل عدي ياسين ابراهيم','C'),(229,'مجتبى حامد مرهون حمد','C'),(230,'مجتبى فلاح حسن عبد العباس','C'),(231,'محمد اسماعيل خلف اسماعيل','C'),(232,'محمد اسماعيل رفيق اسماعيل','C'),(233,'محمد الامين عدي زاحم غافل','C'),(234,'محمد الباقر منير سلمان عوفي','C'),(235,'محمد الجواد حيدر حسن لطيف','C'),(236,'محمد الحبيب عبد الجبار عبود','C'),(237,'محمد باقر عادل محمد علاوي','C'),(238,'محمد جعفر صادق سلمان','C'),(239,'محمد حسين طالب صادق سعيد','C'),(240,'محمد حكمت عادل عاشور','C'),(241,'محمد حيدر سلمان داود','C'),(242,'محمد حيدر علي عباس','C'),(243,'محمد خالد حريمط خفيف','C'),(244,'محمد خضير عباس محمد','C'),(245,'محمد رضا محمد ابراهيم عبد','C'),(246,'محمد رعد فخري طه','C'),(247,'محمد صباح شاهر حسين','C'),(248,'محمد صلاح محمد حسين','C'),(249,'محمد صلاح مهدي حسين','C'),(250,'محمد طاهر علوان سلمان','C'),(251,'محمد عبد الغفار وهيب هاشم','C'),(252,'محمد عبد اللطيف مبدر عبد العباس','C'),(253,'محمد عدي خليل عبد الهادي','C'),(254,'محمد علي حميد كاظم','C'),(255,'محمد علي خليفه محيسن','C'),(256,'محمد علي محمد جاسم','C'),(257,'محمد علي هاشم عبد','C'),(258,'محمد عمار زهير عباس','C'),(259,'محمد فؤاد حمد خليفه','C'),(260,'محمد فلح حسن علي','C'),(261,'محمد فوزي عزيز عبد','C'),(262,'محمد لؤي هادي سلمان','C'),(263,'محمد ماجد جاسم عباس','C'),(264,'محمد مثنى خيري عباس','C'),(265,'محمد مجيد خضير مجيد','C'),(266,'محمد هاني فوزي ناجي زيني','C'),(267,'محمود رعد كاطع صالح','C'),(268,'محمود علي هاشم جاسم','C'),(269,'مرتضى عبد الامير عبد يوسف','C'),(270,'مرتضى عبد خليف مرعى','C'),(271,'مرتضى علي صادق فاضل','C'),(272,'مريم انيس عبد الاله صالح','C'),(273,'مريم عدي فاروق جنجون','C'),(274,'مريم محمد اسماعيل جليل','C'),(275,'مريم محمد كامل عوده','C'),(276,'مريم وضاح نعمت شاكر','C'),(277,'مصطفى ابو ذر جاسم حمود','C'),(278,'مصطفى احمد صاحب مجيد','C'),(279,'مصطفى احمد ماجد حيدر','C'),(280,'مصطفى اسامة ابراهيم محمد','C'),(281,'مصطفى اشرف كامل محمد','C'),(282,'مصطفى ايسر احمد حمد','C'),(283,'مصطفى حامد محمد خضير','C'),(284,'مصطفى حسين علي محمد','C'),(285,'مصطفى حسين علي ناجي','C'),(286,'مصطفى حيدر خضير عباس','C'),(287,'مصطفى سلمان علي محمد','C'),(288,'مصطفى صباح موسى عودة','C'),(289,'مصطفى طالب معن عبد الرحيم','C'),(290,'مصطفى ظاهر شاكر جواد','C'),(291,'مصطفى عبد الرحمن جميل علي','C'),(292,'مصطفى قائد احمد فهد','C'),(293,'مصطفى محمد عباس هاشم','C'),(294,'مصطفى يوسف كوان هادي','C'),(295,'مصعب امين فيصل نهاد','C'),(296,'مقتدى عادل عكار عبود','C'),(297,'مقتدى محمد سعدون جاسم','C'),(298,'ملاك مهند جاسم هاشم','C'),(299,'منار عدنان عبد الرزاق علي','C'),(300,'منتظر ابراهيم مجيد كريم','C'),(301,'منتظر امجد فرحان عوده','C'),(302,'منتظر اياد محجوب جاسم','C'),(303,'منيا مثنى شاكر ابو خضير','C'),(304,'مهدي لطيف ثجيل خشاب','C'),(305,'مهدي مهند عيدان عطية','C'),(306,'موسى الكاظم رحيم كريم مطلك','C'),(307,'موسى ماهر محمد حتروش','C'),(308,'مينا حميد عبدالكريم عبد الله','C'),(309,'نبأ هيثم عبد صدام','C'),(310,'نذير علاء شبوط كاظم','C'),(311,'نصر الله عبد اللطيف رحيم كاظم','C'),(312,'نمير احمد عبد الرزاق عبد الكريم','C'),(313,'نور اركان عيسى خضير','C'),(314,'نور الزهراء امين جليل سلمان','C'),(315,'نور المصطفى احمد غازي عاصي','C'),(316,'نورهان خالد محمد حياوي','C'),(317,'هشام عماد جاسم محمد','C'),(318,'همام محمد جهاد فياض','C'),(319,'همام هاشم شلال حميد','C'),(320,'وارث حيدر كصاب فرحان','C'),(321,'وسام محمد علي مجلد جبر','C'),(322,'وليد خالد نوري رحيم','C'),(323,'ياسر صدام حسن علي','C'),(324,'ياسر عبد الرحمن عبد الله فرحان','C'),(325,'ياسر عمر عبد المنعم حسين','C'),(326,'ياسر قاسم وردي ابراهيم','C'),(327,'يوسف اركان صالح مهدي','C'),(328,'يوسف سيروان أنور محمد','C'),(329,'يوسف سيف الدين بدر صالح','C'),(330,'يوسف عمار هاشم محمد','C'),(331,'يوسف فاضل رشيد غايب','C'),(332,'يوسف وعد عبد الرحمن محمود','C');
/*!40000 ALTER TABLE `section_student` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_exceptions`
--

DROP TABLE IF EXISTS `student_exceptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_exceptions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int NOT NULL,
  `allowed_section` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `notes` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `student_id` (`student_id`),
  CONSTRAINT `student_exceptions_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `section_student` (`student_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_exceptions`
--

LOCK TABLES `student_exceptions` WRITE;
/*!40000 ALTER TABLE `student_exceptions` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_exceptions` ENABLE KEYS */;
UNLOCK TABLES;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-29 23:36:03
