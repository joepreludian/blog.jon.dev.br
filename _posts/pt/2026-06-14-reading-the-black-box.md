---
title: "lendo a caixa-preta: postmortems sem culpa"
dek: "A aviação parou de perguntar \"de quem é a culpa\" em 1974. O software deveria alcançá-la."
ref: reading-the-black-box
tags: [culture, aviation]
sample: true
---

Depois de um incidente, a pergunta interessante nunca é quem digitou o comando.
É por que o sistema tornou aquele comando fácil de digitar, plausível de
digitar, e catastrófico depois de digitado. A aviação aprendeu isso do jeito
caro e escreveu isso no funcionamento das investigações.

{% mermaid caption="fig 01 — o pipeline de investigação. culpa não aparece em lugar nenhum." %}
flowchart LR
  E[evento] --> T[linha do tempo]
  T --> F[fatores contribuintes]
  F --> A[ações corretivas]
  A -.alimenta.-> C[checklist de preflight]
{% endmermaid %}

## a regra que faz funcionar

Uma regra: nada dito na revisão pode ser usado contra quem disse. No momento em
que testemunho vira evidência, as pessoas param de testemunhar — e a sua linha
do tempo vira ficção. Você pode ter culpa ou pode ter fatos. Não os dois.

O resultado nunca é uma promessa de ser mais cuidadoso. É uma mudança no
sistema: uma proteção, um placar, um item de checklist. Cuidado não é um
controle. Checklists são controles.
