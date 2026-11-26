/*
 * historico_produto.js
 * Botão "Histórico" (relógio) da tela de Produtos:
 *  - abre o modal e busca os dados em historico_produto.php (fetch)
 *  - gráfico de barras (Google Charts) do estoque por mês
 *  - lista dos responsáveis (administradores e gerentes) pelo produto
 *  - tudo montado com textContent (seguro contra HTML injetado)
 */
(function () {
    const modal = document.getElementById('modal-historico');
    const tbody = document.querySelector('.table-card tbody');
    if (!modal || !tbody) return;

    const csrf       = document.getElementById('historico-csrf').value;
    const carregando = document.getElementById('historico-carregando');
    const erro       = document.getElementById('historico-erro');
    const conteudo   = document.getElementById('historico-conteudo');
    const nomeEl     = document.getElementById('historico-nome');
    const statusEl   = document.getElementById('historico-status');
    const grid       = document.getElementById('historico-grid');
    const grafico    = document.getElementById('historico-grafico');
    const listaResp  = document.getElementById('historico-resp');

    let gatilho = null;
    let pedido = 0;             // evita que uma resposta antiga sobrescreva uma mais nova
    let chartsPronto = false;   // Google Charts terminou de carregar?
    let linhasEstoque = null;   // últimos dados do gráfico (para desenhar quando a biblioteca carregar)

    /* ---------- Google Charts ---------- */

    if (window.google && google.charts) {
        google.charts.load('current', { packages: ['corechart'] });
        google.charts.setOnLoadCallback(() => {
            chartsPronto = true;
            // se o modal abriu antes da biblioteca terminar de carregar, desenha agora
            if (linhasEstoque && !modal.hidden) desenharGrafico(linhasEstoque);
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
        if (!linhas || !linhas.some(l => l.estoque !== null)) {
            mensagemGrafico('Sem dados de estoque para o gráfico.');
            return;
        }
        if (!chartsPronto) return; // o callback acima desenha quando terminar de carregar

        const dados = new google.visualization.DataTable();
        dados.addColumn('string', 'Mês');
        dados.addColumn('number', 'Estoque');
        dados.addColumn({ type: 'string', role: 'annotation' });
        linhas.forEach(l => {
            dados.addRow([l.mes, l.estoque, l.estoque === null ? null : l.estoque.toLocaleString('pt-BR')]);
        });

        const opcoes = {
            title: 'Estoque por mês',
            legend: { position: 'none' },
            colors: ['#1f1fe0'],
            backgroundColor: 'transparent',
            bar: { groupWidth: '60%' },
            chartArea: { left: 70, right: 20, top: 50, bottom: 50, width: '100%', height: '70%' },
            hAxis: { title: 'Meses' },
            vAxis: { title: 'Estoque (unidades)', minValue: 0 },
            annotations: { alwaysOutside: true, textStyle: { fontSize: 11 } }
        };

        grafico.replaceChildren();
        new google.visualization.ColumnChart(grafico).draw(dados, opcoes);
    }

    /* ---------- formatação e montagem ---------- */

    function formatarData(v) {
        if (!v) return '-';
        const d = new Date(String(v).replace(' ', 'T'));
        return isNaN(d) ? v : d.toLocaleDateString('pt-BR');
    }

    function campo(rotulo, valor) {
        const dt = document.createElement('dt');
        dt.textContent = rotulo;
        const dd = document.createElement('dd');
        dd.textContent = (valor === null || valor === undefined || valor === '') ? '-' : valor;
        grid.append(dt, dd);
    }

    function itemLista(lista, texto, detalhe) {
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
        const d = res.dados;

        nomeEl.textContent = d.nome;
        statusEl.textContent = d.ativo ? 'Ativo' : 'Inativo';
        statusEl.className = 'badge ' + (d.ativo ? 'badge-ativo' : 'badge-inativo');

        grid.replaceChildren();
        campo('Código', d.id);
        campo('Categoria', d.categoria);
        campo('Data de produção', formatarData(d.producao));
        campo('Estoque atual', d.estoque.toLocaleString('pt-BR'));

        listaResp.replaceChildren();
        if (res.responsaveis.length) {
            res.responsaveis.forEach(r => itemLista(listaResp, r.nome, r.papel));
        } else {
            const li = document.createElement('li');
            li.className = 'detalhes-vazio';
            li.textContent = 'Nenhum responsável vinculado.';
            listaResp.appendChild(li);
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
        linhasEstoque = null;

        estado('carregando');
        modal.hidden = false;
        document.body.classList.add('modal-aberto');
        modal.querySelector('.modal-close').focus();

        const fd = new FormData();
        fd.append('csrf_token', csrf);
        fd.append('id', botao.dataset.id);

        try {
            const resp = await fetch('historico_produto.php', {
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
            linhasEstoque = res.estoque;
            desenharGrafico(res.estoque);
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
