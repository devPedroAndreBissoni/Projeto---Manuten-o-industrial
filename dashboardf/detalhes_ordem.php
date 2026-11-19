<?php
/*
 * detalhes_ordem.php
 * Devolve (em JSON) todas as informações de uma ordem de serviço para o modal de detalhes
 * da tela de Ordens de Serviço. Só lê o banco (nenhum INSERT/UPDATE).
 */

require_once 'conexao.php';

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

ini_set('display_errors', '0'); // avisos do PHP não podem quebrar o JSON (continuam no log)

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

/* 2) Mesmo token CSRF das outras telas */
$tokenSessao  = $_SESSION['csrf_token'] ?? '';
$tokenEnviado = $_POST['csrf_token'] ?? '';
if ($tokenSessao === '' || !hash_equals($tokenSessao, (string) $tokenEnviado)) {
    responder(false, 'Sessão expirada. Recarregue a página e tente novamente.', [], 403);
}

/* 3) Validação */
$id = filter_var($_POST['id'] ?? '', FILTER_VALIDATE_INT);
if (!$id) {
    responder(false, 'Registro inválido.', [], 422);
}

try {
    /* 4) Dados principais: ordem + manutenção (tipo e problema) */
    $q = $pdo->prepare(
        "SELECT o.id_ords               AS id,
                o.datetime_ords         AS data,
                o.urgencia_ords         AS urgencia,
                o.nomeresponsavel_ords  AS responsavel,
                o.ativo_ords            AS ativo,
                mt.tipo_manutencao      AS tipo,
                mt.descricao_manutencao AS descricao
           FROM `ordem_de_serviço` o
      LEFT JOIN manutencao mt ON mt.id_manutencao = o.`id_manutenção`
          WHERE o.id_ords = :id"
    );
    $q->execute([':id' => $id]);
    $dados = $q->fetch();

    if (!$dados) {
        responder(false, 'Registro não encontrado.', [], 404);
    }

    $dados['ativo'] = (int) $dados['ativo'] === 1;
    $dados['data']  = $dados['data'] ? date('d/m/Y H:i', strtotime($dados['data'])) : '-';

    /* 5) Máquina(s) da ordem */
    $maquinas = [];
    $mq = $pdo->prepare(
        "SELECT m.nome_maquina AS nome, m.tipo_maquina AS modelo
           FROM recebe_maquina_ords r
     INNER JOIN maquina m ON m.id_maquina = r.id_maquina
          WHERE r.id_ords = :id"
    );
    $mq->execute([':id' => $id]);
    $maquinas = $mq->fetchAll();

    /* 6) Quem abriu a ordem (administrador, gerente ou funcionário).
          Em try próprio: se der problema aqui, o resto do modal ainda abre. */
    $solicitantes = [];
    try {
        $s = $pdo->prepare(
            "SELECT a.nome_administrador AS nome, 'Administrador' AS papel
               FROM chama_administrador_ords c
         INNER JOIN administrador a ON a.id_administrador = c.id_administrador
              WHERE c.id_ords = :id1
             UNION ALL
             SELECT g.nome_gerente, 'Gerente'
               FROM chama_gerente_ords c
         INNER JOIN gerente g ON g.id_gerente = c.id_gerente
              WHERE c.id_ords = :id2
             UNION ALL
             SELECT f.nome_funcionario, 'Funcionário'
               FROM chama_funcionario_ords c
         INNER JOIN funcionario f ON f.id_funcionario = c.id_funcionario
              WHERE c.id_ords = :id3"
        );
        $s->execute([':id1' => $id, ':id2' => $id, ':id3' => $id]);
        $solicitantes = $s->fetchAll();
    } catch (PDOException $e) {
        error_log('Erro ao buscar quem abriu a ordem: ' . $e->getMessage());
    }

    responder(true, 'OK', [
        'dados'        => $dados,
        'maquinas'     => $maquinas,
        'solicitantes' => $solicitantes,
    ]);

} catch (PDOException $e) {
    error_log('Erro ao buscar detalhes da ordem: ' . $e->getMessage());
    responder(false, 'Erro ao consultar o banco de dados.', [], 500);
}