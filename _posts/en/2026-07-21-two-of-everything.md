---
title: "two of everything: redundancy for a one-person backend"
dek: "What a 1948 flight manual taught me about running production alone."
ref: two-of-everything
tags: [redundancy, ops]
---

Light aircraft carry two magnetos. The engine runs fine on one; the second
exists so that a failure is boring. That is the whole philosophy I want for
infrastructure I operate alone: not zero failures — boring failures.

## the boring failover

My setup is deliberately small. One primary box, one warm standby, and a
watchdog that promotes the standby when heartbeats stop. Nothing clever.
Clever is what breaks at 3am, when there is exactly one engineer and he is
asleep.
