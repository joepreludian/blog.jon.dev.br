---
title: "hello world"
dek: "A hello world test."
ref: ola-mundo
tags: [api, reliability]
---

Let's start the process with a hello world.
Testing simplicity.

{% codeblock lang="python" title="orders/api.py" %}
@app.post("/orders")
def create_order(req):
    key = req.headers["Idempotency-Key"]
    if done := store.get(key):
        return done            # same answer, no side effects
    order = charge_and_create(req.body)
    store.set(key, order, ttl=DAY)
    return order
{% endcodeblock %}

Eight lines. The store is the same Postgres you already run, with a unique
constraint doing the actual work. You do not need a distributed lock; you need
a place where the second write fails politely.

{% callout level="CAUTION" %}
Queues are at-least-once. If your consumer is not idempotent, "at least once"
means "twice, on the worst day of the quarter".
{% endcallout %}
