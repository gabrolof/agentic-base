# <PROJECT>

<!-- FILL: one paragraph for a human landing here — what this is and its state. -->

## Working in this repo

Agents and humans both start at **[AGENTS.md](AGENTS.md)** — how to work here, the doc governance rules, and the map to everything else.

Starting a new project from this skeleton: **[docs/bootstrap.md](docs/bootstrap.md)**.

## Layout

```
AGENTS.md                  # the hub: how to work here (CLAUDE.md is a one-line include)
docs/
  requirements/            # WHAT to build — authoritative, beats every other doc
  milestones.md            # IN WHAT ORDER — hub + live progress tracker
  milestones/              # one detailed plan per milestone
  decisions/               # WHY — ADRs, numbered, never deleted
  runbooks.md              # HOW to run, deploy, recover
  docmap.yaml              # code paths → the docs that own them
  bootstrap.md             # first-run checklist for a new project
  workspace-guide-template.md
scripts/check-docs-sync.sh # enforces the doc invariants (hook + Stop hook + CI)
scripts/test-docs-sync.sh  # fixture tests for the checker
.githooks/commit-msg       # arms the checker on commit
.claude/                   # Stop hook + the runtime-verification skill
```

Every workspace added later carries its own `AGENTS.md` (from the template) and an entry in `docmap.yaml`.

## Checks

```bash
git config core.hooksPath .githooks   # once per clone
./scripts/check-docs-sync.sh --worktree
./scripts/test-docs-sync.sh
```
