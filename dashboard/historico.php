<?php

require_once 'conexao.php';

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

// Token de segurança (CSRF) usado pelos formulários e modais
if (empty($_SESSION['csrf_token'])) {
    $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
}
$csrf = $_SESSION['csrf_token'];

/* Nome de quem está logado (mostrado no topo). Mesma lógica do index.php.
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

/* ===== CONSULTA DO HISTÓRICO =====
   Junta as 5 tabelas (funcionario, gerente, administrador, maquina, produto) em uma lista só.
   Diferente das outras páginas, aqui NÃO existe "WHERE ativo = 1": o histórico mostra
   tudo, ativos e inativos. A coluna "ativo" (1 ou 0) diz qual é qual.

   No UNION ALL todos os SELECTs precisam ter as MESMAS colunas, na MESMA ordem.
   Por isso o que não existe em uma tabela vai como NULL.
   Colunas: id, tipo, nome, email, telefone, id_cargo, id_setor, descricao, setor, ativo,
            funcionamento, id_categoria, estoque, producao */
$sql = "SELECT f.id_funcionario       AS id,
               'funcionario'          AS tipo,
               f.nome_funcionario     AS nome,
               f.email_funcionario    AS email,
               f.telefone_funcionario AS telefone,
               f.id_cargo             AS id_cargo,
               f.id_setor             AS id_setor,
               c.nome_cargo           AS descricao, /*Cargo/Modelo/Tipo: aqui é o cargo*/
               s.nome_setor           AS setor,
               f.ativo_funcionario    AS ativo,
               NULL                   AS funcionamento,
               NULL                   AS id_categoria,
               NULL                   AS estoque,
               NULL                   AS producao
        FROM funcionario f
        INNER JOIN cargo c ON c.id_cargo = f.id_cargo
        INNER JOIN setor s ON s.id_setor = f.id_setor

        UNION ALL

        SELECT g.id_gerente, 'gerente', g.nome_gerente,
               g.email_gerente, g.telefone_gerente,
               NULL, NULL, 'Gerente', 'Geral', g.ativo_gerente,
               NULL, NULL, NULL, NULL
        FROM gerente g

        UNION ALL

        SELECT a.id_administrador, 'administrador', a.nome_administrador,
               a.email_administrador, a.telefone_administrador,
               NULL, NULL, 'Administrador', 'Geral', a.ativo_administrador,
               NULL, NULL, NULL, NULL
        FROM administrador a

        UNION ALL

        SELECT m.id_maquina, 'maquina', m.nome_maquina,
               NULL, NULL,
               NULL, NULL, m.tipo_maquina, NULL, m.ativo_maquina, /*Cargo/Modelo/Tipo: aqui é o modelo*/
               m.funcionamento_maquina, NULL, NULL, NULL
        FROM maquina m

        UNION ALL

        SELECT p.id_produto, 'produto', p.nome_produto,
               NULL, NULL,
               NULL, NULL, ct.tipo_categoria, NULL, p.ativo_produto, /*Cargo/Modelo/Tipo: aqui é o tipo (categoria)*/
               NULL, p.id_categoria, p.estoque_produto, p.data_producao
        FROM produto p
        INNER JOIN categoria ct ON ct.id_categoria = p.id_categoria

        ORDER BY nome";

$registros = $pdo->query($sql)->fetchAll();

/* Setores e cargos: só para preencher os selects do modal de edição (igual ao index.php) */
$setores = $pdo->query("SELECT id_setor, nome_setor FROM setor")->fetchAll();
$cargo   = $pdo->query("SELECT id_cargo, nome_cargo, tipo_cargo FROM cargo")->fetchAll();

/* Rótulos do filtro "Registro". A chave é o valor da coluna "tipo" da consulta. */
$origens = [
    'funcionario'   => 'Funcionário',
    'gerente'       => 'Gerente',
    'administrador' => 'Administrador',
    'maquina'       => 'Máquina',
    'produto'       => 'Produto',
];

$paginaAtual = basename($_SERVER['SCRIPT_NAME']); // para marcar o item ativo do menu

$menu = [ //array do menu (igual ao do index.php)
    [
        "nome" => 'Funcionários',
        "arquivo" => 'index.php',
        "icone" => "img/pessoas.svg"
    ],
    [
        "nome" => 'Produtos',
        "arquivo" => 'produtos.php',
        "icone" => "img/caixa.svg"
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
    <title>Histórico</title>
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
                <h1>Histórico</h1>
                <!--Sem botão "Novo Registro": o histórico só consulta e reativa/inativa, não cadastra-->
            </div>

        <!--Filtros (js/filtros-lista.js)-->
            <form class="filters" method="get">
                <label class="search">
                    <img src="img/lupa.svg" alt="lupa" class="lupa">
                    <input type="text" id="filtro-nome" placeholder="Buscar por Nome..." autocomplete="off" aria-label="Buscar por nome">
                </label>

                <label class="field"> Registro:
                    <select name="origem" id="filtro-origem" data-filtro="origem">
                        <option value="">Todos</option>
                        <?php foreach ($origens as $valor => $rotulo): ?>
                        <option value="<?= htmlspecialchars($valor) ?>"><?= htmlspecialchars($rotulo) ?></option>
                        <?php endforeach; ?>
                    </select>
                </label>

                <label class="field"> Status:
                    <select name="status" id="filtro-status" data-filtro="status">
                        <option value="">Todos</option>
                        <option value="ativo">Ativo</option>
                        <option value="inativo">Inativo</option>
                    </select>
                </label>
            </form>

        <!--Tabela-->
            <div class="table-card">
                <table>
                    <thead>
                        <tr><th>Nome</th><th>Cargo/Modelo/Tipo</th><th>Status</th><th class="center">Ações</th></tr>
                    </thead>
                    <tbody>
                        <tr id="sem-resultados" hidden>
                            <td colspan="4" class="center">Nenhum registro encontrado.</td>
                        </tr>
                        <?php foreach ($registros as $f): ?>
                        <?php $estaAtivo = ((int) $f['ativo'] === 1); ?>
                        <tr data-filtravel
                            data-origem="<?= htmlspecialchars($f['tipo']) ?>"
                            data-status="<?= $estaAtivo ? 'ativo' : 'inativo' ?>">
                            <td class="col-nome"><?= htmlspecialchars($f['nome']) ?></td>
                            <td class="col-cargo"><?= htmlspecialchars($f['descricao'] ?? '-') ?></td>
                            <td class="col-status">
                                <span class="badge <?= $estaAtivo ? 'badge-ativo' : 'badge-inativo' ?>">
                                    <?= $estaAtivo ? 'Ativo' : 'Inativo' ?>
                                </span>
                            </td>
                            <td class="actions">
                                <!--Os botões abaixo são os mesmos do index.php. Os data-* levam os dados da linha para o modal-->
                                <button type="button" class="btn-editar" aria-label="Editar" title="Editar"
                                    data-id="<?= (int) $f['id'] ?>"
                                    data-tipo="<?= htmlspecialchars($f['tipo']) ?>"
                                    data-nome="<?= htmlspecialchars($f['nome']) ?>"
                                    data-email="<?= htmlspecialchars($f['email'] ?? '') ?>"
                                    data-telefone="<?= htmlspecialchars($f['telefone'] ?? '') ?>"
                                    data-cargo="<?= htmlspecialchars((string) ($f['id_cargo'] ?? '')) ?>"
                                    data-setor="<?= htmlspecialchars((string) ($f['id_setor'] ?? '')) ?>"
                                    data-modelo="<?= htmlspecialchars($f['tipo'] === 'maquina' ? (string) $f['descricao'] : '') ?>"
                                    data-funcionamento="<?= htmlspecialchars((string) ($f['funcionamento'] ?? '')) ?>"
                                    data-categoria="<?= htmlspecialchars((string) ($f['id_categoria'] ?? '')) ?>"
                                    data-estoque="<?= htmlspecialchars((string) ($f['estoque'] ?? '')) ?>"
                                    data-producao="<?= htmlspecialchars((string) ($f['producao'] ?? '')) ?>">
                                    <img src="img/editar.svg" alt="editar" class="edit">
                                </button>

                                <!--Abre o modal com todas as informações do registro (dados buscados em detalhes.php)-->
                                <button type="button" class="btn-detalhes" aria-label="Detalhes" title = "Detalhes"
                                    data-id="<?= (int) $f['id'] ?>"
                                    data-tipo="<?= htmlspecialchars($f['tipo']) ?>">
                                    <img src="img/listar.svg" alt="detalhes" class="listar">
                                </button>

                                <?php if ($estaAtivo): ?>
                                <!--Inativar = exclusão lógica (ativo = 0). Os dados continuam no banco-->
                                <button type="button" class="btn-inativar" aria-label="Inativar" title = "Inativar"
                                    data-id="<?= (int) $f['id'] ?>"
                                    data-tipo="<?= htmlspecialchars($f['tipo']) ?>"
                                    data-nome="<?= htmlspecialchars($f['nome']) ?>">
                                    <img src="img/lixo.svg" alt="desativar" class="inativar">
                                </button>
                                <?php else: ?>
                                <!--Ativar = desfaz a inativação (ativo = 1). Só aparece para registros inativos-->
                                <button type="button" class="btn-ativar" aria-label="Ativar" title = "Ativar"
                                    data-id="<?= (int) $f['id'] ?>"
                                    data-tipo="<?= htmlspecialchars($f['tipo']) ?>"
                                    data-nome="<?= htmlspecialchars($f['nome']) ?>">
                                    <img src="img/ativar.svg" alt="ativar" class="ativar">
                                </button>
                                <?php endif; ?>
                            </td>
                        </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>
            </div>
        </main>
    </div>
</div>

<!--Modal de edição (copiado do index.php)-->
<div class="modal" id="modal-editar" role="dialog" aria-modal="true" aria-labelledby="editar-titulo" hidden>
    <div class="modal-card">
        <div class="modal-head">
            <h2 id="editar-titulo">Editar Registro</h2>
            <button type="button" class="modal-close" data-fechar aria-label="Fechar">&times;</button>
        </div>

        <form id="form-editar" autocomplete="off">
            <div class="modal-body">
                <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($csrf) ?>">
                <input type="hidden" name="tipo">
                <input type="hidden" name="id">

                <p class="modal-erro" id="editar-erro" role="alert" hidden></p>

                <label class="field"> Nome:
                    <input type="text" name="nome" required minlength="3" maxlength="100">
                </label>

                <label class="field"> E-mail:
                    <input type="email" name="email" required maxlength="100">
                </label>

                <label class="field"> Telefone:
                    <input type="text" name="telefone" required inputmode="tel" maxlength="15" placeholder="(41) 99999-0000">
                </label>

                <!--Só aparecem para funcionários (administrador tem cargo/setor fixos)-->
                <label class="field campo-funcionario"> Setor:
                    <select name="id_setor" required>
                        <?php foreach ($setores as $s): ?>
                        <option value="<?= $s['id_setor'] ?>"><?= htmlspecialchars($s['nome_setor']) ?></option>
                        <?php endforeach; ?>
                    </select>
                </label>

                <label class="field campo-funcionario"> Cargo:
                    <select name="id_cargo" required>
                        <?php foreach ($cargo as $c): ?>
                        <option value="<?= $c['id_cargo'] ?>"><?= htmlspecialchars($c['nome_cargo']) ?></option>
                        <?php endforeach; ?>
                    </select>
                </label>
            </div>

            <div class="modal-foot">
                <button type="button" class="btn-secondary" data-fechar>Cancelar</button>
                <button type="submit" class="btn-primary" id="editar-salvar">Salvar</button>
            </div>
        </form>
    </div>
</div>

<!--Modal de detalhes (copiado do index.php)-->
<div class="modal" id="modal-detalhes" role="dialog" aria-modal="true" aria-labelledby="detalhes-titulo" hidden>
    <div class="modal-card largo">
        <div class="modal-head">
            <h2 id="detalhes-titulo">Detalhes</h2>
            <button type="button" class="modal-close" data-fechar aria-label="Fechar">&times;</button>
        </div>

        <div class="modal-body">
            <input type="hidden" id="detalhes-csrf" value="<?= htmlspecialchars($csrf) ?>">

            <p class="detalhes-carregando" id="detalhes-carregando">Carregando...</p>
            <p class="modal-erro" id="detalhes-erro" role="alert" hidden></p>

            <div id="detalhes-conteudo" class="detalhes-conteudo" hidden>
                <div class="detalhes-topo">
                    <h3 class="detalhes-nome" id="detalhes-nome"></h3>
                    <span id="detalhes-status" class="badge"></span>
                </div>

                <dl class="detalhes-grid" id="detalhes-grid"></dl>

                <section class="detalhes-secao" id="detalhes-resp-secao">
                    <h3>Responsáveis</h3>
                    <ul class="detalhes-lista" id="detalhes-resp"></ul>
                </section>

                <section class="detalhes-secao">
                    <h3>Ordens de serviço</h3>
                    <ul class="detalhes-lista" id="detalhes-os"></ul>
                </section>
            </div>
        </div>

        <div class="modal-foot">
            <button type="button" class="btn-secondary" data-fechar>Fechar</button>
        </div>
    </div>
</div>

<!--Modal de confirmação para inativar (copiado do index.php, texto genérico para qualquer tipo de registro)-->
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
                O registro deixará de aparecer nas listas, mas todos os dados dele continuam guardados no banco.
            </p>
        </div>

        <div class="modal-foot">
            <button type="button" class="btn-secondary" data-fechar>Cancelar</button>
            <button type="button" class="btn-primary" id="inativar-confirmar">Inativar</button>
        </div>
    </div>
</div>

<!--Modal de confirmação para ativar (novo: espelho do modal de inativar)-->
<div class="modal" id="modal-ativar" role="dialog" aria-modal="true" aria-labelledby="ativar-titulo" hidden>
    <div class="modal-card pequeno">
        <div class="modal-head">
            <h2 id="ativar-titulo">Ativar Registro</h2>
            <button type="button" class="modal-close" data-fechar aria-label="Fechar">&times;</button>
        </div>

        <div class="modal-body">
            <input type="hidden" id="ativar-csrf" value="<?= htmlspecialchars($csrf) ?>">

            <p class="modal-erro" id="ativar-erro" role="alert" hidden></p>

            <p class="confirmar-texto">
                Deseja ativar <strong id="ativar-nome"></strong>?
            </p>
            <p class="confirmar-aviso">
                O registro volta a aparecer nas listas normalmente.
            </p>
        </div>

        <div class="modal-foot">
            <button type="button" class="btn-secondary" data-fechar>Cancelar</button>
            <button type="button" class="btn-primary" id="ativar-confirmar">Ativar</button>
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
<script src="js/editar.js"></script>
<script src="js/detalhes.js"></script>
<script src="js/historico-status.js"></script>
<script src="js/conta.js"></script>
<script src="js/filtros-lista.js"></script>
</body>
</html>
