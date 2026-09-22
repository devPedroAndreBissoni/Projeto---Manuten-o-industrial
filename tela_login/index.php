<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
        <style>
        /* Reseta as margens e define o box-sizing */
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            min-height: 50%; /* Ocupa 100% da altura da tela */
            padding: 0;
        }

        /* Estilo do corpo da página (Fundo e centralização) */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f0f4f8;
            display: flex;
            justify-content: left;
            align-items: center;

        }

        /* Caixa principal do formulário */
        .container {
            background-color: #FEF6DD;
            padding: 35px 40px;
            border-radius: 12px;
            width: 100%;
            max-width: 30vw;
            min-height: 100vh;
        }

        /* Título */
        .container h2 {
            text-align: center;
            color: #2d3748;
            margin-bottom: 25px;
            font-size: 1.8rem;
        }

        /* Div que engloba a label e o input */
        .campo {
            display: flex;
            flex-direction: column;
            margin-bottom: 18px;
        }

        /* Estilo dos textos descritivos */
        .campo label {
            font-weight: 600;
            margin-bottom: 6px;
            color: #4a5568;
            font-size: 0.95rem;
        }

        /* Estilo das caixas de texto e seleção */
        .campo input,
        .campo select {
            padding: 12px 15px;
            border: 1px solid #cbd5e0;
            border-radius: 8px;
            font-size: 1rem;
            color: #2d3748;
            background-color: #f8fafc;
            transition: all 0.3s ease;
        }

        /* Efeito ao clicar nas caixas de texto */
        .campo input:focus,
        .campo select:focus {
            outline: none;
            border-color: #D84C32;
            background-color: #FFFAEE;
            box-shadow: 0 0 0 3px rgba(66, 153, 225, 0.2);
        }

        /* Botão de cadastro */
        button[type="submit"] {
            width: 100%;
            padding: 14px;
            background-color:  #DE5D34;
            color: #ffffff;
            border: none;
            border-radius: 8px;
            font-size: 1.1rem;
            font-weight: bold;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            cursor: pointer;
            margin-top: 15px;
            transition: background-color 0.3s ease, transform 0.1s ease;
        }

        /* Efeito ao passar o mouse no botão */
        button[type="submit"]:hover {
            background-color: #DE5D34;
        }

        /* Efeito ao clicar no botão */
        button[type="submit"]:active {
            transform: scale(0.98);
        }

    </style>

</head>
<body>

<div class="container">

        <h2>Bem-vindo à Kidzy!</h2>
   
    <form action="salvar.php" method="POST">

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