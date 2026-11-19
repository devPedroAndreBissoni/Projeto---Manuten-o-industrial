<?php
/*
 * criar_ordem.php
 * Recebe o modal "Nova Ordem de Serviço" (fetch/POST) e grava nas tabelas que JÁ existem:
 *   1) manutencao            -> tipo e problema desta ordem
 *   2) ordem_de_serviço      -> data, urgência, responsável (e o id da manutenção)
 *   3) recebe_maquina_ords   -> liga a ordem à máquina
 *   4) chama_*_ords          -> registra quem abriu a ordem (administrador, gerente ou funcionário)
 * Tudo em uma transação: ou grava as 4 partes, ou não grava nada.
 * Nenhuma estrutura do banco é alterada e nada é apagado.
 */

require_once 'conexao.php';
require_once 'ordens_config.php';

date_default_timezone_set('America/Sao_Paulo');

/* Avisos/erros do PHP não podem ser impressos na resposta (quebrariam o JSON). Continuam no log. */
ini_set('display_errors', '0');

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

/* Lista FIXA: tipo de usuário => [tabela de quem é, coluna id, coluna ativo, tabela de ligação com a ordem].
   Os nomes de tabela/coluna vêm só daqui, nunca de dados digitados. */
$USUARIOS = [
    'administrador' => ['administrador', 'id_administrador', 'ativo_administrador', 'chama_administrador_ords'],
    'gerente'       => ['gerente',       'id_gerente',       'ativo_gerente',       'chama_gerente_ords'],
    'funcionario'   => ['funcionario',   'id_funcionario',   'ativo_funcionario',   'chama_funcionario_ords'],
];

/* 1) Só aceita POST */
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    responder(false, 'Método não permitido.', [], 405);
}

/* 2) Proteção CSRF */
$tokenSessao  = $_SESSION['csrf_token'] ?? '';
$tokenEnviado = $_POST['csrf_token'] ?? '';
if ($tokenSessao === '' || !hash_equals($tokenSessao, (string) $tokenEnviado)) {
    responder(false, 'Sessão expirada. Recarregue a página e tente novamente.', [], 403);
}

/* 3) Precisa estar logado (a pessoa vem da sessão, nunca do navegador) */
$meuId   = (int) ($_SESSION['usuario_id'] ?? 0);
$meuTipo = (string) ($_SESSION['usuario_tipo'] ?? '');
if ($meuId <= 0 || !isset($USUARIOS[$meuTipo])) {
    responder(false, 'Você precisa estar logado.', [], 401);
}
[$tabU, $colIdU, $colAtivoU, $tabLigacao] = $USUARIOS[$meuTipo];

/* 4) Leitura e validação dos campos */
$idMaquina   = filter_var($_POST['id_maquina'] ?? '', FILTER_VALIDATE_INT);
$tipo        = trim((string) ($_POST['tipo_manutencao'] ?? ''));
$problema    = trim((string) ($_POST['problema'] ?? ''));
$obs         = trim((string) ($_POST['observacoes'] ?? ''));
$urgencia    = trim((string) ($_POST['urgencia'] ?? ''));
$responsavel = trim((string) ($_POST['responsavel'] ?? ''));

if (!$idMaquina) {
    responder(false, 'Selecione a máquina.', ['campo' => 'id_maquina'], 422);
}
if (!in_array($tipo, TIPOS_MANUTENCAO, true)) {
    responder(false, 'Selecione o tipo de manutenção.', ['campo' => 'tipo_manutencao'], 422);
}
if (!in_array($problema, PROBLEMAS_MANUTENCAO[$tipo], true)) {
    responder(false, 'Selecione o problema.', ['campo' => 'problema'], 422);
}
if ($problema === 'Outro' && $obs === '') {
    responder(false, 'Descreva o problema nas observações.', ['campo' => 'observacoes'], 422);
}
if (mb_strlen($obs) > 240) {
    responder(false, 'As observações devem ter no máximo 240 caracteres.', ['campo' => 'observacoes'], 422);
}
if (!in_array($urgencia, URGENCIAS, true)) {
    responder(false, 'Selecione a urgência.', ['campo' => 'urgencia'], 422);
}
if (mb_strlen($responsavel) < 3 || mb_strlen($responsavel) > 100) {
    responder(false, 'O responsável deve ter entre 3 e 100 caracteres.', ['campo' => 'responsavel'], 422);
}

/* "Problema" e "observações" cabem juntos em manutencao.descricao_manutencao (300 caracteres) */
$descricao = $obs === '' ? $problema : ($problema . ' — ' . $obs);

try {
    /* 5) Quem está abrindo a ordem precisa existir e estar ativo */
    $u = $pdo->prepare("SELECT COUNT(*) FROM $tabU WHERE $colIdU = :id AND $colAtivoU = 1");
    $u->execute([':id' => $meuId]);
    if ((int) $u->fetchColumn() === 0) {
        responder(false, 'Conta não encontrada ou inativa.', [], 403);
    }

    /* 6) A máquina precisa existir e estar ativa */
    $m = $pdo->prepare("SELECT COUNT(*) FROM maquina WHERE id_maquina = :id AND ativo_maquina = 1");
    $m->execute([':id' => $idMaquina]);
    if ((int) $m->fetchColumn() === 0) {
        responder(false, 'Máquina não encontrada ou inativa.', ['campo' => 'id_maquina'], 422);
    }

    $pdo->beginTransaction();

    /* a) manutencao: a coluna id_manutencao não é AUTO_INCREMENT no banco, então o próximo
          número é calculado aqui (dentro da transação, com FOR UPDATE, para dois pedidos
          simultâneos não pegarem o mesmo número). */
    $proximo = (int) $pdo->query(
        "SELECT COALESCE(MAX(id_manutencao), 0) + 1 FROM manutencao FOR UPDATE"
    )->fetchColumn();

    $pdo->prepare(
        "INSERT INTO manutencao (id_manutencao, tipo_manutencao, descricao_manutencao, ativo_manutencao)
         VALUES (:id, :tipo, :desc, 1)"
    )->execute([':id' => $proximo, ':tipo' => $tipo, ':desc' => $descricao]);

    /* b) ordem_de_serviço (id_ords é AUTO_INCREMENT) */
    $pdo->prepare(
        "INSERT INTO `ordem_de_serviço` (`id_manutenção`, datetime_ords, urgencia_ords, nomeresponsavel_ords, ativo_ords)
         VALUES (:man, :data, :urg, :resp, 1)"
    )->execute([
        ':man'  => $proximo,
        ':data' => date('Y-m-d H:i:s'),
        ':urg'  => $urgencia,
        ':resp' => $responsavel,
    ]);
    $idOrds = (int) $pdo->lastInsertId();

    /* c) máquina <-> ordem */
    $pdo->prepare("INSERT INTO recebe_maquina_ords (id_maquina, id_ords) VALUES (:maq, :ords)")
        ->execute([':maq' => $idMaquina, ':ords' => $idOrds]);

    /* d) quem abriu a ordem */
    $pdo->prepare("INSERT INTO $tabLigacao ($colIdU, id_ords) VALUES (:pessoa, :ords)")
        ->execute([':pessoa' => $meuId, ':ords' => $idOrds]);

    $pdo->commit();

    responder(true, 'Ordem de serviço nº ' . $idOrds . ' criada com sucesso!', ['id' => $idOrds]);

} catch (PDOException $e) {
    if ($pdo->inTransaction()) {
        $pdo->rollBack();
    }
    error_log('Erro ao criar ordem de serviço: ' . $e->getMessage());
    responder(false, 'Erro ao salvar no banco de dados.', [], 500);
} catch (Throwable $e) {
    if (isset($pdo) && $pdo->inTransaction()) {
        $pdo->rollBack();
    }
    error_log('Erro inesperado ao criar ordem de serviço: ' . $e->getMessage());
    responder(false, 'Erro inesperado ao salvar a ordem.', [], 500);
}