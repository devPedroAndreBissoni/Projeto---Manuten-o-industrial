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
  PRIMARY KEY (`id_administrador`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `administrador`
--

LOCK TABLES `administrador` WRITE;
/*!40000 ALTER TABLE `administrador` DISABLE KEYS */;
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
  PRIMARY KEY (`id_cargo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cargo`
--

LOCK TABLES `cargo` WRITE;
/*!40000 ALTER TABLE `cargo` DISABLE KEYS */;
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
-- Table structure for table `funcionario`
--

DROP TABLE IF EXISTS `funcionario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `funcionario` (
  `id_funcionario` int NOT NULL,
  `idCargo` int NOT NULL,
  `idSetor` int NOT NULL,
  `telefone_funcionario` varchar(12) COLLATE utf8mb4_general_ci NOT NULL,
  `cpf_funcionario` varchar(14) COLLATE utf8mb4_general_ci NOT NULL,
  `email_funcionario` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `nome_funcionario` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `senha_funcionario` varchar(225) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id_funcionario`),
  KEY `idCargo` (`idCargo`),
  KEY `idSetor` (`idSetor`),
  CONSTRAINT `funcionario_ibfk_1` FOREIGN KEY (`idCargo`) REFERENCES `cargo` (`id_cargo`),
  CONSTRAINT `funcionario_ibfk_2` FOREIGN KEY (`idCargo`) REFERENCES `cargo` (`id_cargo`),
  CONSTRAINT `funcionario_ibfk_3` FOREIGN KEY (`idSetor`) REFERENCES `setor` (`id_setor`),
  CONSTRAINT `funcionario_ibfk_4` FOREIGN KEY (`idCargo`) REFERENCES `cargo` (`id_cargo`),
  CONSTRAINT `funcionario_ibfk_5` FOREIGN KEY (`idSetor`) REFERENCES `setor` (`id_setor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `funcionario`
--

LOCK TABLES `funcionario` WRITE;
/*!40000 ALTER TABLE `funcionario` DISABLE KEYS */;
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
  PRIMARY KEY (`id_administrador_maquina`),
  KEY `id_administrador` (`id_administrador`),
  KEY `id_maquina` (`id_maquina`),
  CONSTRAINT `gerencia_administrador_maquina_ibfk_1` FOREIGN KEY (`id_administrador`) REFERENCES `administrador` (`id_administrador`),
  CONSTRAINT `gerencia_administrador_maquina_ibfk_2` FOREIGN KEY (`id_maquina`) REFERENCES `máquina` (`id_maquina`),
  CONSTRAINT `gerencia_administrador_maquina_ibfk_3` FOREIGN KEY (`id_administrador`) REFERENCES `administrador` (`id_administrador`),
  CONSTRAINT `gerencia_administrador_maquina_ibfk_4` FOREIGN KEY (`id_maquina`) REFERENCES `máquina` (`id_maquina`)
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
  `id_funcionario` int DEFAULT NULL,
  `id_gerente` int DEFAULT NULL,
  PRIMARY KEY (`id_gerente_funcionario`),
  KEY `id_funcionario` (`id_funcionario`),
  KEY `id_gerente` (`id_gerente`),
  CONSTRAINT `gerencia_gerente_funcionario_ibfk_1` FOREIGN KEY (`id_funcionario`) REFERENCES `funcionario` (`id_funcionario`),
  CONSTRAINT `gerencia_gerente_funcionario_ibfk_2` FOREIGN KEY (`id_gerente`) REFERENCES `gerente` (`id_gerente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
  PRIMARY KEY (`id_gerente_produto`),
  KEY `gerencia_gerente_produto_ibfk_1` (`id_produto`),
  KEY `gerencia_gerente_produto_ibfk_2` (`id_gerente`),
  CONSTRAINT `gerencia_gerente_produto_ibfk_1` FOREIGN KEY (`id_produto`) REFERENCES `produto` (`id_produto`),
  CONSTRAINT `gerencia_gerente_produto_ibfk_2` FOREIGN KEY (`id_gerente`) REFERENCES `gerente` (`id_gerente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
  `nome_gerente` varchar(100) NOT NULL,
  `email_gerente` varchar(100) NOT NULL,
  `cpf_gerente` varchar(12) NOT NULL,
  `telefone_gerente` varchar(14) NOT NULL,
  `senha_gerente` varchar(225) NOT NULL,
  PRIMARY KEY (`id_gerente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gerente`
--

LOCK TABLES `gerente` WRITE;
/*!40000 ALTER TABLE `gerente` DISABLE KEYS */;
/*!40000 ALTER TABLE `gerente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `manutenção`
--

DROP TABLE IF EXISTS `manutenção`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `manutenção` (
  `Chave` int NOT NULL,
  `tipo_manutencao` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `descricao_manutencao` varchar(300) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`Chave`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `manutenção`
--

LOCK TABLES `manutenção` WRITE;
/*!40000 ALTER TABLE `manutenção` DISABLE KEYS */;
/*!40000 ALTER TABLE `manutenção` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `máquina`
--

DROP TABLE IF EXISTS `máquina`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `máquina` (
  `id_maquina` int NOT NULL,
  `tipo_maquina` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `nome_maquina` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `funcionamento_maquina` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id_maquina`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `máquina`
--

LOCK TABLES `máquina` WRITE;
/*!40000 ALTER TABLE `máquina` DISABLE KEYS */;
/*!40000 ALTER TABLE `máquina` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `produto`
--

DROP TABLE IF EXISTS `produto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `produto` (
  `id_produto` int NOT NULL,
  `idCategoria` int NOT NULL,
  `Nome_produto` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id_produto`),
  KEY `idCategoria` (`idCategoria`),
  CONSTRAINT `produto_ibfk_1` FOREIGN KEY (`idCategoria`) REFERENCES `categoria` (`id_categoria_brinquedo`),
  CONSTRAINT `produto_ibfk_2` FOREIGN KEY (`idCategoria`) REFERENCES `categoria` (`id_categoria_brinquedo`),
  CONSTRAINT `produto_ibfk_3` FOREIGN KEY (`idCategoria`) REFERENCES `categoria` (`id_categoria_brinquedo`)
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
-- Table structure for table `realiza`
--

DROP TABLE IF EXISTS `realiza`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `realiza` (
  `id_maquina_manutenção` int NOT NULL AUTO_INCREMENT,
  `Chave` int NOT NULL,
  `id_maquina` int NOT NULL,
  PRIMARY KEY (`id_maquina_manutenção`),
  KEY `Chave` (`Chave`),
  KEY `id_maquina` (`id_maquina`),
  CONSTRAINT `realiza_ibfk_1` FOREIGN KEY (`id_maquina`) REFERENCES `máquina` (`id_maquina`),
  CONSTRAINT `realiza_ibfk_2` FOREIGN KEY (`Chave`) REFERENCES `manutenção` (`Chave`),
  CONSTRAINT `realiza_ibfk_3` FOREIGN KEY (`id_maquina`) REFERENCES `máquina` (`id_maquina`),
  CONSTRAINT `realiza_ibfk_4` FOREIGN KEY (`Chave`) REFERENCES `manutenção` (`Chave`),
  CONSTRAINT `realiza_ibfk_5` FOREIGN KEY (`id_maquina`) REFERENCES `máquina` (`id_maquina`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `realiza`
--

LOCK TABLES `realiza` WRITE;
/*!40000 ALTER TABLE `realiza` DISABLE KEYS */;
/*!40000 ALTER TABLE `realiza` ENABLE KEYS */;
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
  PRIMARY KEY (`id_setor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `setor`
--

LOCK TABLES `setor` WRITE;
/*!40000 ALTER TABLE `setor` DISABLE KEYS */;
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

-- Dump completed on 2026-10-08  9:04:27
