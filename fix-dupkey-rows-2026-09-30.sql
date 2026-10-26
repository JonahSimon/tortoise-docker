/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-11.8.8-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: fix
-- ------------------------------------------------------
-- Server version	11.8.8-MariaDB-ubu2404

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

--
-- Dumping data for table `broadcast_text`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `broadcast_text` WRITE;
/*!40000 ALTER TABLE `broadcast_text` DISABLE KEYS */;
REPLACE INTO `broadcast_text` VALUES (6230202,'The others always laugh at me for forgetting the name of Stormwind\'s second king. It\'s getting embarrassing...','The others always laugh at me for forgetting the name of Stormwind\'s second king. It\'s getting embarrassing...',0,0,0,0,0,0,0,0,0);
REPLACE INTO `broadcast_text` VALUES (6230201,'School is so boring. I\'d rather throw some punches with Brick, atleast he knows how to have fun!','School is so boring. I\'d rather throw some punches with Brick, atleast he knows how to have fun!',0,0,0,0,0,0,0,0,0);
REPLACE INTO `broadcast_text` VALUES (6230107,'Hehe, you\'re funny!','Hehe, you\'re funny!',0,0,0,0,0,0,0,0,0);
REPLACE INTO `broadcast_text` VALUES (6230306,'Thank you! Sister Argent is a very nice woman, so I want to do my best to make her smile!','Thank you! Sister Argent is a very nice woman, so I want to do my best to make her smile!',0,0,0,0,0,0,0,0,0);
REPLACE INTO `broadcast_text` VALUES (6230106,'Oh! The shiny yellow stones, I saw one of those at the blacksmith once!','Oh! The shiny yellow stones, I saw one of those at the blacksmith once!',0,0,0,0,0,0,0,0,0);
REPLACE INTO `broadcast_text` VALUES (6230203,'Theoden Wrynn.','Theoden Wrynn.',0,0,0,0,0,0,0,0,0);
REPLACE INTO `broadcast_text` VALUES (6230204,'Barathen Wrynn.','Barathen Wrynn.',0,0,0,0,0,0,0,0,0);
REPLACE INTO `broadcast_text` VALUES (6230205,'Llane Wrynn.','Llane Wrynn.',0,0,0,0,0,0,0,0,0);
REPLACE INTO `broadcast_text` VALUES (6230206,'Of course! I should really memorize his name. Thank you!','Of course! I should really memorize his name. Thank you!',0,0,0,0,0,0,0,0,0);
REPLACE INTO `broadcast_text` VALUES (6230301,'Father said I should speak more with the others here at the church, but I am a bit shy...','Father said I should speak more with the others here at the church, but I am a bit shy...',0,0,0,0,0,0,0,0,0);
REPLACE INTO `broadcast_text` VALUES (6230302,'I took a small nap during last week\'s school and missed who was very close to Duke Balor and Stormwind - can you remind me? I don\'t want to disappoint Sister Argent.','I took a small nap during last week\'s school and missed who was very close to Duke Balor and Stormwind - can you remind me? I don\'t want to disappoint Sister Argent.',0,0,0,0,0,0,0,0,0);
REPLACE INTO `broadcast_text` VALUES (6230303,'Arnor family.','Arnor family.',0,0,0,0,0,0,0,0,0);
REPLACE INTO `broadcast_text` VALUES (6230304,'Grahan family.','Grahan family.',0,0,0,0,0,0,0,0,0);
REPLACE INTO `broadcast_text` VALUES (6230305,'Prestor family.','Prestor family.',0,0,0,0,0,0,0,0,0);
REPLACE INTO `broadcast_text` VALUES (6244701,'I am the altar boy! Brother Graham said that is a huge responsibility.','I am the altar boy! Brother Graham said that is a huge responsibility.',0,0,0,0,0,0,0,0,0);
REPLACE INTO `broadcast_text` VALUES (6230099,'Hm, I\'m not sure that\'s what it was...','Hm, I\'m not sure that\'s what it was...',0,0,0,0,0,0,0,0,0);
/*!40000 ALTER TABLE `broadcast_text` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Dumping data for table `custom_character_skins`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `custom_character_skins` WRITE;
/*!40000 ALTER TABLE `custom_character_skins` DISABLE KEYS */;
REPLACE INTO `custom_character_skins` VALUES (61112,1,15);
REPLACE INTO `custom_character_skins` VALUES (81256,21,13);
/*!40000 ALTER TABLE `custom_character_skins` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Dumping data for table `gossip_menu_option`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `gossip_menu_option` WRITE;
/*!40000 ALTER TABLE `gossip_menu_option` DISABLE KEYS */;
REPLACE INTO `gossip_menu_option` VALUES (62490,0,0,'<Inspect the body.>',6249002,1,1,6249002,0,6249002,0,0,'',0,41684);
/*!40000 ALTER TABLE `gossip_menu_option` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Dumping data for table `spell_proc_event`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `spell_proc_event` WRITE;
/*!40000 ALTER TABLE `spell_proc_event` DISABLE KEYS */;
REPLACE INTO `spell_proc_event` VALUES (44070,0,0,0,0,0,664232,0,0,0,180);
/*!40000 ALTER TABLE `spell_proc_event` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2026-09-30 14:10:27
