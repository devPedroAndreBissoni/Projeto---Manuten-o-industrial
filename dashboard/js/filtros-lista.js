/* Filtro genérico das listas de Máquinas e Produtos.
   - Busca por nome: lê a célula .col-nome de cada linha.
   - Selects com data-filtro="x": comparam o valor escolhido com o data-x da linha (<tr data-x="...">).
   - Só mexe nas linhas marcadas com data-filtravel; #sem-resultados aparece quando nada sobra. */
(function () {
    'use strict';

    var campoNome     = document.getElementById('filtro-nome');
    var selects       = Array.prototype.slice.call(document.querySelectorAll('select[data-filtro]'));
    var linhas        = Array.prototype.slice.call(document.querySelectorAll('tbody tr[data-filtravel]'));
    var semResultados = document.getElementById('sem-resultados');
    var form          = document.querySelector('form.filters');

    // minúsculas e sem acento, para "maquina" achar "Máquina"
    function normalizar(texto) {
        return String(texto || '')
            .toLowerCase()
            .normalize('NFD')
            .replace(/[\u0300-\u036f]/g, '')
            .trim();
    }

    function aplicar() {
        var busca    = normalizar(campoNome ? campoNome.value : '');
        var visiveis = 0;
        var ultima   = null;

        linhas.forEach(function (tr) {
            tr.classList.remove('ultima-visivel');

            var celula = tr.querySelector('.col-nome');
            var ok = normalizar(celula ? celula.textContent : '').indexOf(busca) !== -1;

            selects.forEach(function (sel) {
                if (sel.value !== '' && (tr.dataset[sel.dataset.filtro] || '') !== sel.value) {
                    ok = false;
                }
            });

            tr.hidden = !ok;
            if (ok) {
                visiveis++;
                ultima = tr;
            }
        });

        if (ultima) {
            ultima.classList.add('ultima-visivel'); // tira a borda da última linha visível
        }
        if (semResultados) {
            semResultados.hidden = visiveis > 0;
        }
    }

    if (campoNome) {
        campoNome.addEventListener('input', aplicar);
    }
    selects.forEach(function (sel) {
        sel.addEventListener('change', aplicar);
    });
    if (form) {
        // Enter no campo de busca não deve recarregar a página
        form.addEventListener('submit', function (e) { e.preventDefault(); });
    }

    aplicar();
})();