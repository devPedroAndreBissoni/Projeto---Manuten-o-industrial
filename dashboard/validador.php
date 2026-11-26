<?php
/*
 * documento.php
 * GUARDA DE ACESSO: só deixa a página (ou ação) continuar se a pessoa entrou pelo LOGIN.
 * Quem cola o link direto, sem ter feito login, é barrado.
 *
 * Como usar: é a PRIMEIRA linha de cada página e de cada arquivo de ação (já feito):
 *     require_once 'documento.php';
 * O mesmo arquivo serve para dashboard, dashboardg e dashboardf, sem editar nada:
 * ele descobre o perfil exigido pelo NOME DA PASTA onde está.
 *
 * O que ele confere, nesta ordem:
 *   1) Existe sessão de login (conectar.php grava usuario_id, usuario_tipo e cargo)?
 *   2) O perfil da sessão é o desta pasta? (um gerente não abre o link do administrador)
 *   3) A conta ainda existe e está ativa no banco? (se foi inativada com a pessoa logada, perde o acesso)
 * Falhou em qualquer um: página -> volta para a tela de login; ação (fetch/JSON) -> responde 401/403 em JSON.
 */

require_once 'conexao.php'; // fornece $pdo

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

/* Impede o navegador de guardar a página: depois do "Sair", o botão Voltar não mostra a tela antiga */
header('Cache-Control: no-store, no-cache, must-revalidate, max-age=0');
header('Pragma: no-cache');

function documento_validar(PDO $pdo): void
{
    /* Caminho da tela de login a partir desta pasta (o mesmo do sair.php) */
    $urlLogin = '../tela_login/index.php';

    /* Pasta => perfil (cargo gravado pelo conectar.php) que pode usar aquela pasta */
    $perfilDaPasta = [
        'dashboard'  => 'administrador',
        'dashboardg' => 'gerente',
        'dashboardf' => 'funcionario',
    ];

    /* Perfil => pasta (para mandar a pessoa de volta ao painel dela) */
    $pastaDoPerfil = array_flip($perfilDaPasta);

    /* Tipo da sessão (tabela onde a pessoa foi achada no login) => tabela, coluna id, coluna ativo.
       Lista FIXA: nada digitado entra no SQL. */
    $tabelas = [
        'funcionario'   => ['funcionario',   'id_funcionario',   'ativo_funcionario'],
        'administrador' => ['administrador', 'id_administrador', 'ativo_administrador'],
        'gerente'       => ['gerente',       'id_gerente',       'ativo_gerente'],
    ];

    /* Navegação normal do navegador (GET pedindo HTML) é redirecionada;
       qualquer outra coisa (fetch, POST) recebe JSON, porque o JS não sabe seguir um redirecionamento. */
    $ehPagina = ($_SERVER['REQUEST_METHOD'] ?? 'GET') === 'GET'
        && stripos($_SERVER['HTTP_ACCEPT'] ?? '', 'text/html') !== false;

    $negar = function (int $status, string $mensagem, string $destino) use ($ehPagina): void {
        if ($ehPagina) {
            header('Location: ' . $destino);
        } else {
            http_response_code($status);
            header('Content-Type: application/json; charset=utf-8');
            echo json_encode(['ok' => false, 'mensagem' => $mensagem], JSON_UNESCAPED_UNICODE);
        }
        exit;
    };

    $encerrarSessao = function (): void {
        $_SESSION = [];
        if (ini_get('session.use_cookies')) {
            $p = session_get_cookie_params();
            setcookie(session_name(), '', time() - 42000, $p['path'], $p['domain'], $p['secure'], $p['httponly']);
        }
        session_destroy();
    };

    /* 1) Tem login? */
    $id    = (int) ($_SESSION['usuario_id'] ?? 0);
    $tipo  = (string) ($_SESSION['usuario_tipo'] ?? '');
    $cargo = (string) ($_SESSION['cargo'] ?? '');

    if ($id <= 0 || !isset($tabelas[$tipo]) || $cargo === '') {
        $negar(401, 'Você precisa fazer login.', $urlLogin);
    }

    /* 2) O perfil da sessão é o desta pasta? */
    $pasta = basename(__DIR__);
    if (isset($perfilDaPasta[$pasta]) && $cargo !== $perfilDaPasta[$pasta]) {
        $meuPainel = isset($pastaDoPerfil[$cargo]) ? '../' . $pastaDoPerfil[$cargo] . '/index.php' : $urlLogin;
        $negar(403, 'Você não tem permissão para acessar esta área.', $meuPainel);
    }

    /* 3) A conta ainda existe e está ativa? */
    [$tabela, $colId, $colAtivo] = $tabelas[$tipo];
    try {
        $q = $pdo->prepare("SELECT $colAtivo FROM $tabela WHERE $colId = :id");
        $q->execute([':id' => $id]);
        $ativo = $q->fetchColumn();
    } catch (PDOException $e) {
        error_log('Erro no documento.php: ' . $e->getMessage());
        $negar(500, 'Erro ao validar o acesso.', $urlLogin);
    }

    if ($ativo === false || (int) $ativo !== 1) {
        $encerrarSessao();
        $negar(401, 'Conta não encontrada ou inativa.', $urlLogin);
    }
}

documento_validar($pdo);