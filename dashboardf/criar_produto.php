<?php
/*
 * criar_produto.php
 * Cadastra um novo produto (botão "Novo Registro" da tela de Produtos).
 * Responde sempre em JSON: { ok: true/false, mensagem: "...", campo?: "..." }
 *
 * Tabela produto: id_produto NÃO é AUTO_INCREMENT, então o id é calculado (MAX + 1)
 * dentro de uma transação, com trava, igual ao cadastro de funcionário.
 * Quem cadastrou (administrador ou gerente) é registrado como responsável pelo produto
 * em gerencia_administrador_produto / gerencia_gerente_produto.
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

/* 2) Mesmo token CSRF das outras ações */
$tokenSessao  = $_SESSION['csrf_token'] ?? '';
$tokenEnviado = $_POST['csrf_token'] ?? '';
if ($tokenSessao === '' || !hash_equals($tokenSessao, $tokenEnviado)) {
    responder(false, 'Sessão expirada. Recarregue a página e tente novamente.', [], 403);
}

/* 3) Precisa estar logado (a pessoa vem SÓ da sessão, nunca do navegador) */
$meuId   = (int) ($_SESSION['usuario_id'] ?? 0);
$meuTipo = (string) ($_SESSION['usuario_tipo'] ?? '');
if ($meuId <= 0 || !in_array($meuTipo, ['funcionario', 'administrador', 'gerente'], true)) {
    responder(false, 'Você precisa estar logado.', [], 401);
}

/* 4) Leitura e validação (a ordem segue a ordem dos campos no formulário) */
$nome        = trim($_POST['nome'] ?? '');
$idCategoria = filter_var($_POST['id_categoria'] ?? '', FILTER_VALIDATE_INT);
$estoque     = trim((string) ($_POST['estoque'] ?? ''));
$data        = trim((string) ($_POST['data_producao'] ?? ''));

if (mb_strlen($nome) < 3 || mb_strlen($nome) > 100) {
    responder(false, 'O nome deve ter entre 3 e 100 caracteres.', ['campo' => 'nome'], 422);
}

if (!$idCategoria) {
    responder(false, 'Selecione a categoria.', ['campo' => 'id_categoria'], 422);
}

if (!preg_match('/^\d{1,12}$/', $estoque)) {
    responder(false, 'Informe o estoque com números inteiros (0 ou mais).', ['campo' => 'estoque'], 422);
}

$d    = DateTime::createFromFormat('!Y-m-d', $data);
$erros = DateTime::getLastErrors();
if (!$d || ($erros && ($erros['warning_count'] || $erros['error_count']))
    || $d->format('Y-m-d') !== $data || (int) $d->format('Y') < 2000) {
    responder(false, 'Informe uma data de produção válida.', ['campo' => 'data_producao'], 422);
}

try {
    /* 5) A categoria precisa existir e estar ativa */
    $c = $pdo->prepare("SELECT COUNT(*) FROM categoria WHERE id_categoria = :id AND ativo_categoria = 1");
    $c->execute([':id' => $idCategoria]);
    if ((int) $c->fetchColumn() === 0) {
        responder(false, 'Categoria inexistente ou inativa.', ['campo' => 'id_categoria'], 422);
    }

    /* 6) Tudo numa transação */
    $pdo->beginTransaction();

    $novoId = (int) $pdo->query(
        "SELECT COALESCE(MAX(id_produto), 0) + 1 FROM produto FOR UPDATE"
    )->fetchColumn();

    $ins = $pdo->prepare(
        "INSERT INTO produto
            (id_produto, id_categoria, nome_produto, estoque_produto, data_producao, ativo_produto)
         VALUES (:id, :cat, :nome, :estoque, :data, 1)"
    );
    $ins->execute([
        ':id' => $novoId, ':cat' => $idCategoria, ':nome' => $nome,
        ':estoque' => $estoque, ':data' => $data,
    ]);

    /* Responsável pelo produto: quem cadastrou (funcionário não tem tabela de gerência) */
    if ($meuTipo === 'administrador') {
        $g = $pdo->prepare(
            "INSERT INTO gerencia_administrador_produto
                (id_administrador, id_produto, ativo_administrador_produto)
             VALUES (:u, :p, 1)"
        );
        $g->execute([':u' => $meuId, ':p' => $novoId]);
    } elseif ($meuTipo === 'gerente') {
        $g = $pdo->prepare(
            "INSERT INTO gerencia_gerente_produto
                (id_produto, id_gerente, ativo_gerente_produto)
             VALUES (:p, :u, 1)"
        );
        $g->execute([':p' => $novoId, ':u' => $meuId]);
    }

    $pdo->commit();

    responder(true, 'Produto cadastrado com sucesso!', ['id' => $novoId], 201);

} catch (PDOException $e) {
    if ($pdo->inTransaction()) {
        $pdo->rollBack();
    }
    error_log('Erro ao cadastrar produto: ' . $e->getMessage());
    responder(false, 'Erro ao salvar no banco de dados.', [], 500);
}