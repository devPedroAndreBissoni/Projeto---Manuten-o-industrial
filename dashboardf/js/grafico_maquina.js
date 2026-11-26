/*
 * grafico_maquina.js
 * Gráfico de pizza (Google Charts) dentro do modal de detalhes da máquina:
 *    horas funcionando x paradas nos últimos 30 dias.
 *  - carrega a biblioteca uma única vez
 *  - expõe window.desenharGraficoMaquina(linhas), chamada pelo listar_maquinas.js
 *    DEPOIS que o conteúdo do modal ficou visível (o Google Charts não consegue
 *    medir/desenhar dentro de um elemento escondido)
 *  - linhas = [['Funcionando', 612.5], ['Parada', 107.5]]  (rótulo, horas) vindas do PHP
 */
(function () {
    const container = document.getElementById('detalhes-grafico');
    if (!container) return;

    let pronto = false;     // biblioteca carregada?
    let pendente = null;    // pedido que chegou antes da biblioteca terminar de carregar

    function mensagem(texto) {
        container.replaceChildren();
        const p = document.createElement('p');
        p.className = 'detalhes-vazio';
        p.textContent = texto;
        container.appendChild(p);
    }

    function desenhar(linhas) {
        if (!linhas || !linhas.length) {
            mensagem('Sem dados para o gráfico.');
            return;
        }

        const dados = google.visualization.arrayToDataTable(
            [['Categoria', 'Quantidade']].concat(linhas)
        );

        const opcoes = {
            title: 'Funcionamento nos últimos 30 dias (horas)',
            colors: ['#0072B2', '#D55E00'],   // azul = funcionando, vermelhão = parada (distinguíveis no daltonismo)
            pieSliceText: 'percentage',
            legend: { position: 'bottom' },
            chartArea: { width: '90%', height: '70%' },
            backgroundColor: 'transparent'
        };

        container.replaceChildren();
        new google.visualization.PieChart(container).draw(dados, opcoes);
    }

    if (!window.google || !google.charts) {
        // loader.js bloqueado (sem internet, adblock...)
        window.desenharGraficoMaquina = () => mensagem('Gráfico indisponível.');
        return;
    }

    google.charts.load('current', { packages: ['corechart'] });
    google.charts.setOnLoadCallback(() => {
        pronto = true;
        if (pendente) {
            desenhar(pendente);
            pendente = null;
        }
    });

    window.desenharGraficoMaquina = function (linhas) {
        if (!pronto) {
            pendente = linhas;
            return;
        }
        desenhar(linhas);
    };
})();
