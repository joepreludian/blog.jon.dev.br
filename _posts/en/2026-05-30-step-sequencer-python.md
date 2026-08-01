---
title: "a step sequencer in 200 lines of python"
dek: "Sixteen steps, one clock, zero dependencies you cannot read in an afternoon."
ref: step-sequencer-python
tags: [music, python]
sample: true
---

A step sequencer is the most honest instrument there is: a grid of booleans and
a clock. Which makes it a perfect weekend project — the whole thing is a loop
with good timing.

{% codeblock lang="python" title="seq/clock.py" %}
STEPS = 16

async def run(pattern, bpm=120):
    beat = 60 / bpm / 4          # sixteenth notes
    while True:
        for step in range(STEPS):
            for track, hits in pattern.items():
                if hits[step]:
                    trigger(track)
            await asyncio.sleep(beat)
{% endcodeblock %}

{% youtube id="aqz-KE-bpKQ" caption="demo — sequencer v0.2 driving a hardware synth" %}{% endyoutube %}

The interesting problems are all timing: asyncio.sleep drifts, so v0.3
schedules against a monotonic deadline instead. Same lesson as backends — never
sleep for a duration when you can sleep until an instant.
