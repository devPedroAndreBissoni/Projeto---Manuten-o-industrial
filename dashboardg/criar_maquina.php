<?php

/*
 * criar_maquina.php
 * Cadastra uma nova máquina/equipamento (botão "Novo Registro" da tela de Máquinas).
 * Responde sempre em JSON: { ok: true/false, mensagem: "...", ... }
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

/* Valores aceitos em "funcionamento" (os mesmos do <select> do modal e do editar_maquina.php) */
const STATUS_VALIDOS = ['Operacional', 'Em manutenção', 'Parada'];

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

/* 3) Leitura dos campos */
$nome          = trim($_POST['nome'] ?? '');
$tipoMaquina   = trim($_POST['tipo_maquina'] ?? '');
$funcionamento = trim($_POST['funcionamento'] ?? '');

/* 4) Validação (a ordem segue a ordem dos campos no formulário) */
if (mb_strlen($nome) < 3 || mb_strlen($nome) > 100) {
    responder(false, 'O nome deve ter entre 3 e 100 caracteres.', ['campo' => 'nome'], 422);
}

if (mb_strlen($tipoMaquina) < 2 || mb_strlen($tipoMaquina) > 50) {
    responder(false, 'O modelo deve ter entre 2 e 50 caracteres.', ['campo' => 'tipo_maquina'], 422);
}

if (!in_array($funcionamento, STATUS_VALIDOS, true)) {
    responder(false, 'Selecione um status válido.', ['campo' => 'funcionamento'], 422);
}

try {
    /* 5) Tudo numa transação */
    $pdo->beginTransaction();

    /* Não deixa cadastrar duas máquinas ativas com o mesmo nome */
    $dup = $pdo->prepare("SELECT COUNT(*) FROM maquina WHERE nome_maquina = :nome AND ativo_maquina = 1");
    $dup->execute([':nome' => $nome]);
    if ((int) $dup->fetchColumn() > 0) {
        $pdo->rollBack();
        responder(false, 'Já existe uma máquina ativa com este nome.', ['campo' => 'nome'], 422);
    }

    /* id_maquina NÃO tem AUTO_INCREMENT no banco: id calculado com trava
       (mesmo padrão usado em criar.php para funcionário e gerente) */
    $novoId = (int) $pdo->query(
        "SELECT COALESCE(MAX(id_maquina), 0) + 1 FROM maquina FOR UPDATE"
    )->fetchColumn();

    $ins = $pdo->prepare(
        "INSERT INTO maquina
            (id_maquina, tipo_maquina, nome_maquina, funcionamento_maquina, ativo_maquina)
         VALUES (:id, :tipo, :nome, :func, 1)"
    );
    $ins->execute([
        ':id'   => $novoId,
        ':tipo' => $tipoMaquina,
        ':nome' => $nome,
        ':func' => $funcionamento,
    ]);

    $pdo->commit();

    responder(true, 'Máquina cadastrada com sucesso!', ['id' => $novoId], 201);

} catch (PDOException $e) {
    if ($pdo->inTransaction()) {
        $pdo->rollBack();
    }
    error_log('Erro ao cadastrar máquina: ' . $e->getMessage());
    responder(false, 'Erro ao salvar no banco de dados.', [], 500);
}
