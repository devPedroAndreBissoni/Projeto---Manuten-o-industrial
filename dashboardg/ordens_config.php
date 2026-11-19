<?php
/*
 * ordens_config.php
 * Listas FIXAS usadas pelas ordens de serviço (mesma ideia do STATUS_VALIDOS do editar_maquina.php).
 * Não existe tabela no banco para isso, então ficam aqui, num lugar só:
 * a tela (selects) e o criar_ordem.php (validação) leem estas mesmas listas.
 *
 * Onde cada valor é gravado (nenhuma tabela/coluna nova):
 *   tipo de manutenção + problema -> manutencao.tipo_manutencao / manutencao.descricao_manutencao
 *   urgência                      -> ordem_de_serviço.urgencia_ords
 */

const TIPOS_MANUTENCAO = ['Preventiva', 'Corretiva', 'Preditiva'];

/* Problemas possíveis de cada tipo de manutenção */
const PROBLEMAS_MANUTENCAO = [
    'Preventiva' => [
        'Inspeção periódica',
        'Lubrificação',
        'Limpeza geral',
        'Calibração / ajuste',
        'Troca de peças por desgaste',
        'Verificação elétrica',
        'Outro',
    ],
    'Corretiva' => [
        'Parada inesperada',
        'Ruído anormal',
        'Vibração excessiva',
        'Superaquecimento',
        'Vazamento de óleo ou fluido',
        'Falha elétrica',
        'Falha mecânica',
        'Falha em sensor / controle',
        'Outro',
    ],
    'Preditiva' => [
        'Análise de vibração',
        'Análise de óleo',
        'Termografia',
        'Monitoramento de desgaste',
        'Medição de consumo elétrico',
        'Outro',
    ],
];

const URGENCIAS = ['Baixa', 'Média', 'Alta', 'Urgente'];    