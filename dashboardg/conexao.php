<?php
$host = 'localhost';
$db   = 'db_kdz';
$user = 'root';   // ajuste para o seu usuário do MySQL
$pass = '';       // ajuste para a sua senha

try {
    $pdo = new PDO("mysql:host=$host;dbname=$db;charset=utf8mb4", $user, $pass, [
        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    ]);
} catch (PDOException $e) {
    die('Erro ao conectar ao banco: ' . $e->getMessage());
}