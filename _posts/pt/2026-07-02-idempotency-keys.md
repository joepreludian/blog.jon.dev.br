---
title: "chaves de idempotência são cintos de segurança"
dek: "Retries são inevitáveis. Duplicatas são uma escolha."
ref: idempotency-keys
tags: [api, reliability]
sample: true
---

Todo cliente vai fazer retry. A rede garante isso, as operadoras garantem isso,
e o seu próprio código de timeout garante isso. A única questão é o que
acontece quando a mesma requisição chega duas vezes.

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
