---
title: "dois de tudo: redundância para um backend de uma pessoa só"
dek: "O que um manual de voo de 1948 me ensinou sobre operar produção sozinho."
ref: two-of-everything
tags: [redundancy, ops]
---

Aviões leves carregam dois magnetos. O motor funciona bem com um; o segundo
existe para que uma falha seja entediante. Essa é a filosofia inteira que eu
quero para infraestrutura que opero sozinho: não zero falhas — falhas
entediantes.

## o failover entediante

Minha configuração é deliberadamente pequena. Uma máquina primária, um
standby aquecido, e um watchdog que promove o standby quando os heartbeats
param. Nada esperto. Esperto é o que quebra às 3h da manhã, quando existe
exatamente um engenheiro e ele está dormindo.
