---
title: "reading the black box: postmortems without blame"
dek: "Aviation stopped asking \"whose fault\" in 1974. Software should catch up."
ref: reading-the-black-box
tags: [culture, aviation]
sample: true
---

After an incident, the interesting question is never who typed the command. It
is why the system made that command easy to type, plausible to type, and
catastrophic once typed. Aviation learned this the expensive way and wrote it
into how investigations work.

{% mermaid caption="fig 01 — the investigation pipeline. blame appears nowhere in it." %}
flowchart LR
  E[event] --> T[timeline]
  T --> F[contributing factors]
  F --> A[corrective actions]
  A -.feeds.-> C[preflight checklist]
{% endmermaid %}

## the rule that makes it work

One rule: nothing said in the review can be used against the person who said
it. The moment testimony becomes evidence, people stop testifying — and your
timeline becomes fiction. You can have blame or you can have facts. Not both.

The output is never a promise to be more careful. It is a change to the system:
a guard rail, a placard, a checklist item. Careful is not a control. Checklists
are controls.
