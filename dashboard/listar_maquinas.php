<?php
/*
 * listar_maquinas.php
 * Devolve (em JSON) todas as informações de uma máquina/equipamento
 * para o modal de detalhes da tela de Máquinas e Equipamentos.
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

/* 2) Mesmo token CSRF usado nas outras telas */
$tokenSessao  = $_SESSION['csrf_token'] ?? '';
$tokenEnviado = $_POST['csrf_token'] ?? '';
if ($tokenSessao === '' || !hash_equals($tokenSessao, $tokenEnviado)) {
    responder(false, 'Sessão expirada. Recarregue a página e tente novamente.', [], 403);
}

/* 3) Validação (só o id importa: o "tipo" que o JS envia é o modelo da máquina, não é usado aqui) */
$id = filter_var($_POST['id'] ?? '', FILTER_VALIDATE_INT);

if (!$id) {
    responder(false, 'Registro inválido.', [], 422);
}

try {
    /* 4) Dados principais.
          Os nomes das chaves são os mesmos que o listar_maquinas.js lê:
          id_maquina, tipo_maquina, funcionamento_maquina, nome e ativo. */
    $q = $pdo->prepare(
        "SELECT m.id_maquina            AS id_maquina,
                m.nome_maquina          AS nome,
                m.tipo_maquina          AS tipo_maquina,
                m.funcionamento_maquina AS funcionamento_maquina,
                m.ativo_maquina         AS ativo
           FROM maquina m
          WHERE m.id_maquina = :id"
    );
    $q->execute([':id' => $id]);
    $dados = $q->fetch();

    if (!$dados) {
        responder(false, 'Registro não encontrado.', [], 404);
    }

    $dados['ativo'] = (int) $dados['ativo'] === 1;

    /* 5) Ordens de serviço ligadas à máquina (últimas 10).
          A ligação máquina <-> ordem é feita pela tabela recebe_maquina_ords.
          Fica em um try próprio: se der problema aqui, o resto do modal ainda abre. */
    $ordens = [];
    try {
        $o = $pdo->prepare(
            "SELECT o.id_ords               AS id,
                    o.datetime_ords         AS data,
                    o.urgencia_ords         AS urgencia,
                    o.nomeresponsavel_ords  AS responsavel
               FROM recebe_maquina_ords r
         INNER JOIN `ordem_de_serviço` o ON o.id_ords = r.id_ords
              WHERE r.id_maquina = :id
           ORDER BY o.datetime_ords DESC
              LIMIT 10"
        );
        $o->execute([':id' => $id]);
        $ordens = $o->fetchAll();
    } catch (PDOException $e) {
        error_log('Erro ao buscar ordens de serviço da máquina: ' . $e->getMessage());
    }

    responder(true, 'OK', [
        'dados'  => $dados,
        'ordens' => $ordens,
    ]);

} catch (PDOException $e) {
    error_log('Erro ao buscar detalhes da máquina: ' . $e->getMessage());
    responder(false, 'Erro ao consultar o banco de dados.', [], 500);
}
