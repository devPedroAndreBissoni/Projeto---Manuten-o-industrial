<?php

session_start();

// Dados do banco
$host = "localhost";
$usuario = "root";
$senha = "";
$banco = "db_kdz";

// Conexão com o banco
$conn = mysqli_connect($host, $usuario, $senha, $banco);

// Verifica se a conexão funcionou
if (!$conn) {
    die("Erro na conexão com o banco: " . mysqli_connect_error());
}

// Verifica se o formulário foi enviado
if ($_SERVER["REQUEST_METHOD"] == "POST") {

    // Pega os dados digitados no formulário
    $email = $_POST["email"];
    $senha_digitada = $_POST["senha"];

    // Procura o usuário pelo email
    $sql = "SELECT id, email, senha, permissao FROM usuarios WHERE email = ?";

    // Prepara a consulta
    $stmt = mysqli_prepare($conn, $sql);

    // Coloca o email no ?
    mysqli_stmt_bind_param($stmt, "s", $email);

    // Executa a consulta
    mysqli_stmt_execute($stmt);

    // Pega o resultado
    $resultado = mysqli_stmt_get_result($stmt);

    // Verifica se encontrou o usuário
    if (mysqli_num_rows($resultado) == 1) {

        // Pega os dados do usuário
        $usuario = mysqli_fetch_assoc($resultado);

        // Verifica a senha
        if (password_verify($senha_digitada, $usuario["senha"])) {

            // Guarda informações do usuário na sessão
            $_SESSION["id"] = $usuario["id"];
            $_SESSION["email"] = $usuario["email"];
            $_SESSION["permissao"] = $usuario["permissao"];

            // Verifica a permissão
            if ($usuario["permissao"] == "funcionario") {

                header("Location: funcionario.php");
                exit();

            } elseif ($usuario["permissao"] == "gerente") {

                header("Location: gerente.php");
                exit();

            } elseif ($usuario["permissao"] == "administrador") {

                header("Location: administrador.php");
                exit();

            } else {

                echo "Permissão inválida.";
            }

        } else {

            echo "Senha incorreta.";
        }

    } else {

        echo "Usuário não encontrado.";
    }

    // Fecha a consulta
    mysqli_stmt_close($stmt);
}

// Fecha a conexão
mysqli_close($conn);

?>