/*
 * novo_maquina.js
 * Botão "Novo Registro" da tela de Máquinas e Equipamentos: abre o modal de cadastro.
 *  - checagem rápida no navegador (o servidor valida tudo de novo)
 *  - envia para criar_maquina.php; se der certo, recarrega a lista (já ordenada por nome)
 *    e mostra o aviso de sucesso depois do recarregamento
 */
(function () {
    const CHAVE_AVISO = 'kidzy_aviso';

    function toast(mensagem, tipo) {
        const el = document.createElement('div');
        el.className = 'toast ' + (tipo === 'erro' ? 'toast-erro' : 'toast-ok');
        el.setAttribute('role', 'status');
        el.textContent = mensagem;
        document.body.appendChild(el);
        setTimeout(() => el.classList.add('saindo'), 2800);
        setTimeout(() => el.remove(), 3300);
    }

    /* Aviso guardado antes do recarregamento da página */
    try {
        const aviso = sessionStorage.getItem(CHAVE_AVISO);
        if (aviso) {
            sessionStorage.removeItem(CHAVE_AVISO);
            toast(aviso, 'ok');
        }
    } catch (e) { /* sessionStorage indisponível: só não mostra o aviso */ }

    const modal   = document.getElementById('modal-novo');
    const btnNovo = document.getElementById('btn-novo');
    const form    = document.getElementById('form-novo');
    if (!modal || !btnNovo || !form) return;

    const erro      = document.getElementById('novo-erro');
    const btnSalvar = document.getElementById('novo-salvar');

    let enviando = false;

    /* ---------- erros ---------- */

    function limparErro() {
        erro.hidden = true;
        erro.textContent = '';
        form.querySelectorAll('.invalido').forEach(el => el.classList.remove('invalido'));
    }

    function mostrarErro(mensagem, campo) {
        limparErro();
        erro.textContent = mensagem;
        erro.hidden = false;
        if (campo && form.elements[campo]) {
            form.elements[campo].classList.add('invalido');
            form.elements[campo].focus();
        }
    }

    /* ---------- abrir / fechar ---------- */

    function abrir() {
        form.reset();
        limparErro();
        modal.hidden = false;
        document.body.classList.add('modal-aberto');
        form.elements.nome.focus();
    }

    function fechar() {
        if (enviando) return;
        form.reset();
        modal.hidden = true;
        document.body.classList.remove('modal-aberto');
        btnNovo.focus();
    }

    btnNovo.addEventListener('click', abrir);

    // Só fecha pelo X, por Cancelar ou Esc (clicar fora não descarta o que foi digitado)
    modal.addEventListener('click', (e) => {
        if (e.target.closest('[data-fechar]')) fechar();
    });

    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape' && !modal.hidden) fechar();
    });

    /* ---------- salvar ---------- */

    form.addEventListener('submit', async (e) => {
        e.preventDefault();
        if (enviando) return;
        limparErro();

        if (!form.checkValidity()) {
            form.reportValidity();
            return;
        }

        enviando = true;
        let recarregando = false;
        btnSalvar.disabled = true;
        btnSalvar.textContent = 'Salvando...';

        try {
            const resposta = await fetch('criar_maquina.php', {
                method: 'POST',
                body: new FormData(form),
                headers: { 'Accept': 'application/json' }
            });
            const dados = await resposta.json();

            if (!dados.ok) {
                mostrarErro(dados.mensagem, dados.campo);
                return;
            }

            recarregando = true;
            try { sessionStorage.setItem(CHAVE_AVISO, dados.mensagem); } catch (e2) { /* sem aviso */ }
            location.reload();
        } catch (err) {
            mostrarErro('Não foi possível se conectar ao servidor. Tente novamente.');
        } finally {
            if (!recarregando) {
                enviando = false;
                btnSalvar.disabled = false;
                btnSalvar.textContent = 'Cadastrar';
            }
        }
    });
})();
