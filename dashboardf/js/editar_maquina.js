/*
 * editar_maquina.js
 * Controla o modal de edição da tela de Máquinas e Equipamentos:
 *  - abre o modal já preenchido com os dados da linha clicada
 *  - envia as alterações para editar_maquina.php (fetch)
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

    /* ---------- abrir / fechar ---------- */

    function abrirModal(botao) {
        gatilho = botao;
        linhaAtual = botao.closest('tr');
        const d = botao.dataset;

        limparErro();
        form.elements.id.value            = d.id;
        form.elements.nome.value          = d.nome;
        form.elements.tipo_maquina.value  = d.tipo;
        form.elements.funcionamento.value = d.funcionamento;

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
            const resposta = await fetch('editar_maquina.php', {
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

    /* Atualiza a linha, os data-attributes (usados pelos filtros e pelos outros botões)
       e as células da tabela com os novos valores */
    function atualizarLinha(dados) {
        if (!linhaAtual) return;

        linhaAtual.querySelector('.col-nome').textContent   = dados.nome;
        linhaAtual.querySelector('.col-tipo').textContent   = dados.tipo_maquina;
        linhaAtual.querySelector('.col-status').textContent = dados.funcionamento;

        // o filtro (js/filtros-lista.js) lê estes dois atributos da <tr>
        linhaAtual.dataset.tipo          = dados.tipo_maquina;
        linhaAtual.dataset.funcionamento = dados.funcionamento;

        const editar = linhaAtual.querySelector('.btn-editar');
        editar.dataset.nome          = dados.nome;
        editar.dataset.tipo          = dados.tipo_maquina;
        editar.dataset.funcionamento = dados.funcionamento;

        const detalhes = linhaAtual.querySelector('.btn-detalhes');
        if (detalhes) detalhes.dataset.tipo = dados.tipo_maquina;

        const inativar = linhaAtual.querySelector('.btn-inativar');
        if (inativar) inativar.dataset.nome = dados.nome;
    }
})();
