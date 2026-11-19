/*
 * conta.js
 * Engrenagem do topo: abre o modal "Minha conta".
 *  - mostra os dados da conta (conta.php?acao=ver)
 *  - permite alterar e-mail e telefone (acao=salvar)
 *  - permite trocar a senha, exigindo a atual (acao=senha)
 */
(function () {
    const btnAbrir = document.getElementById('btn-conta');
    const modal    = document.getElementById('modal-conta');
    if (!btnAbrir || !modal) return;

    const carregando = document.getElementById('conta-carregando');
    const conteudo   = document.getElementById('conta-conteudo');
    const erroGeral  = document.getElementById('conta-erro');
    const grid       = document.getElementById('conta-grid');
    const nomeEl     = document.getElementById('conta-nome');
    const badge      = document.getElementById('conta-status');

    const formDados = document.getElementById('form-conta-dados');
    const formSenha = document.getElementById('form-conta-senha');
    const erroDados = document.getElementById('conta-dados-erro');
    const erroSenha = document.getElementById('conta-senha-erro');
    const btnDados  = document.getElementById('conta-dados-salvar');
    const btnSenha  = document.getElementById('conta-senha-salvar');
    const chkMostrar = document.getElementById('conta-mostrar-senha');

    let ocupado = false;

    /* ---------- utilidades ---------- */

    function toast(mensagem, tipo) {
        const el = document.createElement('div');
        el.className = 'toast ' + (tipo === 'erro' ? 'toast-erro' : 'toast-ok');
        el.setAttribute('role', 'status');
        el.textContent = mensagem;
        document.body.appendChild(el);
        setTimeout(() => el.classList.add('saindo'), 2800);
        setTimeout(() => el.remove(), 3300);
    }

    function mascaraCpf(v) {
        const d = String(v).replace(/\D/g, '').slice(0, 11);
        return d.replace(/(\d{3})(\d)/, '$1.$2')
                .replace(/(\d{3})(\d)/, '$1.$2')
                .replace(/(\d{3})(\d{1,2})$/, '$1-$2');
    }

    function mascaraTelefone(valor) {
        const v = String(valor).replace(/\D/g, '').slice(0, 11);
        if (v.length > 10) return v.replace(/(\d{2})(\d{5})(\d{0,4})/, '($1) $2-$3');
        if (v.length > 6)  return v.replace(/(\d{2})(\d{4})(\d{0,4})/, '($1) $2-$3');
        if (v.length > 2)  return v.replace(/(\d{2})(\d{0,5})/, '($1) $2');
        return v.length ? '(' + v : '';
    }

    function mostrarErro(form, el, mensagem, campo) {
        limparErro(form, el);
        el.textContent = mensagem;
        el.hidden = false;
        if (campo && form.elements[campo]) {
            form.elements[campo].classList.add('invalido');
            form.elements[campo].focus();
        }
    }

    function limparErro(form, el) {
        el.hidden = true;
        el.textContent = '';
        form.querySelectorAll('.invalido').forEach(i => i.classList.remove('invalido'));
    }

    function linha(rotulo, valor) {
        const dt = document.createElement('dt');
        dt.textContent = rotulo;
        const dd = document.createElement('dd');
        dd.textContent = valor || '—';
        grid.append(dt, dd);
    }

    /* Texto sempre entra com textContent (nada de innerHTML com dado do banco) */
    function preencher(d) {
        nomeEl.textContent = d.nome;
        badge.textContent = d.ativo ? 'Ativo' : 'Inativo';
        badge.className = 'badge ' + (d.ativo ? 'badge-ativo' : 'badge-inativo');

        grid.replaceChildren();
        linha('CPF', mascaraCpf(d.cpf));
        linha('Cargo / Permissão', d.cargo);
        linha('Setor', d.setor);
        linha('E-mail', d.email);
        linha('Telefone', mascaraTelefone(d.telefone));

        formDados.elements.email.value = d.email;
        formDados.elements.telefone.value = mascaraTelefone(d.telefone);
    }

    /* ---------- abrir / fechar ---------- */

    async function abrir() {
        formSenha.reset();
        limparErro(formDados, erroDados);
        limparErro(formSenha, erroSenha);
        trocarTipoSenha(false);
        erroGeral.hidden = true;
        conteudo.hidden = true;
        carregando.hidden = false;
        modal.hidden = false;
        document.body.classList.add('modal-aberto');

        try {
            const r = await fetch('conta.php?acao=ver', { headers: { 'Accept': 'application/json' } });
            const dados = await r.json();
            carregando.hidden = true;
            if (!dados.ok) {
                erroGeral.textContent = dados.mensagem;
                erroGeral.hidden = false;
                return;
            }
            preencher(dados.dados);
            conteudo.hidden = false;
            formDados.elements.email.focus();
        } catch (e) {
            carregando.hidden = true;
            erroGeral.textContent = 'Não foi possível carregar sua conta. Tente novamente.';
            erroGeral.hidden = false;
        }
    }

    function fechar() {
        if (ocupado) return;
        formSenha.reset(); // não deixa senha digitada na página
        modal.hidden = true;
        document.body.classList.remove('modal-aberto');
        btnAbrir.focus();
    }

    btnAbrir.addEventListener('click', abrir);

    modal.addEventListener('click', (e) => {
        if (e.target.closest('[data-fechar]')) fechar();
    });

    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape' && !modal.hidden) fechar();
    });

    /* ---------- máscara do telefone / mostrar senha ---------- */

    formDados.elements.telefone.addEventListener('input', (e) => {
        e.target.value = mascaraTelefone(e.target.value);
    });

    function trocarTipoSenha(mostrar) {
        chkMostrar.checked = mostrar;
        const tipo = mostrar ? 'text' : 'password';
        ['senha_atual', 'nova_senha', 'confirmar_senha'].forEach(n => { formSenha.elements[n].type = tipo; });
    }

    chkMostrar.addEventListener('change', () => trocarTipoSenha(chkMostrar.checked));

    /* ---------- envio ---------- */

    async function enviar(form, botao, textoBotao, erroEl) {
        ocupado = true;
        botao.disabled = true;
        botao.textContent = 'Salvando...';
        try {
            const r = await fetch('conta.php', {
                method: 'POST',
                body: new FormData(form),
                headers: { 'Accept': 'application/json' }
            });
            const dados = await r.json();
            if (!dados.ok) {
                mostrarErro(form, erroEl, dados.mensagem, dados.campo);
                return null;
            }
            return dados;
        } catch (e) {
            mostrarErro(form, erroEl, 'Não foi possível se conectar ao servidor. Tente novamente.');
            return null;
        } finally {
            ocupado = false;
            botao.disabled = false;
            botao.textContent = textoBotao;
        }
    }

    formDados.addEventListener('submit', async (e) => {
        e.preventDefault();
        if (ocupado) return;
        limparErro(formDados, erroDados);

        if (!formDados.checkValidity()) { formDados.reportValidity(); return; }

        const tel = formDados.elements.telefone.value.replace(/\D/g, '');
        if (tel.length < 10 || tel.length > 11) {
            mostrarErro(formDados, erroDados, 'O telefone deve ter DDD + número (10 ou 11 dígitos).', 'telefone');
            return;
        }

        const r = await enviar(formDados, btnDados, 'Salvar dados', erroDados);
        if (!r) return;

        // atualiza a lista de informações sem recarregar a página
        const dd = grid.querySelectorAll('dd');
        dd[4].textContent = r.email;
        dd[5].textContent = mascaraTelefone(r.telefone);
        toast(r.mensagem, 'ok');
    });

    formSenha.addEventListener('submit', async (e) => {
        e.preventDefault();
        if (ocupado) return;
        limparErro(formSenha, erroSenha);

        const f = formSenha.elements;
        if (!f.senha_atual.value) {
            mostrarErro(formSenha, erroSenha, 'Informe a senha atual.', 'senha_atual');
            return;
        }
        if (f.nova_senha.value.length < 8) {
            mostrarErro(formSenha, erroSenha, 'A nova senha deve ter pelo menos 8 caracteres.', 'nova_senha');
            return;
        }
        if (f.nova_senha.value !== f.confirmar_senha.value) {
            mostrarErro(formSenha, erroSenha, 'As senhas não conferem.', 'confirmar_senha');
            return;
        }

        const r = await enviar(formSenha, btnSenha, 'Alterar senha', erroSenha);
        if (!r) return;

        formSenha.reset();
        trocarTipoSenha(false);
        toast(r.mensagem, 'ok');
    });
})();