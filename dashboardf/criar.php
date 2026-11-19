<?php
/*
 * criar.php
 * Cadastra um novo funcionário (botão "Novo Registro").
 * A senha é guardada SOMENTE como hash (bcrypt): nunca em texto puro.
 * O login futuro deve conferir com password_verify($senhaDigitada, $hashDoBanco).
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

/* Valida CPF pelos dígitos verificadores (recebe só números) */
function cpfValido(string $cpf): bool
{
    if (!preg_match('/^\d{11}$/', $cpf) || preg_match('/^(\d)\1{10}$/', $cpf)) {
        return false;
    }
    for ($t = 9; $t < 11; $t++) {
        $soma = 0;
        for ($i = 0; $i < $t; $i++) {
            $soma += (int) $cpf[$i] * (($t + 1) - $i);
        }
        if ((int) $cpf[$t] !== ((10 * $soma) % 11) % 10) {
            return false;
        }
    }
    return true;
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

/* 3) Leitura dos campos (a senha NÃO leva trim: espaços fazem parte dela) */
$nome      = trim($_POST['nome'] ?? '');
$cpf       = preg_replace('/\D/', '', $_POST['cpf'] ?? '');
$telefone  = preg_replace('/\D/', '', $_POST['telefone'] ?? '');
$email     = trim($_POST['email'] ?? '');
$idSetor   = filter_var($_POST['id_setor'] ?? '', FILTER_VALIDATE_INT);
$idCargo   = filter_var($_POST['id_cargo'] ?? '', FILTER_VALIDATE_INT);
$senha     = (string) ($_POST['senha'] ?? '');
$confirmar = (string) ($_POST['confirmar_senha'] ?? '');

/* 4) Validação (a ordem segue a ordem dos campos no formulário) */
if (mb_strlen($nome) < 3 || mb_strlen($nome) > 100) {
    responder(false, 'O nome deve ter entre 3 e 100 caracteres.', ['campo' => 'nome'], 422);
}

if (!cpfValido($cpf)) {
    responder(false, 'Informe um CPF válido.', ['campo' => 'cpf'], 422);
}

if (strlen($telefone) < 10 || strlen($telefone) > 11) {
    responder(false, 'O telefone deve ter DDD + número (10 ou 11 dígitos).', ['campo' => 'telefone'], 422);
}

if (!filter_var($email, FILTER_VALIDATE_EMAIL) || mb_strlen($email) > 100) {
    responder(false, 'Informe um e-mail válido.', ['campo' => 'email'], 422);
}

if (!$idCargo) {
    responder(false, 'Selecione o cargo.', ['campo' => 'id_cargo'], 422);
}

if (strlen($senha) < 8) {
    responder(false, 'A senha deve ter pelo menos 8 caracteres.', ['campo' => 'senha'], 422);
}

if (strlen($senha) > 72) { // limite do bcrypt: acima disso o final da senha seria ignorado
    responder(false, 'A senha deve ter no máximo 72 caracteres.', ['campo' => 'senha'], 422);
}

if (!hash_equals($senha, $confirmar)) {
    responder(false, 'As senhas não conferem.', ['campo' => 'confirmar_senha'], 422);
}

try {
    /* 5) O cargo escolhido decide EM QUAL TABELA a pessoa é gravada.
          O tipo vem do banco (cargo.tipo_cargo), nunca do navegador. */
    $c = $pdo->prepare("SELECT tipo_cargo FROM cargo WHERE id_cargo = :id AND ativo_cargo = 1");
    $c->execute([':id' => $idCargo]);
    $tipo = $c->fetchColumn();

    $tipo = $tipo === false ? '' : mb_strtolower(trim((string) $tipo));
    if (!in_array($tipo, ['funcionario', 'administrador', 'gerente'], true)) {
        responder(false, 'Cargo inexistente ou inativo.', ['campo' => 'id_cargo'], 422);
    }

    /* Setor só existe na tabela funcionario */
    if ($tipo === 'funcionario') {
        if (!$idSetor) {
            responder(false, 'Selecione o setor.', ['campo' => 'id_setor'], 422);
        }
        $s = $pdo->prepare("SELECT COUNT(*) FROM setor WHERE id_setor = :id AND ativo_setor = 1");
        $s->execute([':id' => $idSetor]);
        if ((int) $s->fetchColumn() === 0) {
            responder(false, 'Setor inexistente ou inativo.', ['campo' => 'id_setor'], 422);
        }
    }

    $hash = password_hash($senha, PASSWORD_BCRYPT, ['cost' => 12]);

    /* 6) Tudo numa transação */
    $pdo->beginTransaction();

    /* CPF e e-mail não podem existir em nenhuma tabela de pessoas */
    $dup = $pdo->prepare(
        "SELECT
            (SELECT COUNT(*) FROM funcionario   WHERE cpf_funcionario   = :c1) +
            (SELECT COUNT(*) FROM administrador WHERE cpf_administrador = :c2) +
            (SELECT COUNT(*) FROM gerente       WHERE cpf_gerente       = :c3) AS cpf_total,
            (SELECT COUNT(*) FROM funcionario   WHERE email_funcionario   = :e1) +
            (SELECT COUNT(*) FROM administrador WHERE email_administrador = :e2) +
            (SELECT COUNT(*) FROM gerente       WHERE email_gerente       = :e3) AS email_total"
    );
    $dup->execute([
        ':c1' => $cpf, ':c2' => $cpf, ':c3' => $cpf,
        ':e1' => $email, ':e2' => $email, ':e3' => $email,
    ]);
    $r = $dup->fetch();

    if ((int) $r['cpf_total'] > 0) {
        $pdo->rollBack();
        responder(false, 'Já existe um cadastro com este CPF.', ['campo' => 'cpf'], 422);
    }
    if ((int) $r['email_total'] > 0) {
        $pdo->rollBack();
        responder(false, 'Este e-mail já está sendo usado por outro cadastro.', ['campo' => 'email'], 422);
    }

    switch ($tipo) {
        case 'administrador':
            /* id_administrador é AUTO_INCREMENT */
            $ins = $pdo->prepare(
                "INSERT INTO administrador
                    (id_cargo, ativo_administrador, cpf_administrador, nome_administrador,
                     email_administrador, telefone_administrador, senha_administrador)
                 VALUES (:cargo, 1, :cpf, :nome, :email, :tel, :senha)"
            );
            $ins->execute([
                ':cargo' => $idCargo, ':cpf' => $cpf, ':nome' => $nome,
                ':email' => $email, ':tel' => $telefone, ':senha' => $hash,
            ]);
            $novoId = (int) $pdo->lastInsertId();
            break;

        case 'gerente':
            /* gerente NÃO tem AUTO_INCREMENT nem cargo/setor: id calculado com trava */
            $novoId = (int) $pdo->query(
                "SELECT COALESCE(MAX(id_gerente), 0) + 1 FROM gerente FOR UPDATE"
            )->fetchColumn();
            $ins = $pdo->prepare(
                "INSERT INTO gerente
                    (id_gerente, nome_gerente, email_gerente, cpf_gerente,
                     telefone_gerente, senha_gerente, ativo_gerente)
                 VALUES (:id, :nome, :email, :cpf, :tel, :senha, 1)"
            );
            $ins->execute([
                ':id' => $novoId, ':nome' => $nome, ':email' => $email,
                ':cpf' => $cpf, ':tel' => $telefone, ':senha' => $hash,
            ]);
            break;

        default: /* funcionario: sem AUTO_INCREMENT, id calculado com trava */
            $novoId = (int) $pdo->query(
                "SELECT COALESCE(MAX(id_funcionario), 0) + 1 FROM funcionario FOR UPDATE"
            )->fetchColumn();
            $ins = $pdo->prepare(
                "INSERT INTO funcionario
                    (id_funcionario, id_cargo, id_setor, telefone_funcionario, cpf_funcionario,
                     email_funcionario, nome_funcionario, senha_funcionario, ativo_funcionario)
                 VALUES (:id, :cargo, :setor, :tel, :cpf, :email, :nome, :senha, 1)"
            );
            $ins->execute([
                ':id' => $novoId, ':cargo' => $idCargo, ':setor' => $idSetor,
                ':tel' => $telefone, ':cpf' => $cpf, ':email' => $email,
                ':nome' => $nome, ':senha' => $hash,
            ]);
    }

    $pdo->commit();

    responder(true, 'Cadastro realizado com sucesso!', ['id' => $novoId, 'tipo' => $tipo], 201);

} catch (PDOException $e) {
    if ($pdo->inTransaction()) {
        $pdo->rollBack();
    }
    error_log('Erro ao cadastrar: ' . $e->getMessage());
    responder(false, 'Erro ao salvar no banco de dados.', [], 500);
}