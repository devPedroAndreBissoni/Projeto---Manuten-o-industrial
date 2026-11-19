/*
 * filtros.js
 * Filtro da lista de funcionários, em tempo real (sem recarregar a página).
 * As três condições valem juntas:
 *   - nome: contém o texto digitado (ignora maiúsculas e acentos)
 *   - setor: id do setor escolhido (administradores não têm setor, então saem do filtro)
 *   - cargo: tipo do cargo escolhido (administrador / gerente / funcionario)
 */
(function () {
    const form     = document.querySelector('.filters');
    const campoNome  = document.getElementById('filtro-nome');
    const campoSetor = document.getElementById('filtro-setor');
    const campoCargo = document.getElementById('filtro-cargo');
    const corpo    = document.querySelector('.table-card tbody');
    const vazio    = document.getElementById('sem-resultados');
    if (!form || !campoNome || !campoSetor || !campoCargo || !corpo || !vazio) return;

    /* "João" e "joao" passam a ser iguais */
    function normalizar(texto) {
        return String(texto || '')
            .normalize('NFD')
            .replace(/[\u0300-\u036f]/g, '')
            .toLowerCase()
            .trim();
    }

    function linhas() {
        return Array.from(corpo.querySelectorAll('tr')).filter(tr => tr !== vazio);
    }

    function filtrar() {
        const nome  = normalizar(campoNome.value);
        const setor = campoSetor.value;
        const cargo = campoCargo.value;

        let visiveis = 0;
        let ultima = null;

        linhas().forEach(tr => {
            const nomeLinha = normalizar(tr.querySelector('.col-nome')?.textContent);

            const ok =
                (nome  === '' || nomeLinha.includes(nome)) &&
                (setor === '' || tr.dataset.setorId === setor) &&
                (cargo === '' || tr.dataset.cargoTipo === cargo);

            tr.hidden = !ok;
            tr.classList.remove('ultima-visivel');
            if (ok) { visiveis++; ultima = tr; }
        });

        if (ultima) ultima.classList.add('ultima-visivel'); // tira a linha de baixo do último item visível
        vazio.hidden = visiveis > 0;
    }

    campoNome.addEventListener('input', filtrar);
    campoSetor.addEventListener('change', filtrar);
    campoCargo.addEventListener('change', filtrar);

    // Enter no campo de busca não deve recarregar a página
    form.addEventListener('submit', (e) => {
        e.preventDefault();
        filtrar();
    });

    // Se uma linha for removida (inativar), o filtro se ajusta sozinho
    new MutationObserver(filtrar).observe(corpo, { childList: true });

    filtrar();
})();