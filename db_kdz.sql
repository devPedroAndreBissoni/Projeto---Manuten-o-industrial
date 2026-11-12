-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 05/11/2026 às 12:28
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
(1, 0, 1, '11111111111', 'Admin Teste', 'admin@kdz.com', '41999990001', '$2b$12$BLjoVZQgYBnnAoy1Cw8/Vu0BLM8WSQEMvosyfYKIG32KS8apHyKDK'),
(2, 1, 0, '11111111112', 'Admin Teste 2', 'admin2@kdz.com', '41999990002', '$2b$12$BLjoVZQgYBnnAoy1Cw8/Vu0BLM8WSQEMvosyfYKIG32KS8apHyKDK');

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
  `id_ords` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `chama_funcionario_ords`
--

CREATE TABLE `chama_funcionario_ords` (
  `id_chama_funcionario_ords` int(11) NOT NULL,
  `id_funcionario` int(11) DEFAULT NULL,
  `id_ords` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `chama_gerente_ords`
--

CREATE TABLE `chama_gerente_ords` (
  `id_chama_gerente_ords` int(11) NOT NULL,
  `id_gerente` int(11) DEFAULT NULL,
  `id_ords` int(11) DEFAULT NULL
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
(4, 3, 'Caixa Plástica 20L', 800, '2026-10-15', 1),
(5, 3, 'Tampa Plástica Universal', 1500, '2026-10-20', 1);

-- --------------------------------------------------------

--
-- Estrutura para tabela `recebe_maquina_ords`
--

CREATE TABLE `recebe_maquina_ords` (
  `id_recebe_maquina_ords` int(11) NOT NULL,
  `id_maquina` int(11) NOT NULL,
  `id_ords` int(11) NOT NULL
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
  MODIFY `id_administrador` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

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
-- Restrições para tabelas `ordem_de_serviço`
--
ALTER TABLE `ordem_de_serviço`
  ADD CONSTRAINT `ordem_de_serviço_ibfk_1` FOREIGN KEY (`id_manutenção`) REFERENCES `manutencao` (`id_manutencao`);

--
-- Restrições para tabelas `produto`
--
ALTER TABLE `produto`
  ADD CONSTRAINT `produto_ibfk_1` FOREIGN KEY (`id_categoria`) REFERENCES `categoria` (`id_categoria`),
  ADD CONSTRAINT `produto_ibfk_2` FOREIGN KEY (`id_categoria`) REFERENCES `categoria` (`id_categoria`),
  ADD CONSTRAINT `produto_ibfk_3` FOREIGN KEY (`id_categoria`) REFERENCES `categoria` (`id_categoria`);

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
