<?php

require_once 'conexao.php';
require_once 'ordens_config.php';

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

// Token de segurança (CSRF) usado pelos formulários e modais
if (empty($_SESSION['csrf_token'])) {
    $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
}
$csrf = $_SESSION['csrf_token'];

/* Nome de quem está logado (mostrado no topo). Mesma lógica das outras telas.
   Os nomes de tabela/coluna vêm desta lista fixa, nunca de dados digitados. */
require_once 'resolver_usuario.php';
resolverUsuarioSessao($pdo); // garante usuario_id/usuario_tipo na sessão

$tabelasUsuario = [
    'funcionario'   => ['funcionario',   'nome_funcionario',   'id_funcionario'],
    'administrador' => ['administrador', 'nome_administrador', 'id_administrador'],
    'gerente'       => ['gerente',       'nome_gerente',       'id_gerente'],
];
$nomeUsuario = $_SESSION['nome'] ?? 'Usuário'; // reserva: nome gravado pelo login
$tipoUsuario = $_SESSION['usuario_tipo'] ?? '';
if (isset($tabelasUsuario[$tipoUsuario])) {
    [$tabU, $colNome, $colId] = $tabelasUsuario[$tipoUsuario];
    $stU = $pdo->prepare("SELECT $colNome FROM $tabU WHERE $colId = :id AND ativo_$tabU = 1");
    $stU->execute([':id' => (int) ($_SESSION['usuario_id'] ?? 0)]);
    $nomeUsuario = $stU->fetchColumn() ?: $nomeUsuario;
}

/* Lista as ordens ativas, da mais recente para a mais antiga.
   ordem_de_serviço -> manutencao (tipo e problema) e recebe_maquina_ords -> maquina (qual máquina).
   Inativas continuam no banco, só não aparecem aqui. */
$sql = "SELECT o.id_ords                                  AS id,
               o.datetime_ords                            AS data,
               o.urgencia_ords                            AS urgencia,
               o.nomeresponsavel_ords                     AS responsavel,
               mt.tipo_manutencao                         AS tipo,
               GROUP_CONCAT(m.nome_maquina SEPARATOR ', ') AS maquina
        FROM `ordem_de_serviço` o
        LEFT JOIN manutencao mt         ON mt.id_manutencao = o.`id_manutenção`
        LEFT JOIN recebe_maquina_ords r ON r.id_ords = o.id_ords
        LEFT JOIN maquina m             ON m.id_maquina = r.id_maquina
        WHERE o.ativo_ords = 1
        GROUP BY o.id_ords, o.datetime_ords, o.urgencia_ords, o.nomeresponsavel_ords, mt.tipo_manutencao
        ORDER BY o.datetime_ords DESC, o.id_ords DESC";

$ordens = $pdo->query($sql)->fetchAll();

/* Máquinas ativas: opções do select do modal "Nova Ordem de Serviço" */
$maquinasOrdem = $pdo->query(
    "SELECT id_maquina AS id, nome_maquina AS nome FROM maquina WHERE ativo_maquina = 1 ORDER BY nome_maquina"
)->fetchAll();

/* Classe da etiqueta de urgência (cores já existentes no style.css) */
function classeUrgencia(string $u): string
{
    switch ($u) {
        case 'Baixa': return 'badge-ativo';
        case 'Média': return 'badge-medio';
        default:      return 'badge-inativo'; // Alta / Urgente
    }
}

$paginaAtual = basename($_SERVER['SCRIPT_NAME']); // para marcar o item ativo do menu

$menu = [ //array do menu (igual ao do index.php)
    [
        "nome" => 'Funcionários',
        "arquivo" => 'index.php',
        "icone" => "img/pessoas.svg"
    ],
    [
        "nome" => 'Máq. e Equip.',
        "arquivo" => '../dashboardg/maquinas.php',
        "icone" => "img/maquinas.svg"
    ],
    [
        "nome" => 'Ordens de Serviço',
        "arquivo" => 'ordens.php',
        "icone" => "img/maleta.svg"
    ],
    [
        "nome" => "Histórico",
        "arquivo" => 'historico.php',
        "icone" => "img/historico.svg"
    ],
];

?>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ordens de Serviço</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="page">
            <!--Topo-->
        <header class="topbar">
            <div class = "brand"> <!--classe da logo-->
                <img src="img/kidzy-logo.svg" alt="Kidzy Brinquedos" title="Logomarca" class="logo">
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
                <h1>Ordens de Serviço</h1>
                <button type="button" class="btn-primary" id="btn-nova-ordem" data-abrir-ordem> <!--Abre o modal de nova ordem (js/ordens.js)-->
                    <span class = "icon-plus">
                        <img src="img/plus.svg" alt="+" class="plus">
                    </span>
                    <span>Nova Ordem</span>
                </button>
            </div>

        <!--Filtros (js/filtros-lista.js)-->
            <form class="filters" method="get">
                <label class="search">
                    <img src="img/lupa.svg" alt="lupa" class="lupa">
                    <input type="text" id="filtro-nome" placeholder="Buscar por Máquina..." autocomplete="off" aria-label="Buscar por máquina">
                </label>

                <label class="field"> Manutenção:
                    <select name="tipo" id="filtro-tipo" data-filtro="tipo">
                        <option value="">Todas</option>
                        <?php foreach (TIPOS_MANUTENCAO as $t): ?>
                        <option value="<?= htmlspecialchars($t) ?>"><?= htmlspecialchars($t) ?></option>
                        <?php endforeach; ?>
                    </select>
                </label>

                <label class="field"> Urgência:
                    <select name="urgencia" id="filtro-urgencia" data-filtro="urgencia">
                        <option value="">Todas</option>
                        <?php foreach (URGENCIAS as $u): ?>
                        <option value="<?= htmlspecialchars($u) ?>"><?= htmlspecialchars($u) ?></option>
                        <?php endforeach; ?>
                    </select>
                </label>
            </form>

        <!--Tabela-->
            <div class="table-card">
                <table class="tabela-ordens">
                    <thead>
                        <tr><th>Máquina</th><th>Manutenção</th><th>Urgência</th><th>Abertura</th><th class="center">Ações</th></tr>
                    </thead>
                    <tbody>
                        <tr id="sem-resultados" <?= $ordens ? 'hidden' : '' ?>>
                            <td colspan="5" class="center">Nenhum registro encontrado.</td>
                        </tr>
                        <?php foreach ($ordens as $o): ?>
                        <tr data-filtravel
                            data-tipo="<?= htmlspecialchars((string) ($o['tipo'] ?? '')) ?>"
                            data-urgencia="<?= htmlspecialchars((string) $o['urgencia']) ?>">
                            <td class="col-nome"><?= htmlspecialchars($o['maquina'] ?? '-') ?></td>
                            <td class="col-tipo"><?= htmlspecialchars($o['tipo'] ?? '-') ?></td>
                            <td class="col-urgencia">
                                <span class="badge <?= classeUrgencia((string) $o['urgencia']) ?>"><?= htmlspecialchars($o['urgencia']) ?></span>
                            </td>
                            <td class="col-data"><?= htmlspecialchars(date('d/m/Y H:i', strtotime($o['data']))) ?></td>
                            <td class="actions">
                                <!--Abre o modal com todas as informações da ordem (dados buscados em detalhes_ordem.php)-->
                                <button type="button" class="btn-detalhes" aria-label="Detalhes" title="Detalhes"
                                    data-id="<?= (int) $o['id'] ?>">
                                    <img src="img/listar.svg" alt="detalhes" class="listar">
                                </button>

                                <!--Inativar = exclusão lógica (ativo_ords = 0). Os dados continuam no banco-->
                                <button type="button" class="btn-inativar" aria-label="Inativar" title="Inativar"
                                    data-id="<?= (int) $o['id'] ?>"
                                    data-tipo="ordem"
                                    data-nome="<?= htmlspecialchars('a ordem nº ' . (int) $o['id'] . ' (' . ($o['maquina'] ?? 'sem máquina') . ')') ?>">
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

<?php include 'modal_ordem.php'; ?>

<!--Modal de detalhes da ordem (js/ordens.js)-->
<div class="modal" id="modal-os-detalhes" role="dialog" aria-modal="true" aria-labelledby="os-detalhes-titulo" hidden>
    <div class="modal-card largo">
        <div class="modal-head">
            <h2 id="os-detalhes-titulo">Detalhes da Ordem</h2>
            <button type="button" class="modal-close" data-fechar aria-label="Fechar">&times;</button>
        </div>

        <div class="modal-body">
            <input type="hidden" id="os-detalhes-csrf" value="<?= htmlspecialchars($csrf) ?>">

            <p class="detalhes-carregando" id="os-detalhes-carregando">Carregando...</p>
            <p class="modal-erro" id="os-detalhes-erro" role="alert" hidden></p>

            <div id="os-detalhes-conteudo" class="detalhes-conteudo" hidden>
                <div class="detalhes-topo">
                    <h3 class="detalhes-nome" id="os-detalhes-nome"></h3>
                    <span id="os-detalhes-urgencia" class="badge"></span>
                </div>

                <dl class="detalhes-grid" id="os-detalhes-grid"></dl>

                <section class="detalhes-secao">
                    <h3>Aberta por</h3>
                    <ul class="detalhes-lista" id="os-detalhes-solicitantes"></ul>
                </section>
            </div>
        </div>

        <div class="modal-foot">
            <button type="button" class="btn-secondary" data-fechar>Fechar</button>
        </div>
    </div>
</div>

<!--Modal de confirmação para inativar (js/inativar.js)-->
<div class="modal" id="modal-inativar" role="dialog" aria-modal="true" aria-labelledby="inativar-titulo" hidden>
    <div class="modal-card pequeno">
        <div class="modal-head">
            <h2 id="inativar-titulo">Inativar Registro</h2>
            <button type="button" class="modal-close" data-fechar aria-label="Fechar">&times;</button>
        </div>

        <div class="modal-body">
            <input type="hidden" id="inativar-csrf" value="<?= htmlspecialchars($csrf) ?>">

            <p class="modal-erro" id="inativar-erro" role="alert" hidden></p>

            <p class="confirmar-texto">
                Deseja inativar <strong id="inativar-nome"></strong>?
            </p>
            <p class="confirmar-aviso">
                O registro deixará de aparecer na lista, mas todos os dados dele continuam guardados no banco.
            </p>
        </div>

        <div class="modal-foot">
            <button type="button" class="btn-secondary" data-fechar>Cancelar</button>
            <button type="button" class="btn-primary" id="inativar-confirmar">Inativar</button>
        </div>
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
<script src="js/inativar.js"></script>
<script src="js/conta.js"></script>
<script src="js/filtros-lista.js"></script>
<script src="js/ordens.js"></script>
</body>
</html>