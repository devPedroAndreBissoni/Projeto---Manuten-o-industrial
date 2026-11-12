<?php
/*
 * editar_maquina.php
 * Recebe os dados do modal de edição de máquina (via fetch/POST) e atualiza o banco.
 * Responde sempre em JSON: { ok: true/false, mensagem: "...", ... }
 */

require_once 'conexao.php';

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

header('Content-Type: application/json; charset=utf-8');

/* Função auxiliar para responder e encerrar */
function responder(bool $ok, string $mensagem, array $extra = [], int $status = 200): void
{
    http_response_code($status);
    echo json_encode(array_merge(['ok' => $ok, 'mensagem' => $mensagem], $extra), JSON_UNESCAPED_UNICODE);
    exit;
}

/* Valores aceitos em "funcionamento" (os mesmos do <select> do modal).
   Se criar um status novo no banco, inclua aqui e no modal. */
const STATUS_VALIDOS = ['Operacional', 'Em manutenção', 'Parada'];

/* 1) Só aceita POST */
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    responder(false, 'Método não permitido.', [], 405);
}

/* 2) Proteção CSRF: o token da sessão precisa bater com o enviado pelo formulário */
$tokenSessao  = $_SESSION['csrf_token'] ?? '';
$tokenEnviado = $_POST['csrf_token'] ?? '';
if ($tokenSessao === '' || !hash_equals($tokenSessao, $tokenEnviado)) {
    responder(false, 'Sessão expirada. Recarregue a página e tente novamente.', [], 403);
}

/* 3) Leitura e validação dos campos */
$id             = filter_var($_POST['id'] ?? '', FILTER_VALIDATE_INT);
$nome           = trim($_POST['nome'] ?? '');
$tipoMaquina    = trim($_POST['tipo_maquina'] ?? '');
$funcionamento  = trim($_POST['funcionamento'] ?? '');

if (!$id) {
    responder(false, 'Registro inválido.', [], 422);
}

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
    /* 4) A máquina precisa existir e estar ativa */
    $ex = $pdo->prepare("SELECT COUNT(*) FROM maquina WHERE id_maquina = :id AND ativo_maquina = 1");
    $ex->execute([':id' => $id]);
    if ((int) $ex->fetchColumn() === 0) {
        responder(false, 'Máquina não encontrada.', [], 404);
    }

    /* 5) UPDATE */
    $up = $pdo->prepare(
        "UPDATE maquina
            SET nome_maquina          = :nome,
                tipo_maquina          = :tipo,
                funcionamento_maquina = :func
          WHERE id_maquina = :id"
    );
    $up->execute([
        ':nome' => $nome,
        ':tipo' => $tipoMaquina,
        ':func' => $funcionamento,
        ':id'   => $id,
    ]);

    responder(true, 'Máquina atualizada com sucesso!', [
        'nome'          => $nome,
        'tipo_maquina'  => $tipoMaquina,
        'funcionamento' => $funcionamento,
    ]);

} catch (PDOException $e) {
    error_log('Erro ao editar máquina: ' . $e->getMessage());
    responder(false, 'Erro ao salvar no banco de dados.', [], 500);
}
