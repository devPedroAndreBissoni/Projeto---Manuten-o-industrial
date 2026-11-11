/*
 * historico-status.js
 * Inativar e Ativar na tela de Histórico.
 *  - lixeira (btn-inativar): confirma no modal e envia para inativar.php
 *  - botão Ativar (btn-ativar): confirma no modal e envia para ativar.php
 *  - diferente das outras telas, a linha NÃO some: o selo de status muda
 *    (Ativo/Inativo) e o botão da linha troca (lixeira <-> ativar)
 *  - depois da troca, o filtro de Status é reaplicado (se estiver em "Ativo",
 *    uma linha recém-inativada sai da lista, e vice-versa)
 */
(function () {
    const tbody = document.querySelector('.table-card tbody');
    if (!tbody) return;

    function toast(mensagem, tipo) {
        const el = document.createElement('div');
        el.className = 'toast ' + (tipo === 'erro' ? 'toast-erro' : 'toast-ok');
        el.setAttribute('role', 'status');
        el.textContent = mensagem;
        document.body.appendChild(el);
        setTimeout(() => el.classList.add('saindo'), 2800);
        setTimeout(() => el.remove(), 3300);
    }

    /* Monta o botão que passa a valer depois da troca (mesmo HTML dos botões do historico.php) */
    function criarBotao(ativando, dados) {
        const btn = document.createElement('button');
        btn.type = 'button';
        btn.dataset.id = dados.id;
        btn.dataset.tipo = dados.tipo;
        btn.dataset.nome = dados.nome;

        const img = document.createElement('img');
        if (ativando) { // registro acabou de ser ATIVADO -> passa a mostrar a lixeira
            btn.className = 'btn-inativar';
            btn.setAttribute('aria-label', 'Inativar');
            btn.title = 'Inativar';
            img.src = 'img/lixo.svg';
            img.alt = 'desativar';
            img.className = 'inativar';
        } else {        // registro acabou de ser INATIVADO -> passa a mostrar o Ativar
            btn.className = 'btn-ativar';
            btn.setAttribute('aria-label', 'Ativar');
            btn.title = 'Ativar';
            img.src = 'img/ativar.svg';
            img.alt = 'ativar';
            img.className = 'ativar';
        }
        btn.appendChild(img);
        return btn;
    }

    /* Atualiza a linha: selo, data-status (usado pelo filtro) e botão */
    function atualizarLinha(linha, botaoAntigo, ativando) {
        const selo = linha.querySelector('.col-status .badge');
        if (selo) {
            selo.textContent = ativando ? 'Ativo' : 'Inativo';
            selo.className = 'badge ' + (ativando ? 'badge-ativo' : 'badge-inativo');
        }
        linha.dataset.status = ativando ? 'ativo' : 'inativo';

        const novo = criarBotao(ativando, {
            id: botaoAntigo.dataset.id,
            tipo: botaoAntigo.dataset.tipo,
            nome: botaoAntigo.dataset.nome
        });
        botaoAntigo.replaceWith(novo);

        // pede ao filtro-lista.js para reaplicar os filtros (ele escuta o "change" do select)
        const filtroStatus = document.getElementById('filtro-status');
        if (filtroStatus) filtroStatus.dispatchEvent(new Event('change'));
    }

    /* Cria o comportamento de um modal de confirmação.
       cfg: classe do botão da linha, id do modal, prefixo dos ids, arquivo PHP e textos. */
    function configurar(cfg) {
        const modal = document.getElementById(cfg.modalId);
        if (!modal) return;

        const csrf      = document.getElementById(cfg.prefixo + '-csrf').value;
        const nomeEl    = document.getElementById(cfg.prefixo + '-nome');
        const erro      = document.getElementById(cfg.prefixo + '-erro');
        const btnOk     = document.getElementById(cfg.prefixo + '-confirmar');
        const btnCancel = modal.querySelector('.modal-foot [data-fechar]');

        let gatilho = null;   // botão da linha que abriu o modal
        let enviando = false;

        function limparErro() {
            erro.hidden = true;
            erro.textContent = '';
        }

        function abrir(botao) {
            gatilho = botao;
            limparErro();
            nomeEl.textContent = botao.dataset.nome;
            modal.hidden = false;
            document.body.classList.add('modal-aberto');
            btnCancel.focus();
        }

        function fechar() {
            if (enviando) return;
            modal.hidden = true;
            document.body.classList.remove('modal-aberto');
            if (gatilho && document.body.contains(gatilho)) gatilho.focus();
        }

        // delegação no tbody: continua funcionando mesmo depois que os botões são trocados
        tbody.addEventListener('click', (e) => {
            const botao = e.target.closest('.' + cfg.classeBotao);
            if (botao) abrir(botao);
        });

        modal.addEventListener('click', (e) => {
            if (e.target === modal || e.target.closest('[data-fechar]')) fechar();
        });

        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape' && !modal.hidden) fechar();
        });

        btnOk.addEventListener('click', async () => {
            if (!gatilho || enviando) return;

            enviando = true;
            limparErro();
            btnOk.disabled = true;
            btnOk.textContent = cfg.textoEnviando;

            const fd = new FormData();
            fd.append('csrf_token', csrf);
            fd.append('tipo', gatilho.dataset.tipo);
            fd.append('id', gatilho.dataset.id);

            try {
                const resp = await fetch(cfg.arquivo, {
                    method: 'POST',
                    body: fd,
                    headers: { 'Accept': 'application/json' }
                });
                const res = await resp.json();

                if (!res.ok) {
                    erro.textContent = res.mensagem;
                    erro.hidden = false;
                    return;
                }

                const linha = gatilho.closest('tr');
                const botao = gatilho;
                enviando = false;   // libera o fechar()
                fechar();
                atualizarLinha(linha, botao, cfg.ativando);
                toast(res.mensagem, 'ok');
            } catch (err) {
                erro.textContent = 'Não foi possível se conectar ao servidor. Tente novamente.';
                erro.hidden = false;
            } finally {
                enviando = false;
                btnOk.disabled = false;
                btnOk.textContent = cfg.textoBotao;
            }
        });
    }

    configurar({
        classeBotao: 'btn-inativar', modalId: 'modal-inativar', prefixo: 'inativar',
        arquivo: 'inativar.php', ativando: false,
        textoBotao: 'Inativar', textoEnviando: 'Inativando...'
    });

    configurar({
        classeBotao: 'btn-ativar', modalId: 'modal-ativar', prefixo: 'ativar',
        arquivo: 'ativar.php', ativando: true,
        textoBotao: 'Ativar', textoEnviando: 'Ativando...'
    });
})();
