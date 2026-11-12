<?php
/*
 * inativar.php
 * Inativação (exclusão LÓGICA) de funcionário, gerente, administrador, máquina ou produto.
 * Nada é apagado do banco: apenas a coluna ativo_* passa de 1 para 0.
 * Todos os dados continuam guardados e podem ser consultados ou reativados depois (ativar.php).
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

/* Lista FIXA dos tipos aceitos (a mesma do ativar.php):
   tipo => [tabela, coluna do id, coluna ativo, mensagem de sucesso].
   Os nomes de tabela/coluna vêm só daqui, nunca de dados digitados. */
$tipos = [
    'funcionario'   => ['funcionario',   'id_funcionario',   'ativo_funcionario',   'Funcionário inativado com sucesso!'],
    'gerente'       => ['gerente',       'id_gerente',       'ativo_gerente',       'Gerente inativado com sucesso!'],
    'administrador' => ['administrador', 'id_administrador', 'ativo_administrador', 'Administrador inativado com sucesso!'],
    'maquina'       => ['maquina',       'id_maquina',       'ativo_maquina',       'Máquina inativada com sucesso!'],
    'produto'       => ['produto',       'id_produto',       'ativo_produto',       'Produto inativado com sucesso!'],
];

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

/* 3) Validação: o tipo precisa existir na lista fixa acima */
$tipo = $_POST['tipo'] ?? '';
$id   = filter_var($_POST['id'] ?? '', FILTER_VALIDATE_INT);

if (!is_string($tipo) || !isset($tipos[$tipo]) || !$id) {
    responder(false, 'Registro inválido.', [], 422);
}

[$tabela, $colId, $colAtivo, $msgSucesso] = $tipos[$tipo];

try {
    if ($tipo !== 'administrador') {
        // Só UPDATE: nenhum DELETE em lugar nenhum
        $up = $pdo->prepare(
            "UPDATE $tabela
                SET $colAtivo = 0
              WHERE $colId = :id AND $colAtivo = 1"
        );
        $up->execute([':id' => $id]);

        if ($up->rowCount() === 0) {
            responder(false, 'Registro não encontrado ou já inativo.', [], 404);
        }

        responder(true, $msgSucesso);
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
    responder(true, $msgSucesso);

} catch (PDOException $e) {
    if ($pdo->inTransaction()) {
        $pdo->rollBack();
    }
    error_log('Erro ao inativar registro: ' . $e->getMessage());
    responder(false, 'Erro ao salvar no banco de dados.', [], 500);
}
