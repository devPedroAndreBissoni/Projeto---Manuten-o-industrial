-- MySQL dump 10.13  Distrib 8.0.38, for Win64 (x86_64)
--
-- Host: localhost    Database: db_kdz
-- ------------------------------------------------------
-- Server version	8.0.39

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
-- Table structure for table `administrador`
--

DROP TABLE IF EXISTS `administrador`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `administrador` (
  `id_administrador` int NOT NULL AUTO_INCREMENT,
  `cpf_administrador` varchar(14) COLLATE utf8mb4_general_ci NOT NULL,
  `nome_administrador` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `email_administrador` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `telefone_administrador` varchar(12) COLLATE utf8mb4_general_ci NOT NULL,
  `senha_administrador` varchar(225) COLLATE utf8mb4_general_ci NOT NULL,
  `ativo_administrador` tinyint(1) NOT NULL DEFAULT '1',
  `id_cargo` int DEFAULT NULL,
  PRIMARY KEY (`id_administrador`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `administrador`
--

LOCK TABLES `administrador` WRITE;
/*!40000 ALTER TABLE `administrador` DISABLE KEYS */;
INSERT INTO `administrador` VALUES (1,'11111111111','Admin Teste','admin@kdz.com','41999990001','$2b$12$BLjoVZQgYBnnAoy1Cw8/Vu0BLM8WSQEMvosyfYKIG32KS8apHyKDK',1,0),(2,'11111111112','Admin Teste 2','admin2@kdz.com','41999990002','$2b$12$BLjoVZQgYBnnAoy1Cw8/Vu0BLM8WSQEMvosyfYKIG32KS8apHyKDK',0,1);
/*!40000 ALTER TABLE `administrador` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cargo`
--

DROP TABLE IF EXISTS `cargo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cargo` (
  `id_cargo` int NOT NULL,
  `tipo_cargo` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `nome_cargo` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `ativo_cargo` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id_cargo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cargo`
--

LOCK TABLES `cargo` WRITE;
/*!40000 ALTER TABLE `cargo` DISABLE KEYS */;
INSERT INTO `cargo` VALUES (1,'administrador','Administrador',1),(2,'gerente','Gerente',1),(3,'funcionario','Funcionario',1);
/*!40000 ALTER TABLE `cargo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categoria`
--

DROP TABLE IF EXISTS `categoria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categoria` (
  `id_categoria_brinquedo` int NOT NULL,
  `tipo_categoria` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `ativo_categoria` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id_categoria_brinquedo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categoria`
--

LOCK TABLES `categoria` WRITE;
/*!40000 ALTER TABLE `categoria` DISABLE KEYS */;
/*!40000 ALTER TABLE `categoria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chama_administrador_ords`
--

DROP TABLE IF EXISTS `chama_administrador_ords`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chama_administrador_ords` (
  `id_chama_administrador_ords` int NOT NULL AUTO_INCREMENT,
  `id_administrador` int NOT NULL,
  `id_ords` int DEFAULT NULL,
  PRIMARY KEY (`id_chama_administrador_ords`),
  KEY `id_administrador` (`id_administrador`),
  KEY `id_ords` (`id_ords`),
  CONSTRAINT `chama_administrador_ords_ibfk_1` FOREIGN KEY (`id_administrador`) REFERENCES `administrador` (`id_administrador`),
  CONSTRAINT `chama_administrador_ords_ibfk_2` FOREIGN KEY (`id_ords`) REFERENCES `ordem_de_serviço` (`id_ords`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chama_administrador_ords`
--

LOCK TABLES `chama_administrador_ords` WRITE;
/*!40000 ALTER TABLE `chama_administrador_ords` DISABLE KEYS */;
/*!40000 ALTER TABLE `chama_administrador_ords` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chama_funcionario_ords`
--

DROP TABLE IF EXISTS `chama_funcionario_ords`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chama_funcionario_ords` (
  `id_chama_funcionario_ords` int NOT NULL AUTO_INCREMENT,
  `id_funcionario` int DEFAULT NULL,
  `id_ords` int DEFAULT NULL,
  PRIMARY KEY (`id_chama_funcionario_ords`),
  KEY `id_funcionario` (`id_funcionario`),
  KEY `id_ords` (`id_ords`),
  CONSTRAINT `chama_funcionario_ords_ibfk_1` FOREIGN KEY (`id_funcionario`) REFERENCES `funcionario` (`id_funcionario`),
  CONSTRAINT `chama_funcionario_ords_ibfk_2` FOREIGN KEY (`id_ords`) REFERENCES `ordem_de_serviço` (`id_ords`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chama_funcionario_ords`
--

LOCK TABLES `chama_funcionario_ords` WRITE;
/*!40000 ALTER TABLE `chama_funcionario_ords` DISABLE KEYS */;
/*!40000 ALTER TABLE `chama_funcionario_ords` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chama_gerente_ords`
--

DROP TABLE IF EXISTS `chama_gerente_ords`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chama_gerente_ords` (
  `id_chama_gerente_ords` int NOT NULL AUTO_INCREMENT,
  `id_gerente` int DEFAULT NULL,
  `id_ords` int DEFAULT NULL,
  PRIMARY KEY (`id_chama_gerente_ords`),
  KEY `id_gerente` (`id_gerente`),
  KEY `id_ords` (`id_ords`),
  CONSTRAINT `chama_gerente_ords_ibfk_1` FOREIGN KEY (`id_gerente`) REFERENCES `gerente` (`id_gerente`),
  CONSTRAINT `chama_gerente_ords_ibfk_2` FOREIGN KEY (`id_ords`) REFERENCES `ordem_de_serviço` (`id_ords`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chama_gerente_ords`
--

LOCK TABLES `chama_gerente_ords` WRITE;
/*!40000 ALTER TABLE `chama_gerente_ords` DISABLE KEYS */;
/*!40000 ALTER TABLE `chama_gerente_ords` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `funcionario`
--

DROP TABLE IF EXISTS `funcionario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `funcionario` (
  `id_funcionario` int NOT NULL,
  `id_cargo` int NOT NULL,
  `id_setor` int NOT NULL,
  `telefone_funcionario` varchar(12) COLLATE utf8mb4_general_ci NOT NULL,
  `cpf_funcionario` varchar(14) COLLATE utf8mb4_general_ci NOT NULL,
  `email_funcionario` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `nome_funcionario` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `senha_funcionario` varchar(225) COLLATE utf8mb4_general_ci NOT NULL,
  `ativo_funcionario` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id_funcionario`),
  KEY `idCargo` (`id_cargo`),
  KEY `idSetor` (`id_setor`),
  CONSTRAINT `funcionario_ibfk_1` FOREIGN KEY (`id_cargo`) REFERENCES `cargo` (`id_cargo`),
  CONSTRAINT `funcionario_ibfk_2` FOREIGN KEY (`id_cargo`) REFERENCES `cargo` (`id_cargo`),
  CONSTRAINT `funcionario_ibfk_3` FOREIGN KEY (`id_setor`) REFERENCES `setor` (`id_setor`),
  CONSTRAINT `funcionario_ibfk_4` FOREIGN KEY (`id_cargo`) REFERENCES `cargo` (`id_cargo`),
  CONSTRAINT `funcionario_ibfk_5` FOREIGN KEY (`id_setor`) REFERENCES `setor` (`id_setor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `funcionario`
--

LOCK TABLES `funcionario` WRITE;
/*!40000 ALTER TABLE `funcionario` DISABLE KEYS */;
INSERT INTO `funcionario` VALUES (1,3,1,'41977770001','33333333331','funcionario@kdz.com','Funcionario Teste','$2b$12$vW0GYTuYyffBe8UYa.ixQOEISkO7qAGqoZ/J4hiiRCAQebJkwjvHi',1),(2,2,2,'41977770002','33333333332','gerente.func@kdz.com','Gerente Teste (func)','$2b$12$vW0GYTuYyffBe8UYa.ixQOEISkO7qAGqoZ/J4hiiRCAQebJkwjvHi',1),(3,1,2,'41977770003','33333333333','admin.func@kdz.com','Admin Teste (func)','$2b$12$vW0GYTuYyffBe8UYa.ixQOEISkO7qAGqoZ/J4hiiRCAQebJkwjvHi',1);
/*!40000 ALTER TABLE `funcionario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gerencia_administrador_funcionario`
--

DROP TABLE IF EXISTS `gerencia_administrador_funcionario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gerencia_administrador_funcionario` (
  `id_administrador_funcionario` int NOT NULL AUTO_INCREMENT,
  `id_funcionario` int NOT NULL,
  `id_administrador` int NOT NULL,
  `ativo_administrador_funcionario` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id_administrador_funcionario`),
  KEY `id_funcionario` (`id_funcionario`),
  KEY `id_administrador` (`id_administrador`),
  CONSTRAINT `gerencia_administrador_funcionario_ibfk_1` FOREIGN KEY (`id_funcionario`) REFERENCES `funcionario` (`id_funcionario`),
  CONSTRAINT `gerencia_administrador_funcionario_ibfk_2` FOREIGN KEY (`id_administrador`) REFERENCES `administrador` (`id_administrador`),
  CONSTRAINT `gerencia_administrador_funcionario_ibfk_3` FOREIGN KEY (`id_funcionario`) REFERENCES `funcionario` (`id_funcionario`),
  CONSTRAINT `gerencia_administrador_funcionario_ibfk_4` FOREIGN KEY (`id_administrador`) REFERENCES `administrador` (`id_administrador`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gerencia_administrador_funcionario`
--

LOCK TABLES `gerencia_administrador_funcionario` WRITE;
/*!40000 ALTER TABLE `gerencia_administrador_funcionario` DISABLE KEYS */;
/*!40000 ALTER TABLE `gerencia_administrador_funcionario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gerencia_administrador_maquina`
--

DROP TABLE IF EXISTS `gerencia_administrador_maquina`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gerencia_administrador_maquina` (
  `id_administrador_maquina` int NOT NULL AUTO_INCREMENT,
  `id_administrador` int NOT NULL,
  `id_maquina` int NOT NULL,
  `ativo_administrador_maquina` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id_administrador_maquina`),
  KEY `id_administrador` (`id_administrador`),
  KEY `id_maquina` (`id_maquina`),
  CONSTRAINT `gerencia_administrador_maquina_ibfk_1` FOREIGN KEY (`id_administrador`) REFERENCES `administrador` (`id_administrador`),
  CONSTRAINT `gerencia_administrador_maquina_ibfk_2` FOREIGN KEY (`id_maquina`) REFERENCES `maquina` (`id_maquina`),
  CONSTRAINT `gerencia_administrador_maquina_ibfk_3` FOREIGN KEY (`id_administrador`) REFERENCES `administrador` (`id_administrador`),
  CONSTRAINT `gerencia_administrador_maquina_ibfk_4` FOREIGN KEY (`id_maquina`) REFERENCES `maquina` (`id_maquina`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gerencia_administrador_maquina`
--

LOCK TABLES `gerencia_administrador_maquina` WRITE;
/*!40000 ALTER TABLE `gerencia_administrador_maquina` DISABLE KEYS */;
/*!40000 ALTER TABLE `gerencia_administrador_maquina` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gerencia_administrador_produto`
--

DROP TABLE IF EXISTS `gerencia_administrador_produto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gerencia_administrador_produto` (
  `id_administrador_produto` int NOT NULL AUTO_INCREMENT,
  `id_administrador` int NOT NULL,
  `id_produto` int NOT NULL,
  `ativo_administrador_produto` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id_administrador_produto`),
  KEY `id_administrador` (`id_administrador`),
  KEY `id_produto` (`id_produto`),
  CONSTRAINT `gerencia_administrador_produto_ibfk_1` FOREIGN KEY (`id_administrador`) REFERENCES `administrador` (`id_administrador`),
  CONSTRAINT `gerencia_administrador_produto_ibfk_2` FOREIGN KEY (`id_produto`) REFERENCES `produto` (`id_produto`),
  CONSTRAINT `gerencia_administrador_produto_ibfk_3` FOREIGN KEY (`id_administrador`) REFERENCES `administrador` (`id_administrador`),
  CONSTRAINT `gerencia_administrador_produto_ibfk_4` FOREIGN KEY (`id_produto`) REFERENCES `produto` (`id_produto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gerencia_administrador_produto`
--

LOCK TABLES `gerencia_administrador_produto` WRITE;
/*!40000 ALTER TABLE `gerencia_administrador_produto` DISABLE KEYS */;
/*!40000 ALTER TABLE `gerencia_administrador_produto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gerencia_gerente_funcionario`
--

DROP TABLE IF EXISTS `gerencia_gerente_funcionario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gerencia_gerente_funcionario` (
  `id_gerente_funcionario` int NOT NULL AUTO_INCREMENT,
  `id_funcionario` int NOT NULL,
  `id_gerente` int NOT NULL,
  `ativo_gerente_funcionario` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id_gerente_funcionario`),
  KEY `id_funcionario` (`id_funcionario`),
  KEY `id_gerente` (`id_gerente`),
  CONSTRAINT `gerencia_gerente_funcionario_ibfk_1` FOREIGN KEY (`id_funcionario`) REFERENCES `funcionario` (`id_funcionario`),
  CONSTRAINT `gerencia_gerente_funcionario_ibfk_2` FOREIGN KEY (`id_gerente`) REFERENCES `gerente` (`id_gerente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gerencia_gerente_funcionario`
--

LOCK TABLES `gerencia_gerente_funcionario` WRITE;
/*!40000 ALTER TABLE `gerencia_gerente_funcionario` DISABLE KEYS */;
/*!40000 ALTER TABLE `gerencia_gerente_funcionario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gerencia_gerente_produto`
--

DROP TABLE IF EXISTS `gerencia_gerente_produto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gerencia_gerente_produto` (
  `id_gerente_produto` int NOT NULL AUTO_INCREMENT,
  `id_produto` int NOT NULL,
  `id_gerente` int NOT NULL,
  `ativo_gerente_produto` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id_gerente_produto`),
  KEY `gerencia_gerente_produto_ibfk_1` (`id_produto`),
  KEY `gerencia_gerente_produto_ibfk_2` (`id_gerente`),
  CONSTRAINT `gerencia_gerente_produto_ibfk_1` FOREIGN KEY (`id_produto`) REFERENCES `produto` (`id_produto`),
  CONSTRAINT `gerencia_gerente_produto_ibfk_2` FOREIGN KEY (`id_gerente`) REFERENCES `gerente` (`id_gerente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gerencia_gerente_produto`
--

LOCK TABLES `gerencia_gerente_produto` WRITE;
/*!40000 ALTER TABLE `gerencia_gerente_produto` DISABLE KEYS */;
/*!40000 ALTER TABLE `gerencia_gerente_produto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gerente`
--

DROP TABLE IF EXISTS `gerente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gerente` (
  `id_gerente` int NOT NULL,
  `nome_gerente` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `email_gerente` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `cpf_gerente` varchar(12) COLLATE utf8mb4_general_ci NOT NULL,
  `telefone_gerente` varchar(14) COLLATE utf8mb4_general_ci NOT NULL,
  `senha_gerente` varchar(225) COLLATE utf8mb4_general_ci NOT NULL,
  `ativo_gerente` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id_gerente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gerente`
--

LOCK TABLES `gerente` WRITE;
/*!40000 ALTER TABLE `gerente` DISABLE KEYS */;
INSERT INTO `gerente` VALUES (1,'Gerente Teste','gerente@kdz.com','22222222221','41988880001','$2b$12$fEiAJXIlTREvjCnTkRQ9uulBDfMXsG1DJcfv8jq2Za1U/KlJKB3ZG',1),(2,'Gerente Teste 2','gerente2@kdz.com','22222222222','41988880002','$2b$12$fEiAJXIlTREvjCnTkRQ9uulBDfMXsG1DJcfv8jq2Za1U/KlJKB3ZG',1);
/*!40000 ALTER TABLE `gerente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `manutencao`
--

DROP TABLE IF EXISTS `manutencao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `manutencao` (
  `id_manutencao` int NOT NULL,
  `tipo_manutencao` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `descricao_manutencao` varchar(300) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ativo_manutencao` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id_manutencao`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `manutencao`
--

LOCK TABLES `manutencao` WRITE;
/*!40000 ALTER TABLE `manutencao` DISABLE KEYS */;
/*!40000 ALTER TABLE `manutencao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `maquina`
--

DROP TABLE IF EXISTS `maquina`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `maquina` (
  `id_maquina` int NOT NULL,
  `tipo_maquina` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `nome_maquina` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `funcionamento_maquina` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `ativo_maquina` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id_maquina`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `maquina`
--

LOCK TABLES `maquina` WRITE;
/*!40000 ALTER TABLE `maquina` DISABLE KEYS */;
/*!40000 ALTER TABLE `maquina` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ordem_de_serviço`
--

DROP TABLE IF EXISTS `ordem_de_serviço`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ordem_de_serviço` (
  `id_ords` int NOT NULL AUTO_INCREMENT,
  `id_manutenção` int DEFAULT NULL,
  `datetime_ords` datetime NOT NULL,
  `urgencia_ords` varchar(225) NOT NULL,
  `nomeresponsavel_ords` varchar(225) NOT NULL,
  `ativo_ords` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id_ords`),
  KEY `id_manutenção` (`id_manutenção`),
  CONSTRAINT `ordem_de_serviço_ibfk_1` FOREIGN KEY (`id_manutenção`) REFERENCES `manutencao` (`id_manutencao`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ordem_de_serviço`
--

LOCK TABLES `ordem_de_serviço` WRITE;
/*!40000 ALTER TABLE `ordem_de_serviço` DISABLE KEYS */;
/*!40000 ALTER TABLE `ordem_de_serviço` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `produto`
--

DROP TABLE IF EXISTS `produto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `produto` (
  `id_produto` int NOT NULL,
  `id_categoria` int NOT NULL,
  `nome_produto` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `estoque_produto` bigint NOT NULL,
  `data_producao` date NOT NULL,
  `ativo_produto` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id_produto`),
  KEY `idCategoria` (`id_categoria`),
  CONSTRAINT `produto_ibfk_1` FOREIGN KEY (`id_categoria`) REFERENCES `categoria` (`id_categoria_brinquedo`),
  CONSTRAINT `produto_ibfk_2` FOREIGN KEY (`id_categoria`) REFERENCES `categoria` (`id_categoria_brinquedo`),
  CONSTRAINT `produto_ibfk_3` FOREIGN KEY (`id_categoria`) REFERENCES `categoria` (`id_categoria_brinquedo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produto`
--

LOCK TABLES `produto` WRITE;
/*!40000 ALTER TABLE `produto` DISABLE KEYS */;
/*!40000 ALTER TABLE `produto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recebe_maquina_ords`
--

DROP TABLE IF EXISTS `recebe_maquina_ords`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recebe_maquina_ords` (
  `id_recebe_maquina_ords` int NOT NULL AUTO_INCREMENT,
  `id_maquina` int NOT NULL,
  `id_ords` int NOT NULL,
  PRIMARY KEY (`id_recebe_maquina_ords`),
  KEY `id_maquina` (`id_maquina`),
  KEY `id_ords` (`id_ords`),
  CONSTRAINT `recebe_maquina_ords_ibfk_1` FOREIGN KEY (`id_maquina`) REFERENCES `maquina` (`id_maquina`),
  CONSTRAINT `recebe_maquina_ords_ibfk_2` FOREIGN KEY (`id_ords`) REFERENCES `ordem_de_serviço` (`id_ords`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recebe_maquina_ords`
--

LOCK TABLES `recebe_maquina_ords` WRITE;
/*!40000 ALTER TABLE `recebe_maquina_ords` DISABLE KEYS */;
/*!40000 ALTER TABLE `recebe_maquina_ords` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `setor`
--

DROP TABLE IF EXISTS `setor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `setor` (
  `id_setor` int NOT NULL,
  `nome_setor` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `ativo_setor` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id_setor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `setor`
--

LOCK TABLES `setor` WRITE;
/*!40000 ALTER TABLE `setor` DISABLE KEYS */;
INSERT INTO `setor` VALUES (1,'Atendimento',1),(2,'Manutenção',1);
/*!40000 ALTER TABLE `setor` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-22 11:12:19
