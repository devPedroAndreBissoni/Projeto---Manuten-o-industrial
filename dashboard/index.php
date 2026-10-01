<?php

$funcionarios = [
    ['nome' => 'Ana', 'cargo' => 'funcionária', 'setor' => 'Máquinas'], //URGENTEEEE TROCAR PELO BANCO ASSIM QUE POSSÍVEL
    ['nome' => 'Pedro', 'cargo'=> 'funcionário', 'setor' => 'Manutenção'],
    ['nome' => 'Eduardo', 'cargo' => 'Gerente', 'setor' => 'Manutenção'],
];

$menu = [ //array do menu //aqui
    [
        "nome" => "Histórico",
        "icone" => "img/historico.svg"
    ], 
    [
        "nome" => 'Máquinas e Equipamentos',
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


function icon($nome) {
    // 1) ícones inline (os que já estão no array)
    $p = [
        'bell' => '<path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/>',
    ];
    if (isset($p[$nome])) {
        return '<svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                 stroke-width="2" stroke-linecap="round" stroke-linejoin="round">' . $p[$nome] . '</svg>';
    }
}
?>
<!DOCTYPE html>
<html lang="en">
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
                <button class="icon-btn" aria-label="Notificações"><?= icon('bell') ?></button>
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
            <div class="content head">
                <h1>Histórico</h1>
                <button class="btn-primary">
                    <span class = "icon-plus">
                        <img src="img/plus.svg" alt="+" class="plus">
                    </span>
                    <h1>Novo Registro</h1>
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
            <body>
                <?php foreach ($funcionarios as $f): ?>
                <tr>
                    <td><?= htmlspecialchars($f['nome']) ?></td>
                    <td><?= htmlspecialchars($f['cargo']) ?></td>
                    <td><?= htmlspecialchars($f['setor']) ?></td>
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
            </body>
        </table>
    </main>
</div>
</body>
</html>