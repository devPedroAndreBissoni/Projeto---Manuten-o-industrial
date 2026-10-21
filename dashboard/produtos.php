<?php
require_once 'conexao.php';
$sql = "SELECT p.nome_produto                   AS nome,                  
               p.data_producao                   AS producao,
               p.estoque_produto          AS estoque
        FROM produto p";

$maquina = $pdo -> query($sql) -> fetchAll();
$tituloPagina = 'Produtos'; ?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Produtos</title>
    <link rel="stylesheet" href="css/style.css">    
</head>
<body>
<div class="page">
            <!--Topo-->
        <header class="topbar">
            <div class = "brand"> <!--classe da logo-->
                <img src="img/kidzy-logo.svg" alt="Kidzy Brinquedos" class="logo">
                <h1>KIDZY Brinquedos</h1>
            </div>

            <div class="topbar-right">
                <div class="user"> <!--aqui só botei texto substituir pelo usuário do banco!!!!-->
                    <span class="avatar"></span>
                    <span><strong>teste</strong>oi</span>
                </div>
                <button class="btn-login" type="button" data-action="login"> <!--Ícone do login/Usuário-->
                    <span class="icon-circle" aria-hidden="true">
                        <span class="icon-user"></span>
                    </span>
                </button>
                <button class="icon-btn" aria-label="Notificações">
                    <img src="img/sino.svg" alt="sininho">
                </button>
                <button class="icon-btn" aria-label="Configurações">
                    <img src="img/engrenagem.svg" alt="Config">
                </button>
        </header>
                                <!--barra da esquerda-->
        <div class="body">
    <nav class="sidebar">
    <?php include 'menu.php' ?>
    </nav>
                                <!--Botao de novo registro e titulo da pagina-->
    <main class ="content">
            <div class="content-head">
                <h1>Produtos</h1>
                <button class="btn-primary">
                    <span class = "icon-plus">
                        <img src="img/plus.svg" alt="+" class="plus">
                    </span>
                    <span>Novo Registro</span>
                </button>
            </div>
                                <!--Filtros-->
            <form class="filters">
                <label class="search">
                    <img src="img/lupa.svg" alt="lupa" class="lupa">
                    <input type="text" placeholder="Buscar por Nome...">
                </label>

                <label class="field"> Categoria:
                     <select>
                        <option value="1"> [Carros]</option>
                        <option value="2"> [Blocos de Madeira]</option>
                        <option value="3"> [Trens]</option>
                    </select>
                </label>

                <label class = "field"> Local de armazenamento:
                    <select name ="cargo" id="cargo">
                        <option value="1">[Armazem 1]</option>
                        <option value="2">[Armazem 2]</option>
                        <option value="3">[Armazem 3]</option>
                    </select>
                </label>
            </form>
                                <!--Tabela-->
        <div class="table-card">
                <table>
                    <thead>
                        <tr><th>Nome</th><th>Data de produção</th><th>Estoque</th><th class="center">Ações</th></tr>
                    </thead>
                    <tbody>
                        <?php foreach ($maquina as $m): ?>
                        <tr>
                            <td><?= htmlspecialchars($m['nome']) ?></td>
                            <td><?= htmlspecialchars($m['Data'] ?? '-') ?></td>
                            <td><?= htmlspecialchars($m['Estoque'] ?? '-') ?></td>
                            <td class="actions">
                                <button aria-label="Editar">
                                    <img src="img/editar.svg" alt="editar" class="edit">
                                </button> 

                                <button aria-label="Documento">
                                    <img src="img/listar.svg" alt="detalhes" class="listar">
                                </button> 

                                <button aria-label="Histórico">
                                    <img src="img/relogio.svg" alt="relogio" class="relogio">
                                </button> 
                                
                                <button aria-label="Inativar">
                                    <img src="img/lixo.svg" alt="lixo" class="lixo">
                                </button>  
                            </td>
                        </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>
            </div>
        </main>
    </div>
</div>
</body>
</html>