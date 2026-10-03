---
title: "Meu relacionamento com IA"
ref: meu-relacionamento-com-ia
date: 2026-09-26
tags: [ ai, ai-relationship-serie, engineering, workflow ]
---

Bom, vou compartilhar uma história sobre minha introdução à utilização de LLMs. Meus pensamentos, 
e observações. Vou tentar criar uma série onde irei explorar os pontos, senão isto aqui vai ficar muito grande.

# O escopo

Tudo começa com uma negativa de um projeto onde eu estava inserido. Trabalhava em uma iniciativa na 
qual precisava criar uma API HTTP JSON para um software que, incialmente, foi feito em linha de 
comando que criava workflows. O ponto é que o desenvolvimento precisava ser compatível com o 
programa em linha de comando, e também suportar novos modos de rodar um workflow.

O time, à época, estava muito centrado em ganhar velocidade, e utilizaram o Claude (via Claude 
code) para as atividades. A utilização de IA era mais que incentivada na companhia, mas nenhuma 
estratégia ou fluxo era definido. Inclusive a criação do aplicativo em linha de comando trazia 
o legado de um Software que não seguia boas práticas. Havia um FORTE acoplamento de código de 
modo a se tornar impraticável o desenvolvimento rápido de novas features sem uma utilização massiva 
de IA.

# O problema

Tínhamos um prazo apertado e algumas implementações a serem feitas. Como exemplo tinhamos que 
suportar um workflow de uma tecnologia A e precisaríamos implementar de uma tecnologia B, mas 
seguindo uma configuração curiosa, onde elas deveriam conversar.

* Tecnologia A
  * Carregava à partir de um arquivo individualmente
  * Carregava à partir de um projeto em ZIP
  * Carregava à partir de um link RAW de um github apontando para um arquivo de pipeline;
* Tecnologia B atendia aos mesmos critérios, só que não carregava do arquivo individualmente, apenas em um formato de pipeline X.

No final das contas, pra não export tanto os detalhes, tinhamos duas tecnologias, que lidavam com dois tipos distintos de linguagem de pipeline.

| Linguagem    | X (legada) | Y (moderna) |
| ------------ | ---------- | ----------- |
| Tecnologia A | Funciona   | -           |
| Tecnologia B | Funciona   | Funciona    |

A tecnologia B, na linguagem moderna, não suportava carregar de arquivos.

Tinhamos incialmente até que uma configuração pensada na flexibilidade, mas que ganhou uma camada horrível de design de software. Uma classe inchada que herdava por tecnologia, mas que não implementava suporte às linguagens modernas. Pior, havia um método que invocava as funções cujo os parâmetros passavam de 8. Mas esse esse foi o primeiro elo do problema. 8 parâmetros dos quais, 3 ou 4 eram utilizados por tipo, a saber.

* Se eu mandasse um arquivo,
  * Eu podia esperar os parametros de entrada, e tudo certo.
* Se eu mandasse um arquivo ZIP, 
  * Eu teria que esperar onde está, dentro do zip, o `entrypoint` do mesmo, assim como os parâmetros.
* Se eu mandasse um link do github, 
  * Eu precisaria me assegurar que era um link válido, depois o endpoint, depois os parâmetros, etc.

Certamente havia uma inconsistência no projeto. Pior, as classes que realizavam a tarefa de criar o workflow e inciar a tarefa eram extremamente acopladas à classe inchada.

> **Vários métodos em uma classe não significa baixo acoplamento.**

O ponto que me motivou a justamente me forçar um refactor foi justamente o fato de compreender que o código estava estritamente acoplado, injetando dependências onde não precisava, criando um atrito desnecessário que só cresceu com a utilização de IA.

## Ta, mas o que tem a ver a IA com sua introdução?

Em resumo o projeto foi renovado, mas eu acabei saindo do projeto. Não pela qualidade técnica, mas pela falta de performance que eles queriam, justamente por que estavam impulsionados pela utilização de agentes de IA.

Em resumo, passei um certo tempo justamente quebrando as classes em outras menores, mas especialistas, onde eu conseguia trabalhar de maneira desacoplada. Por exemplo, ao fornecer um arquivo ZIP eu criei uma classe que cuidava de todo o processo de abertura e fechamento do arquivo, não sendo necessário criar essa lógica em todo o lugar que fazia uso desse tipo de arquivo. Também para o repositório do git, criar uma class to tipo

```python
GithubProjectLoader().from_raw_url(link="...")
```

Me dava a flexibilidade de validar o projeto do github antemão e criar uma camada de abstração que, dependente da Tecnologia utilizada, eu conseguiria parametrizar para as classes de execução daquela tecnologia especifica, adapatando a chamada para o destino.

Resultado dessa aplicação, meu refactor simplificou o processo tornando-o mais fácil de ler. Adicionei 1000 linhas e removi outras 3000.

Quando eu estava numa semana entre projetos, eu resolvi fazer uma imersão nos agentes de IA, e resolvi criar um projeto interno da empresa, onde eu conseguiria por em prática meus conhecimentos (e infelizmente contribuir um pouco mais para a conta de energia mais cara nos Estados Unidos)

## Virando a chave

O ato de trabalhar com LLMs começou devagar: pequenos trechos de código, gerar documentação, criar e executar suítes de teste... Estes foram meus primeiros passos, mas percebi que ainda podia ganhar mais velocidade. Daí veio a ideia de usar LLMs agênticas para o resgate. Instalei o Claude Code e comecei pequeno.

No inicio realizei uma pesquisa prévia das melhores práticas. Vi que usar uma abordagem spec driven e ser o mais objetivo nos prompts faz com que o resultado seja bastante satisfatório.

Também o ato de se criar ferramentas de testar a qualidade do software gerado contribui drasticamente para uma melhora de um projeto a longo prazo ou cujo o codebase se torna grande o bastante.

Assim o fiz. Iniciei um projeto no qual eu sabia fazê-lo manualmente. Dei todos os passos e separei por contextos pequenos e delimitados. Com isso evitaria com que a LLM se desviasse para o caminho de gerar código ruim. Também adicionei à isto o fato de que ao criar um bom `CLAUDE.md` eu conseguiria evitar alguns padrões ruins, ou a necessidade de ser explicito toda vez que eu iria gerar um código novo.

Acho que farei um novo post sobre as dicas. Por ora irei focar na parte mais conteitual.

## Os resultados

Bom. Ao utillizar a IA para o trabalho minha produtividade aumentou drasticamente ao custo de um gasto cognitivo elevado. É dificil sempre trabalhar na especificação, principalmente quando se está projetando uma solução mais robusta. No final código se tornou uma commodity. O que você projeta ainda é seu. Sua assinatura pessoal. O reflexo do seu trabalho.

### Deixou de ser divertido?

A conquista, a experimentação para se fazer um programa funcionar... Ler uma API por dias e depois implementar e ter aquela satisfação pessoal? Sim, acho que vendo por essa perspectiva, sim. As coisas ficaram mais alto nível. Você enxerga funcionalidades completas ao invés de trechos de código. Ler código gerado se tornou uma tarefa inglória, principalmente quando o modelo possui uma certa preferência por alguns tipos específicos. Não é incomum em python um retorno vir em forma de list comprehension, por exemplo. Em alguns casos essa forma não seria a mais legível.

Também se você não "calibrar" seu agente de IA para trabalhar corretamente, voce irá inevitavelmente criar um código que não é consistente. Digo "consistente" quando ele poderá ter resultados ou estratégias de resolução de maneira imprevisível, dado justamente a natureza não determinística das LLMs. 

### "Inteligências Artificiais" potencializam o profissional

Circulou na internet o termo do "desenvolvedor 10x", onde quando assistido por IA, ele chegaria a ter 10x da performance habitual. Na minha opinião, acho que não chega a tanto. No máximo 2,5x. Mas isto é, quando utilizado de maneira correta, unindo o aprendizado e toque humano à facilidade e criação da máquina. Infelizmente pessoas não desenvolvedoras passaram a venerar a IA como uma ótima solução pelo fato de criar soluções que resolvem problemas pontuais, mas não se tocaram que na verdade não estavam desenvolvendo código, mas sim gerando SLOP, ou seja, código desleixado, com pouco ou nenhum critério. 

É sabido que um código que incrementa ao longo do tempo pode se tornar um problema para manter caso voce não estabeleça formas de se garantir a evolução do projeto. Tudo depende de como você "pede" para as LLMs.

Não me canso de ver profissionais medíocres gerando código desleixado, ou gurus vendendo cursos de IA. Bom... o que falar sobre essa galera? Acho que merecem um post à parte. 

O que eu quero concluir é: voce pode ser um profissional 2,5x mais medíocre.

### O que pedir passa por entender o que você quer primeiramente

Parece algo estúpido, mas conversei com um grande amigo que não é uma pessoa técnica. Ele é mais de negócios, mas potencializou seu trabalho com a utilização de IA, o que é, em si, louvável. Uma pessoa extremamente inteligente e que quer o trabalho pronto. O cara que está no timming de startups. (acho que merece um outro post falando sobre minha experiencia em um projeto que fracassou).

Certa vez estavamos em uma lanchonete e ele me falou, empolgado, que estava fazendo um curso de IA para aprender a fazer melhores prompts. O que eu contra-argumentei é que, para se desenvolver um bom repertório de prompts voce precisa, necessariamente, aprender a como sistemas funcionam. Pra isso é inevitavel estudar programação.

### As pessoas se tornaram intelectualmente mais preguiçosas

Acho que o grande problema de se implementar coisas utilizando IAs é que toda velocidade e produtividade cobra um preço caro: pessoas se tornam preguiçosas e acabam recorrendo à ferramenta sempre que possível. Isso gera um vício silencioso que, caso a bolha de IA estoure, vai gerar uma série de profissionais que passarão a ter um grande problema pela frente. Um apagão, ou grande "rollback".

### IA não é barata e certamente é uma bolha

Hoje o que consumimos em termos de "Inteligências" se trata da lei de Moore elevada ao extremo, somado a otimizações com uma boa dose de Hype. O preço por token precisa ser equalizado. Hoje rodamos com o token subsidiado e as preocupações de usarmos IAs de maneira segura e privada foi pro espaço. O que temos é um aumento da dependência e pessoas que fazem mal uso dela. Bom... Acho que acabei desviando um pouco o foco nesse ponto. Acho que vale uma postagem sobre esse ponto.

### Um projeto que se inicia ruim, vai se manter ruim

As LLMs são ótimas ferramentas para geração de código. Mas no contexto que eu citei lá no começo do post, as pessoas que utilizaram IA simplesmente pegaram o Claude e dispararam prompts para gerar código para o lançamento. Qual o resultado? Muitos códigos gerados, analisados pelo própria IA, que ao irem à produção geraram uma série de problemas. Além de manter a base de código problemática, tornou-se impossível mante-la sem a utilização de IA. A IA simplesmente leu o código criado e construiu em cima, mantendo vícios e elevando o consumo de tokens a níveis que poderiam ser evitados se uma arquitetura mínima fosse criada, com seus guardrails e consistências. Ela entregou o trabalho: funcionou pro que voce pediu. Mas a responsabilidade do conjunto da obra estar funcionando era sua, não da IA. E esta ficou frágil e suscetível à bugs.

Muita cobertura de teste não significa que seu código é bom ou seguro. Mais um tópico que eu posso tentar explorar mais em uma postagem futura.

# Conclusão

Utilizar ferramentas de LLM são inevitáveis. Principalmente no mercado de TI na qual resolveu uma dor grande acerca da produtividade. Vem com problemas intríssecos, como a tendência de SLOP e código incoerente, mas que ainda vale à pena arriscar. A extração de valor se dá mais entre profissionais sêniores, dado que eles sabem aonde se quer chegar.

> NUNCA delegue à LLM o seu processo de pensamento. Pode ser OK experimentar, testar em protótipos, mas jamais em um projeto em produção na qual você é o responsável. A IA pode errar, mas você será o responsável, sempre.

Quanto mais Jr for o profissional, menos é recomendável a utilização de LLMs. A fundação é necessária para um desenvolvimento acelerado. A sensação de estar pra trás infelizmente é uma realidade. FOMO e outras coisas podem ser maiores nesse mundo com agentes, LLMs e etc. 

Como se é inevitável trabalhar com ela, eu iria por um caminho mais educacional. Use a LLM para te ensinar a fazer; não deixar ela fazer por você. Tente dominar o que ela faz. Tente pensar assim: se eu puxar a LLM da tomada eu seria capaz de fazer o mesmo trabalho, se tempo não fosse um fator limitante?

O projeto que eu iniciei com IA foi adotado pela empresa e vai ser lançado em produção na época que esse post será lançado. O projeto foi estruturado em 4 semanas, mas o aprendizado para se chegar nesse nível de sofisticação tomou uns 10 anos. Entre estudar React, Django, experienciar problemas em produção e pedir ajustes que eu vi que, em produção não funcionava. O caminho dos 10 anos geram profissionais que hoje podem se tornar 2,5x mais eficientes.

Por exemplo. Essa postagem eu iniciei dia 26 de setembro, mas só finalizei dia 3 de outubro (claro, teve uns hiatos entre retomar a escrita). Usei IA para gerar a versão em inglês, logo se tornando visível para o público falante de lingua inglesa. Eu sei me comunicar muito bem em inglês, mas seria duplamente desgastante escrever a versão em ingles. Eu gerei a versão em ingles. Saberia fazer eu mesmo, mas a LLM é muito eficiente em tradução. Como eu sou o responsável pelo texto, eu pedi para ele gerar, e eu mesmo apenas revisei. Esse é o fluxo que eu acredito ser o mais otimizado para manter uma boa produtividade, assistido por IA. Como resultado você viu o conteudo expresso por um humano que usou sim de IA, mas que em síntese se mantém humano, não um texto pasteurizado de IA.

E você? O que acha à respeito? Ficaria feliz em poder continuar a conversa com você. E se mora por JPA e região, me avisa pra tomarmos um café e tomarmos um papo ao vivo.

Obrigado por me ler.







