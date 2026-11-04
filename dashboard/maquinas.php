<?php

require_once 'conexao.php';

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

// Token de segurança (CSRF) usado pelos formulários (ex.: "Minha conta")
if (empty($_SESSION['csrf_token'])) {
    $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
}
$csrf = $_SESSION['csrf_token'];

/* Nome de quem está logado (mostrado no topo). Mesma lógica do index.php.
   A sessão (usuario_id / usuario_tipo) é gravada pelo login; o bloco temporário que
   simula o login continua só no index.php e deve ser apagado de lá quando o login existir.
   Os nomes de tabela/coluna vêm desta lista fixa, nunca de dados digitados. */
$tabelasUsuario = [
    'funcionario'   => ['funcionario',   'nome_funcionario',   'id_funcionario'],
    'administrador' => ['administrador', 'nome_administrador', 'id_administrador'],
    'gerente'       => ['gerente',       'nome_gerente',       'id_gerente'],
];
$nomeUsuario = 'Usuário';
$tipoUsuario = $_SESSION['usuario_tipo'] ?? '';
if (isset($tabelasUsuario[$tipoUsuario])) {
    [$tabU, $colNome, $colId] = $tabelasUsuario[$tipoUsuario];
    $stU = $pdo->prepare("SELECT $colNome FROM $tabU WHERE $colId = :id AND ativo_$tabU = 1");
    $stU->execute([':id' => (int) ($_SESSION['usuario_id'] ?? 0)]);
    $nomeUsuario = $stU->fetchColumn() ?: $nomeUsuario;
}

/* Também traz o id (usado pelos botões de ação) e só lista as máquinas ativas.
   Inativas continuam no banco, só não aparecem aqui. */
$sql = "SELECT m.id_maquina             AS id,
               m.nome_maquina           AS nome,
               m.tipo_maquina           AS maquina,
               m.funcionamento_maquina  AS funcionamento
        FROM maquina m
        WHERE m.ativo_maquina = 1
        ORDER BY m.nome_maquina";

$maquinas = $pdo->query($sql)->fetchAll();

/* Opções dos filtros vêm do banco, para existirem só valores que realmente existem */
$tipos  = $pdo->query("SELECT DISTINCT tipo_maquina FROM maquina WHERE ativo_maquina = 1 ORDER BY tipo_maquina")->fetchAll(PDO::FETCH_COLUMN);
$status = $pdo->query("SELECT DISTINCT funcionamento_maquina FROM maquina WHERE ativo_maquina = 1 ORDER BY funcionamento_maquina")->fetchAll(PDO::FETCH_COLUMN);

$paginaAtual = basename($_SERVER['SCRIPT_NAME']); // para marcar o item ativo do menu

$menu = [ //array do menu (igual ao do index.php)
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
                <div class="user">
                    <span class="avatar"></span>
                    <span><strong><?= htmlspecialchars($nomeUsuario) ?></strong></span>
                </div>
                <button class="btn-login" type="button" data-action="login"> <!--Ícone do login/Usuário-->
                    <span class="icon-circle" aria-hidden="true">
                        <span class="icon-user"></span>
                    </span>
                </button>
                <button class="icon-btn" aria-label="Notificações">
                    <img src="img/sino.svg" alt="sininho">
                </button>
                <button type="button" class="icon-btn" id="btn-conta" aria-label="Configurações da conta">
                    <img src="img/engrenagem.svg" alt="Config">
                </button>
            </div>
        </header>

    <!--Corpo-->
    <div class="body">
    <nav class="sidebar">
    <?php foreach ($menu as $item): ?> <!--Parte que faz o menu ser verificado como ativo-->
        <?php $ativo = (basename($item['arquivo']) === $paginaAtual) ? 'active' : ''; ?>
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
                <h1>Máquinas e Equipamentos</h1>
                <button type="button" class="btn-primary" id="btn-novo">
                    <span class = "icon-plus">
                        <img src="img/plus.svg" alt="+" class="plus">
                    </span>
                    <span>Novo Registro</span>
                </button>
            </div>

        <!--Filtros (js/filtros-lista.js)-->
            <form class="filters" method="get">
                <label class="search">
                    <img src="img/lupa.svg" alt="lupa" class="lupa">
                    <input type="text" id="filtro-nome" placeholder="Buscar por Nome..." autocomplete="off" aria-label="Buscar por nome">
                </label>

                <label class="field"> Modelo:
                    <select name="tipo" id="filtro-tipo" data-filtro="tipo">
                        <option value="">Todos</option>
                        <?php foreach ($tipos as $t): ?>
                        <option value="<?= htmlspecialchars($t) ?>"><?= htmlspecialchars($t) ?></option>
                        <?php endforeach; ?>
                    </select>
                </label>

                <label class = "field"> Status:
                    <select name="status" id="filtro-status" data-filtro="funcionamento">
                        <option value="">Todos</option>
                        <?php foreach ($status as $s): ?>
                        <option value="<?= htmlspecialchars($s) ?>"><?= htmlspecialchars($s) ?></option>
                        <?php endforeach; ?>
                    </select>
                </label>
            </form>

        <!--Tabela-->
            <div class="table-card">
                <table>
                    <thead>
                        <tr><th>Código</th><th>Equipamento/Modelo</th><th>Status</th><th class="center">Ações</th></tr>
                    </thead>
                    <tbody>
                        <tr id="sem-resultados" hidden>
                            <td colspan="4" class="center">Nenhum registro encontrado.</td>
                        </tr>
                        <?php foreach ($maquinas as $m): ?>
                        <tr data-filtravel
                            data-tipo="<?= htmlspecialchars((string) ($m['maquina'] ?? '')) ?>"
                            data-funcionamento="<?= htmlspecialchars((string) ($m['funcionamento'] ?? '')) ?>">
                            <td class="col-nome"><?= htmlspecialchars($m['nome']) ?></td>
                            <td class="col-tipo"><?= htmlspecialchars($m['maquina'] ?? '-') ?></td>
                            <td class="col-status"><?= htmlspecialchars($m['funcionamento'] ?? '-') ?></td>
                            <td class="actions">
                                <button type="button" class="btn-editar" aria-label="Editar" title="Editar"
                                    data-id="<?= (int) $m['id'] ?>"
                                    data-nome="<?= htmlspecialchars($m['nome']) ?>"
                                    data-tipo="<?= htmlspecialchars((string) ($m['maquina'] ?? '')) ?>"
                                    data-funcionamento="<?= htmlspecialchars((string) ($m['funcionamento'] ?? '')) ?>">
                                    <img src="img/editar.svg" alt="editar" class="edit">
                                </button>

                                <button type="button" class="btn-manutencao" aria-label="Manutenção" title="Manutenção"
                                    data-id="<?= (int) $m['id'] ?>">
                                    <img src="img/chave.svg" alt="chave" class="chave">
                                </button>

                                <button type="button" class="btn-detalhes" aria-label="Detalhes" title="Detalhes"
                                    data-id="<?= (int) $m['id'] ?>">
                                    <img src="img/listar.svg" alt="detalhes" class="listar">
                                </button>

                                <button type="button" class="btn-historico" aria-label="Histórico" title="Histórico"
                                    data-id="<?= (int) $m['id'] ?>">
                                    <img src="img/relogio.svg" alt="relogio" class="relogio">
                                </button>

                                <!--Inativar = exclusão lógica (ativo = 0). Os dados continuam no banco-->
                                <button type="button" class="btn-inativar" aria-label="Inativar" title="Inativar"
                                    data-id="<?= (int) $m['id'] ?>"
                                    data-nome="<?= htmlspecialchars($m['nome']) ?>">
                                    <img src="img/lixo.svg" alt="desativar" class="inativar">
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

<!--Modal "Minha conta" (engrenagem) - igual ao do index.php, usado pelo js/conta.js-->
<div class="modal" id="modal-conta" role="dialog" aria-modal="true" aria-labelledby="conta-titulo" hidden>
    <div class="modal-card largo">
        <div class="modal-head">
            <h2 id="conta-titulo">Minha conta</h2>
            <button type="button" class="modal-close" data-fechar aria-label="Fechar">&times;</button>
        </div>

        <div class="modal-body">
            <p class="detalhes-carregando" id="conta-carregando">Carregando...</p>
            <p class="modal-erro" id="conta-erro" role="alert" hidden></p>

            <div id="conta-conteudo" class="detalhes-conteudo" hidden>
                <div class="detalhes-topo">
                    <h3 class="detalhes-nome" id="conta-nome"></h3>
                    <span id="conta-status" class="badge"></span>
                </div>

                <dl class="detalhes-grid" id="conta-grid"></dl>

                <!--Alterar e-mail e telefone-->
                <section class="detalhes-secao">
                    <h3>Alterar contato</h3>
                    <form id="form-conta-dados" class="conta-form" autocomplete="off">
                        <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($csrf) ?>">
                        <input type="hidden" name="acao" value="salvar">

                        <p class="modal-erro" id="conta-dados-erro" role="alert" hidden></p>

                        <div class="linha-2">
                            <label class="field"> E-mail:
                                <input type="email" name="email" required maxlength="100">
                            </label>
                            <label class="field"> Telefone:
                                <input type="text" name="telefone" required inputmode="tel" maxlength="15" placeholder="(41) 99999-0000">
                            </label>
                        </div>

                        <div class="conta-acoes">
                            <button type="submit" class="btn-primary" id="conta-dados-salvar">Salvar dados</button>
                        </div>
                    </form>
                </section>

                <!--Alterar senha-->
                <section class="detalhes-secao">
                    <h3>Alterar senha</h3>
                    <form id="form-conta-senha" class="conta-form" autocomplete="off">
                        <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($csrf) ?>">
                        <input type="hidden" name="acao" value="senha">

                        <p class="modal-erro" id="conta-senha-erro" role="alert" hidden></p>

                        <label class="field"> Senha atual:
                            <input type="password" name="senha_atual" required maxlength="72" autocomplete="current-password">
                        </label>

                        <div class="linha-2">
                            <label class="field"> Nova senha:
                                <input type="password" name="nova_senha" required minlength="8" maxlength="72" autocomplete="new-password">
                            </label>
                            <label class="field"> Confirmar nova senha:
                                <input type="password" name="confirmar_senha" required minlength="8" maxlength="72" autocomplete="new-password">
                            </label>
                        </div>

                        <label class="check">
                            <input type="checkbox" id="conta-mostrar-senha"> Mostrar senha
                        </label>
                        <p class="campo-dica">A senha deve ter de 8 a 72 caracteres.</p>

                        <div class="conta-acoes">
                            <button type="submit" class="btn-primary" id="conta-senha-salvar">Alterar senha</button>
                        </div>
                    </form>
                </section>
            </div>
        </div>

        <div class="modal-foot">
            <!--Sair: encerra a sessão em sair.php e volta para tela_login/index.php-->
            <form class="form-sair" method="post" action="sair.php">
                <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($csrf) ?>">
                <button type="submit" class="btn-primary" id="conta-sair">Sair</button>
            </form>
            <button type="button" class="btn-secondary" data-fechar>Fechar</button>
        </div>
    </div>
</div>

<script src="js/menu.js"></script>
<script src="js/conta.js"></script>
<script src="js/filtros-lista.js"></script>
</body>
</html>