-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 26/11/2026 às 14:06
-- Versão do servidor: 10.4.32-MariaDB
-- Versão do PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `db_kdz`
--

-- --------------------------------------------------------

--
-- Estrutura para tabela `administrador`
--

CREATE TABLE `administrador` (
  `id_administrador` int(11) NOT NULL,
  `id_cargo` int(11) NOT NULL,
  `ativo_administrador` tinyint(1) NOT NULL DEFAULT 1,
  `cpf_administrador` varchar(14) NOT NULL,
  `nome_administrador` varchar(100) NOT NULL,
  `email_administrador` varchar(100) NOT NULL,
  `telefone_administrador` varchar(12) NOT NULL,
  `senha_administrador` varchar(225) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `administrador`
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
-- Estrutura para tabela `cargo`
--

CREATE TABLE `cargo` (
  `id_cargo` int(11) NOT NULL,
  `tipo_cargo` varchar(50) NOT NULL,
  `nome_cargo` varchar(50) NOT NULL,
  `ativo_cargo` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `cargo`
--

INSERT INTO `cargo` (`id_cargo`, `tipo_cargo`, `nome_cargo`, `ativo_cargo`) VALUES
(1, 'administrador', 'Administrador', 1),
(2, 'gerente', 'Gerente', 1),
(3, 'funcionario', 'Funcionario', 1);

-- --------------------------------------------------------

--
-- Estrutura para tabela `categoria`
--

CREATE TABLE `categoria` (
  `id_categoria` int(11) NOT NULL,
  `tipo_categoria` varchar(50) NOT NULL,
  `ativo_categoria` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `categoria`
--

INSERT INTO `categoria` (`id_categoria`, `tipo_categoria`, `ativo_categoria`) VALUES
(1, 'Matéria-prima', 1),
(2, 'Peça de reposição', 1),
(3, 'Produto acabado', 1);

-- --------------------------------------------------------

--
-- Estrutura para tabela `chama_administrador_ords`
--

CREATE TABLE `chama_administrador_ords` (
  `id_chama_administrador_ords` int(11) NOT NULL,
  `id_administrador` int(11) NOT NULL,
  `id_ords` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `chama_administrador_ords`
--

INSERT INTO `chama_administrador_ords` (`id_chama_administrador_ords`, `id_administrador`, `id_ords`) VALUES
(1, 1, 1);

-- --------------------------------------------------------

--
-- Estrutura para tabela `chama_funcionario_ords`
--

CREATE TABLE `chama_funcionario_ords` (
  `id_chama_funcionario_ords` int(11) NOT NULL,
  `id_funcionario` int(11) NOT NULL,
  `id_ords` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `chama_gerente_ords`
--

CREATE TABLE `chama_gerente_ords` (
  `id_chama_gerente_ords` int(11) NOT NULL,
  `id_gerente` int(11) NOT NULL,
  `id_ords` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `estoque_mensal`
--

CREATE TABLE `estoque_mensal` (
  `id_estoque_mensal` int(11) NOT NULL,
  `id_produto` int(11) NOT NULL,
  `mes` date NOT NULL,
  `quantidade` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `estoque_mensal`
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
-- Estrutura para tabela `funcionamento_maquina`
--

CREATE TABLE `funcionamento_maquina` (
  `id_funcionamento_maquina` int(11) NOT NULL,
  `id_maquina` int(11) DEFAULT NULL,
  `inicio_funcionamento_maquina` datetime NOT NULL,
  `fim_funcionamento_maquina` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `funcionamento_maquina`
--

INSERT INTO `funcionamento_maquina` (`id_funcionamento_maquina`, `id_maquina`, `inicio_funcionamento_maquina`, `fim_funcionamento_maquina`) VALUES
(1001, 1, '2025-12-01 00:00:00', '2025-12-04 08:00:00'),
(1002, 1, '2025-12-05 14:00:00', '2025-12-26 08:45:00'),
(1003, 1, '2025-12-27 14:45:00', '2026-01-01 00:00:00'),
(1004, 1, '2026-01-01 00:00:00', '2026-01-05 01:00:00'),
(1005, 1, '2026-01-05 03:00:00', '2026-01-13 12:45:00'),
(1006, 1, '2026-01-13 15:45:00', '2026-01-23 06:30:00'),
(1007, 1, '2026-01-24 06:30:00', '2026-02-01 00:00:00'),
(1008, 1, '2026-02-01 00:00:00', '2026-02-20 14:00:00'),
(1009, 1, '2026-02-21 20:00:00', '2026-03-01 00:00:00'),
(1010, 1, '2026-03-01 00:00:00', '2026-03-04 12:30:00'),
(1011, 1, '2026-03-04 20:30:00', '2026-03-11 20:00:00'),
(1012, 1, '2026-03-12 04:00:00', '2026-03-21 06:30:00'),
(1013, 1, '2026-03-21 18:30:00', '2026-03-27 09:45:00'),
(1014, 1, '2026-03-27 12:45:00', '2026-04-01 00:00:00'),
(1015, 1, '2026-04-01 00:00:00', '2026-04-06 12:30:00'),
(1016, 1, '2026-04-07 18:30:00', '2026-04-25 05:00:00'),
(1017, 1, '2026-04-26 05:00:00', '2026-05-01 00:00:00'),
(1018, 1, '2026-05-01 00:00:00', '2026-06-01 00:00:00'),
(1019, 1, '2026-06-01 00:00:00', '2026-06-07 19:00:00'),
(1020, 1, '2026-06-09 01:00:00', '2026-06-16 10:45:00'),
(1021, 1, '2026-06-17 02:45:00', '2026-06-23 06:00:00'),
(1022, 1, '2026-06-23 12:00:00', '2026-07-01 00:00:00'),
(1023, 1, '2026-07-01 00:00:00', '2026-07-03 20:45:00'),
(1024, 1, '2026-07-04 04:45:00', '2026-07-10 20:45:00'),
(1025, 1, '2026-07-11 12:45:00', '2026-07-15 00:00:00'),
(1026, 1, '2026-07-15 08:00:00', '2026-07-20 15:45:00'),
(1027, 1, '2026-07-21 15:45:00', '2026-07-27 22:30:00'),
(1028, 1, '2026-07-28 04:30:00', '2026-08-01 00:00:00'),
(1029, 1, '2026-08-01 00:00:00', '2026-08-11 03:45:00'),
(1030, 1, '2026-08-11 06:45:00', '2026-08-24 16:30:00'),
(1031, 1, '2026-08-25 22:30:00', '2026-09-01 00:00:00'),
(1032, 1, '2026-09-01 00:00:00', '2026-09-13 09:30:00'),
(1033, 1, '2026-09-13 12:30:00', '2026-10-01 00:00:00'),
(1034, 1, '2026-10-01 00:00:00', '2026-10-03 02:15:00'),
(1035, 1, '2026-10-03 18:15:00', '2026-10-15 10:00:00'),
(1036, 1, '2026-10-15 12:00:00', '2026-10-23 05:00:00'),
(1037, 1, '2026-10-24 11:00:00', '2026-11-01 00:00:00'),
(1038, 1, '2026-11-01 00:00:00', '2026-11-08 02:30:00'),
(1039, 1, '2026-11-08 10:30:00', '2026-11-16 14:45:00'),
(1040, 1, '2026-11-17 02:45:00', '2026-11-26 06:00:00'),
(1041, 2, '2025-12-01 00:00:00', '2025-12-15 16:30:00'),
(1042, 2, '2025-12-16 22:30:00', '2026-01-01 00:00:00'),
(1043, 2, '2026-01-01 00:00:00', '2026-01-17 01:30:00'),
(1044, 2, '2026-01-17 05:30:00', '2026-02-01 00:00:00'),
(1045, 2, '2026-02-01 00:00:00', '2026-02-06 02:15:00'),
(1046, 2, '2026-02-06 06:15:00', '2026-02-19 23:45:00'),
(1047, 2, '2026-02-20 02:45:00', '2026-03-01 00:00:00'),
(1048, 2, '2026-03-01 00:00:00', '2026-04-01 00:00:00'),
(1049, 2, '2026-04-01 00:00:00', '2026-04-11 07:00:00'),
(1050, 2, '2026-04-11 09:00:00', '2026-05-01 00:00:00'),
(1051, 2, '2026-05-01 00:00:00', '2026-05-06 02:45:00'),
(1052, 2, '2026-05-06 10:45:00', '2026-05-21 14:45:00'),
(1053, 2, '2026-05-21 17:45:00', '2026-06-01 00:00:00'),
(1054, 2, '2026-06-01 00:00:00', '2026-06-08 00:15:00'),
(1055, 2, '2026-06-09 06:15:00', '2026-07-01 00:00:00'),
(1056, 2, '2026-07-01 00:00:00', '2026-07-04 11:00:00'),
(1057, 2, '2026-07-04 17:00:00', '2026-07-15 23:15:00'),
(1058, 2, '2026-07-16 01:15:00', '2026-07-26 21:00:00'),
(1059, 2, '2026-07-27 01:00:00', '2026-08-01 00:00:00'),
(1060, 2, '2026-08-01 00:00:00', '2026-08-17 18:15:00'),
(1061, 2, '2026-08-17 20:15:00', '2026-09-01 00:00:00'),
(1062, 2, '2026-09-01 00:00:00', '2026-09-09 17:15:00'),
(1063, 2, '2026-09-10 23:15:00', '2026-09-19 13:45:00'),
(1064, 2, '2026-09-19 17:45:00', '2026-10-01 00:00:00'),
(1065, 2, '2026-10-01 00:00:00', '2026-10-20 10:30:00'),
(1066, 2, '2026-10-21 02:30:00', '2026-11-01 00:00:00'),
(1067, 2, '2026-11-01 00:00:00', '2026-11-07 05:45:00'),
(1068, 2, '2026-11-08 05:45:00', '2026-11-26 06:00:00'),
(1069, 3, '2025-12-01 00:00:00', '2025-12-04 03:45:00'),
(1070, 3, '2025-12-04 15:45:00', '2025-12-11 19:30:00'),
(1071, 3, '2025-12-13 01:30:00', '2025-12-21 03:15:00'),
(1072, 3, '2025-12-21 09:15:00', '2025-12-25 10:45:00'),
(1073, 3, '2025-12-25 13:45:00', '2026-01-01 00:00:00'),
(1074, 3, '2026-01-01 00:00:00', '2026-01-03 03:15:00'),
(1075, 3, '2026-01-04 09:15:00', '2026-01-08 12:15:00'),
(1076, 3, '2026-01-08 20:15:00', '2026-01-16 06:15:00'),
(1077, 3, '2026-01-16 14:15:00', '2026-01-20 21:00:00'),
(1078, 3, '2026-01-21 05:00:00', '2026-01-29 23:00:00'),
(1079, 3, '2026-01-30 03:00:00', '2026-02-01 00:00:00'),
(1080, 3, '2026-02-01 00:00:00', '2026-02-03 21:15:00'),
(1081, 3, '2026-02-04 09:15:00', '2026-02-13 01:00:00'),
(1082, 3, '2026-02-13 04:00:00', '2026-02-23 04:45:00'),
(1083, 3, '2026-02-23 12:45:00', '2026-03-01 00:00:00'),
(1084, 3, '2026-03-01 00:00:00', '2026-03-02 02:30:00'),
(1085, 3, '2026-03-03 08:30:00', '2026-03-07 20:00:00'),
(1086, 3, '2026-03-08 20:00:00', '2026-03-14 17:15:00'),
(1087, 3, '2026-03-15 05:15:00', '2026-03-18 23:00:00'),
(1088, 3, '2026-03-19 15:00:00', '2026-03-24 09:30:00'),
(1089, 3, '2026-03-25 15:30:00', '2026-03-28 17:00:00'),
(1090, 3, '2026-03-29 05:00:00', '2026-04-01 00:00:00'),
(1091, 3, '2026-04-01 00:00:00', '2026-04-04 08:15:00'),
(1092, 3, '2026-04-04 20:15:00', '2026-04-11 22:15:00'),
(1093, 3, '2026-04-12 01:15:00', '2026-04-19 16:00:00'),
(1094, 3, '2026-04-19 19:00:00', '2026-04-25 03:30:00'),
(1095, 3, '2026-04-25 15:30:00', '2026-05-01 00:00:00'),
(1096, 3, '2026-05-01 00:00:00', '2026-05-02 17:15:00'),
(1097, 3, '2026-05-03 09:15:00', '2026-05-10 18:00:00'),
(1098, 3, '2026-05-10 22:00:00', '2026-05-16 14:45:00'),
(1099, 3, '2026-05-17 20:45:00', '2026-05-23 13:15:00'),
(1100, 3, '2026-05-23 17:15:00', '2026-05-26 19:45:00'),
(1101, 3, '2026-05-27 03:45:00', '2026-06-01 00:00:00'),
(1102, 3, '2026-06-01 00:00:00', '2026-06-03 16:30:00'),
(1103, 3, '2026-06-04 22:30:00', '2026-06-06 17:30:00'),
(1104, 3, '2026-06-07 23:30:00', '2026-06-10 08:15:00'),
(1105, 3, '2026-06-10 10:15:00', '2026-06-15 14:15:00'),
(1106, 3, '2026-06-15 20:15:00', '2026-06-20 23:30:00'),
(1107, 3, '2026-06-21 15:30:00', '2026-06-25 07:30:00'),
(1108, 3, '2026-06-25 13:30:00', '2026-06-28 04:30:00'),
(1109, 3, '2026-06-28 10:30:00', '2026-07-01 00:00:00'),
(1110, 3, '2026-07-01 00:00:00', '2026-07-06 05:45:00'),
(1111, 3, '2026-07-07 11:45:00', '2026-07-13 07:00:00'),
(1112, 3, '2026-07-13 11:00:00', '2026-07-18 22:30:00'),
(1113, 3, '2026-07-20 04:30:00', '2026-07-26 00:00:00'),
(1114, 3, '2026-07-26 03:00:00', '2026-08-01 00:00:00'),
(1115, 3, '2026-08-01 00:00:00', '2026-08-03 07:15:00'),
(1116, 3, '2026-08-04 13:15:00', '2026-08-09 16:00:00'),
(1117, 3, '2026-08-09 19:00:00', '2026-08-12 12:30:00'),
(1118, 3, '2026-08-13 04:30:00', '2026-08-18 19:00:00'),
(1119, 3, '2026-08-19 03:00:00', '2026-08-24 12:15:00'),
(1120, 3, '2026-08-24 18:15:00', '2026-08-30 03:30:00'),
(1121, 3, '2026-08-30 11:30:00', '2026-09-01 00:00:00'),
(1122, 3, '2026-09-01 00:00:00', '2026-09-03 14:30:00'),
(1123, 3, '2026-09-03 18:30:00', '2026-09-09 16:00:00'),
(1124, 3, '2026-09-09 20:00:00', '2026-09-16 19:00:00'),
(1125, 3, '2026-09-18 01:00:00', '2026-09-22 16:30:00'),
(1126, 3, '2026-09-22 19:30:00', '2026-09-26 21:15:00'),
(1127, 3, '2026-09-28 03:15:00', '2026-10-01 00:00:00'),
(1128, 3, '2026-10-01 00:00:00', '2026-10-03 06:00:00'),
(1129, 3, '2026-10-03 14:00:00', '2026-10-11 09:00:00'),
(1130, 3, '2026-10-12 09:00:00', '2026-10-20 00:30:00'),
(1131, 3, '2026-10-20 06:30:00', '2026-10-28 07:30:00'),
(1132, 3, '2026-10-29 07:30:00', '2026-11-01 00:00:00'),
(1133, 3, '2026-11-01 00:00:00', '2026-11-02 15:30:00'),
(1134, 3, '2026-11-03 21:30:00', '2026-11-07 16:45:00'),
(1135, 3, '2026-11-08 16:45:00', '2026-11-12 17:45:00'),
(1136, 3, '2026-11-12 23:45:00', '2026-11-17 12:30:00'),
(1137, 3, '2026-11-18 00:30:00', '2026-11-23 02:15:00'),
(1138, 3, '2026-11-23 18:15:00', '2026-11-26 06:00:00'),
(1139, 4, '2025-12-01 00:00:00', '2025-12-10 04:30:00'),
(1140, 4, '2025-12-11 04:30:00', '2026-01-01 00:00:00'),
(1141, 4, '2026-01-01 00:00:00', '2026-01-08 16:30:00'),
(1142, 4, '2026-01-08 22:30:00', '2026-01-27 02:00:00'),
(1143, 4, '2026-01-28 08:00:00', '2026-02-01 00:00:00'),
(1144, 4, '2026-02-01 00:00:00', '2026-02-14 22:00:00'),
(1145, 4, '2026-02-15 14:00:00', '2026-03-01 00:00:00'),
(1146, 4, '2026-03-01 00:00:00', '2026-03-11 06:30:00'),
(1147, 4, '2026-03-11 22:30:00', '2026-04-01 00:00:00'),
(1148, 4, '2026-04-01 00:00:00', '2026-05-01 00:00:00'),
(1149, 4, '2026-05-01 00:00:00', '2026-05-18 17:15:00'),
(1150, 4, '2026-05-19 17:15:00', '2026-06-01 00:00:00'),
(1151, 4, '2026-06-01 00:00:00', '2026-06-08 14:45:00'),
(1152, 4, '2026-06-08 16:45:00', '2026-06-24 05:30:00'),
(1153, 4, '2026-06-24 07:30:00', '2026-07-01 00:00:00'),
(1154, 4, '2026-07-01 00:00:00', '2026-07-11 08:45:00'),
(1155, 4, '2026-07-12 00:45:00', '2026-08-01 00:00:00'),
(1156, 4, '2026-08-01 00:00:00', '2026-08-05 20:00:00'),
(1157, 4, '2026-08-06 02:00:00', '2026-09-01 00:00:00'),
(1158, 4, '2026-09-01 00:00:00', '2026-09-03 09:45:00'),
(1159, 4, '2026-09-03 15:45:00', '2026-09-22 11:00:00'),
(1160, 4, '2026-09-22 23:00:00', '2026-10-01 00:00:00'),
(1161, 4, '2026-10-01 00:00:00', '2026-10-18 18:15:00'),
(1162, 4, '2026-10-18 21:15:00', '2026-11-01 00:00:00'),
(1163, 4, '2026-11-01 00:00:00', '2026-11-17 21:15:00'),
(1164, 4, '2026-11-18 03:15:00', '2026-11-26 06:00:00');

-- --------------------------------------------------------

--
-- Estrutura para tabela `funcionario`
--

CREATE TABLE `funcionario` (
  `id_funcionario` int(11) NOT NULL,
  `id_cargo` int(11) NOT NULL,
  `id_setor` int(11) NOT NULL,
  `telefone_funcionario` varchar(12) NOT NULL,
  `cpf_funcionario` varchar(14) NOT NULL,
  `email_funcionario` varchar(100) NOT NULL,
  `nome_funcionario` varchar(100) NOT NULL,
  `senha_funcionario` varchar(225) NOT NULL,
  `ativo_funcionario` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `funcionario`
--

INSERT INTO `funcionario` (`id_funcionario`, `id_cargo`, `id_setor`, `telefone_funcionario`, `cpf_funcionario`, `email_funcionario`, `nome_funcionario`, `senha_funcionario`, `ativo_funcionario`) VALUES
(1, 3, 1, '41992178378', '97344287307', 'anaju@kdz.com', 'Ana Julia', '$2y$12$5bTInyE.jT6P5TZZl0N89OrrzsLeM2x6rTjCYAgkP17gDEYbULIhW', 1),
(2, 3, 2, '41991287298', '89034078140', 'julio@kdz.com', 'Julio', '$2y$12$t5BEUJSJIOEmpMby4m.JReh/AfgKnIoekZgvnAZiA98OU9rVOiVCC', 1),
(3, 3, 1, '41912932913', '17215418103', 'dudu@kdz.com', 'Carlos Eduardo', '$2y$12$A7ZAtW.Sd1WuxSHdGHmrLulOsZtvwFHFmfMXSMMTDHPeqEzjNYgCa', 1);

-- --------------------------------------------------------

--
-- Estrutura para tabela `gerencia_administrador_funcionario`
--

CREATE TABLE `gerencia_administrador_funcionario` (
  `id_administrador_funcionario` int(11) NOT NULL,
  `id_funcionario` int(11) NOT NULL,
  `id_administrador` int(11) NOT NULL,
  `ativo_administrador_funcionario` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `gerencia_administrador_maquina`
--

CREATE TABLE `gerencia_administrador_maquina` (
  `id_administrador_maquina` int(11) NOT NULL,
  `id_administrador` int(11) NOT NULL,
  `id_maquina` int(11) NOT NULL,
  `ativo_administrador_maquina` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `gerencia_administrador_produto`
--

CREATE TABLE `gerencia_administrador_produto` (
  `id_administrador_produto` int(11) NOT NULL,
  `id_administrador` int(11) NOT NULL,
  `id_produto` int(11) NOT NULL,
  `ativo_administrador_produto` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `gerencia_gerente_funcionario`
--

CREATE TABLE `gerencia_gerente_funcionario` (
  `id_gerente_funcionario` int(11) NOT NULL,
  `id_funcionario` int(11) NOT NULL,
  `id_gerente` int(11) NOT NULL,
  `ativo_gerente_funcionario` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `gerencia_gerente_produto`
--

CREATE TABLE `gerencia_gerente_produto` (
  `id_gerente_produto` int(11) NOT NULL,
  `id_produto` int(11) NOT NULL,
  `id_gerente` int(11) NOT NULL,
  `ativo_gerente_produto` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `gerente`
--

CREATE TABLE `gerente` (
  `id_gerente` int(11) NOT NULL,
  `id_setor` int(11) NOT NULL,
  `nome_gerente` varchar(100) NOT NULL,
  `email_gerente` varchar(100) NOT NULL,
  `cpf_gerente` varchar(14) NOT NULL,
  `telefone_gerente` varchar(12) NOT NULL,
  `senha_gerente` varchar(225) NOT NULL,
  `ativo_gerente` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `gerente`
--

INSERT INTO `gerente` (`id_gerente`, `id_setor`, `nome_gerente`, `email_gerente`, `cpf_gerente`, `telefone_gerente`, `senha_gerente`, `ativo_gerente`) VALUES
(3, 1, 'Pedro André', 'pedroandre@kdz.com', '89769103896', '41991783213', '$2y$12$xBoe25f8LRpKh96QfssCCON0XKC9Tgs.NU37y6hzMP8ZYdg5uKNGq', 1),
(4, 1, 'Lucas Brasil', 'brasil@kdz.com', '69714355834', '41999843272', '$2y$12$ANRcrUxGnV/gBjXg1nhoXO5E/CGfSoBzdMmLbEpRX3dMcbr/vlwQS', 1),
(5, 2, 'Cesar Stati', 'stati@kdz.com', '09836730982', '4113783219', '$2y$12$XY/0g0RnBxQSoUDvSPMEoOIRT.UNPKs5h7M.BFzaS0br3cwe/RL4G', 1);

-- --------------------------------------------------------

--
-- Estrutura para tabela `manutencao`
--

CREATE TABLE `manutencao` (
  `id_manutencao` int(11) NOT NULL,
  `tipo_manutencao` varchar(50) NOT NULL,
  `descricao_manutencao` varchar(300) DEFAULT NULL,
  `ativo_manutencao` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `manutencao`
--

INSERT INTO `manutencao` (`id_manutencao`, `tipo_manutencao`, `descricao_manutencao`, `ativo_manutencao`) VALUES
(1, 'Preventiva', 'Calibração / ajuste — aaaaa', 1),
(2, 'Corretiva', 'Conserto após falha', 1),
(3, 'Preditiva', 'Manutenção baseada em monitoramento', 1);

-- --------------------------------------------------------

--
-- Estrutura para tabela `maquina`
--

CREATE TABLE `maquina` (
  `id_maquina` int(11) NOT NULL,
  `tipo_maquina` varchar(50) NOT NULL,
  `nome_maquina` varchar(100) NOT NULL,
  `funcionamento_maquina` varchar(50) NOT NULL,
  `ativo_maquina` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `maquina`
--

INSERT INTO `maquina` (`id_maquina`, `tipo_maquina`, `nome_maquina`, `funcionamento_maquina`, `ativo_maquina`) VALUES
(1, 'Injetora', 'Injetora Plástica IP-200', 'Operacional', 1),
(2, 'Torno', 'Torno CNC TC-500', 'Operacional', 1),
(3, 'Prensa', 'Prensa Hidráulica PH-100', 'Em manutenção', 1),
(4, 'Esteira', 'Esteira Transportadora ET-01', 'Operacional', 1),
(5, 'Embaladora', 'Embaladora Automática EA-30', 'Parada', 0);

-- --------------------------------------------------------

--
-- Estrutura para tabela `ordem_de_serviço`
--

CREATE TABLE `ordem_de_serviço` (
  `id_ords` int(11) NOT NULL,
  `id_manutenção` int(11) DEFAULT NULL,
  `datetime_ords` datetime NOT NULL,
  `urgencia_ords` varchar(225) NOT NULL,
  `nomeresponsavel_ords` varchar(225) NOT NULL,
  `ativo_ords` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `ordem_de_serviço`
--

INSERT INTO `ordem_de_serviço` (`id_ords`, `id_manutenção`, `datetime_ords`, `urgencia_ords`, `nomeresponsavel_ords`, `ativo_ords`) VALUES
(1, 1, '2026-11-26 09:04:58', 'Baixa', 'Admin Teste', 1),
(1001, 3, '2025-12-04 08:00:00', 'Alta', 'Lucas Brasil', 1),
(1002, 1, '2025-12-26 08:45:00', 'Alta', 'Lucas Brasil', 1),
(1003, 2, '2026-01-05 01:00:00', 'Baixa', 'Pedro André', 1),
(1004, 2, '2026-01-13 12:45:00', 'Baixa', 'Carlos Eduardo', 1),
(1005, 2, '2026-01-23 06:30:00', 'Alta', 'Pedro André', 1),
(1006, 2, '2026-02-20 14:00:00', 'Alta', 'Ana Julia', 1),
(1007, 3, '2026-03-04 12:30:00', 'Média', 'Lucas Brasil', 1),
(1008, 1, '2026-03-11 20:00:00', 'Média', 'Ana Julia', 1),
(1009, 1, '2026-03-21 06:30:00', 'Média', 'Lucas Brasil', 1),
(1010, 3, '2026-03-27 09:45:00', 'Baixa', 'Pedro André', 1),
(1011, 3, '2026-04-06 12:30:00', 'Alta', 'Julio', 1),
(1012, 2, '2026-04-25 05:00:00', 'Alta', 'Ana Julia', 1),
(1013, 1, '2026-06-07 19:00:00', 'Alta', 'Cesar Stati', 1),
(1014, 1, '2026-06-16 10:45:00', 'Média', 'Cesar Stati', 1),
(1015, 3, '2026-06-23 06:00:00', 'Baixa', 'Carlos Eduardo', 1),
(1016, 1, '2026-07-03 20:45:00', 'Média', 'Pedro André', 1),
(1017, 3, '2026-07-10 20:45:00', 'Média', 'Pedro André', 1),
(1018, 1, '2026-07-15 00:00:00', 'Média', 'Lucas Brasil', 1),
(1019, 2, '2026-07-20 15:45:00', 'Alta', 'Carlos Eduardo', 1),
(1020, 2, '2026-07-27 22:30:00', 'Baixa', 'Pedro André', 1),
(1021, 1, '2026-08-11 03:45:00', 'Baixa', 'Julio', 1),
(1022, 1, '2026-08-24 16:30:00', 'Alta', 'Cesar Stati', 1),
(1023, 1, '2026-09-13 09:30:00', 'Baixa', 'Carlos Eduardo', 1),
(1024, 3, '2026-10-03 02:15:00', 'Média', 'Julio', 1),
(1025, 2, '2026-10-15 10:00:00', 'Baixa', 'Ana Julia', 1),
(1026, 3, '2026-10-23 05:00:00', 'Alta', 'Ana Julia', 1),
(1027, 2, '2026-11-08 02:30:00', 'Média', 'Lucas Brasil', 1),
(1028, 2, '2026-11-16 14:45:00', 'Média', 'Pedro André', 1),
(1029, 2, '2025-12-15 16:30:00', 'Alta', 'Pedro André', 1),
(1030, 3, '2026-01-17 01:30:00', 'Baixa', 'Pedro André', 1),
(1031, 2, '2026-02-06 02:15:00', 'Baixa', 'Ana Julia', 1),
(1032, 2, '2026-02-19 23:45:00', 'Baixa', 'Cesar Stati', 1),
(1033, 3, '2026-04-11 07:00:00', 'Baixa', 'Pedro André', 1),
(1034, 1, '2026-05-06 02:45:00', 'Média', 'Lucas Brasil', 1),
(1035, 3, '2026-05-21 14:45:00', 'Baixa', 'Julio', 1),
(1036, 1, '2026-06-08 00:15:00', 'Alta', 'Lucas Brasil', 1),
(1037, 3, '2026-07-04 11:00:00', 'Baixa', 'Ana Julia', 1),
(1038, 1, '2026-07-15 23:15:00', 'Baixa', 'Cesar Stati', 1),
(1039, 2, '2026-07-26 21:00:00', 'Baixa', 'Pedro André', 1),
(1040, 3, '2026-08-17 18:15:00', 'Baixa', 'Julio', 1),
(1041, 2, '2026-09-09 17:15:00', 'Alta', 'Pedro André', 1),
(1042, 3, '2026-09-19 13:45:00', 'Baixa', 'Pedro André', 1),
(1043, 2, '2026-10-20 10:30:00', 'Média', 'Carlos Eduardo', 1),
(1044, 1, '2026-11-07 05:45:00', 'Alta', 'Carlos Eduardo', 1),
(1045, 2, '2025-12-04 03:45:00', 'Média', 'Pedro André', 1),
(1046, 3, '2025-12-11 19:30:00', 'Alta', 'Cesar Stati', 1),
(1047, 2, '2025-12-21 03:15:00', 'Baixa', 'Ana Julia', 1),
(1048, 2, '2025-12-25 10:45:00', 'Baixa', 'Julio', 1),
(1049, 2, '2026-01-03 03:15:00', 'Alta', 'Carlos Eduardo', 1),
(1050, 2, '2026-01-08 12:15:00', 'Média', 'Cesar Stati', 1),
(1051, 2, '2026-01-16 06:15:00', 'Média', 'Lucas Brasil', 1),
(1052, 2, '2026-01-20 21:00:00', 'Média', 'Carlos Eduardo', 1),
(1053, 3, '2026-01-29 23:00:00', 'Baixa', 'Ana Julia', 1),
(1054, 2, '2026-02-03 21:15:00', 'Média', 'Ana Julia', 1),
(1055, 2, '2026-02-13 01:00:00', 'Baixa', 'Julio', 1),
(1056, 2, '2026-02-23 04:45:00', 'Média', 'Carlos Eduardo', 1),
(1057, 1, '2026-03-02 02:30:00', 'Alta', 'Ana Julia', 1),
(1058, 2, '2026-03-07 20:00:00', 'Alta', 'Cesar Stati', 1),
(1059, 2, '2026-03-14 17:15:00', 'Média', 'Carlos Eduardo', 1),
(1060, 2, '2026-03-18 23:00:00', 'Média', 'Carlos Eduardo', 1),
(1061, 1, '2026-03-24 09:30:00', 'Alta', 'Carlos Eduardo', 1),
(1062, 3, '2026-03-28 17:00:00', 'Média', 'Ana Julia', 1),
(1063, 2, '2026-04-04 08:15:00', 'Média', 'Pedro André', 1),
(1064, 3, '2026-04-11 22:15:00', 'Baixa', 'Julio', 1),
(1065, 2, '2026-04-19 16:00:00', 'Baixa', 'Pedro André', 1),
(1066, 1, '2026-04-25 03:30:00', 'Média', 'Pedro André', 1),
(1067, 1, '2026-05-02 17:15:00', 'Média', 'Carlos Eduardo', 1),
(1068, 2, '2026-05-10 18:00:00', 'Baixa', 'Julio', 1),
(1069, 3, '2026-05-16 14:45:00', 'Alta', 'Ana Julia', 1),
(1070, 2, '2026-05-23 13:15:00', 'Baixa', 'Lucas Brasil', 1),
(1071, 2, '2026-05-26 19:45:00', 'Média', 'Cesar Stati', 1),
(1072, 2, '2026-06-03 16:30:00', 'Alta', 'Pedro André', 1),
(1073, 1, '2026-06-06 17:30:00', 'Alta', 'Lucas Brasil', 1),
(1074, 1, '2026-06-10 08:15:00', 'Baixa', 'Cesar Stati', 1),
(1075, 3, '2026-06-15 14:15:00', 'Baixa', 'Carlos Eduardo', 1),
(1076, 2, '2026-06-20 23:30:00', 'Média', 'Julio', 1),
(1077, 1, '2026-06-25 07:30:00', 'Baixa', 'Julio', 1),
(1078, 1, '2026-06-28 04:30:00', 'Baixa', 'Ana Julia', 1),
(1079, 3, '2026-07-06 05:45:00', 'Alta', 'Julio', 1),
(1080, 3, '2026-07-13 07:00:00', 'Baixa', 'Carlos Eduardo', 1),
(1081, 3, '2026-07-18 22:30:00', 'Alta', 'Ana Julia', 1),
(1082, 1, '2026-07-26 00:00:00', 'Baixa', 'Pedro André', 1),
(1083, 2, '2026-08-03 07:15:00', 'Alta', 'Julio', 1),
(1084, 1, '2026-08-09 16:00:00', 'Baixa', 'Julio', 1),
(1085, 2, '2026-08-12 12:30:00', 'Média', 'Lucas Brasil', 1),
(1086, 1, '2026-08-18 19:00:00', 'Média', 'Pedro André', 1),
(1087, 2, '2026-08-24 12:15:00', 'Baixa', 'Lucas Brasil', 1),
(1088, 2, '2026-08-30 03:30:00', 'Média', 'Cesar Stati', 1),
(1089, 3, '2026-09-03 14:30:00', 'Baixa', 'Lucas Brasil', 1),
(1090, 2, '2026-09-09 16:00:00', 'Baixa', 'Julio', 1),
(1091, 2, '2026-09-16 19:00:00', 'Alta', 'Carlos Eduardo', 1),
(1092, 1, '2026-09-22 16:30:00', 'Baixa', 'Ana Julia', 1),
(1093, 2, '2026-09-26 21:15:00', 'Alta', 'Pedro André', 1),
(1094, 2, '2026-10-03 06:00:00', 'Média', 'Ana Julia', 1),
(1095, 2, '2026-10-11 09:00:00', 'Alta', 'Pedro André', 1),
(1096, 2, '2026-10-20 00:30:00', 'Baixa', 'Carlos Eduardo', 1),
(1097, 2, '2026-10-28 07:30:00', 'Alta', 'Julio', 1),
(1098, 2, '2026-11-02 15:30:00', 'Alta', 'Pedro André', 1),
(1099, 3, '2026-11-07 16:45:00', 'Alta', 'Cesar Stati', 1),
(1100, 2, '2026-11-12 17:45:00', 'Baixa', 'Pedro André', 1),
(1101, 2, '2026-11-17 12:30:00', 'Média', 'Carlos Eduardo', 1),
(1102, 2, '2026-11-23 02:15:00', 'Média', 'Carlos Eduardo', 1),
(1103, 2, '2025-12-10 04:30:00', 'Alta', 'Lucas Brasil', 1),
(1104, 2, '2026-01-08 16:30:00', 'Baixa', 'Carlos Eduardo', 1),
(1105, 3, '2026-01-27 02:00:00', 'Alta', 'Pedro André', 1),
(1106, 3, '2026-02-14 22:00:00', 'Média', 'Cesar Stati', 1),
(1107, 2, '2026-03-11 06:30:00', 'Média', 'Cesar Stati', 1),
(1108, 1, '2026-05-18 17:15:00', 'Alta', 'Carlos Eduardo', 1),
(1109, 3, '2026-06-08 14:45:00', 'Baixa', 'Cesar Stati', 1),
(1110, 2, '2026-06-24 05:30:00', 'Baixa', 'Julio', 1),
(1111, 1, '2026-07-11 08:45:00', 'Média', 'Carlos Eduardo', 1),
(1112, 2, '2026-08-05 20:00:00', 'Baixa', 'Carlos Eduardo', 1),
(1113, 3, '2026-09-03 09:45:00', 'Baixa', 'Cesar Stati', 1),
(1114, 2, '2026-09-22 11:00:00', 'Média', 'Lucas Brasil', 1),
(1115, 2, '2026-10-18 18:15:00', 'Baixa', 'Julio', 1),
(1116, 2, '2026-11-17 21:15:00', 'Baixa', 'Ana Julia', 1);

-- --------------------------------------------------------

--
-- Estrutura para tabela `produto`
--

CREATE TABLE `produto` (
  `id_produto` int(11) NOT NULL,
  `id_categoria` int(11) NOT NULL,
  `nome_produto` varchar(100) NOT NULL,
  `estoque_produto` bigint(20) NOT NULL,
  `data_producao` date NOT NULL,
  `ativo_produto` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `produto`
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
-- Estrutura para tabela `recebe_maquina_ords`
--

CREATE TABLE `recebe_maquina_ords` (
  `id_recebe_maquina_ords` int(11) NOT NULL,
  `id_maquina` int(11) NOT NULL,
  `id_ords` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `recebe_maquina_ords`
--

INSERT INTO `recebe_maquina_ords` (`id_recebe_maquina_ords`, `id_maquina`, `id_ords`) VALUES
(1, 4, 1),
(2, 1, 1001),
(3, 1, 1002),
(4, 1, 1003),
(5, 1, 1004),
(6, 1, 1005),
(7, 1, 1006),
(8, 1, 1007),
(9, 1, 1008),
(10, 1, 1009),
(11, 1, 1010),
(12, 1, 1011),
(13, 1, 1012),
(14, 1, 1013),
(15, 1, 1014),
(16, 1, 1015),
(17, 1, 1016),
(18, 1, 1017),
(19, 1, 1018),
(20, 1, 1019),
(21, 1, 1020),
(22, 1, 1021),
(23, 1, 1022),
(24, 1, 1023),
(25, 1, 1024),
(26, 1, 1025),
(27, 1, 1026),
(28, 1, 1027),
(29, 1, 1028),
(30, 2, 1029),
(31, 2, 1030),
(32, 2, 1031),
(33, 2, 1032),
(34, 2, 1033),
(35, 2, 1034),
(36, 2, 1035),
(37, 2, 1036),
(38, 2, 1037),
(39, 2, 1038),
(40, 2, 1039),
(41, 2, 1040),
(42, 2, 1041),
(43, 2, 1042),
(44, 2, 1043),
(45, 2, 1044),
(46, 3, 1045),
(47, 3, 1046),
(48, 3, 1047),
(49, 3, 1048),
(50, 3, 1049),
(51, 3, 1050),
(52, 3, 1051),
(53, 3, 1052),
(54, 3, 1053),
(55, 3, 1054),
(56, 3, 1055),
(57, 3, 1056),
(58, 3, 1057),
(59, 3, 1058),
(60, 3, 1059),
(61, 3, 1060),
(62, 3, 1061),
(63, 3, 1062),
(64, 3, 1063),
(65, 3, 1064),
(66, 3, 1065),
(67, 3, 1066),
(68, 3, 1067),
(69, 3, 1068),
(70, 3, 1069),
(71, 3, 1070),
(72, 3, 1071),
(73, 3, 1072),
(74, 3, 1073),
(75, 3, 1074),
(76, 3, 1075),
(77, 3, 1076),
(78, 3, 1077),
(79, 3, 1078),
(80, 3, 1079),
(81, 3, 1080),
(82, 3, 1081),
(83, 3, 1082),
(84, 3, 1083),
(85, 3, 1084),
(86, 3, 1085),
(87, 3, 1086),
(88, 3, 1087),
(89, 3, 1088),
(90, 3, 1089),
(91, 3, 1090),
(92, 3, 1091),
(93, 3, 1092),
(94, 3, 1093),
(95, 3, 1094),
(96, 3, 1095),
(97, 3, 1096),
(98, 3, 1097),
(99, 3, 1098),
(100, 3, 1099),
(101, 3, 1100),
(102, 3, 1101),
(103, 3, 1102),
(104, 4, 1103),
(105, 4, 1104),
(106, 4, 1105),
(107, 4, 1106),
(108, 4, 1107),
(109, 4, 1108),
(110, 4, 1109),
(111, 4, 1110),
(112, 4, 1111),
(113, 4, 1112),
(114, 4, 1113),
(115, 4, 1114),
(116, 4, 1115),
(117, 4, 1116);

-- --------------------------------------------------------

--
-- Estrutura para tabela `setor`
--

CREATE TABLE `setor` (
  `id_setor` int(11) NOT NULL,
  `nome_setor` varchar(100) NOT NULL,
  `ativo_setor` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `setor`
--

INSERT INTO `setor` (`id_setor`, `nome_setor`, `ativo_setor`) VALUES
(1, 'Atendimento', 1),
(2, 'Manutenção', 1);

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `administrador`
--
ALTER TABLE `administrador`
  ADD PRIMARY KEY (`id_administrador`);

--
-- Índices de tabela `cargo`
--
ALTER TABLE `cargo`
  ADD PRIMARY KEY (`id_cargo`);

--
-- Índices de tabela `categoria`
--
ALTER TABLE `categoria`
  ADD PRIMARY KEY (`id_categoria`);

--
-- Índices de tabela `chama_administrador_ords`
--
ALTER TABLE `chama_administrador_ords`
  ADD PRIMARY KEY (`id_chama_administrador_ords`),
  ADD KEY `id_administrador` (`id_administrador`),
  ADD KEY `id_ords` (`id_ords`);

--
-- Índices de tabela `chama_funcionario_ords`
--
ALTER TABLE `chama_funcionario_ords`
  ADD PRIMARY KEY (`id_chama_funcionario_ords`),
  ADD KEY `id_funcionario` (`id_funcionario`),
  ADD KEY `id_ords` (`id_ords`);

--
-- Índices de tabela `chama_gerente_ords`
--
ALTER TABLE `chama_gerente_ords`
  ADD PRIMARY KEY (`id_chama_gerente_ords`),
  ADD KEY `id_gerente` (`id_gerente`),
  ADD KEY `id_ords` (`id_ords`);

--
-- Índices de tabela `estoque_mensal`
--
ALTER TABLE `estoque_mensal`
  ADD PRIMARY KEY (`id_estoque_mensal`),
  ADD KEY `id_produto` (`id_produto`);

--
-- Índices de tabela `funcionamento_maquina`
--
ALTER TABLE `funcionamento_maquina`
  ADD PRIMARY KEY (`id_funcionamento_maquina`),
  ADD KEY `id_maquina` (`id_maquina`);

--
-- Índices de tabela `funcionario`
--
ALTER TABLE `funcionario`
  ADD PRIMARY KEY (`id_funcionario`),
  ADD KEY `idCargo` (`id_cargo`),
  ADD KEY `idSetor` (`id_setor`);

--
-- Índices de tabela `gerencia_administrador_funcionario`
--
ALTER TABLE `gerencia_administrador_funcionario`
  ADD PRIMARY KEY (`id_administrador_funcionario`),
  ADD KEY `id_funcionario` (`id_funcionario`),
  ADD KEY `id_administrador` (`id_administrador`);

--
-- Índices de tabela `gerencia_administrador_maquina`
--
ALTER TABLE `gerencia_administrador_maquina`
  ADD PRIMARY KEY (`id_administrador_maquina`),
  ADD KEY `id_administrador` (`id_administrador`),
  ADD KEY `id_maquina` (`id_maquina`);

--
-- Índices de tabela `gerencia_administrador_produto`
--
ALTER TABLE `gerencia_administrador_produto`
  ADD PRIMARY KEY (`id_administrador_produto`),
  ADD KEY `id_administrador` (`id_administrador`),
  ADD KEY `id_produto` (`id_produto`);

--
-- Índices de tabela `gerencia_gerente_funcionario`
--
ALTER TABLE `gerencia_gerente_funcionario`
  ADD PRIMARY KEY (`id_gerente_funcionario`),
  ADD KEY `id_funcionario` (`id_funcionario`),
  ADD KEY `id_gerente` (`id_gerente`);

--
-- Índices de tabela `gerencia_gerente_produto`
--
ALTER TABLE `gerencia_gerente_produto`
  ADD PRIMARY KEY (`id_gerente_produto`),
  ADD KEY `gerencia_gerente_produto_ibfk_1` (`id_produto`),
  ADD KEY `gerencia_gerente_produto_ibfk_2` (`id_gerente`);

--
-- Índices de tabela `gerente`
--
ALTER TABLE `gerente`
  ADD PRIMARY KEY (`id_gerente`),
  ADD KEY `idSetor` (`id_setor`);

--
-- Índices de tabela `manutencao`
--
ALTER TABLE `manutencao`
  ADD PRIMARY KEY (`id_manutencao`);

--
-- Índices de tabela `maquina`
--
ALTER TABLE `maquina`
  ADD PRIMARY KEY (`id_maquina`);

--
-- Índices de tabela `ordem_de_serviço`
--
ALTER TABLE `ordem_de_serviço`
  ADD PRIMARY KEY (`id_ords`),
  ADD KEY `id_manutenção` (`id_manutenção`);

--
-- Índices de tabela `produto`
--
ALTER TABLE `produto`
  ADD PRIMARY KEY (`id_produto`),
  ADD KEY `idCategoria` (`id_categoria`);

--
-- Índices de tabela `recebe_maquina_ords`
--
ALTER TABLE `recebe_maquina_ords`
  ADD PRIMARY KEY (`id_recebe_maquina_ords`),
  ADD KEY `id_maquina` (`id_maquina`),
  ADD KEY `id_ords` (`id_ords`);

--
-- Índices de tabela `setor`
--
ALTER TABLE `setor`
  ADD PRIMARY KEY (`id_setor`);

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
  MODIFY `id_chama_administrador_ords` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

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
-- AUTO_INCREMENT de tabela `estoque_mensal`
--
ALTER TABLE `estoque_mensal`
  MODIFY `id_estoque_mensal` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=61;

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
  MODIFY `id_ords` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1117;

--
-- AUTO_INCREMENT de tabela `recebe_maquina_ords`
--
ALTER TABLE `recebe_maquina_ords`
  MODIFY `id_recebe_maquina_ords` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=118;

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `chama_administrador_ords`
--
ALTER TABLE `chama_administrador_ords`
  ADD CONSTRAINT `chama_administrador_ords_ibfk_1` FOREIGN KEY (`id_administrador`) REFERENCES `administrador` (`id_administrador`),
  ADD CONSTRAINT `chama_administrador_ords_ibfk_2` FOREIGN KEY (`id_ords`) REFERENCES `ordem_de_serviço` (`id_ords`);

--
-- Restrições para tabelas `chama_funcionario_ords`
--
ALTER TABLE `chama_funcionario_ords`
  ADD CONSTRAINT `chama_funcionario_ords_ibfk_1` FOREIGN KEY (`id_funcionario`) REFERENCES `funcionario` (`id_funcionario`),
  ADD CONSTRAINT `chama_funcionario_ords_ibfk_2` FOREIGN KEY (`id_ords`) REFERENCES `ordem_de_serviço` (`id_ords`);

--
-- Restrições para tabelas `chama_gerente_ords`
--
ALTER TABLE `chama_gerente_ords`
  ADD CONSTRAINT `chama_gerente_ords_ibfk_1` FOREIGN KEY (`id_gerente`) REFERENCES `gerente` (`id_gerente`),
  ADD CONSTRAINT `chama_gerente_ords_ibfk_2` FOREIGN KEY (`id_ords`) REFERENCES `ordem_de_serviço` (`id_ords`);

--
-- Restrições para tabelas `estoque_mensal`
--
ALTER TABLE `estoque_mensal`
  ADD CONSTRAINT `estoque_mensal_ibfk_1` FOREIGN KEY (`id_produto`) REFERENCES `produto` (`id_produto`);

--
-- Restrições para tabelas `funcionamento_maquina`
--
ALTER TABLE `funcionamento_maquina`
  ADD CONSTRAINT `funcionamento_maquina_ibfk_1` FOREIGN KEY (`id_maquina`) REFERENCES `maquina` (`id_maquina`);

--
-- Restrições para tabelas `funcionario`
--
ALTER TABLE `funcionario`
  ADD CONSTRAINT `funcionario_ibfk_1` FOREIGN KEY (`id_cargo`) REFERENCES `cargo` (`id_cargo`),
  ADD CONSTRAINT `funcionario_ibfk_3` FOREIGN KEY (`id_setor`) REFERENCES `setor` (`id_setor`);

--
-- Restrições para tabelas `gerencia_administrador_funcionario`
--
ALTER TABLE `gerencia_administrador_funcionario`
  ADD CONSTRAINT `gerencia_administrador_funcionario_ibfk_1` FOREIGN KEY (`id_funcionario`) REFERENCES `funcionario` (`id_funcionario`),
  ADD CONSTRAINT `gerencia_administrador_funcionario_ibfk_2` FOREIGN KEY (`id_administrador`) REFERENCES `administrador` (`id_administrador`);

--
-- Restrições para tabelas `gerencia_administrador_maquina`
--
ALTER TABLE `gerencia_administrador_maquina`
  ADD CONSTRAINT `gerencia_administrador_maquina_ibfk_1` FOREIGN KEY (`id_administrador`) REFERENCES `administrador` (`id_administrador`),
  ADD CONSTRAINT `gerencia_administrador_maquina_ibfk_2` FOREIGN KEY (`id_maquina`) REFERENCES `maquina` (`id_maquina`);

--
-- Restrições para tabelas `gerencia_administrador_produto`
--
ALTER TABLE `gerencia_administrador_produto`
  ADD CONSTRAINT `gerencia_administrador_produto_ibfk_1` FOREIGN KEY (`id_administrador`) REFERENCES `administrador` (`id_administrador`),
  ADD CONSTRAINT `gerencia_administrador_produto_ibfk_2` FOREIGN KEY (`id_produto`) REFERENCES `produto` (`id_produto`);

--
-- Restrições para tabelas `gerencia_gerente_funcionario`
--
ALTER TABLE `gerencia_gerente_funcionario`
  ADD CONSTRAINT `gerencia_gerente_funcionario_ibfk_1` FOREIGN KEY (`id_funcionario`) REFERENCES `funcionario` (`id_funcionario`),
  ADD CONSTRAINT `gerencia_gerente_funcionario_ibfk_2` FOREIGN KEY (`id_gerente`) REFERENCES `gerente` (`id_gerente`);

--
-- Restrições para tabelas `gerencia_gerente_produto`
--
ALTER TABLE `gerencia_gerente_produto`
  ADD CONSTRAINT `gerencia_gerente_produto_ibfk_1` FOREIGN KEY (`id_produto`) REFERENCES `produto` (`id_produto`),
  ADD CONSTRAINT `gerencia_gerente_produto_ibfk_2` FOREIGN KEY (`id_gerente`) REFERENCES `gerente` (`id_gerente`);

--
-- Restrições para tabelas `gerente`
--
ALTER TABLE `gerente`
  ADD CONSTRAINT `gerente_ibfk_1` FOREIGN KEY (`id_setor`) REFERENCES `setor` (`id_setor`);

--
-- Restrições para tabelas `ordem_de_serviço`
--
ALTER TABLE `ordem_de_serviço`
  ADD CONSTRAINT `ordem_de_serviço_ibfk_1` FOREIGN KEY (`id_manutenção`) REFERENCES `manutencao` (`id_manutencao`);

--
-- Restrições para tabelas `produto`
--
ALTER TABLE `produto`
  ADD CONSTRAINT `produto_ibfk_1` FOREIGN KEY (`id_categoria`) REFERENCES `categoria` (`id_categoria`);

--
-- Restrições para tabelas `recebe_maquina_ords`
--
ALTER TABLE `recebe_maquina_ords`
  ADD CONSTRAINT `recebe_maquina_ords_ibfk_1` FOREIGN KEY (`id_maquina`) REFERENCES `maquina` (`id_maquina`),
  ADD CONSTRAINT `recebe_maquina_ords_ibfk_2` FOREIGN KEY (`id_ords`) REFERENCES `ordem_de_serviço` (`id_ords`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
