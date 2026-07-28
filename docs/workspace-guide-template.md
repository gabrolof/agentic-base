# Workspace guide template

The shape every workspace `AGENTS.md` follows — a workspace being whatever unit this project deploys or versions independently (a service, a library, an app; the directory layout is this project's own choice, not a given). Copy it to `<workspace>/AGENTS.md` in the same commit that creates the workspace, add a sibling `CLAUDE.md` containing only `@AGENTS.md`, and add the workspace's glob to [docmap.yaml](docmap.yaml).

**Every workspace gets a guide — no size threshold.** A tiny workspace gets a short guide, not no guide; a three-file config package can still break every consumer at once. An honest "zero tests, no runner wired" Testing section is part of the value, not a reason to skip the file.

A workspace guide is the file an agent reads *while writing code in that workspace*. It is not a tutorial and not a changelog. Everything in it earns its line by preventing a specific mistake — and where reality currently falls short of a rule, the guide says so bluntly instead of describing the repo we wish we had.

---

```markdown
# AGENTS.md — <workspace name>

One or two lines: what this workspace is, what it owns, and the docs/ADRs that
govern it. State the blast radius — who consumes this workspace and what breaks
downstream ("a bug here hits every consumer at once — treat changes as
load-bearing", when true). The root AGENTS.md holds how to work; this file is
additive and workspace-specific.

> ⚠️ **HEADLINE RISK** — only when one danger dominates everything else in this
> workspace (unsafe to deploy, destructive command, real money moves). State it
> above everything, name the concrete consequence, and say what must exist
> before the risk is closed. Delete the block the moment it no longer holds;
> most workspaces never need it.

## Rules

Invariants that hold for all code here — the things that are wrong to violate,
not merely unusual. Each states the rule and why it bites. Keep to what an agent
must know before writing a line; anything fully enforced by types or tests
demotes out of this list (see the ADR index's demotion rule).

## Patterns (copy these shapes)

The nearest-example map: for each recurring kind of file here (route, component,
migration, test), name the canonical example and the shape it follows. This is
what "follow established patterns" resolves to in practice. When existing code
is NOT the pattern to copy — debt that predates a rule — say so here explicitly
and list it under Known sharp edges, or the next agent will faithfully copy the
wrong thing.

## Testing

Three parts, all mandatory — an honest empty section beats an absent one:

1. **What should be tested**, highest value first, with concrete boundary cases
   ("exactly at, just under, and just over the limit" — not "test the limit").
2. **Current state, stated bluntly.** "There are zero tests" when true — no
   sugarcoating. If a check passes vacuously, say exactly that: "the `test`
   script exits 0 while asserting nothing." Name what a green run proves and
   what it does not. Never let a stub imply coverage that doesn't exist.
3. **Recommended approach** for when tests get added: runner, where the config
   goes, and the real constraints ("needs a live database — no in-memory mode
   exists"). When adding tests, add the runner first; don't assume one exists.

## Confirming a change

The exact sequence to trust a change here, copy-pasteable:

- Environment prerequisites and first-run-only steps, called out as such.
- The commands — and which one is the real gate when others pass vacuously
  ("until the stubs are replaced, `typecheck` is the only meaningful check").
- A short manual smoke sequence when automation can't cover the flow: the
  concrete actions to perform and the observable state that proves the change.
- Downstream consumers to re-verify when a change here ripples past the
  workspace boundary — partial validation is not enough for shared code.

## Do / Don't

The accumulated sharp edges, one line each, added the moment they bite (root
AGENTS.md rule 6):

- DO <the rule that avoids the trap>.
- DON'T <the specific action> — <the concrete symptom it produces>.

Blunt and specific. "DON'T run X without flag Y — it exits 0 while checking
nothing" beats "be careful with X". No narrative, no dates, no changelog: state
the trap, state the rule, stop. A line that becomes false gets deleted, not
appended around.

## Known sharp edges

The honest current-state inventory, one line each: stubs, placeholder values,
code that violates a rule above ("X still hand-rolls Y — debt, not the pattern
to copy"), stale comments that mislead ("the header comment in X describes the
old flow — don't follow it"), and behavior nobody has confirmed ("intentional
or a bug? Unconfirmed."). This section is what keeps "copy the nearest example"
safe — it names the examples that are wrong. Same discipline as Do/Don't: a
line that stops being true gets deleted, not appended around.
```

---

## What belongs where

| Content | Home |
|---|---|
| A rule you need *while typing code* in this workspace | this workspace's `AGENTS.md` |
| What a green check does and doesn't prove here | this guide → Testing |
| Known debt, stubs, and misleading code | this guide → Known sharp edges |
| A rule that crosses workspace boundaries | root [AGENTS.md](../AGENTS.md) → Critical invariants |
| *Why* a choice was made, and what it rules out | an [ADR](decisions/README.md) |
| *What* the product must do | [requirements/](requirements/README.md) |
| *In what order* it gets built | [milestones](milestones.md) |
| How to run/deploy/recover something | [runbooks.md](runbooks.md) |
