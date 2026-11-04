<?php
/*
 * conta.php
 * Configurações da conta de quem está logado (engrenagem no topo).
 *   GET  ?acao=ver     -> devolve os dados da própria conta
 *   POST acao=salvar   -> altera e-mail e telefone
 *   POST acao=senha    -> altera a senha (exige a senha atual)
 *
 * A pessoa é identificada SOMENTE pela sessão ($_SESSION['usuario_id'] e
 * $_SESSION['usuario_tipo']), nunca por um id enviado pelo navegador.
 * O futuro login precisa gravar essas duas chaves.
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

/* Nomes das colunas de cada tabela (lista fixa: nada vindo do navegador entra no SQL) */
$TABELAS = [
    'funcionario' => [
        'tabela' => 'funcionario', 'id' => 'id_funcionario', 'nome' => 'nome_funcionario',
        'email' => 'email_funcionario', 'cpf' => 'cpf_funcionario',
        'tel' => 'telefone_funcionario', 'senha' => 'senha_funcionario', 'ativo' => 'ativo_funcionario',
    ],
    'administrador' => [
        'tabela' => 'administrador', 'id' => 'id_administrador', 'nome' => 'nome_administrador',
        'email' => 'email_administrador', 'cpf' => 'cpf_administrador',
        'tel' => 'telefone_administrador', 'senha' => 'senha_administrador', 'ativo' => 'ativo_administrador',
    ],
    'gerente' => [
        'tabela' => 'gerente', 'id' => 'id_gerente', 'nome' => 'nome_gerente',
        'email' => 'email_gerente', 'cpf' => 'cpf_gerente',
        'tel' => 'telefone_gerente', 'senha' => 'senha_gerente', 'ativo' => 'ativo_gerente',
    ],
];

/* 1) Precisa estar logado */
$meuId   = (int) ($_SESSION['usuario_id'] ?? 0);
$meuTipo = (string) ($_SESSION['usuario_tipo'] ?? '');

if ($meuId <= 0 || !isset($TABELAS[$meuTipo])) {
    responder(false, 'Você precisa estar logado.', [], 401);
}
$t = $TABELAS[$meuTipo];

$acao = $_SERVER['REQUEST_METHOD'] === 'POST' ? ($_POST['acao'] ?? '') : ($_GET['acao'] ?? 'ver');

/* 2) Ações que alteram dados: só POST + token CSRF */
if ($acao !== 'ver') {
    if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
        responder(false, 'Método não permitido.', [], 405);
    }
    $tokenSessao  = $_SESSION['csrf_token'] ?? '';
    $tokenEnviado = $_POST['csrf_token'] ?? '';
    if ($tokenSessao === '' || !hash_equals($tokenSessao, $tokenEnviado)) {
        responder(false, 'Sessão expirada. Recarregue a página e tente novamente.', [], 403);
    }
}

try {
    /* A conta precisa existir e estar ativa */
    $q = $pdo->prepare(
        "SELECT {$t['id']} AS id, {$t['nome']} AS nome, {$t['email']} AS email, {$t['cpf']} AS cpf,
                {$t['tel']} AS telefone, {$t['senha']} AS senha, {$t['ativo']} AS ativo
         FROM {$t['tabela']} WHERE {$t['id']} = :id"
    );
    $q->execute([':id' => $meuId]);
    $conta = $q->fetch();

    if (!$conta || (int) $conta['ativo'] !== 1) {
        responder(false, 'Conta não encontrada ou inativa.', [], 403);
    }

    switch ($acao) {

        /* ---------- VER ---------- */
        case 'ver':
            $cargo = ucfirst($meuTipo);
            $setor = 'Geral';

            if ($meuTipo === 'funcionario') {
                $d = $pdo->prepare(
                    "SELECT c.nome_cargo, s.nome_setor
                     FROM funcionario f
                     INNER JOIN cargo c ON c.id_cargo = f.id_cargo
                     INNER JOIN setor s ON s.id_setor = f.id_setor
                     WHERE f.id_funcionario = :id"
                );
                $d->execute([':id' => $meuId]);
                if ($linha = $d->fetch()) {
                    $cargo = $linha['nome_cargo'];
                    $setor = $linha['nome_setor'];
                }
            } elseif ($meuTipo === 'administrador') {
                $cargo = 'Administrador';
            } else {
                $cargo = 'Gerente';
            }

            responder(true, 'ok', ['dados' => [
                'id'       => (int) $conta['id'],
                'nome'     => $conta['nome'],
                'cpf'      => $conta['cpf'],
                'email'    => $conta['email'],
                'telefone' => $conta['telefone'],
                'cargo'    => $cargo,
                'setor'    => $setor,
                'tipo'     => $meuTipo,
                'ativo'    => (int) $conta['ativo'],
            ]]);

        /* ---------- SALVAR E-MAIL / TELEFONE ---------- */
        case 'salvar':
            $email    = trim($_POST['email'] ?? '');
            $telefone = preg_replace('/\D/', '', $_POST['telefone'] ?? '');

            if (!filter_var($email, FILTER_VALIDATE_EMAIL) || mb_strlen($email) > 100) {
                responder(false, 'Informe um e-mail válido.', ['campo' => 'email'], 422);
            }
            if (strlen($telefone) < 10 || strlen($telefone) > 11) {
                responder(false, 'O telefone deve ter DDD + número (10 ou 11 dígitos).', ['campo' => 'telefone'], 422);
            }

            /* O e-mail não pode estar em uso por OUTRA pessoa (em qualquer das 3 tabelas) */
            foreach ($TABELAS as $tipo => $x) {
                $sql = "SELECT COUNT(*) FROM {$x['tabela']} WHERE {$x['email']} = :e";
                $par = [':e' => $email];
                if ($tipo === $meuTipo) {
                    $sql .= " AND {$x['id']} <> :id";
                    $par[':id'] = $meuId;
                }
                $c = $pdo->prepare($sql);
                $c->execute($par);
                if ((int) $c->fetchColumn() > 0) {
                    responder(false, 'Este e-mail já está sendo usado por outro cadastro.', ['campo' => 'email'], 422);
                }
            }

            $up = $pdo->prepare(
                "UPDATE {$t['tabela']} SET {$t['email']} = :e, {$t['tel']} = :tel WHERE {$t['id']} = :id"
            );
            $up->execute([':e' => $email, ':tel' => $telefone, ':id' => $meuId]);

            responder(true, 'Dados atualizados com sucesso!', ['email' => $email, 'telefone' => $telefone]);

        /* ---------- TROCAR SENHA ---------- */
        case 'senha':
            $atual     = (string) ($_POST['senha_atual'] ?? '');
            $nova      = (string) ($_POST['nova_senha'] ?? '');
            $confirmar = (string) ($_POST['confirmar_senha'] ?? '');

            if ($atual === '' || !password_verify($atual, $conta['senha'])) {
                responder(false, 'A senha atual está incorreta.', ['campo' => 'senha_atual'], 422);
            }
            if (strlen($nova) < 8) {
                responder(false, 'A nova senha deve ter pelo menos 8 caracteres.', ['campo' => 'nova_senha'], 422);
            }
            if (strlen($nova) > 72) {
                responder(false, 'A nova senha deve ter no máximo 72 caracteres.', ['campo' => 'nova_senha'], 422);
            }
            if (!hash_equals($nova, $confirmar)) {
                responder(false, 'As senhas não conferem.', ['campo' => 'confirmar_senha'], 422);
            }
            if (hash_equals($atual, $nova)) {
                responder(false, 'A nova senha deve ser diferente da atual.', ['campo' => 'nova_senha'], 422);
            }

            $hash = password_hash($nova, PASSWORD_BCRYPT, ['cost' => 12]);
            $up = $pdo->prepare("UPDATE {$t['tabela']} SET {$t['senha']} = :s WHERE {$t['id']} = :id");
            $up->execute([':s' => $hash, ':id' => $meuId]);

            session_regenerate_id(true); // novo id de sessão após mudar credencial

            responder(true, 'Senha alterada com sucesso!');

        default:
            responder(false, 'Ação inválida.', [], 400);
    }

} catch (PDOException $e) {
    error_log('Erro em conta.php: ' . $e->getMessage());
    responder(false, 'Erro ao acessar o banco de dados.', [], 500);
}