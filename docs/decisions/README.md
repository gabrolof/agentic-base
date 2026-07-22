# Architecture Decisions (ADRs)

The canonical record of *why* things are the way they are. One decision per file, named `NNN-short-title.md`, numbered, never deleted — a reversed decision gets `status: superseded` in its frontmatter plus a banner linking to what replaced it, and stays for history.

Where this sits among the other docs: [milestones](../milestones.md) say *in what order* to build; ADRs say *why* a path was chosen; each workspace's `AGENTS.md` carries the rules an agent needs *while writing code*.

**Demotion rule:** a constraint keeps a line in an `AGENTS.md` only while an agent needs it to write correct code without opening the ADR — once fully encoded in types, constants, tests, or checks, the `AGENTS.md` line is deleted and the ADR carries it alone. This is what keeps the always-loaded files short enough to be read.

**Write the ADR when the choice is made, not after it hurts.** Every technology, boundary, and pattern this repo commits to gets one — nothing is inherited by assumption.

## Adding an ADR

Copy the highest-numbered file (or the template below for the first), bump the number, keep the frontmatter (`title`, `status`, `scope`) and the backlink. Scope is where the decision bites — a workspace name, or `repo`/`infra`. Link the ADR from the milestone or code comment that motivated it, and add its row to the index.

```markdown
---
title: <short title>
status: accepted | superseded | amended
scope: <workspace | repo | infra>
---

# ADR NNN — <title>

← back to the [decision index](README.md)

## Context

What forced a choice — the problem, the constraints, the alternatives that were live.

## Decision

What was decided, stated as current-state fact.

## Consequences

What this makes easier, what it rules out, what to watch for.
```

Write the **Consequences** honestly, including the ones you don't like. An ADR that lists only upsides is a sales pitch, and the next agent will trust it and get burned.

## Index

| # | Decision | Scope | Status |
|---|----------|-------|--------|
| _none yet_ | | | |
