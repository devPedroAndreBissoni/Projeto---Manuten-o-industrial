<?php
/*
 * modal_ordem.php
 * Modal "Nova Ordem de Serviço". Usado por maquinas.php (botão da chave) e ordens.php (botão "Nova Ordem").
 * A página que inclui precisa ter: $csrf, $nomeUsuario, $maquinasOrdem (lista com 'id' e 'nome')
 * e já ter feito require 'ordens_config.php'. Quem controla o modal é o js/ordens.js.
 */

/* As variáveis abaixo vêm da página que faz o include. As linhas servem para o editor (VS Code)
   não sublinhar em vermelho e para a página não quebrar se alguma estiver ausente. */
/** @var string $csrf */
/** @var string $nomeUsuario */
/** @var array  $maquinasOrdem */
$csrf          = $csrf          ?? '';
$nomeUsuario   = $nomeUsuario   ?? '';
$maquinasOrdem = $maquinasOrdem ?? [];
?>
<!--Modal de nova ordem de serviço (js/ordens.js -> criar_ordem.php)-->
<div class="modal" id="modal-ordem" role="dialog" aria-modal="true" aria-labelledby="ordem-titulo" hidden
     data-problemas="<?= htmlspecialchars(json_encode(PROBLEMAS_MANUTENCAO, JSON_UNESCAPED_UNICODE), ENT_QUOTES) ?>">
    <div class="modal-card medio">
        <div class="modal-head">
            <h2 id="ordem-titulo">Nova Ordem de Serviço</h2>
            <button type="button" class="modal-close" data-fechar aria-label="Fechar">&times;</button>
        </div>

        <form id="form-ordem" autocomplete="off">
            <div class="modal-body">
                <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($csrf) ?>">

                <p class="modal-erro" id="ordem-erro" role="alert" hidden></p>

                <label class="field"> Máquina:
                    <select name="id_maquina" required>
                        <option value="" selected disabled>Selecione...</option>
                        <?php foreach ($maquinasOrdem as $mo): ?>
                        <option value="<?= (int) $mo['id'] ?>"><?= htmlspecialchars($mo['nome']) ?></option>
                        <?php endforeach; ?>
                    </select>
                </label>

                <div class="linha-2">
                    <label class="field"> Tipo de manutenção:
                        <select name="tipo_manutencao" required>
                            <option value="" selected disabled>Selecione...</option>
                            <?php foreach (TIPOS_MANUTENCAO as $t): ?>
                            <option value="<?= htmlspecialchars($t) ?>"><?= htmlspecialchars($t) ?></option>
                            <?php endforeach; ?>
                        </select>
                    </label>

                    <label class="field"> Urgência:
                        <select name="urgencia" required>
                            <option value="" selected disabled>Selecione...</option>
                            <?php foreach (URGENCIAS as $u): ?>
                            <option value="<?= htmlspecialchars($u) ?>"><?= htmlspecialchars($u) ?></option>
                            <?php endforeach; ?>
                        </select>
                    </label>
                </div>

                <!--As opções mudam conforme o tipo de manutenção escolhido-->
                <label class="field"> Problema:
                    <select name="problema" required disabled>
                        <option value="" selected disabled>Escolha o tipo de manutenção primeiro</option>
                    </select>
                </label>

                <label class="field"> Observações:
                    <textarea name="observacoes" rows="3" maxlength="240" placeholder="Detalhe o que está acontecendo (obrigatório se o problema for &quot;Outro&quot;)"></textarea>
                </label>

                <label class="field"> Responsável:
                    <input type="text" name="responsavel" required minlength="3" maxlength="100"
                           value="<?= htmlspecialchars($nomeUsuario) ?>">
                </label>
            </div>

            <div class="modal-foot">
                <button type="button" class="btn-secondary" data-fechar>Cancelar</button>
                <button type="submit" class="btn-primary" id="ordem-salvar">Criar ordem</button>
            </div>
        </form>
    </div>
</div>
