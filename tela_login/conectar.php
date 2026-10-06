<?php

session_start();

// Dados do banco
$host   = "localhost";
$user   = "root";
$pass   = "";
$banco  = "db_kdz";

// Conexão com o banco
$conn = mysqli_connect($host, $user, $pass, $banco);

if (!$conn) {
    die("Erro na conexão com o banco: " . mysqli_connect_error());
}

// Verifica se o formulário foi enviado
if ($_SERVER["REQUEST_METHOD"] == "POST") {

    $email = trim($_POST["email"]);
    $senha_digitada = $_POST["senha"];

    // Cargo => página de destino
    $destinos = [
        "funcionario"   => "../dashboardf/index.php",
        "gerente"       => "../dashboardg/index.php",
        "administrador" => "../dashboard/index.php"
    ];

    // 1) Procura em funcionario (funcionário e gerente)
    $sql = "SELECT f.id_funcionario AS id, f.nome_funcionario AS nome,
                   f.email_funcionario AS email, f.senha_funcionario AS senha_hash,
                   c.nome_cargo AS cargo
            FROM funcionario f
            LEFT JOIN cargo c ON c.id_cargo = f.idCargo
            WHERE f.email_funcionario = ?";

    $stmt = mysqli_prepare($conn, $sql);
    mysqli_stmt_bind_param($stmt, "s", $email);
    mysqli_stmt_execute($stmt);
    $dados = mysqli_fetch_assoc(mysqli_stmt_get_result($stmt));
    mysqli_stmt_close($stmt);

    // 2) Se não achou, procura em administrador
    if (!$dados) {
        $sql = "SELECT id_administrador AS id, nome_administrador AS nome,
                       email_administrador AS email, senha_administrador AS senha_hash,
                       'administrador' AS cargo
                FROM administrador
                WHERE email_administrador = ?";

        $stmt = mysqli_prepare($conn, $sql);
        mysqli_stmt_bind_param($stmt, "s", $email);
        mysqli_stmt_execute($stmt);
        $dados = mysqli_fetch_assoc(mysqli_stmt_get_result($stmt));
        mysqli_stmt_close($stmt);
    }

    // 3) Valida
    if (!$dados) {

        echo "Usuário não encontrado.";

    } elseif (!password_verify($senha_digitada, $dados["senha_hash"] ?? "")) {

        echo "Senha incorreta.";

    } else {

        // Cargo sem acento e em minúsculo
        $cargo = mb_strtolower(trim($dados["cargo"] ?? ""), "UTF-8");
        $cargo = strtr($cargo, [
            "á" => "a", "ã" => "a", "â" => "a",
            "é" => "e", "ê" => "e", "í" => "i",
            "ó" => "o", "ô" => "o", "õ" => "o",
            "ú" => "u", "ç" => "c"
        ]);

        if (isset($destinos[$cargo])) {

            session_regenerate_id(true);

            $_SESSION["id"]    = $dados["id"];
            $_SESSION["nome"]  = $dados["nome"];
            $_SESSION["email"] = $dados["email"];
            $_SESSION["cargo"] = $cargo;

            header("Location: " . $destinos[$cargo]);
            exit();

        } else {
            echo "Seu cargo não tem permissão de acesso.";
        }
    }
}

mysqli_close($conn);

?>