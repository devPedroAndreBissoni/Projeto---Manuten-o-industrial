/*
 * detalhes_produto.js
 * Modal de detalhes da tela de Produtos:
 *  - abre ao clicar no botão "Detalhes" (.btn-detalhes-produto) da linha
 *  - busca os dados em detalhes_produto.php (fetch)
 *  - monta o conteúdo com textContent (seguro contra HTML injetado)
 */
(function () {
    const modal = document.getElementById('modal-detalhes-produto');
    const tbody = document.querySelector('.table-card tbody');
    if (!modal || !tbody) return;

    const csrfEl     = document.getElementById('prod-detalhes-csrf');
    const csrf       = csrfEl ? csrfEl.value : '';
    const carregando = document.getElementById('prod-detalhes-carregando');
    const erro       = document.getElementById('prod-detalhes-erro');
    const conteudo   = document.getElementById('prod-detalhes-conteudo');
    const nomeEl     = document.getElementById('prod-detalhes-nome');
    const statusEl   = document.getElementById('prod-detalhes-status');
    const grid       = document.getElementById('prod-detalhes-grid');
    const listaResp  = document.getElementById('prod-detalhes-resp');

    // Confere se todos os elementos do modal existem; se faltar algum, diz qual
    const obrigatorios = {
        'prod-detalhes-carregando': carregando, 'prod-detalhes-erro': erro,
        'prod-detalhes-conteudo': conteudo, 'prod-detalhes-nome': nomeEl,
        'prod-detalhes-status': statusEl, 'prod-detalhes-grid': grid,
        'prod-detalhes-resp': listaResp
    };
    const faltando = Object.keys(obrigatorios).filter(id => !obrigatorios[id]);
    if (faltando.length) {
        console.error('detalhes_produto.js: faltam estes ids no HTML do modal:', faltando.join(', '));
        return;
    }

    let gatilho = null;
    let pedido = 0; // evita que uma resposta antiga sobrescreva uma mais nova

    /* ---------- formatação ---------- */

    function formatarData(v) {
        // 'YYYY-MM-DD' -> 'DD/MM/YYYY' (sem passar por Date, evita problema de fuso)
        const m = /^(\d{4})-(\d{2})-(\d{2})/.exec(String(v || ''));
        return m ? m[3] + '/' + m[2] + '/' + m[1] : (v || '-');
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
        campo('Data de produção', formatarData(d.data_producao));
        campo('Estoque', Number(d.estoque).toLocaleString('pt-BR'));

        listaResp.replaceChildren();
        if (res.responsaveis.length) {
            res.responsaveis.forEach(r => itemLista(listaResp, r.nome, r.papel));
        } else {
            listaVazia(listaResp, 'Nenhum responsável vinculado.');
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
            const resp = await fetch('detalhes_produto.php', {
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
        const botao = e.target.closest('.btn-detalhes-produto');
        if (botao) abrir(botao);
    });

    modal.addEventListener('click', (e) => {
        if (e.target === modal || e.target.closest('[data-fechar]')) fechar();
    });

    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape' && !modal.hidden) fechar();
    });
})();