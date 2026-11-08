---
title: "Disposable machines for working with AI"
ref: maquinas-descartaveis-para-uso-com-ia
date: 2026-11-08
tags: [ ai, engineering, lima-ai, vm ]
---

Working with AI has become a reality. Nothing new in that statement. If you use AI agents, such as Claude Code, this post is for you. I will try to cover the safety of running a system with Claude under a broad set of privileges, without giving up security. It is also useful for prototyping, for several docker compose projects on the same machine, or for several simultaneous lines of work on the same project.

## What was the motivation?

Today I work for an international consulting firm, and it is not unusual to work on multiple projects. As an example, I had two projects that used similar ports and exported a service in the same port range. Changing the mounted ports would not be a problem, but doing that for every project would be a tedious task.

Another thing that motivated me was that I did not want the service of whatever project I was working on to have full access to my machine. Today I work on a MacBook, and it was not unusual for Claude to ask me for permission to access other folders on the system. That was bothering me quite a bit.

Another point was that Claude's [`auto` mode](https://claude.com/resources/articles/auto-mode) screens commands before running them, which is good, but it consumes a few more tokens and is still not perfect. Claude itself recommends an isolated environment where the damage stays contained.

One more pain I had was around proofs of concept and experimentation. You could tell me that git worktrees would solve the problem. Yes, but only in part. In a project with docker compose, how would I segregate the whole system easily, so I could try a different kind of database tuning, a migration chain, or even a different data dump, without rewriting many files or keeping two versions of the database in the same docker compose?

## The solution: virtual machines. But how?

Right. I could create a virtual machine for the work. The problem with that was precisely the setup. How to bring my SSH keys over, how to copy the project inside so I could use Claude without fearing it would wander through my computer looking for files, and how to connect to that virtual machine in a predictable way? The Claude session would run inside it, but the browser, the editor and so on would stay outside the VM.

I tried starting out with a virtual machine manager, such as [UTM](https://getutm.app/), but that gave me a headache to configure. I had to build a base image, then install everything on it, clone it when needed, then access it... that made the work rather slow, especially when it came to configuring access to the server, and so on.

The solution I found came from searching the internet. Lima VMs.

## Lima VM: Linux Machines

The Lima project [https://lima-vm.io/](https://lima-vm.io/) addresses part of the problem. It has an interface that strongly resembles the `docker` CLI, gives you a simple way to create virtual machines, and has several projects built on top of it. One I can mention that does the job very well is Colima [https://colima.run/](https://colima.run/). With it you can provision machines with docker installed, no fuss... and you can create several instances. Without weighing the system down with a GUI full of things, or requiring a login like Docker Desktop does.

Another good thing about Lima is that it drastically simplifies access to the machine over SSH, forwarding the ports and providing an API that lets you mount folders inside it. In the words of its own site, the idea behind Lima is this:

> Lima launches Linux virtual machines with automatic file sharing and port forwarding (similar to WSL2).

## Lima VM helps, but it is still not everything

I ran some tests with the Lima project and it works very well, but I still had to create an image, clone it, import the credentials, install Claude, authenticate it, install docker, and only then could I work on the project. After thinking about it for a while, I thought: why not build a solution to the problem? That is where Lima-AI came from.

## Lima-ai: an isolated environment for Claude

[https://lima-ai.readthedocs.io/en/latest/](https://lima-ai.readthedocs.io/en/latest/)

Well, it was initially built for Claude Code, but we may expand it to any other coding agent system. It was precisely with the pains of getting a coding system started in mind that I decided to "vibe code" the system, while acting as a validator of the generated code, ensuring its quality.

**Important note**: this project has no relationship with the organisation behind the Lima project. The project is open source and aims to improve the experience of those who work with Claude.

What it does is basically what I listed as pains a few sections above: it creates a base VM for you, with Claude, docker, a few useful tools such as [RTK](https://github.com/rtk-ai/rtk) (to help save tokens), takes care of injecting a token that can be used inside the virtual machine, copies your SSH key and imports your Claude settings so you can get to work.

Another thing I did, which differs from a plain Lima VM machine, is that I treat the instance as completely independent, with no `port forwarding`. In other words, I assign it a domain name through which you will access it. The project name plus the workspace (if the project is running under git, it already suggests a branch for it).

If you are curious, I strongly recommend you [look at the project's quickstart](https://lima-ai.readthedocs.io/en/latest/quickstart/). The domain name that gets created is shown in the banner as soon as the project is created. I will still go over the code to ensure its consistency, but it is already functional.

## Next steps

Well. Now I hope to spread the word about this tool and maintain it so it covers more usage scenarios, replacing the AI-written parts with more human language. As I said before, this is a vibe-coded project, but under the supervision of a software developer.

Thank you for your time, and have a great rest of your day.
