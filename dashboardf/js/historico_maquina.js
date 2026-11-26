/*
 * historico_maquina.js
 * Botão "Histórico" (relógio) da tela de Máquinas e Equipamentos:
 *  - abre o modal e busca os dados em historico_maquina.php (fetch)
 *  - gráfico de linha (Google Charts) do tempo médio entre falhas (MTBF) por mês
 *  - lista de todas as ordens da máquina com o responsável por cada uma
 *  - tudo montado com textContent (seguro contra HTML injetado)
 */
(function () {
    const modal = document.getElementById('modal-hm');
    const tbody = document.querySelector('.table-card tbody');
    if (!modal || !tbody) return;

    const csrf       = document.getElementById('hm-csrf').value;
    const carregando = document.getElementById('hm-carregando');
    const erro       = document.getElementById('hm-erro');
    const conteudo   = document.getElementById('hm-conteudo');
    const nomeEl     = document.getElementById('hm-nome');
    const tipoEl     = document.getElementById('hm-tipo');
    const grafico    = document.getElementById('hm-grafico');
    const lista      = document.getElementById('hm-lista');

    let gatilho = null;
    let pedido = 0;             // evita que uma resposta antiga sobrescreva uma mais nova
    let chartsPronto = false;   // Google Charts terminou de carregar?
    let linhasMtbf = null;      // últimos dados do gráfico (para redesenhar se necessário)

    /* ---------- Google Charts ---------- */

    if (window.google && google.charts) {
        google.charts.load('current', { packages: ['corechart'] });
        google.charts.setOnLoadCallback(() => {
            chartsPronto = true;
            // se o modal abriu antes da biblioteca terminar de carregar, desenha agora
            if (linhasMtbf && !modal.hidden) desenharGrafico(linhasMtbf);
        });
    }

    function mensagemGrafico(texto) {
        grafico.replaceChildren();
        const p = document.createElement('p');
        p.className = 'detalhes-vazio';
        p.textContent = texto;
        grafico.appendChild(p);
    }

    function desenharGrafico(linhas) {
        if (!window.google || !google.charts) {
            mensagemGrafico('Gráfico indisponível.');
            return;
        }
        if (!linhas || !linhas.some(l => l.mtbf !== null)) {
            mensagemGrafico('Sem falhas registradas nos últimos meses.');
            return;
        }
        if (!chartsPronto) return; // o callback acima desenha quando terminar de carregar

        const dados = new google.visualization.DataTable();
        dados.addColumn('string', 'Mês');
        dados.addColumn('number', 'MTBF (h)');
        dados.addColumn({ type: 'string', role: 'annotation' });
        linhas.forEach(l => {
            dados.addRow([l.mes, l.mtbf, l.mtbf === null ? null : String(l.mtbf).replace('.', ',') + ' h']);
        });

        const opcoes = {
            title: 'Tempo médio entre falhas (MTBF)',
            legend: { position: 'none' },
            colors: ['#1f1fe0'],
            lineWidth: 3,
            pointSize: 6,
            backgroundColor: 'transparent',
            chartArea: { left: 60, right: 20, top: 50, bottom: 50, width: '100%', height: '70%' },
            hAxis: { title: 'Meses' },
            vAxis: { title: 'Tempo médio de falha (horas)', minValue: 0 },
            annotations: { textStyle: { fontSize: 11 } }
        };

        grafico.replaceChildren();
        new google.visualization.LineChart(grafico).draw(dados, opcoes);
    }

    /* ---------- formatação e montagem ---------- */

    function formatarData(v) {
        if (!v) return '-';
        const d = new Date(String(v).replace(' ', 'T'));
        return isNaN(d) ? v : d.toLocaleString('pt-BR', { dateStyle: 'short', timeStyle: 'short' });
    }

    function itemLista(texto, detalhe) {
        const li = document.createElement('li');
        const a = document.createElement('span');
        a.textContent = texto;
        li.appendChild(a);
        if (detalhe) {
            const b = document.createElement('span');
            b.className = 'detalhes-item-sec';
            b.textContent = detalhe;
            li.appendChild(b);
        }
        lista.appendChild(li);
    }

    function montar(res) {
        nomeEl.textContent = res.maquina.nome;
        tipoEl.textContent = res.maquina.tipo;

        lista.replaceChildren();
        if (res.pessoas.length) {
            res.pessoas.forEach(o => {
                const partes = [formatarData(o.data), 'Urgência: ' + o.urgencia];
                if (o.manutencao) partes.push('Manutenção: ' + o.manutencao);
                itemLista((o.responsavel || '-') + ' · OS #' + o.id, partes.join(' · '));
            });
        } else {
            const li = document.createElement('li');
            li.className = 'detalhes-vazio';
            li.textContent = 'Nenhum atendimento registrado para esta máquina.';
            lista.appendChild(li);
        }
    }

    /* ---------- abrir / fechar / carregar ---------- */

    function estado(modo, mensagem) {
        carregando.hidden = modo !== 'carregando';
        erro.hidden = modo !== 'erro';
        conteudo.hidden = modo !== 'ok';
        if (modo === 'erro') erro.textContent = mensagem;
    }

    async function abrir(botao) {
        gatilho = botao;
        const meuPedido = ++pedido;
        linhasMtbf = null;

        estado('carregando');
        modal.hidden = false;
        document.body.classList.add('modal-aberto');
        modal.querySelector('.modal-close').focus();

        const fd = new FormData();
        fd.append('csrf_token', csrf);
        fd.append('id', botao.dataset.id);

        try {
            const resp = await fetch('historico_maquina.php', {
                method: 'POST',
                body: fd,
                headers: { 'Accept': 'application/json' }
            });
            const res = await resp.json();
            if (meuPedido !== pedido) return;

            if (!res.ok) {
                estado('erro', res.mensagem);
                return;
            }

            montar(res);
            estado('ok');                 // o conteúdo precisa estar VISÍVEL antes de desenhar
            linhasMtbf = res.mtbf;
            desenharGrafico(res.mtbf);
        } catch (e) {
            if (meuPedido !== pedido) return;
            estado('erro', 'Não foi possível se conectar ao servidor. Tente novamente.');
        }
    }

    function fechar() {
        pedido++; // descarta qualquer resposta que ainda esteja a caminho
        modal.hidden = true;
        document.body.classList.remove('modal-aberto');
        if (gatilho) gatilho.focus();
    }

    tbody.addEventListener('click', (e) => {
        const botao = e.target.closest('.btn-historico');
        if (botao) abrir(botao);
    });

    modal.addEventListener('click', (e) => {
        if (e.target === modal || e.target.closest('[data-fechar]')) fechar();
    });

    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape' && !modal.hidden) fechar();
    });
})();
