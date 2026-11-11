<?php
/*
 * ativar.php
 * Reativação de funcionário, gerente, administrador, máquina ou produto.
 * É o inverso do inativar.php: a coluna ativo_* volta de 0 para 1.
 * Nada é criado nem apagado: o registro apenas volta a aparecer nas listas.
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

/* Lista FIXA dos tipos aceitos: tipo => [tabela, coluna do id, coluna ativo, mensagem de sucesso].
   Os nomes de tabela/coluna vêm só daqui, nunca de dados digitados. */
$tipos = [
    'funcionario'   => ['funcionario',   'id_funcionario',   'ativo_funcionario',   'Funcionário ativado com sucesso!'],
    'gerente'       => ['gerente',       'id_gerente',       'ativo_gerente',       'Gerente ativado com sucesso!'],
    'administrador' => ['administrador', 'id_administrador', 'ativo_administrador', 'Administrador ativado com sucesso!'],
    'maquina'       => ['maquina',       'id_maquina',       'ativo_maquina',       'Máquina ativada com sucesso!'],
    'produto'       => ['produto',       'id_produto',       'ativo_produto',       'Produto ativado com sucesso!'],
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
    /* Só UPDATE. O "AND ativo = 0" evita reativar duas vezes e dá o aviso correto. */
    $up = $pdo->prepare(
        "UPDATE $tabela
            SET $colAtivo = 1
          WHERE $colId = :id AND $colAtivo = 0"
    );
    $up->execute([':id' => $id]);

    if ($up->rowCount() === 0) {
        responder(false, 'Registro não encontrado ou já ativo.', [], 404);
    }

    responder(true, $msgSucesso);

} catch (PDOException $e) {
    error_log('Erro ao ativar registro: ' . $e->getMessage());
    responder(false, 'Erro ao salvar no banco de dados.', [], 500);
}
