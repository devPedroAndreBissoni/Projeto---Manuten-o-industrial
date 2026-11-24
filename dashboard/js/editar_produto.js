/*
 * editar_produto.js
 * Controla o modal de edição da tela de Produtos:
 *  - abre o modal já preenchido com os dados da linha clicada
 *  - envia as alterações para editar_produto.php (fetch)
 *  - atualiza a linha da tabela sem recarregar a página
 */
(function () {
    const modal     = document.getElementById('modal-editar');
    const form      = document.getElementById('form-editar');
    const erro      = document.getElementById('editar-erro');
    const btnSalvar = document.getElementById('editar-salvar');
    const tbody     = document.querySelector('.table-card tbody');

    if (!modal || !form || !tbody) return;

    let linhaAtual = null;   // <tr> que está sendo editada
    let gatilho = null;      // botão que abriu o modal (para devolver o foco)
    let enviando = false;

    /* ---------- utilidades ---------- */

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

    /* Estoque: só dígitos */
    form.elements.estoque.addEventListener('input', (e) => {
        e.target.value = e.target.value.replace(/\D/g, '').slice(0, 12);
    });

    /* ---------- abrir / fechar ---------- */

    function abrirModal(botao) {
        gatilho = botao;
        linhaAtual = botao.closest('tr');
        const d = botao.dataset;

        limparErro();
        form.elements.id.value            = d.id;
        form.elements.nome.value          = d.nome;
        form.elements.id_categoria.value  = d.categoria;
        form.elements.estoque.value       = d.estoque;
        form.elements.data_producao.value = d.producao;

        modal.hidden = false;
        document.body.classList.add('modal-aberto');
        form.elements.nome.focus();
    }

    function fecharModal() {
        if (enviando) return;
        modal.hidden = true;
        document.body.classList.remove('modal-aberto');
        if (gatilho) gatilho.focus();
        linhaAtual = null;
    }

    tbody.addEventListener('click', (e) => {
        const botao = e.target.closest('.btn-editar');
        if (botao) abrirModal(botao);
    });

    // Fecha pelo fundo escuro ou pelos botões com data-fechar
    modal.addEventListener('click', (e) => {
        if (e.target === modal || e.target.closest('[data-fechar]')) fecharModal();
    });

    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape' && !modal.hidden) fecharModal();
    });

    /* ---------- salvar ---------- */

    form.addEventListener('submit', async (e) => {
        e.preventDefault();
        if (enviando) return;
        limparErro();

        // validação rápida no navegador (o servidor valida de novo)
        if (!form.checkValidity()) {
            form.reportValidity();
            return;
        }

        if (form.elements.nome.value.trim().length < 3) {
            mostrarErro('O nome deve ter pelo menos 3 caracteres.', 'nome');
            return;
        }

        if (!/^\d+$/.test(form.elements.estoque.value)) {
            mostrarErro('Informe o estoque com números inteiros (0 ou mais).', 'estoque');
            return;
        }

        enviando = true;
        btnSalvar.disabled = true;
        btnSalvar.textContent = 'Salvando...';

        try {
            const resposta = await fetch('editar_produto.php', {
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
            enviando = false;
            fecharModal();
            toast(dados.mensagem, 'ok');
        } catch (err) {
            mostrarErro('Não foi possível se conectar ao servidor. Tente novamente.');
        } finally {
            enviando = false;
            btnSalvar.disabled = false;
            btnSalvar.textContent = 'Salvar';
        }
    });

    /* Atualiza a linha da tabela e os data-attributes dos botões com os novos valores */
    function atualizarLinha(dados) {
        if (!linhaAtual) return;

        linhaAtual.querySelector('.col-nome').textContent    = dados.nome;
        linhaAtual.querySelector('.col-producao').textContent = dados.producao;
        linhaAtual.querySelector('.col-estoque').textContent  = dados.estoque;
        linhaAtual.dataset.categoria = dados.id_categoria; // o filtro de categoria lê este valor

        const botao = linhaAtual.querySelector('.btn-editar');
        botao.dataset.nome      = dados.nome;
        botao.dataset.categoria = dados.id_categoria;
        botao.dataset.estoque   = dados.estoque;
        botao.dataset.producao  = dados.data_producao;

        const inativar = linhaAtual.querySelector('.btn-inativar');
        if (inativar) inativar.dataset.nome = dados.nome;
    }
})();