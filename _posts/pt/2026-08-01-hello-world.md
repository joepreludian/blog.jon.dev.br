---
title: "ola mundo"
dek: "Um tesde de Olá mundo"
ref: ola-mundo
tags: [api, reliability]
---

Vamos iniciar o processo fazendo um hello world. 
Testando a simplicidade.

{% codeblock lang="python" title="orders/api.py" %}
@app.post("/orders")
def create_order(req):
    key = req.headers["Idempotency-Key"]
    if done := store.get(key):
        return done            # mesma resposta, sem efeitos
    order = charge_and_create(req.body)
    store.set(key, order, ttl=DIA)
    return order
{% endcodeblock %}

Doze linhas. O store é o mesmo Postgres que você já roda, com uma unique
constraint fazendo o trabalho de verdade. Você não precisa de um lock
distribuído; precisa de um lugar onde a segunda escrita falha educadamente.

{% callout level="CUIDADO" %}
Filas são at-least-once. Se o seu consumer não é idempotente, "pelo menos uma
vez" significa "duas vezes, no pior dia do trimestre".
{% endcallout %}
