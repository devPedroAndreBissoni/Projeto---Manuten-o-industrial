<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="style.css">

</head>
<body>
        <div class = "brand">
            <img src="img/logo.png" alt="Kidzy Brinquedos" class="logo"><!--classe da logo-->
        </div>

<div class="container">
    
        <h2>Bem-vindo à Kidzy!</h2>
   
    <form class="login" action="salvar.php" method="POST">

        <div class="campo">
            <label for="email">Digite o seu email:</label>
            <input type="text" id="email" name="email" required>
        </div>
        <div class="campo">
            <label for="sobrenome">Digite a sua Senha:</label>
            <input type="text" id="senha" name="senha" required>
        </div>
            <button type="submit">Entrar</button>

    
    </form>

</div>

</body>
</html>