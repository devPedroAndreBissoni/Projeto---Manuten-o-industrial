<?php
    $proposal = [
        'title' => "Nossa proposta",
        'text' => "Esse é um sistema que preza manutenção Industrial de fábrica de brinquedos"
    ];
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tela-inicial</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<a href="../tela_login/index.php">login</a>

<main class="page">
    <header class = "topbar">
        <div class = "brand">
            <img src="img/logo.png" alt="Kidzy Brinquedos" class="logo"><!--classe da logo-->
        </div>
            <nav class="main-nav" aria-label="Navegação Principal">
                <button class="nav-item search trigger" type="button" aria-label="Pesquisar">
                    <span class="icon-circle" aria-hidden="true">
                        <span class="icon-search"></span>
                    </span>
                    <span>Pesquisar</span>
                </button>

                <button class="nav-item" type="button" data-action="contact">
                    <span class="icon circle" aria-hidden="true">
                        <span class="icon-phone"><img src="img/phone-call.png"> <!--mudei isso de emoji para ícone mas dai não posso esquecer de fazer alterações no css para imagem em vez de texto-->
                    </span>
                    <span>Contato</span>
                </button>

                <button class="nav-item" type="button" data-action="login">
                    <span class="icon-circle" aria-hidden="true">
                        <span class="icon-user"></span>
                    </span>
                    <span>login</span>
                </button>
            </nav>
    </header>

    <section class = "hero" aria-label="Introdução">
        <div class="hero-side hero-blue">
            <img class="decor blocks-left" src="img/blocos2.png" alt="briquedos jogados" aria-hidden="true">
        </div>

        <div class="hero-side hero-cream">
            <img class="decor blocks-right" src="img/blocos.png" alt="briquedos empilhados" aria-hidden="true">
        </div>

        <article class="proposal-card">
            <div class="proposal-image">
                <img src="img/brinquedos.png" alt="brinquedos de madeira empilhados">
            </div>
            
            <div class="proposal-content">
                <h1><?= htmlspecialchars($proposal['title'], ENT_QUOTES, 'UTF-8') ?></h1>
                <p><?= htmlspecialchars($proposal['text'], ENT_QUOTES, 'UTF-8') ?></p>
            </div>
        </article>
    </section>     
</main>

<div class = "search modal" id="searchModal" aria-hidden="true">
    <div class="search box" role="dialog" aria-modal="true" aria-labelledby="searchTitle">
        <button class="close-search" type="button" aria-label="Fechar">x</button>
        <h2 id="searchTitle">Pesquisar</h2>

        <div class="search-field">
            <input id="searchInput" type="search" placeholder="O que você procura?">
            <button id="searchButton" type="button">Buscar</button>
        </div>

        <p id="searchResult">Digite algo para pesquisar.</p>
    </div>
</div> 
</body>
</html>
