---
title: "My relationship with AI"
ref: meu-relacionamento-com-ia
date: 2026-09-26
tags: [ ai, ai-relationship-serie, engineering, workflow ]
---

Well, I'm going to share a story about how I got started with LLMs. My thoughts
and observations. I'll try to turn this into a series where I explore each point
on its own, otherwise this one would get far too long.

# The scope

It all starts with a setback on a project I was part of. I was working on an
initiative where I had to build an HTTP JSON API for a piece of software that was
originally a command-line tool for creating workflows. The catch was that the new
work had to stay compatible with the command-line program, and also support new
ways of running a workflow.

The team, at the time, was very focused on gaining speed, and they used Claude (via
Claude Code) for the work. Using AI was more than encouraged at the company, but no
strategy or workflow had been defined. On top of that, the command-line application
carried the legacy of software that didn't follow good practices. The code was
STRONGLY coupled, to the point where shipping new features quickly was impractical
without heavy use of AI.

# The problem

We had a tight deadline and a few things to implement. For example, we had to
support a workflow from a technology A, and we needed to implement one from a
technology B, but following a curious setup in which the two had to talk to each
other.

* Technology A
  * Loaded from a single file
  * Loaded from a project in a ZIP
  * Loaded from a GitHub RAW link pointing to a pipeline file;
* Technology B met the same criteria, except it didn't load from a single file, only in a pipeline format X.

In the end, without exposing too many details, we had two technologies, dealing with two distinct kinds of pipeline language.

| Language     | X (legacy) | Y (modern) |
| ------------ | ---------- | ---------- |
| Technology A | Works      | -          |
| Technology B | Works      | Works      |

Technology B, in the modern language, did not support loading from files.

Initially we even had a setup designed with flexibility in mind, but it picked up a horrible layer of software design. A bloated class that was inherited per technology, but that didn't implement support for the modern languages. Worse, there was a method that invoked functions whose parameters went past 8. But that was the first link in the problem. 8 parameters, of which 3 or 4 were used per type, namely:

* If I sent a file,
  * I could expect the input parameters, and that was it.
* If I sent a ZIP file,
  * I had to expect where, inside the zip, its `entrypoint` was, as well as the parameters.
* If I sent a GitHub link,
  * I had to make sure it was a valid link, then the endpoint, then the parameters, and so on.

There was clearly an inconsistency in the project. Worse, the classes that created the workflow and started the task were extremely coupled to the bloated class.

> **Many methods in one class does not mean low coupling.**

What pushed me to force a refactor was precisely understanding that the code was tightly coupled, injecting dependencies where it didn't need to, creating unnecessary friction that only grew with the use of AI.

## Ok, but what does AI have to do with how you got started?

In short, the project was renewed, but I ended up leaving it. Not because of technical quality, but because of the lack of the performance they wanted, precisely because they were being driven by the use of AI agents.

In short, I spent some time breaking the classes into smaller, specialised ones, where I could work in a decoupled way. For example, when a ZIP file was supplied, I created a class that took care of the whole process of opening and closing the file, so that logic didn't have to be written everywhere that used that kind of file. Likewise for the git repository, creating a class like

```python
GithubProjectLoader().from_raw_url(link="...")
```

gave me the flexibility to validate the GitHub project beforehand and create an abstraction layer that, depending on the technology in use, I could parametrise for that specific technology's execution classes, adapting the call to its destination.

As a result, my refactor simplified the process and made it easier to read. I added 1,000 lines and removed another 3,000.

When I had a week between projects, I decided to immerse myself in AI agents, and decided to create an internal project at the company, where I could put what I knew into practice (and, unfortunately, contribute a little more to more expensive energy bills in the United States).

## Flipping the switch

Working with LLMs started slowly: small snippets of code, generating documentation, creating and running test suites... Those were my first steps, but I realised I could still gain more speed. That's where the idea of agentic LLMs came to the rescue. I installed Claude Code and started small.

At the beginning I did some prior research on best practices. I saw that using a spec-driven approach and being as objective as possible in prompts makes the result quite satisfying.

Also, building tools to test the quality of the generated software contributes drastically to improving a project in the long run, or one whose codebase grows large enough.

So that's what I did. I started a project that I knew how to build by hand. I laid out every step and split it into small, bounded contexts. That would keep the LLM from drifting off towards generating bad code. I also added to this the fact that by writing a good `CLAUDE.md` I could avoid some bad patterns, or the need to be explicit every time I was going to generate new code.

I think I'll write a new post about the tips. For now I'll focus on the more conceptual part.

## The results

Well. Using AI for the work, my productivity increased drastically, at the cost of a high cognitive load. It's hard to always be working on the specification, especially when you're designing a more robust solution. In the end, code became a commodity. What you design is still yours. Your personal signature. The reflection of your work.

### Did it stop being fun?

The conquest, the experimenting to make a program work... Reading an API for days, then implementing it and getting that personal satisfaction? Yes, seen from that perspective, I think so. Things became more high-level. You see complete features instead of snippets of code. Reading generated code became a thankless task, especially when the model has a certain preference for some specific patterns. In Python it's not unusual for a return value to come as a list comprehension, for example. In some cases that form wouldn't be the most readable.

Also, if you don't "calibrate" your AI agent to work properly, you will inevitably create code that isn't consistent. I say "consistent" in the sense that it may produce results, or resolution strategies, in unpredictable ways, precisely because of the non-deterministic nature of LLMs.

### "Artificial Intelligences" amplify the professional

The term "10x developer" went around the internet: when assisted by AI, a developer would reach 10x their usual performance. In my opinion, it doesn't get that far. 2.5x at most. And that is when it's used correctly, joining human learning and touch with the ease and creation of the machine. Unfortunately, non-developers started to worship AI as a great solution because it creates things that solve one-off problems, but they didn't realise they weren't actually developing code, but generating SLOP, that is, sloppy code, with little or no judgement.

It's well known that code that grows over time can become a problem to maintain if you don't establish ways to guarantee the project's evolution. It all depends on how you "ask" the LLMs.

I never tire of seeing mediocre professionals generating sloppy code, or gurus selling AI courses. Well... what is there to say about that crowd? I think they deserve a post of their own.

What I want to conclude is: you can be a professional who is 2.5x more mediocre.

### What to ask starts with understanding what you want in the first place

It sounds stupid, but I talked with a great friend who isn't a technical person. He's more on the business side, but he amplified his work with AI, which is, in itself, praiseworthy. An extremely intelligent person who wants the work done. The guy who runs on startup timing. (I think that deserves another post about my experience on a project that failed.)

Once we were at a snack bar and he told me, excitedly, that he was taking an AI course to learn how to write better prompts. My counter-argument was that, to develop a good repertoire of prompts, you necessarily need to learn how systems work. And for that, studying programming is unavoidable.

### People have become intellectually lazier

I think the big problem with building things using AI is that all the speed and productivity comes at a steep price: people become lazy and end up reaching for the tool whenever possible. That creates a silent addiction which, if the AI bubble bursts, will leave a whole set of professionals facing a big problem ahead. A blackout, or a big "rollback".

### AI isn't cheap, and it's certainly a bubble

Today, what we consume in terms of "Intelligences" is Moore's law taken to the extreme, plus optimisations and a good dose of hype. The price per token needs to be balanced out. Today we run on subsidised tokens, and the concern about using AI safely and privately went out the window. What we have is growing dependence and people who misuse it. Well... I think I drifted a bit off topic here. I think that point is worth a post of its own.

### A project that starts bad stays bad

LLMs are great tools for generating code. But in the context I mentioned at the start of this post, the people who used AI simply took Claude and fired off prompts to generate code for the launch. The result? Lots of generated code, reviewed by the AI itself, which caused a series of problems once it reached production. Besides keeping the codebase problematic, it became impossible to maintain without AI. The AI simply read the code that had been created and built on top of it, keeping its bad habits and raising token consumption to levels that could have been avoided had a minimal architecture been created, with its guardrails and consistency. It delivered the work: it did what you asked. But the responsibility for the whole thing working was yours, not the AI's. And it ended up fragile and prone to bugs.

Lots of test coverage doesn't mean your code is good or safe. Another topic I may try to explore further in a future post.

# Conclusion

Using LLM tools is unavoidable. Especially in the IT market, where it solved a big pain around productivity. It comes with intrinsic problems, like the tendency towards SLOP and incoherent code, but it's still worth the risk. The value is extracted mostly by senior professionals, since they know where they want to get to.

> NEVER delegate your thinking process to the LLM. It may be OK to experiment, to try things out in prototypes, but never in a production project you are responsible for. The AI can be wrong, but you will be the one responsible, always.

The more junior the professional, the less advisable it is to use LLMs. The foundation is necessary for accelerated development. The feeling of falling behind is, unfortunately, real. FOMO and the like can be bigger in this world of agents, LLMs and so on.

Since working with it is unavoidable, I would take a more educational path. Use the LLM to teach you how to do it; don't let it do it for you. Try to master what it does. Try to think like this: if I pulled the LLM's plug, would I be able to do the same work, if time weren't a limiting factor?

The project I started with AI was adopted by the company and will go into production around the time this post is published. The project was structured in 4 weeks, but the learning needed to reach that level of sophistication took about 10 years. Between studying React and Django, living through problems in production, and asking for adjustments I had seen didn't work in production. The 10-year path produces professionals who today can become 2.5x more efficient.

Take this post, for example. I started it on September 26, but only finished it on October 3 (of course, with a few breaks before getting back to writing). I used AI to generate the English version, which makes it available to English-speaking readers. I communicate very well in English, but writing the English version myself would have been twice the effort. So I generated it. I would know how to do it myself, but the LLM is very efficient at translation. Since I am the one responsible for the text, I asked it to generate the translation, and I only reviewed it. That is the workflow I believe is the most efficient for keeping good productivity with AI assistance. As a result, what you read is content expressed by a human who did use AI, but which, in essence, remains human, not pasteurised AI text.

And you? What do you think about it? I'd be happy to keep the conversation going with you. And if you live in or around João Pessoa, let me know so we can grab a coffee and chat in person.

Thanks for reading.
