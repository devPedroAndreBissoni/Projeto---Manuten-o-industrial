/*
 * editar.js
 * Controla o modal de edição da tela de Funcionários:
 *  - abre o modal já preenchido com os dados da linha clicada
 *  - envia as alterações para editar.php (fetch)
 *  - atualiza a linha da tabela sem recarregar a página
 */
(function () {
    const modal    = document.getElementById('modal-editar');
    const form     = document.getElementById('form-editar');
    const erro     = document.getElementById('editar-erro');
    const btnSalvar = document.getElementById('editar-salvar');
    const tbody    = document.querySelector('.table-card tbody');

    if (!modal || !form || !tbody) return;

    let linhaAtual = null;   // <tr> que está sendo editada
    let gatilho = null;      // botão que abriu o modal (para devolver o foco)

    /* ---------- utilidades ---------- */

    function formatarTelefone(valor) {
        const v = valor.replace(/\D/g, '').slice(0, 11);
        if (v.length > 10) return v.replace(/(\d{2})(\d{5})(\d{0,4})/, '($1) $2-$3');
        if (v.length > 6)  return v.replace(/(\d{2})(\d{4})(\d{0,4})/, '($1) $2-$3');
        if (v.length > 2)  return v.replace(/(\d{2})(\d{0,5})/, '($1) $2');
        return v.length ? '(' + v : '';
    }

    function mostrarErro(mensagem, campo) {
        erro.textContent = mensagem;
        erro.hidden = false;
        form.querySelectorAll('.invalido').forEach(el => el.classList.remove('invalido'));
        if (campo && form.elements[campo]) {
            form.elements[campo].classList.add('invalido');
            form.elements[campo].focus();
        }
    }

    function limparErro() {
        erro.hidden = true;
        erro.textContent = '';
        form.querySelectorAll('.invalido').forEach(el => el.classList.remove('invalido'));
    }

    function toast(mensagem, tipo) {
        const el = document.createElement('div');
        el.className = 'toast ' + (tipo === 'erro' ? 'toast-erro' : 'toast-ok');
        el.setAttribute('role', 'status');
        el.textContent = mensagem;
        document.body.appendChild(el);
        setTimeout(() => el.classList.add('saindo'), 2800);
        setTimeout(() => el.remove(), 3300);
    }

    /* ---------- abrir / fechar ---------- */

    function abrirModal(botao) {
        gatilho = botao;
        linhaAtual = botao.closest('tr');
        const d = botao.dataset;

        limparErro();
        form.elements.tipo.value     = d.tipo;
        form.elements.id.value       = d.id;
        form.elements.nome.value     = d.nome;
        form.elements.email.value    = d.email;
        form.elements.telefone.value = formatarTelefone(d.telefone || '');

        // Administrador não tem cargo/setor editáveis
        const ehFuncionario = d.tipo === 'funcionario';
        modal.querySelectorAll('.campo-funcionario').forEach(el => { el.hidden = !ehFuncionario; });
        form.elements.id_cargo.disabled = !ehFuncionario;
        form.elements.id_setor.disabled = !ehFuncionario;
        if (ehFuncionario) {
            form.elements.id_cargo.value = d.cargo;
            form.elements.id_setor.value = d.setor;
        }

        modal.hidden = false;
        document.body.classList.add('modal-aberto');
        form.elements.nome.focus();
    }

    function fecharModal() {
        modal.hidden = true;
        document.body.classList.remove('modal-aberto');
        if (gatilho) gatilho.focus();
        linhaAtual = null;
    }

    tbody.addEventListener('click', (e) => {
        const botao = e.target.closest('.btn-editar');
        if (botao) abrirModal(botao);
    });

    modal.addEventListener('click', (e) => {
        // clique no fundo escuro ou nos botões com data-fechar
        if (e.target === modal || e.target.closest('[data-fechar]')) fecharModal();
    });

    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape' && !modal.hidden) fecharModal();
    });

    form.elements.telefone.addEventListener('input', (e) => {
        e.target.value = formatarTelefone(e.target.value);
    });

    /* ---------- salvar ---------- */

    form.addEventListener('submit', async (e) => {
        e.preventDefault();
        limparErro();

        // validação rápida no navegador (o servidor valida de novo)
        if (!form.checkValidity()) {
            form.reportValidity();
            return;
        }

        btnSalvar.disabled = true;
        btnSalvar.textContent = 'Salvando...';

        try {
            const resposta = await fetch('editar.php', {
                method: 'POST',
                body: new FormData(form),
                headers: { 'Accept': 'application/json' }
            });
            const dados = await resposta.json();

            if (!dados.ok) {
                mostrarErro(dados.mensagem, dados.campo);
                return;
            }

            atualizarLinha(dados);
            fecharModal();
            toast(dados.mensagem, 'ok');
        } catch (err) {
            mostrarErro('Não foi possível se conectar ao servidor. Tente novamente.');
        } finally {
            btnSalvar.disabled = false;
            btnSalvar.textContent = 'Salvar';
        }
    });

    /* Atualiza a linha da tabela e os data-attributes do botão com os novos valores */
    function atualizarLinha(dados) {
        if (!linhaAtual) return;

        linhaAtual.querySelector('.col-nome').textContent  = dados.nome;
        // a tela de Histórico não tem coluna de setor, por isso cada célula é opcional
        const celCargo = linhaAtual.querySelector('.col-cargo');
        const celSetor = linhaAtual.querySelector('.col-setor');
        if (celCargo) celCargo.textContent = dados.cargo;
        if (celSetor) celSetor.textContent = dados.setor;

        const botao = linhaAtual.querySelector('.btn-editar');
        botao.dataset.nome     = dados.nome;
        botao.dataset.email    = dados.email;
        botao.dataset.telefone = dados.telefone;
        if (dados.id_cargo) botao.dataset.cargo = dados.id_cargo;
        if (dados.id_setor) botao.dataset.setor = dados.id_setor;
    }
})();