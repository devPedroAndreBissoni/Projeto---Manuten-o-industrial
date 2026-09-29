const modal = document.querySelector("#searchModal"); //O id dele tava como searchModal
const abrirbtn = document.querySelector(".search-trigger, .nav-item.search"); //Puxei a classe pq não coloquei id específico
const fecharbtn = document.querySelector(".close-search"); //O mesmo serve para fechar

abrirbtn.addEventListener("click", () =>
    {
        modal.classList.add("is-open");
    });

fecharbtn.addEventListener ("click", () =>{
    modal.classList.remove("is-open");
});