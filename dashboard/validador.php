<?php
/*
 * validador.php
 * GUARDA DE ACESSO: só deixa a página (ou ação) continuar se a pessoa entrou pelo LOGIN
 * e se o CARGO DELA NO BANCO é o da pasta. Quem cola o link direto é barrado.
 *
 * Como usar: é a PRIMEIRA linha de cada página e de cada arquivo de ação:
 *     require_once 'validador.php';
 * O mesmo arquivo serve para dashboard, dashboardg e dashboardf, sem editar nada:
 * o perfil exigido vem do NOME DA PASTA onde ele está.
 *
 * O que confere, a cada acesso:
 *   1) Existe sessão de login (conectar.php grava usuario_id e usuario_tipo)?
 *   2) A conta existe e está ativa no banco?
 *   3) O cargo ATUAL da pessoa no banco é o desta pasta? (não confia no cargo guardado na sessão:
 *      se o cargo foi alterado depois do login, vale o do banco)
 * Falhou: página -> redireciona; ação (fetch/JSON) -> responde 401/403 em JSON.
 */

require_once 'conexao.php'; // fornece $pdo

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

/* Impede o navegador de guardar a página: depois do "Sair", o botão Voltar não mostra a tela antiga */
header('Cache-Control: no-store, no-cache, must-revalidate, max-age=0');
header('Pragma: no-cache');

function validador_executar(PDO $pdo): void
{
    /* Caminho da tela de login a partir desta pasta (o mesmo do sair.php) */
    $urlLogin = '../tela_login/index.php';

    /* Pasta => perfil que pode usar aquela pasta (mesmos nomes do $destinos do conectar.php) */
    $perfilDaPasta = [
        'dashboard'  => 'administrador',
        'dashboardg' => 'gerente',
        'dashboardf' => 'funcionario',
    ];
    $pastaDoPerfil = array_flip($perfilDaPasta);

    /* Tipo da sessão (tabela onde a pessoa foi achada no login) => consulta que devolve ativo e cargo.
       Lista FIXA: nada digitado entra no SQL. */
    $consultas = [
        'funcionario'   => "SELECT f.ativo_funcionario AS ativo, c.nome_cargo AS cargo
                              FROM funcionario f
                         LEFT JOIN cargo c ON c.id_cargo = f.id_cargo
                             WHERE f.id_funcionario = :id",
        'administrador' => "SELECT ativo_administrador AS ativo, 'administrador' AS cargo
                              FROM administrador WHERE id_administrador = :id",
        'gerente'       => "SELECT ativo_gerente AS ativo, 'gerente' AS cargo
                              FROM gerente WHERE id_gerente = :id",
    ];

    /* Navegação normal do navegador (GET pedindo HTML) é redirecionada;
       o resto (fetch, POST) recebe JSON, porque o JS não sabe seguir um redirecionamento. */
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
    $id   = (int) ($_SESSION['usuario_id'] ?? 0);
    $tipo = (string) ($_SESSION['usuario_tipo'] ?? '');

    if ($id <= 0 || !isset($consultas[$tipo])) {
        $negar(401, 'Você precisa fazer login.', $urlLogin);
    }

    /* 2) A conta existe e está ativa? E qual é o cargo dela AGORA, no banco? */
    try {
        $q = $pdo->prepare($consultas[$tipo]);
        $q->execute([':id' => $id]);
        $conta = $q->fetch(PDO::FETCH_ASSOC);
    } catch (PDOException $e) {
        error_log('Erro no validador.php: ' . $e->getMessage());
        $negar(500, 'Erro ao validar o acesso.', $urlLogin);
    }

    if (!$conta || (int) $conta['ativo'] !== 1) {
        $encerrarSessao();
        $negar(401, 'Conta não encontrada ou inativa.', $urlLogin);
    }

    /* Cargo sem acento e em minúsculo (a mesma regra do conectar.php) */
    $cargo = mb_strtolower(trim((string) ($conta['cargo'] ?? '')), 'UTF-8');
    $cargo = strtr($cargo, [
        'á' => 'a', 'ã' => 'a', 'â' => 'a',
        'é' => 'e', 'ê' => 'e', 'í' => 'i',
        'ó' => 'o', 'ô' => 'o', 'õ' => 'o',
        'ú' => 'u', 'ç' => 'c',
    ]);
    $_SESSION['cargo'] = $cargo; // mantém a sessão igual ao banco

    /* 3) O cargo atual é o desta pasta? Se a pasta não está na lista, é bloqueada por segurança. */
    $pasta = basename(__DIR__);
    $pasta = basename(__DIR__);

    if (!isset($perfilDaPasta[$pasta]) || $cargo !== $perfilDaPasta[$pasta]) {
    
        if ($cargo === 'funcionario') {
            $meuPainel = '../dashboardf/maquinas.php';
    
        } else {
            $meuPainel = isset($pastaDoPerfil[$cargo])
                ? '../' . $pastaDoPerfil[$cargo] . '/index.php'
                : $urlLogin;
        }
    
        $negar(
            403,
            'Você não tem permissão para acessar esta área.',
            $meuPainel
        );
    }
}
validador_executar($pdo);