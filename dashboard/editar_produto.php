<?php
/*
 * editar_produto.php
 * Recebe os dados do modal de edição da tela de Produtos (via fetch/POST) e atualiza a tabela produto.
 * Responde sempre em JSON: { ok: true/false, mensagem: "...", ... }
 */

require_once 'conexao.php';
require_once __DIR__ . '/resolver_usuario.php';

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}
resolverUsuarioSessao($pdo); // garante usuario_id/usuario_tipo na sessão

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

/* 2) Proteção CSRF */
$tokenSessao  = $_SESSION['csrf_token'] ?? '';
$tokenEnviado = $_POST['csrf_token'] ?? '';
if ($tokenSessao === '' || !hash_equals($tokenSessao, $tokenEnviado)) {
    responder(false, 'Sessão expirada. Recarregue a página e tente novamente.', [], 403);
}

/* 3) Precisa estar logado */
if ((int) ($_SESSION['usuario_id'] ?? 0) <= 0
    || !in_array((string) ($_SESSION['usuario_tipo'] ?? ''), ['funcionario', 'administrador', 'gerente'], true)) {
    responder(false, 'Você precisa estar logado.', [], 401);
}

/* 4) Leitura e validação dos campos */
$id          = filter_var($_POST['id'] ?? '', FILTER_VALIDATE_INT);
$nome        = trim($_POST['nome'] ?? '');
$idCategoria = filter_var($_POST['id_categoria'] ?? '', FILTER_VALIDATE_INT);
$estoque     = trim((string) ($_POST['estoque'] ?? ''));
$data        = trim((string) ($_POST['data_producao'] ?? ''));

if (!$id) {
    responder(false, 'Registro inválido.', [], 422);
}

if (mb_strlen($nome) < 3 || mb_strlen($nome) > 100) {
    responder(false, 'O nome deve ter entre 3 e 100 caracteres.', ['campo' => 'nome'], 422);
}

if (!$idCategoria) {
    responder(false, 'Selecione a categoria.', ['campo' => 'id_categoria'], 422);
}

if (!preg_match('/^\d{1,12}$/', $estoque)) {
    responder(false, 'Informe o estoque com números inteiros (0 ou mais).', ['campo' => 'estoque'], 422);
}

$d     = DateTime::createFromFormat('!Y-m-d', $data);
$erros = DateTime::getLastErrors();
if (!$d || ($erros && ($erros['warning_count'] || $erros['error_count']))
    || $d->format('Y-m-d') !== $data || (int) $d->format('Y') < 2000) {
    responder(false, 'Informe uma data de produção válida.', ['campo' => 'data_producao'], 422);
}

try {
    /* 5) O produto precisa existir (o UPDATE sozinho não distingue "não achou" de "nada mudou") */
    $e = $pdo->prepare("SELECT COUNT(*) FROM produto WHERE id_produto = :id");
    $e->execute([':id' => $id]);
    if ((int) $e->fetchColumn() === 0) {
        responder(false, 'Produto não encontrado.', [], 404);
    }

    /* A categoria precisa existir e estar ativa; o nome volta para atualizar a tabela */
    $c = $pdo->prepare("SELECT tipo_categoria FROM categoria WHERE id_categoria = :id AND ativo_categoria = 1");
    $c->execute([':id' => $idCategoria]);
    $nomeCategoria = $c->fetchColumn();
    if ($nomeCategoria === false) {
        responder(false, 'Categoria inexistente ou inativa.', ['campo' => 'id_categoria'], 422);
    }

    /* 6) UPDATE */
    $up = $pdo->prepare(
        "UPDATE produto
            SET nome_produto    = :nome,
                id_categoria    = :cat,
                estoque_produto = :estoque,
                data_producao   = :data
          WHERE id_produto = :id"
    );
    $up->execute([
        ':nome' => $nome, ':cat' => $idCategoria, ':estoque' => $estoque,
        ':data' => $data, ':id' => $id,
    ]);

    responder(true, 'Produto atualizado com sucesso!', [
        'nome'          => $nome,
        'id_categoria'  => $idCategoria,
        'categoria'     => $nomeCategoria,
        'estoque'       => (int) $estoque,
        'data_producao' => $data,
        'producao'      => $d->format('d/m/Y'),
    ]);

} catch (PDOException $ex) {
    error_log('Erro ao editar produto: ' . $ex->getMessage());
    responder(false, 'Erro ao salvar no banco de dados.', [], 500);
}