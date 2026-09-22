<?PHP

$host = "localhost";
$usuario = "root";
$senha = "";
$banco = "banco";

$connection = mysqli_connect($host, $usuario, $senha, $banco);

if (!$connection) {
    die("erro na conexão: " . mysqli_connect_error());
}

?>