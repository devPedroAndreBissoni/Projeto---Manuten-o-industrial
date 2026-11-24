<?php
/*
 * resolver_usuario.php
 * Garante $_SESSION['usuario_id'] e $_SESSION['usuario_tipo'].
 * Se o login gravou só id/nome/email/cargo (sessão antiga ou conectar.php antigo),
 * descobre a pessoa pelo e-mail da sessão, na mesma ordem do login
 * (funcionario, administrador, gerente), e grava as duas chaves.
 * Nomes de tabela/coluna vêm desta lista fixa, nunca de dados digitados.
 */
function resolverUsuarioSessao(PDO $pdo): void
{
    if (!empty($_SESSION['usuario_id']) && !empty($_SESSION['usuario_tipo'])) {
        return;
    }
    $email = (string) ($_SESSION['email'] ?? '');
    if ($email === '') {
        return; // não está logado
    }

    $buscas = [
        'funcionario'   => ['funcionario',   'id_funcionario',   'email_funcionario',   'ativo_funcionario'],
        'administrador' => ['administrador', 'id_administrador', 'email_administrador', 'ativo_administrador'],
        'gerente'       => ['gerente',       'id_gerente',       'email_gerente',       'ativo_gerente'],
    ];

    foreach ($buscas as $tipo => [$tabela, $colId, $colEmail, $colAtivo]) {
        $st = $pdo->prepare("SELECT $colId FROM $tabela WHERE $colEmail = :e AND $colAtivo = 1 LIMIT 1");
        $st->execute([':e' => $email]);
        $id = $st->fetchColumn();
        if ($id !== false) {
            $_SESSION['usuario_id']   = (int) $id;
            $_SESSION['usuario_tipo'] = $tipo;
            return;
        }
    }
}