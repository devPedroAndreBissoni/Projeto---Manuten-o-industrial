<?php
/* Encerra a sessão e volta para a tela de login.
   Recebe POST do botão "Sair" (modal Minha conta) com o token CSRF. */

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

// Caminho da tela de login a partir desta pasta (ajuste se a estrutura for diferente)
const URL_LOGIN = '../tela_login/index.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header('Location: index.php');
    exit;
}

$token = $_POST['csrf_token'] ?? '';
if (empty($_SESSION['csrf_token']) || !hash_equals($_SESSION['csrf_token'], (string) $token)) {
    http_response_code(403);
    exit('Requisição inválida.');
}

// Limpa os dados da sessão, apaga o cookie e destrói a sessão
$_SESSION = [];
if (ini_get('session.use_cookies')) {
    $p = session_get_cookie_params();
    setcookie(session_name(), '', time() - 42000, $p['path'], $p['domain'], $p['secure'], $p['httponly']);
}
session_destroy();

header('Location: ' . URL_LOGIN);
exit;