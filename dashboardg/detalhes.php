<?php
/*
 * detalhes.php
 * Devolve (em JSON) todas as informações de um funcionário ou administrador
 * para o modal de detalhes. A senha NUNCA é consultada nem enviada.
 */

require_once 'conexao.php';

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

header('Content-Type: application/json; charset=utf-8');

function responder(bool $ok, string $mensagem, array $extra = [], int $status = 200): void
{
    http_response_code($status);
    echo json_encode(array_merge(['ok' => $ok, 'mensagem' => $mensagem], $extra), JSON_UNESCAPED_UNICODE);
    exit;
}

/* 1) Só aceita POST */
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    responder(false, 'Método não permitido.', [], 405);
}

/* 2) Mesmo token CSRF usado na edição */
$tokenSessao  = $_SESSION['csrf_token'] ?? '';
$tokenEnviado = $_POST['csrf_token'] ?? '';
if ($tokenSessao === '' || !hash_equals($tokenSessao, $tokenEnviado)) {
    responder(false, 'Sessão expirada. Recarregue a página e tente novamente.', [], 403);
}

/* 3) Validação */
$tipo = $_POST['tipo'] ?? '';
$id   = filter_var($_POST['id'] ?? '', FILTER_VALIDATE_INT);

if (!in_array($tipo, ['funcionario', 'administrador'], true) || !$id) {
    responder(false, 'Registro inválido.', [], 422);
}

try {
    $responsaveis = [];

    /* 4) Dados principais (colunas escolhidas uma a uma: sem senha) */
    if ($tipo === 'funcionario') {
        $q = $pdo->prepare(
            "SELECT f.id_funcionario       AS id,
                    f.nome_funcionario     AS nome,
                    f.cpf_funcionario      AS cpf,
                    f.email_funcionario    AS email,
                    f.telefone_funcionario AS telefone,
                    f.ativo_funcionario    AS ativo,
                    c.nome_cargo           AS cargo,
                    s.nome_setor           AS setor
               FROM funcionario f
         INNER JOIN cargo c ON c.id_cargo = f.id_cargo
         INNER JOIN setor s ON s.id_setor = f.id_setor
              WHERE f.id_funcionario = :id"
        );
        $q->execute([':id' => $id]);
        $dados = $q->fetch();

        /* Quem gerencia este funcionário (administradores e gerentes) */
        $r = $pdo->prepare(
            "SELECT a.nome_administrador AS nome, 'Administrador' AS papel
               FROM gerencia_administrador_funcionario g
         INNER JOIN administrador a ON a.id_administrador = g.id_administrador
              WHERE g.id_funcionario = :id1 AND g.ativo_administrador_funcionario = 1
             UNION ALL
             SELECT ge.nome_gerente, 'Gerente'
               FROM gerencia_gerente_funcionario g
         INNER JOIN gerente ge ON ge.id_gerente = g.id_gerente
              WHERE g.id_funcionario = :id2 AND g.ativo_gerente_funcionario = 1"
        );
        $r->execute([':id1' => $id, ':id2' => $id]);
        $responsaveis = $r->fetchAll();
    } else {
        $q = $pdo->prepare(
            "SELECT id_administrador        AS id,
                    nome_administrador      AS nome,
                    cpf_administrador       AS cpf,
                    email_administrador     AS email,
                    telefone_administrador  AS telefone,
                    ativo_administrador     AS ativo,
                    'Administrador'         AS cargo,
                    'Geral'                 AS setor
               FROM administrador
              WHERE id_administrador = :id"
        );
        $q->execute([':id' => $id]);
        $dados = $q->fetch();
    }

    if (!$dados) {
        responder(false, 'Registro não encontrado.', [], 404);
    }

    $dados['ativo'] = (int) $dados['ativo'] === 1;
    $dados['tipo']  = $tipo;

    /* 5) Ordens de serviço ligadas à pessoa (últimas 10).
          Fica em um try próprio: se der problema aqui, o resto do modal ainda abre. */
    $ordens = [];
    try {
        $tabelaLigacao = $tipo === 'funcionario' ? 'chama_funcionario_ords'    : 'chama_administrador_ords';
        $colunaId      = $tipo === 'funcionario' ? 'id_funcionario'            : 'id_administrador';

        $o = $pdo->prepare(
            "SELECT o.id_ords               AS id,
                    o.datetime_ords         AS data,
                    o.urgencia_ords         AS urgencia,
                    o.nomeresponsavel_ords  AS responsavel
               FROM {$tabelaLigacao} l
         INNER JOIN `ordem_de_serviço` o ON o.id_ords = l.id_ords
              WHERE l.{$colunaId} = :id
           ORDER BY o.datetime_ords DESC
              LIMIT 10"
        );
        $o->execute([':id' => $id]);
        $ordens = $o->fetchAll();
    } catch (PDOException $e) {
        error_log('Erro ao buscar ordens de serviço: ' . $e->getMessage());
    }

    responder(true, 'OK', [
        'dados'        => $dados,
        'responsaveis' => $responsaveis,
        'ordens'       => $ordens,
    ]);

} catch (PDOException $e) {
    error_log('Erro ao buscar detalhes: ' . $e->getMessage());
    responder(false, 'Erro ao consultar o banco de dados.', [], 500);
}