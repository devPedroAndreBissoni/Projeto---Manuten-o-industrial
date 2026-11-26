<?php
/*
 * detalhes_produto.php
 * Devolve (em JSON) todas as informações de um produto para o modal de detalhes:
 * dados principais + categoria e responsáveis (administradores e gerentes).
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

/* 2) Mesmo token CSRF usado nas outras telas */
$tokenSessao  = $_SESSION['csrf_token'] ?? '';
$tokenEnviado = $_POST['csrf_token'] ?? '';
if ($tokenSessao === '' || !hash_equals($tokenSessao, $tokenEnviado)) {
    responder(false, 'Sessão expirada. Recarregue a página e tente novamente.', [], 403);
}

/* 3) Validação */
$id = filter_var($_POST['id'] ?? '', FILTER_VALIDATE_INT);
if (!$id) {
    responder(false, 'Registro inválido.', [], 422);
}

try {
    /* 4) Dados principais */
    $q = $pdo->prepare(
        "SELECT p.id_produto      AS id,
                p.nome_produto    AS nome,
                p.estoque_produto AS estoque,
                p.data_producao   AS data_producao,
                p.ativo_produto   AS ativo,
                c.tipo_categoria  AS categoria
           FROM produto p
     INNER JOIN categoria c ON c.id_categoria = p.id_categoria
          WHERE p.id_produto = :id"
    );
    $q->execute([':id' => $id]);
    $dados = $q->fetch();

    if (!$dados) {
        responder(false, 'Registro não encontrado.', [], 404);
    }

    $dados['ativo']   = (int) $dados['ativo'] === 1;
    $dados['estoque'] = (int) $dados['estoque'];

    /* 5) Quem gerencia este produto (administradores e gerentes) */
    $r = $pdo->prepare(
        "SELECT a.nome_administrador AS nome, 'Administrador' AS papel
           FROM gerencia_administrador_produto g
     INNER JOIN administrador a ON a.id_administrador = g.id_administrador
          WHERE g.id_produto = :id1 AND g.ativo_administrador_produto = 1
         UNION ALL
         SELECT ge.nome_gerente, 'Gerente'
           FROM gerencia_gerente_produto g
     INNER JOIN gerente ge ON ge.id_gerente = g.id_gerente
          WHERE g.id_produto = :id2 AND g.ativo_gerente_produto = 1"
    );
    $r->execute([':id1' => $id, ':id2' => $id]);
    $responsaveis = $r->fetchAll();

    responder(true, 'OK', [
        'dados'        => $dados,
        'responsaveis' => $responsaveis,
    ]);

} catch (PDOException $e) {
    error_log('Erro ao buscar detalhes do produto: ' . $e->getMessage());
    responder(false, 'Erro ao consultar o banco de dados.', [], 500);
}