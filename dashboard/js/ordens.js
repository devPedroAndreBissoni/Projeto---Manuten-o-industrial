/*
 * ordens.js
 * Ordens de serviço. Usado em duas telas:
 *   - maquinas.php: o botão da chave (.btn-manutencao) abre o modal "Nova Ordem" já com a máquina da linha.
 *   - ordens.php:   o botão "Nova Ordem" abre o mesmo modal; o botão de detalhes (.btn-detalhes)
 *                   abre o modal com as informações da ordem.
 * Envia para criar_ordem.php e detalhes_ordem.php (JSON).
 */
(function () {
    'use strict';

    var modalOrdem = document.getElementById('modal-ordem');
    var modalDet   = document.getElementById('modal-os-detalhes');
    var form       = document.getElementById('form-ordem');

    /* ---------- utilidades ---------- */
    function abrir(modal) {
        modal.hidden = false;
        document.body.classList.add('modal-aberto');
    }

    function fechar(modal) {
        modal.hidden = true;
        if (!document.querySelector('.modal:not([hidden])')) {
            document.body.classList.remove('modal-aberto');
        }
    }

    function toast(texto, ok) {
        var t = document.createElement('div');
        t.className = 'toast ' + (ok ? 'toast-ok' : 'toast-erro');
        t.textContent = texto;
        document.body.appendChild(t);
        setTimeout(function () { t.classList.add('saindo'); }, 2600);
        setTimeout(function () { t.remove(); }, 3100);
    }

    function mostrarErro(el, texto) {
        el.textContent = texto;
        el.hidden = false;
    }

    /* Fechar: botões [data-fechar], clique no fundo escuro e tecla Esc (só destes dois modais) */
    [modalOrdem, modalDet].forEach(function (modal) {
        if (!modal) return;
        modal.addEventListener('click', function (e) {
            if (e.target === modal || e.target.closest('[data-fechar]')) fechar(modal);
        });
    });
    document.addEventListener('keydown', function (e) {
        if (e.key !== 'Escape') return;
        [modalOrdem, modalDet].forEach(function (modal) {
            if (modal && !modal.hidden) fechar(modal);
        });
    });

    /* ---------- NOVA ORDEM ---------- */
    if (modalOrdem && form) {
        var problemas = {};
        try { problemas = JSON.parse(modalOrdem.dataset.problemas || '{}'); } catch (e) {}

        var selMaquina  = form.elements['id_maquina'];
        var selTipo     = form.elements['tipo_manutencao'];
        var selProblema = form.elements['problema'];
        var erro        = document.getElementById('ordem-erro');
        var btnSalvar   = document.getElementById('ordem-salvar');

        function limparErro() {
            erro.hidden = true;
            erro.textContent = '';
            Array.prototype.forEach.call(form.elements, function (c) { c.classList.remove('invalido'); });
        }

        /* O select "Problema" só mostra as opções do tipo de manutenção escolhido */
        function carregarProblemas() {
            var lista = problemas[selTipo.value] || [];
            selProblema.innerHTML = '';

            var ph = document.createElement('option');
            ph.value = '';
            ph.disabled = true;
            ph.selected = true;
            ph.textContent = lista.length ? 'Selecione...' : 'Escolha o tipo de manutenção primeiro';
            selProblema.appendChild(ph);

            lista.forEach(function (p) {
                var o = document.createElement('option');
                o.value = p;
                o.textContent = p;
                selProblema.appendChild(o);
            });
            selProblema.disabled = lista.length === 0;
        }

        selTipo.addEventListener('change', carregarProblemas);

        function abrirNovaOrdem(idMaquina) {
            form.reset();
            carregarProblemas();
            limparErro();
            if (idMaquina) selMaquina.value = String(idMaquina);
            abrir(modalOrdem);
            (idMaquina ? selTipo : selMaquina).focus();
        }

        document.addEventListener('click', function (e) {
            var chave = e.target.closest('.btn-manutencao');
            if (chave) {
                abrirNovaOrdem(chave.dataset.id);
                return;
            }
            if (e.target.closest('[data-abrir-ordem]')) abrirNovaOrdem(null);
        });

        form.addEventListener('submit', function (e) {
            e.preventDefault();
            limparErro();
            btnSalvar.disabled = true;

            fetch('criar_ordem.php', { method: 'POST', body: new FormData(form) })
                .then(function (r) { return r.json(); })
                .then(function (j) {
                    if (!j.ok) {
                        mostrarErro(erro, j.mensagem || 'Não foi possível criar a ordem.');
                        if (j.campo && form.elements[j.campo]) form.elements[j.campo].classList.add('invalido');
                        return;
                    }
                    fechar(modalOrdem);
                    toast(j.mensagem, true);
                    /* Na tela de ordens a lista precisa mostrar a nova linha */
                    if (modalDet) setTimeout(function () { location.reload(); }, 900);
                })
                .catch(function () {
                    mostrarErro(erro, 'Falha de conexão. Tente novamente.');
                })
                .then(function () { btnSalvar.disabled = false; });
        });
    }

    /* ---------- DETALHES (só existe na tela de ordens) ---------- */
    if (modalDet) {
        var carregando = document.getElementById('os-detalhes-carregando');
        var erroDet    = document.getElementById('os-detalhes-erro');
        var conteudo   = document.getElementById('os-detalhes-conteudo');
        var nomeEl     = document.getElementById('os-detalhes-nome');
        var urgEl      = document.getElementById('os-detalhes-urgencia');
        var grid       = document.getElementById('os-detalhes-grid');
        var listaSol   = document.getElementById('os-detalhes-solicitantes');
        var csrfDet    = document.getElementById('os-detalhes-csrf').value;

        function campo(rotulo, valor) {
            var dt = document.createElement('dt');
            dt.textContent = rotulo;
            var dd = document.createElement('dd');
            dd.textContent = (valor === null || valor === undefined || valor === '') ? '-' : valor;
            grid.appendChild(dt);
            grid.appendChild(dd);
        }

        function item(principal, secundario) {
            var li = document.createElement('li');
            var a = document.createElement('span');
            a.textContent = principal;
            li.appendChild(a);
            if (secundario) {
                var b = document.createElement('span');
                b.className = 'detalhes-item-sec';
                b.textContent = secundario;
                li.appendChild(b);
            }
            return li;
        }

        function classeUrgencia(u) {
            if (u === 'Baixa') return 'badge-ativo';
            if (u === 'Média') return 'badge-medio';
            return 'badge-inativo';
        }

        function preencher(j) {
            var d = j.dados;
            var nomesMaq = j.maquinas.map(function (m) { return m.nome; }).join(', ');

            nomeEl.textContent = 'Ordem nº ' + d.id;
            urgEl.textContent = d.urgencia;
            urgEl.className = 'badge ' + classeUrgencia(d.urgencia);

            grid.innerHTML = '';
            campo('Máquina', nomesMaq);
            campo('Modelo', j.maquinas.map(function (m) { return m.modelo; }).join(', '));
            campo('Tipo de manutenção', d.tipo);
            campo('Problema', d.descricao);
            campo('Data de abertura', d.data);
            campo('Responsável', d.responsavel);
            campo('Situação', d.ativo ? 'Ativa' : 'Inativa');

            listaSol.innerHTML = '';
            if (!j.solicitantes.length) {
                var vazio = item('Nenhum registro de quem abriu esta ordem.');
                vazio.className = 'detalhes-vazio';
                listaSol.appendChild(vazio);
            } else {
                j.solicitantes.forEach(function (s) { listaSol.appendChild(item(s.nome, s.papel)); });
            }
        }

        document.addEventListener('click', function (e) {
            var btn = e.target.closest('.btn-detalhes');
            if (!btn) return;

            carregando.hidden = false;
            erroDet.hidden = true;
            conteudo.hidden = true;
            abrir(modalDet);

            var dados = new FormData();
            dados.append('csrf_token', csrfDet);
            dados.append('id', btn.dataset.id);

            fetch('detalhes_ordem.php', { method: 'POST', body: dados })
                .then(function (r) { return r.json(); })
                .then(function (j) {
                    carregando.hidden = true;
                    if (!j.ok) { mostrarErro(erroDet, j.mensagem || 'Erro ao carregar.'); return; }
                    preencher(j);
                    conteudo.hidden = false;
                })
                .catch(function () {
                    carregando.hidden = true;
                    mostrarErro(erroDet, 'Falha de conexão. Tente novamente.');
                });
        });
    }
})();