<?php
/*
 * inativar.php
 * Inativação (exclusão LÓGICA) de funcionário ou administrador.
 * Nada é apagado do banco: apenas a coluna ativo_* passa de 1 para 0.
 * Todos os dados da pessoa continuam guardados e podem ser consultados ou reativados depois.
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

/* 2) Mesmo token CSRF das outras ações */
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
    if ($tipo === 'funcionario') {
        // Só UPDATE: nenhum DELETE em lugar nenhum
        $up = $pdo->prepare(
            "UPDATE funcionario
                SET ativo_funcionario = 0
              WHERE id_funcionario = :id AND ativo_funcionario = 1"
        );
        $up->execute([':id' => $id]);

        if ($up->rowCount() === 0) {
            responder(false, 'Registro não encontrado ou já inativo.', [], 404);
        }

        responder(true, 'Funcionário inativado com sucesso!');
    }

    /* Administrador: não deixa inativar o último ativo (evita ficar sem ninguém com acesso).
       A transação com FOR UPDATE impede que dois pedidos simultâneos burlem essa regra. */
    $pdo->beginTransaction();

    $total = (int) $pdo->query(
        "SELECT COUNT(*) FROM administrador WHERE ativo_administrador = 1 FOR UPDATE"
    )->fetchColumn();

    if ($total <= 1) {
        $pdo->rollBack();
        responder(false, 'Não é possível inativar o único administrador ativo.', [], 422);
    }

    $up = $pdo->prepare(
        "UPDATE administrador
            SET ativo_administrador = 0
          WHERE id_administrador = :id AND ativo_administrador = 1"
    );
    $up->execute([':id' => $id]);

    if ($up->rowCount() === 0) {
        $pdo->rollBack();
        responder(false, 'Registro não encontrado ou já inativo.', [], 404);
    }

    $pdo->commit();
    responder(true, 'Administrador inativado com sucesso!');

} catch (PDOException $e) {
    if ($pdo->inTransaction()) {
        $pdo->rollBack();
    }
    error_log('Erro ao inativar registro: ' . $e->getMessage());
    responder(false, 'Erro ao salvar no banco de dados.', [], 500);
}