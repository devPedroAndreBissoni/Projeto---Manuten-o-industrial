<?php
/*
 * funcionamento_util.php
 * Cálculos de funcionamento da máquina, usados pelos gráficos de máquinas
 * (historico_maquina.php e listar_maquinas.php).
 *
 * A tabela funcionamento_maquina guarda os PERÍODOS em que a máquina esteve funcionando
 * (inicio_funcionamento_maquina -> fim_funcionamento_maquina).
 */

/* Horas por dia em que a máquina deveria operar (ajuste conforme a fábrica).
   24 = opera o dia todo; se a fábrica trabalha em um turno de 8h, use 8. */
const HORAS_OPERACAO_DIA = 24;

/*
 * Horas em que a máquina FUNCIONOU dentro do período [$inicio, $fim).
 * Só conta a parte de cada registro que cai dentro do período.
 * Devolve null quando não há nenhum registro de funcionamento no período
 * (sem dados: diferente de "funcionou 0 horas").
 */
function horasFuncionando(PDO $pdo, int $idMaquina, DateTimeImmutable $inicio, DateTimeImmutable $fim): ?float
{
    $q = $pdo->prepare(
        "SELECT COUNT(*) AS n,
                COALESCE(SUM(TIMESTAMPDIFF(SECOND,
                    GREATEST(inicio_funcionamento_maquina, CAST(:ini1 AS DATETIME)),
                    LEAST(fim_funcionamento_maquina,       CAST(:fim1 AS DATETIME)))), 0) AS segundos
           FROM funcionamento_maquina
          WHERE id_maquina = :id
            AND inicio_funcionamento_maquina < CAST(:fim2 AS DATETIME)
            AND fim_funcionamento_maquina    > CAST(:ini2 AS DATETIME)"
    );
    $q->execute([
        ':id'   => $idMaquina,
        ':ini1' => $inicio->format('Y-m-d H:i:s'),
        ':ini2' => $inicio->format('Y-m-d H:i:s'),
        ':fim1' => $fim->format('Y-m-d H:i:s'),
        ':fim2' => $fim->format('Y-m-d H:i:s'),
    ]);
    $r = $q->fetch();

    if ((int) $r['n'] === 0) {
        return null;
    }
    return max(0.0, (float) $r['segundos'] / 3600);
}
