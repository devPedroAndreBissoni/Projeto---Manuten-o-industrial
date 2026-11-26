-- MySQL dump 10.13  Distrib 8.0.38, for Win64 (x86_64)
--
-- Host: localhost    Database: db_kdz
-- ------------------------------------------------------
-- Server version	8.0.39

-- Host: 127.0.0.1
-- Tempo de geração: 25/11/2026 às 12:46
-- Versão do servidor: 10.4.32-MariaDB
-- Versão do PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";



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
  `id_cargo` int NOT NULL,
  `ativo_administrador` tinyint(1) NOT NULL DEFAULT '1',
  `cpf_administrador` varchar(14) COLLATE utf8mb4_general_ci NOT NULL,
  `nome_administrador` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `email_administrador` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `telefone_administrador` varchar(12) COLLATE utf8mb4_general_ci NOT NULL,
  `senha_administrador` varchar(225) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id_administrador`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `administrador`
--


INSERT INTO `administrador` (`id_administrador`, `id_cargo`, `ativo_administrador`, `cpf_administrador`, `nome_administrador`, `email_administrador`, `telefone_administrador`, `senha_administrador`) VALUES
(1, 1, 1, '11111111111', 'Admin Teste', 'admin@kdz.com', '41999990001', '$2b$12$BLjoVZQgYBnnAoy1Cw8/Vu0BLM8WSQEMvosyfYKIG32KS8apHyKDK'),
(2, 1, 0, '11111111112', 'Admin Teste 2', 'admin2@kdz.com', '41999990002', '$2b$12$BLjoVZQgYBnnAoy1Cw8/Vu0BLM8WSQEMvosyfYKIG32KS8apHyKDK'),
(3, 1, 1, '54861770033', 'Lucas Emanuel', 'lucasemanuel@kdz.com', '41291837218', '$2y$12$WdxyIheGFQI2JYkolux4EO1B5VicbxXi1ws/T2PdqIBH2N0xprYcO'),
(4, 1, 1, '59168978804', 'Felipe Alexandre', 'felps@kdz.com', '41991014814', '$2y$12$J3T5o0UJBe707nDFuA6ACOu8SWGSAJezQbmsAI..fZD50GHPjo692'),
(5, 1, 1, '43195216922', 'Eduardo Fischer', 'eduardo@kdz.com', '41991298137', '$2y$12$CkF.58RH5tdn8gdVP9OgpO4uVQC/uE6lr/bunPa3bmI2NgDFXv9WW'),
(6, 1, 1, '89045866153', 'Isabela', 'isa@kdz.com', '41991232139', '$2y$12$1L0U./ULMyKHJ0JfyifovetkGl.viNiBzgZNeSw6vqtgDEEQDv0dO');

-- --------------------------------------------------------


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
  `id_categoria` int NOT NULL,
  `tipo_categoria` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `ativo_categoria` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id_categoria`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categoria`
--

LOCK TABLES `categoria` WRITE;
/*!40000 ALTER TABLE `categoria` DISABLE KEYS */;
INSERT INTO `categoria` VALUES (1,'Matéria-prima',1),(2,'Peça de reposição',1),(3,'Produto acabado',1);
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
  `id_ords` int NOT NULL,
  PRIMARY KEY (`id_chama_administrador_ords`),
  KEY `id_administrador` (`id_administrador`),
  KEY `id_ords` (`id_ords`),
  CONSTRAINT `chama_administrador_ords_ibfk_1` FOREIGN KEY (`id_administrador`) REFERENCES `administrador` (`id_administrador`),
  CONSTRAINT `chama_administrador_ords_ibfk_2` FOREIGN KEY (`id_ords`) REFERENCES `ordem_de_serviço` (`id_ords`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
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
  `id_funcionario` int NOT NULL,
  `id_ords` int NOT NULL,
  PRIMARY KEY (`id_chama_funcionario_ords`),
  KEY `id_funcionario` (`id_funcionario`),
  KEY `id_ords` (`id_ords`),
  CONSTRAINT `chama_funcionario_ords_ibfk_1` FOREIGN KEY (`id_funcionario`) REFERENCES `funcionario` (`id_funcionario`),
  CONSTRAINT `chama_funcionario_ords_ibfk_2` FOREIGN KEY (`id_ords`) REFERENCES `ordem_de_serviço` (`id_ords`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
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
  `id_gerente` int NOT NULL,
  `id_ords` int NOT NULL,
  PRIMARY KEY (`id_chama_gerente_ords`),
  KEY `id_gerente` (`id_gerente`),
  KEY `id_ords` (`id_ords`),
  CONSTRAINT `chama_gerente_ords_ibfk_1` FOREIGN KEY (`id_gerente`) REFERENCES `gerente` (`id_gerente`),
  CONSTRAINT `chama_gerente_ords_ibfk_2` FOREIGN KEY (`id_ords`) REFERENCES `ordem_de_serviço` (`id_ords`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chama_gerente_ords`
--

LOCK TABLES `chama_gerente_ords` WRITE;
/*!40000 ALTER TABLE `chama_gerente_ords` DISABLE KEYS */;
/*!40000 ALTER TABLE `chama_gerente_ords` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estoque_mensal`
--

DROP TABLE IF EXISTS `estoque_mensal`;
CREATE TABLE `estoque_mensal` (
  `id_estoque_mensal` int NOT NULL AUTO_INCREMENT,
  `id_produto` int NOT NULL,
  `mes` date NOT NULL,
  `quantidade` bigint NOT NULL,
  PRIMARY KEY (`id_estoque_mensal`),
  KEY `id_produto` (`id_produto`),
  CONSTRAINT `estoque_mensal_ibfk_1` FOREIGN KEY (`id_produto`) REFERENCES `produto` (`id_produto`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `estoque_mensal`
--

INSERT INTO `estoque_mensal` (`id_estoque_mensal`, `id_produto`, `mes`, `quantidade`) VALUES
(1, 4, '2025-12-01', 650),
(2, 4, '2026-01-01', 720),
(3, 4, '2026-02-01', 910),
(4, 4, '2026-03-01', 1050),
(5, 4, '2026-04-01', 880),
(6, 4, '2026-05-01', 760),
(7, 4, '2026-06-01', 690),
(8, 4, '2026-07-01', 940),
(9, 4, '2026-08-01', 1120),
(10, 4, '2026-09-01', 870),
(11, 4, '2026-10-01', 730),
(12, 4, '2026-11-01', 900),
(13, 1, '2025-12-01', 420),
(14, 1, '2026-01-01', 480),
(15, 1, '2026-02-01', 530),
(16, 1, '2026-03-01', 610),
(17, 1, '2026-04-01', 450),
(18, 1, '2026-05-01', 390),
(19, 1, '2026-06-01', 470),
(20, 1, '2026-07-01', 560),
(21, 1, '2026-08-01', 640),
(22, 1, '2026-09-01', 520),
(23, 1, '2026-10-01', 480),
(24, 1, '2026-11-01', 500),
(25, 2, '2025-12-01', 180),
(26, 2, '2026-01-01', 210),
(27, 2, '2026-02-01', 260),
(28, 2, '2026-03-01', 300),
(29, 2, '2026-04-01', 240),
(30, 2, '2026-05-01', 190),
(31, 2, '2026-06-01', 220),
(32, 2, '2026-07-01', 280),
(33, 2, '2026-08-01', 310),
(34, 2, '2026-09-01', 230),
(35, 2, '2026-10-01', 270),
(36, 2, '2026-11-01', 250),
(37, 3, '2025-12-01', 90),
(38, 3, '2026-01-01', 110),
(39, 3, '2026-02-01', 140),
(40, 3, '2026-03-01', 95),
(41, 3, '2026-04-01', 130),
(42, 3, '2026-05-01', 160),
(43, 3, '2026-06-01', 100),
(44, 3, '2026-07-01', 85),
(45, 3, '2026-08-01', 125),
(46, 3, '2026-09-01', 150),
(47, 3, '2026-10-01', 105),
(48, 3, '2026-11-01', 120),
(49, 5, '2025-12-01', 1300),
(50, 5, '2026-01-01', 1450),
(51, 5, '2026-02-01', 1620),
(52, 5, '2026-03-01', 1750),
(53, 5, '2026-04-01', 1380),
(54, 5, '2026-05-01', 1250),
(55, 5, '2026-06-01', 1580),
(56, 5, '2026-07-01', 1700),
(57, 5, '2026-08-01', 1420),
(58, 5, '2026-09-01', 1310),
(59, 5, '2026-10-01', 1640),
(60, 5, '2026-11-01', 1500);

-- --------------------------------------------------------

--
-- Table structure for table `funcionamento_maquina`
--

DROP TABLE IF EXISTS `funcionamento_maquina`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `funcionamento_maquina` (
  `id_funcionamento_maquina` int NOT NULL,
  `id_maquina` int DEFAULT NULL,
  `inicio_funcionamento_maquina` datetime NOT NULL,
  `fim_funcionamento_maquina` datetime NOT NULL,
  PRIMARY KEY (`id_funcionamento_maquina`),
  KEY `id_maquina` (`id_maquina`),
  CONSTRAINT `funcionamento_maquina_ibfk_1` FOREIGN KEY (`id_maquina`) REFERENCES `maquina` (`id_maquina`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `funcionamento_maquina`
--

LOCK TABLES `funcionamento_maquina` WRITE;
/*!40000 ALTER TABLE `funcionamento_maquina` DISABLE KEYS */;
/*!40000 ALTER TABLE `funcionamento_maquina` ENABLE KEYS */;
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
  CONSTRAINT `funcionario_ibfk_3` FOREIGN KEY (`id_setor`) REFERENCES `setor` (`id_setor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `funcionario`
--



INSERT INTO `funcionario` (`id_funcionario`, `id_cargo`, `id_setor`, `telefone_funcionario`, `cpf_funcionario`, `email_funcionario`, `nome_funcionario`, `senha_funcionario`, `ativo_funcionario`) VALUES
(1, 3, 1, '41992178378', '97344287307', 'anaju@kdz.com', 'Ana Julia', '$2y$12$5bTInyE.jT6P5TZZl0N89OrrzsLeM2x6rTjCYAgkP17gDEYbULIhW', 1),
(2, 3, 2, '41991287298', '89034078140', 'julio@kdz.com', 'Julio', '$2y$12$t5BEUJSJIOEmpMby4m.JReh/AfgKnIoekZgvnAZiA98OU9rVOiVCC', 1),
(3, 3, 1, '41912932913', '17215418103', 'dudu@kdz.com', 'Carlos Eduardo', '$2y$12$A7ZAtW.Sd1WuxSHdGHmrLulOsZtvwFHFmfMXSMMTDHPeqEzjNYgCa', 1);

-- --------------------------------------------------------


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
  CONSTRAINT `gerencia_administrador_funcionario_ibfk_2` FOREIGN KEY (`id_administrador`) REFERENCES `administrador` (`id_administrador`)
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
  CONSTRAINT `gerencia_administrador_maquina_ibfk_2` FOREIGN KEY (`id_maquina`) REFERENCES `maquina` (`id_maquina`)
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
  CONSTRAINT `gerencia_administrador_produto_ibfk_2` FOREIGN KEY (`id_produto`) REFERENCES `produto` (`id_produto`)
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
  `id_setor` int NOT NULL,
  `nome_gerente` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `email_gerente` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `cpf_gerente` varchar(14) COLLATE utf8mb4_general_ci NOT NULL,
  `telefone_gerente` varchar(12) COLLATE utf8mb4_general_ci NOT NULL,
  `senha_gerente` varchar(225) COLLATE utf8mb4_general_ci NOT NULL,
  `ativo_gerente` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id_gerente`),
  KEY `idSetor` (`id_setor`),
  CONSTRAINT `gerente_ibfk_1` FOREIGN KEY (`id_setor`) REFERENCES `setor` (`id_setor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gerente`
--


INSERT INTO `gerente` (`id_gerente`, `id_setor`, `nome_gerente`, `email_gerente`, `cpf_gerente`, `telefone_gerente`, `senha_gerente`, `ativo_gerente`) VALUES
(3, 1, 'Pedro André', 'pedroandre@kdz.com', '89769103896', '41991783213', '$2y$12$xBoe25f8LRpKh96QfssCCON0XKC9Tgs.NU37y6hzMP8ZYdg5uKNGq', 1),
(4, 1, 'Lucas Brasil', 'brasil@kdz.com', '69714355834', '41999843272', '$2y$12$ANRcrUxGnV/gBjXg1nhoXO5E/CGfSoBzdMmLbEpRX3dMcbr/vlwQS', 1),
(5, 2, 'Cesar Stati', 'stati@kdz.com', '09836730982', '4113783219', '$2y$12$XY/0g0RnBxQSoUDvSPMEoOIRT.UNPKs5h7M.BFzaS0br3cwe/RL4G', 1);

-- --------------------------------------------------------


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
INSERT INTO `maquina` VALUES (1,'Injetora','Injetora Plástica IP-200','Operacional',1),(2,'Torno','Torno CNC TC-500','Operacional',1),(3,'Prensa','Prensa Hidráulica PH-100','Em manutenção',1),(4,'Esteira','Esteira Transportadora ET-01','Operacional',1),(5,'Embaladora','Embaladora Automática EA-30','Parada',0);
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
  `urgencia_ords` varchar(225) COLLATE utf8mb4_general_ci NOT NULL,
  `nomeresponsavel_ords` varchar(225) COLLATE utf8mb4_general_ci NOT NULL,
  `ativo_ords` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id_ords`),
  KEY `id_manutenção` (`id_manutenção`),
  CONSTRAINT `ordem_de_serviço_ibfk_1` FOREIGN KEY (`id_manutenção`) REFERENCES `manutencao` (`id_manutencao`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
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
  CONSTRAINT `produto_ibfk_1` FOREIGN KEY (`id_categoria`) REFERENCES `categoria` (`id_categoria`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produto`
--

INSERT INTO `produto` (`id_produto`, `id_categoria`, `nome_produto`, `estoque_produto`, `data_producao`, `ativo_produto`) VALUES
(1, 1, 'Granulado de Polipropileno 25kg', 500, '2026-10-01', 1),
(2, 1, 'Chapa de Aço 2mm', 250, '2026-10-05', 1),
(3, 2, 'Correia Dentada CD-45', 120, '2026-10-10', 1),
(4, 1, 'Caixa Plástica 20L', 900, '2026-11-25', 1),
(5, 3, 'Tampa Plástica Universal', 1500, '2026-10-20', 1);

--
-- Acionadores `produto`
--
DELIMITER $$
CREATE TRIGGER `trg_produto_estoque_ai` AFTER INSERT ON `produto` FOR EACH ROW BEGIN
  INSERT INTO `estoque_mensal` (`id_produto`, `mes`, `quantidade`)
  VALUES (NEW.`id_produto`, DATE_FORMAT(CURDATE(), '%Y-%m-01'), NEW.`estoque_produto`);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_produto_estoque_au` AFTER UPDATE ON `produto` FOR EACH ROW BEGIN
  IF NEW.`estoque_produto` <> OLD.`estoque_produto` THEN
    IF EXISTS (SELECT 1 FROM `estoque_mensal`
                WHERE `id_produto` = NEW.`id_produto`
                  AND `mes` = DATE_FORMAT(CURDATE(), '%Y-%m-01')) THEN
      UPDATE `estoque_mensal`
         SET `quantidade` = NEW.`estoque_produto`
       WHERE `id_produto` = NEW.`id_produto`
         AND `mes` = DATE_FORMAT(CURDATE(), '%Y-%m-01');
    ELSE
      INSERT INTO `estoque_mensal` (`id_produto`, `mes`, `quantidade`)
      VALUES (NEW.`id_produto`, DATE_FORMAT(CURDATE(), '%Y-%m-01'), NEW.`estoque_produto`);
    END IF;
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
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



--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `administrador`
--
ALTER TABLE `administrador`
  MODIFY `id_administrador` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de tabela `chama_administrador_ords`
--
ALTER TABLE `chama_administrador_ords`
  MODIFY `id_chama_administrador_ords` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `chama_funcionario_ords`
--
ALTER TABLE `chama_funcionario_ords`
  MODIFY `id_chama_funcionario_ords` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `chama_gerente_ords`
--
ALTER TABLE `chama_gerente_ords`
  MODIFY `id_chama_gerente_ords` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `gerencia_administrador_funcionario`
--
ALTER TABLE `gerencia_administrador_funcionario`
  MODIFY `id_administrador_funcionario` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `gerencia_administrador_maquina`
--
ALTER TABLE `gerencia_administrador_maquina`
  MODIFY `id_administrador_maquina` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `gerencia_administrador_produto`
--
ALTER TABLE `gerencia_administrador_produto`
  MODIFY `id_administrador_produto` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `gerencia_gerente_funcionario`
--
ALTER TABLE `gerencia_gerente_funcionario`
  MODIFY `id_gerente_funcionario` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `gerencia_gerente_produto`
--
ALTER TABLE `gerencia_gerente_produto`
  MODIFY `id_gerente_produto` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `ordem_de_serviço`
--
ALTER TABLE `ordem_de_serviço`
  MODIFY `id_ords` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `recebe_maquina_ords`
--
ALTER TABLE `recebe_maquina_ords`
  MODIFY `id_recebe_maquina_ords` int(11) NOT NULL AUTO_INCREMENT;

COMMIT;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-25  8:33:34