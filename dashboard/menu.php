<?php
// menu.php
$paginaAtual = basename($_SERVER['SCRIPT_NAME']);

$menu = [
    ["nome" => 'Funcionários',      "arquivo" => 'index.php',                   "icone" => "img/pessoas.svg"],
    ["nome" => 'Histórico',         "arquivo" => 'historico.php',               "icone" => "img/historico.svg"],
    ["nome" => 'Máq. e Equip.',     "arquivo" => 'maquinas.php', "icone" => "img/maquinas.svg"],
    ["nome" => 'Ordens de Serviço', "arquivo" => 'ordens.php',       "icone" => "img/maleta.svg"],
    ["nome" => 'Produtos',          "arquivo" => 'produtos.php',                "icone" => "img/caixa.svg"],
];
?>
<nav class="sidebar">
    <?php foreach ($menu as $item): ?>
        <?php $ativo = ($item['arquivo'] === $paginaAtual) ? 'active' : ''; ?>
        <a href="<?= htmlspecialchars($item['arquivo']) ?>" class="side-item <?= $ativo ?>">
            <img src="<?= htmlspecialchars($item['icone']) ?>" alt="">
            <span><?= htmlspecialchars($item['nome']) ?></span>
        </a>
    <?php endforeach; ?>
</nav>