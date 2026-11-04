/*
 * detalhes.js
 * Modal de detalhes da tela de Funcionários:
 *  - abre ao clicar no botão "Detalhes" da linha
 *  - busca os dados completos em detalhes.php (fetch)
 *  - monta o conteúdo com textContent (seguro contra HTML injetado)
 */
(function () {
    const modal    = document.getElementById('modal-detalhes');
    const tbody    = document.querySelector('.table-card tbody');
    if (!modal || !tbody) return;

    const csrf       = document.getElementById('detalhes-csrf').value;
    const carregando = document.getElementById('detalhes-carregando');
    const erro       = document.getElementById('detalhes-erro');
    const conteudo   = document.getElementById('detalhes-conteudo');
    const nomeEl     = document.getElementById('detalhes-nome');
    const statusEl   = document.getElementById('detalhes-status');
    const grid       = document.getElementById('detalhes-grid');
    const secaoResp  = document.getElementById('detalhes-resp-secao');
    const listaResp  = document.getElementById('detalhes-resp');
    const listaOS    = document.getElementById('detalhes-os');

    let gatilho = null;
    let pedido = 0; // evita que uma resposta antiga sobrescreva uma mais nova

    /* ---------- formatação ---------- */

    function formatarCpf(v) {
        const d = String(v || '').replace(/\D/g, '');
        return d.length === 11 ? d.replace(/(\d{3})(\d{3})(\d{3})(\d{2})/, '$1.$2.$3-$4') : (v || '-');
    }

    function formatarTelefone(v) {
        const d = String(v || '').replace(/\D/g, '');
        if (d.length === 11) return d.replace(/(\d{2})(\d{5})(\d{4})/, '($1) $2-$3');
        if (d.length === 10) return d.replace(/(\d{2})(\d{4})(\d{4})/, '($1) $2-$3');
        return v || '-';
    }

    function formatarData(v) {
        if (!v) return '-';
        const d = new Date(String(v).replace(' ', 'T'));
        return isNaN(d) ? v : d.toLocaleString('pt-BR', { dateStyle: 'short', timeStyle: 'short' });
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
        campo('Tipo', d.tipo === 'administrador' ? 'Administrador' : 'Funcionário');
        campo('Código', d.id);
        campo('CPF', formatarCpf(d.cpf));
        campo('Telefone', formatarTelefone(d.telefone));
        campo('E-mail', d.email);
        campo('Cargo/Permissão', d.cargo);
        campo('Setor', d.setor);

        // Responsáveis: só existem para funcionários
        listaResp.replaceChildren();
        secaoResp.hidden = d.tipo !== 'funcionario';
        if (d.tipo === 'funcionario') {
            if (res.responsaveis.length) {
                res.responsaveis.forEach(r => itemLista(listaResp, r.nome, r.papel));
            } else {
                listaVazia(listaResp, 'Nenhum responsável vinculado.');
            }
        }

        // Ordens de serviço
        listaOS.replaceChildren();
        if (res.ordens.length) {
            res.ordens.forEach(o => itemLista(
                listaOS,
                'OS #' + o.id + ' · ' + formatarData(o.data),
                'Urgência: ' + o.urgencia + ' · Resp.: ' + o.responsavel
            ));
        } else {
            listaVazia(listaOS, 'Nenhuma ordem de serviço registrada.');
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
        fd.append('tipo', botao.dataset.tipo);
        fd.append('id', botao.dataset.id);

        try {
            const resp = await fetch('detalhes.php', {
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
        const botao = e.target.closest('.btn-detalhes');
        if (botao) abrir(botao);
    });

    modal.addEventListener('click', (e) => {
        if (e.target === modal || e.target.closest('[data-fechar]')) fechar();
    });

    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape' && !modal.hidden) fechar();
    });
})();