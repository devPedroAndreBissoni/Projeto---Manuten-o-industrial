/*
 * historico_produto.js
 * Modal "Histórico" da tela de Produtos:
 *  - abre ao clicar no botão do relógio da linha
 *  - busca os dados em historico_produto.php (fetch)
 *  - mostra os dados do produto e quem é responsável por ele
 *  - monta o conteúdo com textContent (seguro contra HTML injetado)
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
    const listaResp  = document.getElementById('historico-resp');

    let gatilho = null;
    let pedido = 0; // evita que uma resposta antiga sobrescreva uma mais nova

    /* ---------- formatação ---------- */

    function formatarData(v) {
        const m = /^(\d{4})-(\d{2})-(\d{2})/.exec(String(v || ''));
        return m ? m[3] + '/' + m[2] + '/' + m[1] : '-';
    }

    /* ---------- montagem do conteúdo ---------- */

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

    function listaVazia(lista, texto) {
        const li = document.createElement('li');
        li.className = 'detalhes-vazio';
        li.textContent = texto;
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
        campo('Estoque', d.estoque);
        campo('Data de produção', formatarData(d.producao));

        listaResp.replaceChildren();
        if (res.responsaveis.length) {
            res.responsaveis.forEach(r => itemLista(
                listaResp,
                r.nome,
                r.papel + (r.ativo ? '' : ' · Inativo')
            ));
        } else {
            listaVazia(listaResp, 'Nenhum responsável registrado.');
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
            estado('ok');
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