-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 15/10/2026 às 14:13
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
  `cpf_administrador` varchar(14) NOT NULL,
  `nome_administrador` varchar(100) NOT NULL,
  `email_administrador` varchar(100) NOT NULL,
  `telefone_administrador` varchar(12) NOT NULL,
  `senha_administrador` varchar(225) NOT NULL,
  `ativo_administrador` tinyint(1) NOT NULL DEFAULT 1,
  `id_cargo` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `administrador`
--

INSERT INTO `administrador` (`id_administrador`, `cpf_administrador`, `nome_administrador`, `email_administrador`, `telefone_administrador`, `senha_administrador`, `ativo_administrador`, `id_cargo`) VALUES
(1, '11111111111', 'Admin Teste', 'admin@kdz.com', '41999990001', '$2b$12$BLjoVZQgYBnnAoy1Cw8/Vu0BLM8WSQEMvosyfYKIG32KS8apHyKDK', 1, 0),
(2, '11111111112', 'Admin Teste 2', 'admin2@kdz.com', '41999990002', '$2b$12$BLjoVZQgYBnnAoy1Cw8/Vu0BLM8WSQEMvosyfYKIG32KS8apHyKDK', 0, 1);

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
  `id_categoria_brinquedo` int(11) NOT NULL,
  `tipo_categoria` varchar(50) NOT NULL,
  `ativo_categoria` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
(1, 3, 1, '41977770001', '33333333331', 'funcionario@kdz.com', 'Funcionario Teste', '$2b$12$vW0GYTuYyffBe8UYa.ixQOEISkO7qAGqoZ/J4hiiRCAQebJkwjvHi', 1),
(2, 2, 2, '41977770002', '33333333332', 'gerente.func@kdz.com', 'Gerente Teste (func)', '$2b$12$vW0GYTuYyffBe8UYa.ixQOEISkO7qAGqoZ/J4hiiRCAQebJkwjvHi', 1),
(3, 1, 2, '41977770003', '33333333333', 'admin.func@kdz.com', 'Admin Teste (func)', '$2b$12$vW0GYTuYyffBe8UYa.ixQOEISkO7qAGqoZ/J4hiiRCAQebJkwjvHi', 1);

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
  `nome_gerente` varchar(100) NOT NULL,
  `email_gerente` varchar(100) NOT NULL,
  `cpf_gerente` varchar(12) NOT NULL,
  `telefone_gerente` varchar(14) NOT NULL,
  `senha_gerente` varchar(225) NOT NULL,
  `ativo_gerente` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `gerente`
--

INSERT INTO `gerente` (`id_gerente`, `nome_gerente`, `email_gerente`, `cpf_gerente`, `telefone_gerente`, `senha_gerente`, `ativo_gerente`) VALUES
(1, 'Gerente Teste', 'gerente@kdz.com', '22222222221', '41988880001', '$2b$12$fEiAJXIlTREvjCnTkRQ9uulBDfMXsG1DJcfv8jq2Za1U/KlJKB3ZG', 1),
(2, 'Gerente Teste 2', 'gerente2@kdz.com', '22222222222', '41988880002', '$2b$12$fEiAJXIlTREvjCnTkRQ9uulBDfMXsG1DJcfv8jq2Za1U/KlJKB3ZG', 1);

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

-- --------------------------------------------------------

--
-- Estrutura para tabela `produto`
--

CREATE TABLE `produto` (
  `id_produto` int(11) NOT NULL,
  `id_categoria` int(11) NOT NULL,
  `nome_produto` varchar(100) NOT NULL,
  `ativo_produto` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `realiza`
--

CREATE TABLE `realiza` (
  `id_maquina_manutenção` int(11) NOT NULL,
  `id_manutencao` int(11) NOT NULL,
  `id_maquina` int(11) NOT NULL,
  `ativo_manutencao` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
  ADD PRIMARY KEY (`id_categoria_brinquedo`);

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
  ADD PRIMARY KEY (`id_gerente`);

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
-- Índices de tabela `produto`
--
ALTER TABLE `produto`
  ADD PRIMARY KEY (`id_produto`),
  ADD KEY `idCategoria` (`id_categoria`);

--
-- Índices de tabela `realiza`
--
ALTER TABLE `realiza`
  ADD PRIMARY KEY (`id_maquina_manutenção`),
  ADD KEY `Chave` (`id_manutencao`),
  ADD KEY `id_maquina` (`id_maquina`);

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
  MODIFY `id_administrador` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

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
-- AUTO_INCREMENT de tabela `realiza`
--
ALTER TABLE `realiza`
  MODIFY `id_maquina_manutenção` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `funcionario`
--
ALTER TABLE `funcionario`
  ADD CONSTRAINT `funcionario_ibfk_1` FOREIGN KEY (`id_cargo`) REFERENCES `cargo` (`id_cargo`),
  ADD CONSTRAINT `funcionario_ibfk_2` FOREIGN KEY (`id_cargo`) REFERENCES `cargo` (`id_cargo`),
  ADD CONSTRAINT `funcionario_ibfk_3` FOREIGN KEY (`id_setor`) REFERENCES `setor` (`id_setor`),
  ADD CONSTRAINT `funcionario_ibfk_4` FOREIGN KEY (`id_cargo`) REFERENCES `cargo` (`id_cargo`),
  ADD CONSTRAINT `funcionario_ibfk_5` FOREIGN KEY (`id_setor`) REFERENCES `setor` (`id_setor`);

--
-- Restrições para tabelas `gerencia_administrador_funcionario`
--
ALTER TABLE `gerencia_administrador_funcionario`
  ADD CONSTRAINT `gerencia_administrador_funcionario_ibfk_1` FOREIGN KEY (`id_funcionario`) REFERENCES `funcionario` (`id_funcionario`),
  ADD CONSTRAINT `gerencia_administrador_funcionario_ibfk_2` FOREIGN KEY (`id_administrador`) REFERENCES `administrador` (`id_administrador`),
  ADD CONSTRAINT `gerencia_administrador_funcionario_ibfk_3` FOREIGN KEY (`id_funcionario`) REFERENCES `funcionario` (`id_funcionario`),
  ADD CONSTRAINT `gerencia_administrador_funcionario_ibfk_4` FOREIGN KEY (`id_administrador`) REFERENCES `administrador` (`id_administrador`);

--
-- Restrições para tabelas `gerencia_administrador_maquina`
--
ALTER TABLE `gerencia_administrador_maquina`
  ADD CONSTRAINT `gerencia_administrador_maquina_ibfk_1` FOREIGN KEY (`id_administrador`) REFERENCES `administrador` (`id_administrador`),
  ADD CONSTRAINT `gerencia_administrador_maquina_ibfk_2` FOREIGN KEY (`id_maquina`) REFERENCES `maquina` (`id_maquina`),
  ADD CONSTRAINT `gerencia_administrador_maquina_ibfk_3` FOREIGN KEY (`id_administrador`) REFERENCES `administrador` (`id_administrador`),
  ADD CONSTRAINT `gerencia_administrador_maquina_ibfk_4` FOREIGN KEY (`id_maquina`) REFERENCES `maquina` (`id_maquina`);

--
-- Restrições para tabelas `gerencia_administrador_produto`
--
ALTER TABLE `gerencia_administrador_produto`
  ADD CONSTRAINT `gerencia_administrador_produto_ibfk_1` FOREIGN KEY (`id_administrador`) REFERENCES `administrador` (`id_administrador`),
  ADD CONSTRAINT `gerencia_administrador_produto_ibfk_2` FOREIGN KEY (`id_produto`) REFERENCES `produto` (`id_produto`),
  ADD CONSTRAINT `gerencia_administrador_produto_ibfk_3` FOREIGN KEY (`id_administrador`) REFERENCES `administrador` (`id_administrador`),
  ADD CONSTRAINT `gerencia_administrador_produto_ibfk_4` FOREIGN KEY (`id_produto`) REFERENCES `produto` (`id_produto`);

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
-- Restrições para tabelas `produto`
--
ALTER TABLE `produto`
  ADD CONSTRAINT `produto_ibfk_1` FOREIGN KEY (`id_categoria`) REFERENCES `categoria` (`id_categoria_brinquedo`),
  ADD CONSTRAINT `produto_ibfk_2` FOREIGN KEY (`id_categoria`) REFERENCES `categoria` (`id_categoria_brinquedo`),
  ADD CONSTRAINT `produto_ibfk_3` FOREIGN KEY (`id_categoria`) REFERENCES `categoria` (`id_categoria_brinquedo`);

--
-- Restrições para tabelas `realiza`
--
ALTER TABLE `realiza`
  ADD CONSTRAINT `realiza_ibfk_1` FOREIGN KEY (`id_maquina`) REFERENCES `maquina` (`id_maquina`),
  ADD CONSTRAINT `realiza_ibfk_2` FOREIGN KEY (`id_manutencao`) REFERENCES `manutencao` (`id_manutencao`),
  ADD CONSTRAINT `realiza_ibfk_3` FOREIGN KEY (`id_maquina`) REFERENCES `maquina` (`id_maquina`),
  ADD CONSTRAINT `realiza_ibfk_4` FOREIGN KEY (`id_manutencao`) REFERENCES `manutencao` (`id_manutencao`),
  ADD CONSTRAINT `realiza_ibfk_5` FOREIGN KEY (`id_maquina`) REFERENCES `maquina` (`id_maquina`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
