<?php

require_once 'conexao.php';

$sql = "SELECT f.nome_funcionario AS nome,
               c.nome_cargo       AS cargo,
               s.nome_setor       AS setor
        FROM funcionario f
        LEFT JOIN cargo c ON c.id_cargo = f.idCargo
        LEFT JOIN setor s ON s.id_setor = f.idSetor

        UNION ALL

        SELECT a.nome_administrador, 'Administrador', NULL
        FROM administrador a

        ORDER BY nome";
        
$funcionarios = $pdo->query($sql)->fetchAll();

$menu = [ //array do menu //aqui
    [
        "nome" => "Histórico",
        "icone" => "img/historico.svg"
    ], 
    [
        "nome" => 'Máq. e Equip.',
        "arquivo" => 'telamaquinas.php',
        "icone" => "img/maquinas.svg"
    ],
    [
        "nome" => 'Funcionários',
        "icone" => "img/pessoas.svg"       
    ],
    [
        "nome" => 'Ordens de Serviço',
        "icone" => "img/maleta.svg"
],
    [
        "nome" => 'Produtos',
        "icone" => "img/caixa.svg"
    ],
];


?>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Admin</title>
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
            </div>
        </header>

    <!--Corpo-->
    <div class="body">
        <nav class = "sidebar"> <!--Parte lateral-->
        <?php foreach ($menu as $item): ?> <!--Aqui puxei o array do menu lá de cima-->
                <a href="#" class="side-item">
                    <img src="<?= $item['icone'] ?>" alt="">
                    <span><?= $item['nome'] ?></span>
                </a>
        <?php endforeach; ?>
        </nav>
        <main class ="content">
            <div class="content-head">
                <h1>Funcionarios</h1>
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

                <label class="field"> Setor:
                    <select>
                        <option value="1"> Produção</option>
                    </select>
                </label>

                <label class = "field"> Cargo:
                    <select name ="cargo" id="cargo">
                        <option value="1">[Funcionário]</option>
                        <option value="2">[Gerente]</option>
                        <option value="3">[Administrador]</option>
                    </select>
                </label>
            </form>

        <!--Tabela-->
        <table>
            <thead>
                <tr><th>Nome</th><th>Cargo/Permissão</th><th>Setor</th><th class="center">Ações</th></tr>
            </thead>
            <tbody>
                <?php foreach ($funcionarios as $f): ?>
                <tr>
                    <td><?= htmlspecialchars($f['nome']) ?></td>
                    <td><?= htmlspecialchars($f['cargo'] ?? '-') ?></td>
                    <td><?= htmlspecialchars($f['setor'] ?? '-') ?></td>
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
                    </td>
                </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    </main>
</div>
</body>
</html>