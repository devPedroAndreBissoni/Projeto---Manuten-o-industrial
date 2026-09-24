# Kidzy Brinquedos - Sistema de Gerenciamento de Manutenção Industrial

---

##  Escopo do Projeto

### Problema
A empresa realiza o controle das manutenções preventivas e corretivas de suas máquinas por meio de planilhas eletrônicas, formulários em papel e comunicação informal entre os setores. Esse processo acarreta diversos gargalos operacionais:
- Dificuldade no acompanhamento e consulta do histórico de equipamentos.
- Atrasos frequentes nas manutenções programadas.
- Aumento de paradas não planejadas nas linhas de produção.
- Perda de produtividade e elevação dos custos operacionais.
- Dificuldade dos gestores para identificar equipamentos com alto índice de falhas, acompanhar o desempenho da equipe de manutenção e planejar a renovação do parque fabril.

### Objetivo
Desenvolver uma solução digital para o gerenciamento inteligente da manutenção industrial focada no setor de fábrica de brinquedos. O sistema busca gerenciar o parque de máquinas em tempo real, permitindo que todos os colaboradores saibam se os equipamentos estão em pleno funcionamento ou se necessitam de suporte técnico.

### Público-alvo
Colaboradores da indústria fabril da Kidzy Brinquedos, divididos conforme seus níveis de atuação e responsabilidade no fluxo operacional:
- **Funcionários:** Operadores de chão de fábrica e técnicos de manutenção.
- **Gerentes:** Responsáveis pelo planejamento, equipes e recursos fabris.
- **Administradores:** Gestores com controle total dos dados e acessos do sistema.

### Solução
Desenvolvimento de uma plataforma web integrada a um banco de dados relacional que centraliza o controle das rotinas de manutenção. O sistema possibilita o cadastro de máquinas, setores, técnicos e produtos, emissão de ordens de serviço (preventivas e corretivas), acompanhamento do status em tempo real, alertas automáticos para manutenções agendadas e geração de relatórios gerenciais para tomada de decisão.

---

###  Permissões e Níveis de Acesso

O sistema conta com Controle de Acesso Baseado em Cargos (RBAC):

| Cargo | Permissões |
| :--- | :--- |
| **Funcionário** | Listar e atualizar máquinas e produtos. |
| **Gerente** | Listar, atualizar e cadastrar funcionários e máquinas. |
| **Administrador** | Permissão total (*CRUD*): Listar, atualizar, cadastrar e deletar funcionários, máquinas e produtos. |

---

###  Principais Funcionalidades

- **Ordens de Serviço:** Visualização detalhada e criação de novas ordens de serviço (OS).
- **Gestão de Máquinas:** Controle e atualização de status operacional dos equipamentos em tempo real.
- **Gestão de Produtos:** Acompanhamento do catálogo de brinquedos/produtos vinculados à linha de produção.
- **Gestão de Equipamentos e Histórico:** Registro completo do histórico de intervenções e suportes prestados.
- **Gestão de Funcionários:** Controle de cadastros e níveis de acesso da equipe.
- **Alertas Automáticos:** Notificações programadas para manutenções preventivas.
- **Relatórios Gerenciais:** Indicadores sobre o desempenho do parque fabril e equipe técnica.

---

##  Design System

### Cores

| Aplicação | Cor | Hexadecimal |
| :--- | :--- | :--- |
| **Cor Primária** | Terracota / Laranja | `#DE5D34` |
| **Cor Secundária** | Azul Índigo | `#495AC0` |
| **Cor de Fundo** | Creme Claro | `#FEF6DD` |
| **Texto (Principal)** | Castanho Escuro | `#2C221A` |
| **Texto (Alternativo)** | Off-White | `#FFF8E7` |

###  Tipografia

- **Fonte Principal (Interface do Sistema):** `Khand` (Sans-serif funcional e legível para sistemas industriais)
- **Fonte da Logotipo:** `Sniglet` (Usada exclusivamente na identidade visual e marca *Kidzy Brinquedos*)

###  Logotipo

A identidade visual da **Kidzy Brinquedos** combina cores vibrantes e acolhedoras com elementos lúdicos (blocos de montar infantis) para transmitir simplicidade, organização e foco na indústria de brinquedos, mantendo o tom profissional necessário para a gestão fabril.

---

##  Tecnologias

- **Frontend:** HTML, CSS
- **Backend:** PHP, JavaScript, Python
- **Banco de Dados:** MySQL

---

##  Equipe

- Ana Julia
- Eduardo Fischer
- Lucas Brasil
- Lucas Emanuel
- Pedro Ándre
