# Workspace guide template

The shape every workspace `AGENTS.md` follows — a workspace being whatever unit this project deploys or versions independently (a service, a library, an app; the directory layout is this project's own choice, not a given). Copy it to `<workspace>/AGENTS.md` in the same commit that creates the workspace, add a sibling `CLAUDE.md` containing only `@AGENTS.md`, and add the workspace's glob to [docmap.yaml](docmap.yaml).

A workspace guide is the file an agent reads *while writing code in that workspace*. It is not a tutorial and not a changelog. Everything in it earns its line by preventing a specific mistake.

---

```markdown
# AGENTS.md — <workspace name>

One or two lines: what this workspace is, what it owns, and the docs/ADRs that
govern it.

## Rules

Invariants that hold for all code here — the things that are wrong to violate,
not merely unusual. Each states the rule and why it bites. Keep to what an agent
must know before writing a line; anything fully enforced by types or tests
demotes out of this list (see the ADR index's demotion rule).

## Patterns (copy these shapes)

The nearest-example map: for each recurring kind of file here (route, component,
migration, test), name the canonical example and the shape it follows. This is
what "follow established patterns" resolves to in practice.

## Commands

The commands scoped to this workspace — run, test, build. Exact, copy-pasteable.

## Do / Don't

The accumulated sharp edges, one line each, added the moment they bite (root
AGENTS.md rule 6):

- DO <the rule that avoids the trap>.
- DON'T <the specific action> — <the concrete symptom it produces>.

Blunt and specific. "DON'T run X without flag Y — it exits 0 while checking
nothing" beats "be careful with X". No narrative, no dates, no changelog: state
the trap, state the rule, stop. A line that becomes false gets deleted, not
appended around.
```

---

## What belongs where

| Content | Home |
|---|---|
| A rule you need *while typing code* in this workspace | this workspace's `AGENTS.md` |
| A rule that crosses workspace boundaries | root [AGENTS.md](../AGENTS.md) → Critical invariants |
| *Why* a choice was made, and what it rules out | an [ADR](decisions/README.md) |
| *What* the product must do | [requirements/](requirements/README.md) |
| *In what order* it gets built | [milestones](milestones.md) |
| How to run/deploy/recover something | [runbooks.md](runbooks.md) |
