<?php
/*
 * editar.php
 * Recebe os dados do modal de edição (via fetch/POST) e atualiza o banco.
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

/* 1) Só aceita POST */
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    responder(false, 'Método não permitido.', [], 405);
}

/* 2) Proteção CSRF: o token da sessão precisa bater com o enviado pelo formulário */
$tokenSessao = $_SESSION['csrf_token'] ?? '';
$tokenEnviado = $_POST['csrf_token'] ?? '';
if ($tokenSessao === '' || !hash_equals($tokenSessao, $tokenEnviado)) {
    responder(false, 'Sessão expirada. Recarregue a página e tente novamente.', [], 403);
}

/* 3) Leitura e validação dos campos */
$tipo     = $_POST['tipo'] ?? '';
$id       = filter_var($_POST['id'] ?? '', FILTER_VALIDATE_INT);
$nome     = trim($_POST['nome'] ?? '');
$email    = trim($_POST['email'] ?? '');
$telefone = preg_replace('/\D/', '', $_POST['telefone'] ?? ''); // só dígitos

if (!in_array($tipo, ['funcionario', 'administrador'], true) || !$id) {
    responder(false, 'Registro inválido.', [], 422);
}

if (mb_strlen($nome) < 3 || mb_strlen($nome) > 100) {
    responder(false, 'O nome deve ter entre 3 e 100 caracteres.', ['campo' => 'nome'], 422);
}

if (!filter_var($email, FILTER_VALIDATE_EMAIL) || mb_strlen($email) > 100) {
    responder(false, 'Informe um e-mail válido.', ['campo' => 'email'], 422);
}

if (strlen($telefone) < 10 || strlen($telefone) > 11) {
    responder(false, 'O telefone deve ter DDD + número (10 ou 11 dígitos).', ['campo' => 'telefone'], 422);
}

try {
    /* 4) E-mail não pode estar em uso por OUTRO registro */
    $idFuncionario   = $tipo === 'funcionario'   ? $id : 0;
    $idAdministrador = $tipo === 'administrador' ? $id : 0;

    $dup = $pdo->prepare(
        "SELECT
            (SELECT COUNT(*) FROM funcionario   WHERE email_funcionario   = :e1 AND id_funcionario   <> :idf) +
            (SELECT COUNT(*) FROM administrador WHERE email_administrador = :e2 AND id_administrador <> :ida)
            AS total"
    );
    $dup->execute([':e1' => $email, ':idf' => $idFuncionario, ':e2' => $email, ':ida' => $idAdministrador]);
    if ((int) $dup->fetchColumn() > 0) {
        responder(false, 'Este e-mail já está sendo usado por outro registro.', ['campo' => 'email'], 422);
    }

    /* 5) UPDATE conforme o tipo (as duas tabelas são diferentes) */
    if ($tipo === 'funcionario') {
        $idCargo = filter_var($_POST['id_cargo'] ?? '', FILTER_VALIDATE_INT);
        $idSetor = filter_var($_POST['id_setor'] ?? '', FILTER_VALIDATE_INT);

        if (!$idCargo || !$idSetor) {
            responder(false, 'Selecione o cargo e o setor.', [], 422);
        }

        // garante que cargo e setor realmente existem no banco
        $c = $pdo->prepare("SELECT nome_cargo FROM cargo WHERE id_cargo = ?");
        $c->execute([$idCargo]);
        $nomeCargo = $c->fetchColumn();

        $s = $pdo->prepare("SELECT nome_setor FROM setor WHERE id_setor = ?");
        $s->execute([$idSetor]);
        $nomeSetor = $s->fetchColumn();

        if ($nomeCargo === false || $nomeSetor === false) {
            responder(false, 'Cargo ou setor inexistente.', [], 422);
        }

        $up = $pdo->prepare(
            "UPDATE funcionario
                SET nome_funcionario     = :nome,
                    email_funcionario    = :email,
                    telefone_funcionario = :tel,
                    id_cargo             = :cargo,
                    id_setor             = :setor
              WHERE id_funcionario = :id"
        );
        $up->execute([
            ':nome'  => $nome,
            ':email' => $email,
            ':tel'   => $telefone,
            ':cargo' => $idCargo,
            ':setor' => $idSetor,
            ':id'    => $id,
        ]);

        responder(true, 'Funcionário atualizado com sucesso!', [
            'nome'     => $nome,
            'cargo'    => $nomeCargo,
            'setor'    => $nomeSetor,
            'id_cargo' => $idCargo,
            'id_setor' => $idSetor,
            'email'    => $email,
            'telefone' => $telefone,
        ]);
    }

    /* Administrador: cargo e setor são fixos, só edita dados pessoais */
    $up = $pdo->prepare(
        "UPDATE administrador
            SET nome_administrador     = :nome,
                email_administrador    = :email,
                telefone_administrador = :tel
          WHERE id_administrador = :id"
    );
    $up->execute([':nome' => $nome, ':email' => $email, ':tel' => $telefone, ':id' => $id]);

    responder(true, 'Administrador atualizado com sucesso!', [
        'nome'     => $nome,
        'cargo'    => 'Administrador',
        'setor'    => 'Geral',
        'email'    => $email,
        'telefone' => $telefone,
    ]);

} catch (PDOException $e) {
    error_log('Erro ao editar registro: ' . $e->getMessage());
    responder(false, 'Erro ao salvar no banco de dados.', [], 500);
}