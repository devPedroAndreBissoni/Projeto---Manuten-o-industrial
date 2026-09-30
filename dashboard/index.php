<?php

$funcionarios = [
    ['nome' => 'Ana', 'cargo' => 'funcionária', 'setor' => 'Máquinas'], //URGENTEEEE TROCAR PELO BANCO ASSIM QUE POSSÍVEL
    ['nome' => 'Pedro', 'cargo'=> 'funcionário', 'setor' => 'Manutenção'],
    ['nome' => 'Eduardo', 'cargo' => 'Gerente', 'setor' => 'Manutenção'],
];

$menu = [
    ['Histórico', 'relogio', true], //array do menu //aqui
    ['Máquinas e Equipamentos','maquinas', false],
    ['Funcionários', 'pessoas', false],
    ['Ordens de Serviço', 'maleta', false],
    ['Produtos', 'produto', false],
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

    // 2) ícones em arquivo: img/icons/NOME.svg
    $nome    = basename($nome);                                   // segurança: bloqueia "../"
    $caminho = __DIR__ . '/img/icons/' . $nome . '.svg';         // onde o PHP procura no disco
    if (is_file($caminho)) {
        return '<img class="icon" src="img/icons/' . $nome . '.svg" alt="">';  // o que o navegador carrega
    }

    return '';   // ícone inexistente: não quebra a página
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
            <div class = "brand">
                <img src="img/logo-kidzy-vetorizado.svg" alt="Kidzy Brinquedos" class="logo"><!--classe da logo-->
            </div>

            <div class="topbar-right">
                <div class="user"> <!--aqui só botei texto substituir pelo usuário do banco!!!!-->
                    <span class="avatar"></span>
                    <span><strong>teste</strong>oi</span>
                </div>
                <button class="icon-btn" aria-label="Notificações"><?= icon('bell') ?></button>
            </div>
        </header>

    <!--Corpo-->
    <div class="body">
        <nav class = "sidebar"> <!--Parte lateral-->
        <?php foreach ($menu as [$texto, $ico, $ativo]): ?> <!--Aqui puxei o array do menu lá de cima-->
                <a href="#" class="side-item <?= $ativo ? 'active' : '' ?>">
                    <?= icon($ico) ?><span><?= $texto ?></span>
                </a>
            <?php endforeach; ?>
        </nav>
        <main class ="content">
            <div class="content head">
                <h1>Histórico</h1>
                <button class="btn-primary"><?= icon('bell') ?> Novo Registro</button> <!--AQUI-->
            </div>

        <!--Filtros-->
            <form class="filters">
                <label class="search"><?= icon('lupa') ?> <!--AQUI-->
                    <input type="text" placeholder="Buscar por Nome...">
                </label>

                <label class="field"> Setor:
                    <select><option> Produção</option></select>
                </label>

                <label class = "field"> Cargo:
                    <select><option>[Técnico]</option></select>
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
                        <button aria-label="Editar"><?= icon('editar') ?></button> 
                        <button aria-label="Documento"><?= icon('listar') ?></button> 
                        <button aria-label="Histórico"><?= icon('historico') ?></button> 
                    </td>
                </tr>
                <?php endforeach; ?>
            </body>
        </table>
    </main>
</div>
</body>
</html>