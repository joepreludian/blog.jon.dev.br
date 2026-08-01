---
title: "um step sequencer em 200 linhas de python"
dek: "Dezesseis passos, um clock, zero dependências que você não consiga ler numa tarde."
ref: step-sequencer-python
tags: [music, python]
sample: true
---

Um step sequencer é o instrumento mais honesto que existe: uma grade de
booleanos e um clock. O que o torna um projeto de fim de semana perfeito — a
coisa toda é um loop com timing bom.

{% codeblock lang="python" title="seq/clock.py" %}
STEPS = 16

async def run(pattern, bpm=120):
    beat = 60 / bpm / 4          # semicolcheias
    while True:
        for step in range(STEPS):
            for track, hits in pattern.items():
                if hits[step]:
                    trigger(track)
            await asyncio.sleep(beat)
{% endcodeblock %}

{% youtube id="aqz-KE-bpKQ" caption="demo — sequencer v0.2 tocando um synth de hardware" %}{% endyoutube %}

Os problemas interessantes são todos de timing: asyncio.sleep deriva, então a
v0.3 agenda contra um deadline monotônico. Mesma lição dos backends — nunca
durma por uma duração quando você pode dormir até um instante.
