<?php

require_once 'conexao.php';

$sql = "SELECT f.nome_funcionario AS nome, /*Deixei com apelidos diferentes por serem tabelas diferentes c, s, f*/
               c.nome_cargo       AS cargo,
               s.nome_setor       AS setor
        FROM funcionario f
        INNER JOIN cargo c ON c.id_cargo = f.id_cargo /*INNER JOIN só pode ser usado para tabelas diferentes*/
        INNER JOIN setor s ON s.id_setor = f.id_setor

        UNION ALL /*UNION ALL -> junta todas as tabelas em uma, puxando as informações das outras duas para a principal*/

        SELECT a.nome_administrador, 'Administrador', 'Geral'
        FROM administrador a

        ORDER BY nome";
        
$funcionarios = $pdo->query($sql)->fetchAll();

$setores = $pdo->query("SELECT id_setor, nome_setor FROM setor")->fetchAll();

$cargo = $pdo->query("SELECT id_cargo, tipo_cargo FROM cargo")->fetchAll();

$paginaAtual = basename($_SERVER['SCRIPT_NAME']); // para marcar o item ativo do menu   

$menu = [ //array do menu //aqui
    [
        "nome" => 'Funcionários',
        "arquivo" => 'index.php',
        "icone" => "img/pessoas.svg"       
    ],
    [
        "nome" => "Histórico",
        "arquivo" => 'historico.php',
        "icone" => "img/historico.svg"
    ], 
    [
        "nome" => 'Máq. e Equip.',
        "arquivo" => '../dashboard/maquinas.php',
        "icone" => "img/maquinas.svg"
    ],
    [
        "nome" => 'Ordens de Serviço',
        "arquivo" => 'ordens.php',
        "icone" => "img/maleta.svg"
    ],
    [
        "nome" => 'Produtos',
        "arquivo" => 'produtos.php',
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
    <nav class="sidebar">
    <?php foreach ($menu as $item): ?> <!--Parte que faz o menu ser verificado como ativo-->
        <?php $ativo = ($item['arquivo'] === $paginaAtual) ? 'active' : ''; ?>
        <a href="<?= htmlspecialchars($item['arquivo']) ?>"
           class="side-item <?= $ativo ?>"
           <?= $ativo ? 'aria-current="page"' : '' ?>>
            <img src="<?= htmlspecialchars($item['icone']) ?>" alt="">
            <span><?= htmlspecialchars($item['nome']) ?></span>
        </a>
    <?php endforeach; ?>
    </nav>
        <main class ="content">
            <div class="content-head">
                <h1>Funcionários</h1>
                <button class="btn-primary">
                    <span class = "icon-plus">
                        <img src="img/plus.svg" alt="+" class="plus">
                    </span>
                    <span>Novo Registro</span>
                </button>
            </div>
            
        <!--Filtros-->
            <form class="filters" method="get">
                <label class="search">
                    <img src="img/lupa.svg" alt="lupa" class="lupa">
                        <input type="text" placeholder="Buscar por Nome...">
                </label>

                <label class="field"> Setor:
                <select name="setor"> <!--aqui eu puxei o setor que eu chamei lá em cima para vincular ao banco para ter opções que realmente existam no banco de dados-->
                <option value="">Todos</option>
                <?php foreach ($setores as $s): ?>
                <option value="<?= $s['id_setor'] ?>"><?= htmlspecialchars($s['nome_setor']) ?></option>
                <?php endforeach; ?>
                </select>
                </label>

                <label class = "field"> Cargo:
                <select name="cargo"> <!--Segui a mesma lógica do setor-->
                <option value="">Todos</option>
                <?php foreach ($cargo as $c): ?>
                <option value="<?= $c['id_cargo'] ?>"><?= htmlspecialchars($c['tipo_cargo']) ?></option>
                <?php endforeach; ?>
                </select>
                </label>
            </form>

        <!--Tabela-->
            <div class="table-card">
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
            </div>
        </main>
    </div>
</div>
<script src="js/menu.js"></script>
</body>
</html>