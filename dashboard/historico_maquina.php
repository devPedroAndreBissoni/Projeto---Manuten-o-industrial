<?php
/*
 * historico_maquina.php
 * Devolve (em JSON) o histórico de UMA máquina para o modal do botão "Histórico":
 *   - mtbf:   tempo médio entre falhas (MTBF) por mês, últimos 12 meses
 *   - pessoas: todas as ordens de serviço da máquina com o responsável por cada uma
 *
 * MTBF do mês = (tempo de operação - tempo parado) / número de falhas
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

/* ---------- configuração do cálculo ---------- */

const MESES_NO_GRAFICO  = 12;  // quantos meses aparecem no gráfico
const HORAS_OPERACAO_DIA = 24; // horas por dia em que a máquina deveria operar (ajuste conforme a fábrica)
const MESES_ABREV = ['jan', 'fev', 'mar', 'abr', 'mai', 'jun', 'jul', 'ago', 'set', 'out', 'nov', 'dez'];

/*
 * Tempo parado (em horas) da máquina dentro do período [$inicio, $fim).
 *
 * ATENÇÃO: o banco atual NÃO guarda quando a máquina parou nem quando voltou
 * (a ordem de serviço só tem a data de abertura). Por isso esta função devolve 0
 * e o MTBF sai como "tempo de operação / falhas".
 * Quando o banco novo tiver esses dados, é SÓ AQUI que se muda: faça um SELECT
 * somando (fim_da_parada - inicio_da_parada) em horas das paradas da máquina.
 */
function tempoParadoHoras(PDO $pdo, int $idMaquina, DateTimeImmutable $inicio, DateTimeImmutable $fim): float
{
    return 0.0;
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
    /* 4) A máquina precisa existir */
    $q = $pdo->prepare("SELECT nome_maquina AS nome, tipo_maquina AS tipo FROM maquina WHERE id_maquina = :id");
    $q->execute([':id' => $id]);
    $maquina = $q->fetch();

    if (!$maquina) {
        responder(false, 'Máquina não encontrada.', [], 404);
    }

    /* 5) MTBF por mês. Fica em try próprio: se falhar, a lista de pessoas ainda abre. */
    $mtbf = [];
    try {
        $agora      = new DateTimeImmutable('now');
        $primeiroMes = $agora->modify('first day of this month')->setTime(0, 0)
                             ->modify('-' . (MESES_NO_GRAFICO - 1) . ' months');

        /* Falhas por mês = ordens de serviço abertas para a máquina naquele mês */
        $f = $pdo->prepare(
            "SELECT DATE_FORMAT(o.datetime_ords, '%Y-%m') AS mes, COUNT(*) AS falhas
               FROM recebe_maquina_ords r
         INNER JOIN `ordem_de_serviço` o ON o.id_ords = r.id_ords
              WHERE r.id_maquina = :id AND o.datetime_ords >= :inicio
           GROUP BY mes"
        );
        $f->execute([':id' => $id, ':inicio' => $primeiroMes->format('Y-m-d H:i:s')]);
        $falhasPorMes = [];
        foreach ($f->fetchAll() as $linha) {
            $falhasPorMes[$linha['mes']] = (int) $linha['falhas'];
        }

        for ($i = 0; $i < MESES_NO_GRAFICO; $i++) {
            $inicio = $primeiroMes->modify("+$i months");
            $fim    = $inicio->modify('+1 month');
            $chave  = $inicio->format('Y-m');
            $rotulo = MESES_ABREV[(int) $inicio->format('n') - 1] . '/' . $inicio->format('y');

            $falhas = $falhasPorMes[$chave] ?? 0;
            $valor  = null; // mês sem falhas: MTBF não existe (o gráfico deixa o ponto vazio)

            if ($falhas > 0) {
                // no mês atual, só conta o tempo que já passou
                $fimReal  = $fim > $agora ? $agora : $fim;
                $horasMes = ($fimReal->getTimestamp() - $inicio->getTimestamp()) / 3600 * (HORAS_OPERACAO_DIA / 24);
                $parado   = tempoParadoHoras($pdo, $id, $inicio, $fimReal);
                $valor    = round(max(0.0, ($horasMes - $parado) / $falhas), 1);
            }

            $mtbf[] = ['mes' => $rotulo, 'mtbf' => $valor, 'falhas' => $falhas];
        }
    } catch (PDOException $e) {
        error_log('Erro ao calcular MTBF: ' . $e->getMessage());
        $mtbf = [];
    }

    /* 6) Todas as ordens da máquina com quem foi o responsável (mais recentes primeiro) */
    $pessoas = [];
    try {
        $p = $pdo->prepare(
            "SELECT o.id_ords               AS id,
                    o.datetime_ords         AS data,
                    o.urgencia_ords         AS urgencia,
                    o.nomeresponsavel_ords  AS responsavel,
                    mt.tipo_manutencao      AS manutencao
               FROM recebe_maquina_ords r
         INNER JOIN `ordem_de_serviço` o ON o.id_ords = r.id_ords
          LEFT JOIN manutencao mt ON mt.id_manutencao = o.`id_manutenção`
              WHERE r.id_maquina = :id
           ORDER BY o.datetime_ords DESC
              LIMIT 200"
        );
        $p->execute([':id' => $id]);
        $pessoas = $p->fetchAll();
    } catch (PDOException $e) {
        error_log('Erro ao buscar histórico da máquina: ' . $e->getMessage());
    }

    responder(true, 'OK', [
        'maquina' => $maquina,
        'mtbf'    => $mtbf,
        'pessoas' => $pessoas,
    ]);

} catch (PDOException $e) {
    error_log('Erro ao buscar histórico da máquina: ' . $e->getMessage());
    responder(false, 'Erro ao consultar o banco de dados.', [], 500);
}
