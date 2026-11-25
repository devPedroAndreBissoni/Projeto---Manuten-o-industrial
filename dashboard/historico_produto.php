<?php
/*
 * historico_produto.php
 * Devolve (em JSON) o histórico de UM produto para o modal do botão "Histórico":
 *   - dados:        informações do produto (categoria, produção, estoque atual)
 *   - estoque:      estoque por mês, últimos 12 meses (gráfico de barras)
 *   - responsaveis: administradores e gerentes que gerenciam o produto
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

/* ---------- configuração do gráfico ---------- */

const MESES_NO_GRAFICO = 12;
const MESES_ABREV = ['jan', 'fev', 'mar', 'abr', 'mai', 'jun', 'jul', 'ago', 'set', 'out', 'nov', 'dez'];

/*
 * Estoque do produto em cada mês, no formato ['2026-11' => 800, '2026-10' => 750, ...].
 * Lê a tabela estoque_mensal (veja estoque_mensal.sql). Se a tabela ainda não existir
 * ou não tiver nada para o produto, cai para o único dado confiável que o banco tem:
 * o estoque de hoje, colocado no mês atual.
 */
function estoquePorMes(PDO $pdo, int $idProduto, int $estoqueAtual, DateTimeImmutable $agora): array
{
    $mesAtual = $agora->format('Y-m');
    $porMes   = [];

    try {
        $inicio = $agora->modify('first day of this month')->setTime(0, 0)
                        ->modify('-' . (MESES_NO_GRAFICO - 1) . ' months');

        $q = $pdo->prepare(
            "SELECT DATE_FORMAT(mes, '%Y-%m') AS ym, quantidade
               FROM estoque_mensal
              WHERE id_produto = :id AND mes >= :inicio"
        );
        $q->execute([':id' => $idProduto, ':inicio' => $inicio->format('Y-m-d')]);
        foreach ($q->fetchAll() as $linha) {
            $porMes[$linha['ym']] = (int) $linha['quantidade'];
        }
    } catch (PDOException $e) {
        error_log('Erro ao ler estoque_mensal: ' . $e->getMessage());
    }

    // o mês atual sempre existe: se a tabela não tem, vale o estoque de hoje
    if (!isset($porMes[$mesAtual])) {
        $porMes[$mesAtual] = $estoqueAtual;
    }

    return $porMes;
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

/* 3) Validação */
$id = filter_var($_POST['id'] ?? '', FILTER_VALIDATE_INT);
if (!$id) {
    responder(false, 'Registro inválido.', [], 422);
}

try {
    /* 4) Dados principais do produto */
    $q = $pdo->prepare(
        "SELECT p.id_produto      AS id,
                p.nome_produto    AS nome,
                p.estoque_produto AS estoque,
                p.data_producao   AS producao,
                p.ativo_produto   AS ativo,
                c.tipo_categoria  AS categoria
           FROM produto p
     INNER JOIN categoria c ON c.id_categoria = p.id_categoria
          WHERE p.id_produto = :id"
    );
    $q->execute([':id' => $id]);
    $dados = $q->fetch();

    if (!$dados) {
        responder(false, 'Produto não encontrado.', [], 404);
    }

    $dados['ativo']   = (int) $dados['ativo'] === 1;
    $dados['estoque'] = (int) $dados['estoque'];

    /* 5) Estoque por mês (os 12 últimos meses, na ordem do gráfico).
          O número vai como int: o Google Charts não desenha barra com texto. */
    $estoque = [];
    $agora   = new DateTimeImmutable('now');
    $primeiroMes = $agora->modify('first day of this month')->setTime(0, 0)
                         ->modify('-' . (MESES_NO_GRAFICO - 1) . ' months');

    $porMes = estoquePorMes($pdo, $id, $dados['estoque'], $agora);

    for ($i = 0; $i < MESES_NO_GRAFICO; $i++) {
        $mes    = $primeiroMes->modify("+$i months");
        $chave  = $mes->format('Y-m');
        $rotulo = MESES_ABREV[(int) $mes->format('n') - 1] . '/' . $mes->format('y');

        $estoque[] = [
            'mes'     => $rotulo,
            'estoque' => isset($porMes[$chave]) ? (int) $porMes[$chave] : null,
        ];
    }

    /* 6) Quem gerencia o produto (administradores e gerentes).
          Fica em try próprio: se der problema aqui, o resto do modal ainda abre. */
    $responsaveis = [];
    try {
        $r = $pdo->prepare(
            "SELECT a.nome_administrador AS nome, 'Administrador' AS papel
               FROM gerencia_administrador_produto g
         INNER JOIN administrador a ON a.id_administrador = g.id_administrador
              WHERE g.id_produto = :id1 AND g.ativo_administrador_produto = 1
             UNION ALL
             SELECT ge.nome_gerente, 'Gerente'
               FROM gerencia_gerente_produto g
         INNER JOIN gerente ge ON ge.id_gerente = g.id_gerente
              WHERE g.id_produto = :id2 AND g.ativo_gerente_produto = 1"
        );
        $r->execute([':id1' => $id, ':id2' => $id]);
        $responsaveis = $r->fetchAll();
    } catch (PDOException $e) {
        error_log('Erro ao buscar responsáveis do produto: ' . $e->getMessage());
    }

    responder(true, 'OK', [
        'dados'        => $dados,
        'estoque'      => $estoque,
        'responsaveis' => $responsaveis,
    ]);

} catch (PDOException $e) {
    error_log('Erro ao buscar histórico do produto: ' . $e->getMessage());
    responder(false, 'Erro ao consultar o banco de dados.', [], 500);
}
