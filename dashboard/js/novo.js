/*
 * novo.js
 * Botão "Novo Registro": abre o modal de cadastro de funcionário.
 *  - máscaras de CPF e telefone
 *  - checagem rápida no navegador (o servidor valida tudo de novo)
 *  - envia para criar.php; se der certo, recarrega a lista (já ordenada por nome)
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
    const chkMostrar = document.getElementById('novo-mostrar-senha');

    let enviando = false;

    /* ---------- máscaras ---------- */

    function mascaraCpf(valor) {
        const d = valor.replace(/\D/g, '').slice(0, 11);
        return d.replace(/(\d{3})(\d)/, '$1.$2')
                .replace(/(\d{3})(\d)/, '$1.$2')
                .replace(/(\d{3})(\d{1,2})$/, '$1-$2');
    }

    function mascaraTelefone(valor) {
        const v = valor.replace(/\D/g, '').slice(0, 11);
        if (v.length > 10) return v.replace(/(\d{2})(\d{5})(\d{0,4})/, '($1) $2-$3');
        if (v.length > 6)  return v.replace(/(\d{2})(\d{4})(\d{0,4})/, '($1) $2-$3');
        if (v.length > 2)  return v.replace(/(\d{2})(\d{0,5})/, '($1) $2');
        return v.length ? '(' + v : '';
    }

    form.elements.cpf.addEventListener('input', (e) => {
        e.target.value = mascaraCpf(e.target.value);
    });

    form.elements.telefone.addEventListener('input', (e) => {
        e.target.value = mascaraTelefone(e.target.value);
    });

    chkMostrar.addEventListener('change', () => {
        const tipo = chkMostrar.checked ? 'text' : 'password';
        form.elements.senha.type = tipo;
        form.elements.confirmar_senha.type = tipo;
    });

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
        form.reset();                       // limpa tudo, inclusive senhas de uma tentativa anterior
        form.elements.senha.type = 'password';
        form.elements.confirmar_senha.type = 'password';
        limparErro();
        modal.hidden = false;
        document.body.classList.add('modal-aberto');
        form.elements.nome.focus();
    }

    function fechar() {
        if (enviando) return;
        form.reset();                       // não deixa a senha digitada ficar na página
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

        if (form.elements.cpf.value.replace(/\D/g, '').length !== 11) {
            mostrarErro('Informe o CPF completo (11 dígitos).', 'cpf');
            return;
        }

        const tel = form.elements.telefone.value.replace(/\D/g, '');
        if (tel.length < 10 || tel.length > 11) {
            mostrarErro('O telefone deve ter DDD + número (10 ou 11 dígitos).', 'telefone');
            return;
        }

        if (form.elements.senha.value.length < 8) {
            mostrarErro('A senha deve ter pelo menos 8 caracteres.', 'senha');
            return;
        }

        if (form.elements.senha.value !== form.elements.confirmar_senha.value) {
            mostrarErro('As senhas não conferem.', 'confirmar_senha');
            return;
        }

        enviando = true;
        let recarregando = false;
        btnSalvar.disabled = true;
        btnSalvar.textContent = 'Salvando...';

        try {
            const resposta = await fetch('criar.php', {
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