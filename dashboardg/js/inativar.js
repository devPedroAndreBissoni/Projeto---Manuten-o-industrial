/*
 * inativar.js
 * Inativação (exclusão lógica) na tela de Funcionários:
 *  - clique na lixeira abre um modal de confirmação
 *  - confirmando, envia para inativar.php (ativo = 0, nada é apagado do banco)
 *  - a linha some da tabela sem recarregar a página
 */
(function () {
    const modal     = document.getElementById('modal-inativar');
    const tbody     = document.querySelector('.table-card tbody');
    if (!modal || !tbody) return;

    const csrf      = document.getElementById('inativar-csrf').value;
    const nomeEl    = document.getElementById('inativar-nome');
    const erro      = document.getElementById('inativar-erro');
    const btnOk     = document.getElementById('inativar-confirmar');
    const btnCancel = modal.querySelector('.modal-foot [data-fechar]');

    let gatilho = null;   // botão (lixeira) que abriu o modal
    let enviando = false;

    function toast(mensagem, tipo) {
        const el = document.createElement('div');
        el.className = 'toast ' + (tipo === 'erro' ? 'toast-erro' : 'toast-ok');
        el.setAttribute('role', 'status');
        el.textContent = mensagem;
        document.body.appendChild(el);
        setTimeout(() => el.classList.add('saindo'), 2800);
        setTimeout(() => el.remove(), 3300);
    }

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
        btnCancel.focus(); // foco no "Cancelar": ação destrutiva nunca fica como padrão
    }

    function fechar() {
        if (enviando) return;
        modal.hidden = true;
        document.body.classList.remove('modal-aberto');
        if (gatilho && document.body.contains(gatilho)) gatilho.focus();
    }

    function removerLinha(linha) {
        linha.classList.add('removendo');
        setTimeout(() => {
            linha.remove();
            if (!tbody.querySelector('tr')) {
                const tr = document.createElement('tr');
                const td = document.createElement('td');
                td.colSpan = 4;
                td.className = 'center';
                td.textContent = 'Nenhum registro encontrado.';
                tr.appendChild(td);
                tbody.appendChild(tr);
            }
        }, 300);
    }

    tbody.addEventListener('click', (e) => {
        const botao = e.target.closest('.btn-inativar');
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
        btnOk.textContent = 'Inativando...';

        const fd = new FormData();
        fd.append('csrf_token', csrf);
        fd.append('tipo', gatilho.dataset.tipo);
        fd.append('id', gatilho.dataset.id);

        try {
            const resp = await fetch('inativar.php', {
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
            enviando = false;       // libera o fechar()
            fechar();
            removerLinha(linha);
            toast(res.mensagem, 'ok');
        } catch (err) {
            erro.textContent = 'Não foi possível se conectar ao servidor. Tente novamente.';
            erro.hidden = false;
        } finally {
            enviando = false;
            btnOk.disabled = false;
            btnOk.textContent = 'Inativar';
        }
    });
})();