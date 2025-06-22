# Flutter e API

Esse é um projeto do curso de extensão da UNICESUMAR.

Nesso projeto estamos usando a FAKESTOREAPI : https://fakestoreapi.com/products

## Getting Started

## TELAS PRINCIPAIS DO APP
<div style="display: flex; gap: 10px;">
  <img src="/assets/screen_001.jpg" width="110px" height="210px">
  <img src="/assets/screen_002.jpg" width="110px" height="210px">
  <img src="/assets/screen_003.jpg" width="110px" height="210px">
</div>


## MEUS PEDIDOS, MEUS FAVORITOS E PERFIL
<div style="display: flex; gap: 10px;">
  <img src="/assets/screen_004.jpg" width="110px" height="210px">
  <img src="/assets/screen_005.jpg" width="110px" height="210px">
  <img src="/assets/screen_006.jpg" width="110px" height="210px">
</div>


<hr/>

🛍️ Loja Virtual Unicesumar
Aplicativo mobile multiplataforma desenvolvido com Flutter e GetX, simulando uma loja virtual completa com autenticação, listagem de produtos, sistema de favoritos, carrinho de compras e pedidos. Os dados são consumidos da API pública FakeStoreAPI.

📱 Interface do Aplicativo
🏠 Home - Produtos em Destaque
Exibe produtos com destaque visual, categorias navegáveis e botão rápido para adicionar ao carrinho ou aos favoritos.


🛒 Carrinho de Compras
Usuário pode visualizar os produtos adicionados, ajustar quantidades, limpar o carrinho ou finalizar o pedido.


🧾 Tela de Pedidos
Lista os pedidos realizados, com data, número de itens e valor total.


💜 Tela de Favoritos
Exibe os produtos marcados como favoritos, com opção de exclusão.


👤 Tela de Perfil
Mostra as informações da conta do usuário com opções para editar dados ou sair.


✏️ Editar Perfil
Permite ao usuário alterar dados pessoais e de conta, como nome, email e senha.


🔍 Detalhes do Produto
Apresenta imagem, descrição detalhada, preço e botão para adicionar ao carrinho.


🔧 Tecnologias Utilizadas
Flutter 3.x

GetX (estado, navegação e injeção de dependência)

REST API (FakeStoreAPI)

Programação reativa com Rx

Componentização de widgets

📁 Estrutura do Projeto


```txt
lib/
├── common/        # Helpers, temas, constantes
├── controllers/   # GetX Controllers
├── database/      # Integrações locais (ex: SQLite, se necessário)
├── models/        # Modelos baseados na API
├── repository/    # Repositórios remotos e locais
├── views/         # Telas do app
└── widgets/       # Componentes reutilizáveis
```



🎯 Funcionalidades
Login simulado e gerenciamento de usuário

Listagem e filtro por categorias

Favoritar e desfavoritar produtos

Carrinho com quantidade ajustável

Simulação de pedidos com data e valor total

Edição de perfil com dados pessoais e endereço


🧑‍💻 Desenvolvedor/Professor
Leonardo Tomaz da Silva - 24050985-2
André Roberto - 24050984-2

Video de apresentação do projeto: https://youtu.be/hNpYv_S7wtw

Inspirado em:
Rivaldo Roberto da Silva
Engenharia de Software - Unicesumar
Analista de Sistemas Sênior | Flutter | Java | APIs REST

▶️ Playlist das Aulas
Assista ao passo a passo do desenvolvimento na playlist:
🔗 YouTube - Loja Virtual https://www.youtube.com/playlist?list=PLMibyndz00bfPuBB5Q5qIsgegevRzBf07

