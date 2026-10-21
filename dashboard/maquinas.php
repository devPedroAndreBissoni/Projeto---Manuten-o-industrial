<?php
require_once 'conexao.php';
$sql = "SELECT m.nome_maquina                   AS nome,                  
               m.tipo_maquina                   AS maquina,
               m.funcionamento_maquina          AS funcionamento
        FROM maquina m";

$maquina = $pdo -> query($sql) -> fetchAll();
$tituloPagina = 'Maquinas'; ?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Máquinas</title>
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
                <h1>Maquinas e equipamentos</h1>
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

                <label class="field"> Modelo:
                     <select>
                        <option value="1"> [Montagem]</option>
                    </select>
                </label>

                <label class = "field"> Status:
                    <select name ="cargo" id="cargo">
                        <option value="1">[Ativo]</option>
                        <option value="2">[Inativo]</option>
                        <option value="3">[Em Manutenção]</option>
                    </select>
                </label>
            </form>
                                <!--Tabela-->
        <div class="table-card">
                <table>
                    <thead>
                        <tr><th>Codigo</th><th>Equipamento/Modelo</th><th>Status</th><th class="center">Ações</th></tr>
                    </thead>
                    <tbody>
                        <?php foreach ($maquina as $m): ?>
                        <tr>
                            <td><?= htmlspecialchars($m['nome']) ?></td>
                            <td><?= htmlspecialchars($m['maquina'] ?? '-') ?></td>
                            <td><?= htmlspecialchars($m['funcionamento'] ?? '-') ?></td>
                            <td class="actions">
                                <button aria-label="Editar">
                                    <img src="img/editar.svg" alt="editar" class="edit">
                                </button> 

                                <button aria-label="Manutenção">
                                    <img src="img/chave.svg" alt="chave" class="chave">
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