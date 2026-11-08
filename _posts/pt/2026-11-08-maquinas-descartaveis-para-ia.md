---
title: "Máquinas descartáveis para uso com IA"
ref: maquinas-descartaveis-para-uso-com-ia
date: 2026-11-08
tags: [ ai, engineering, lima-ai, vm ]
---

Trabalhar com IA se tornou uma realidade. Nada de novo nessa afirmação. Caso você use agentes de IA, como Claude Code, esse post é para você. Tentarei abordar a segurança de se utilizar um sistema com o claude, usando um conjunto grande de privilégios, mas sem abrir mão da segurança. Também isto é útil para prototipagem, vários projetos com docker compose numa mesma máquina, ou várias frentes de trabalho simultâneas com um mesmo projeto.

## Qual foi a motivação?

Hoje eu trabalho para uma empresa de consultoria internacional e não é incomum trabalhar em múltiplos projetos. Como exemplo, tinha dois projetos, que usavam portas similares e exportavam um serviço no mesmo range de portas. Não seria problema modificar as portas montadas, mas só o trabalho de fazer isso para todos os projetos, seria uma tarefa chata.

Também o que me motivou foi o fato de que eu não queria que o serviço do projeto em que eu estivesse trabalhando tivesse acesso completo a minha máquina. Hoje trabalho em um Macbook e não era incomum o claude me pedir permissões para acessar outras pastas do sistema. Isto estava me incomodando bastante.

Outro ponto também era que o modo `auto` [do claude](https://claude.com/resources/articles/auto-mode) faz uma curadoria dos comandos antes de executá-los, o que é bom, mas consome um pouco mais de tokens e ainda não é perfeito. O claude recomenda um ambiente isolado onde o estrago seja controlado.

Outra dor que eu tinha era acerca de testes de conceito e experimentação. Você pode me falar que usando os git worktrees o problema seria resolvido. Sim, mas em partes. Em um projeto com docker compose, como eu faria para segregar todo o sistema de maneira fácil e poder experimentar um tipo de ajuste de banco distinto, uma cadeia de migrações, ou até mesmo um dump diferente de dados, sem precisar reescrever muitos arquivos ou manter duas versões do banco em um mesmo docker compose?

## Solução encontrada: máquinas virtuais! Mas como?

Tá. Eu poderia criar uma máquina virtual para o trabalho. O problema disso era justamente o setup. Como pegar minhas chaves SSH, como copiar o projeto internamente de modo que eu pudesse usar o claude sem medo de ele invadir meu computador em busca de arquivos, e como eu poderia conectar nessa máquina virtual de maneira previsível? A sessão do claude rodaria lá dentro, mas o browser, o editor etc. estariam do lado de fora da VM.

Eu tentei iniciar usando um gerenciador de máquinas virtuais, como o [UTM](https://getutm.app/), mas isto me dava dor de cabeça pra configurar. Tinha que montar uma imagem base, depois instalar tudo nela, clonar quando precisasse, depois acessar... só que isso tornava o trabalho bastante moroso, principalmente para configurar acesso ao servidor, etc.

A solução encontrada veio por meio de pesquisa na internet. Lima VMs.

## LimaVM: Linux Machines

O projeto Lima [https://lima-vm.io/](https://lima-vm.io/) endereça parte dos problemas. Ele possui uma interface que lembra muito o `docker` cli, te dá a oportunidade de criar máquinas virtuais de maneira facilitada e possui vários projetos que usam sua base. Um dos que eu posso mencionar que faz o trabalho muito bem é o Colima [https://colima.run/](https://colima.run/). Por meio dele você consegue provisionar máquinas com docker instalado, sem complicação... podendo criar várias instâncias. Sem sobrecarregar o sistema com GUI com muitas coisas, ou necessidade de login como o Docker desktop.

Também uma coisa boa do Lima é o fato de ele simplificar drasticamente o acesso à máquina via ssh, montando as portas e provendo uma API que dá pra montar pastas internamente. Segundo o próprio site, a ideia do lima é a seguinte:

> Lima launches Linux virtual machines with automatic file sharing and port forwarding (similar to WSL2).

Lima lança máquinas virtuais com Linux com compartilhamento de arquivos automático e redirecionamento de portas (similar ao WSL2).

## Lima VM ajuda, mas ainda não é tudo

Fiz uns testes com o projeto lima e ele funciona muito bem, mas ainda se fazia necessário eu criar uma imagem, clonar, importar as credenciais, instalar o claude, autenticá-lo, instalar docker, para depois poder funcionar com o projeto. Depois de pensar um pouco, pensei: por que não criar uma solução para o problema? Foi aí que surgiu o Lima-AI.

## Lima-ai: ambiente isolado para o Claude

[https://lima-ai.readthedocs.io/en/latest/](https://lima-ai.readthedocs.io/en/latest/)

Bom, inicialmente foi feito para o Claude Code, mas poderemos expandir para qualquer outro sistema de agente de código. Foi justamente pensando nas dores de se iniciar um sistema para codificar que eu resolvi "vibe code" o sistema, mas atuando como um validador do código gerado, garantindo sua qualidade.

**Observação importante**: esse projeto não possui relação com a organização por trás do projeto do Lima. O projeto é open source e visa melhorar a experiência de quem trabalha com o Claude.

O que ele faz é basicamente o que eu pontuei como as dores em uma seção mais acima desse texto: ele cria uma VM base para você, com o claude, docker, algumas ferramentas úteis como o [RTK](https://github.com/rtk-ai/rtk) (para ajudar a economizar tokens), trata de injetar um token que pode ser utilizado na máquina virtual, assim como copia sua chave SSH e importa suas configurações do claude para poder trabalhar.

Outra coisa que eu fiz, que se diferencia de uma máquina com LimaVM é que eu trato a instância como completamente independente, sem `port forwarding`, ou seja, eu atribuo a ela um nome de domínio por onde você fará o acesso. O nome do projeto + workspace (se o projeto estiver funcionando com git, ele já sugere uma branch para o mesmo).

Recomendo fortemente que vocês, caso tenham curiosidade, [vejam o quickstart](https://lima-ai.readthedocs.io/en/latest/quickstart/) do projeto. Inclusive o nome de domínio criado fica no banner assim que o projeto é criado. Ainda darei uma revisada no código de modo a garantir sua consistência, mas ele já se encontra funcional.

## Próximos passos

Bom. Agora espero divulgar essa ferramenta e dar manutenção nela de modo a cobrir mais cenários de uso, substituindo as partes criadas por IA por uma linguagem mais humana. Como disse anteriormente, trata-se de um projeto vibecoded, mas com a supervisão de um desenvolvedor de softwares.

Obrigado pelo seu tempo e tenha um ótimo final de dia.