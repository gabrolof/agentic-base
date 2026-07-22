---
title: Milestones — overview & progress tracker
---

# Milestones

The **planning hub and live progress tracker**. The table below is the overview; each milestone has its own detailed plan in [`milestones/`](milestones/README.md). Update the **Status** column as work lands — this file is the single place to see where the project stands.

Where this sits among the other docs: [requirements](requirements/README.md) say *what* to build (authoritative source of truth); milestones say *in what order*, sliced into shippable increments with explicit verification criteria; [decisions](decisions/README.md) record *why* a path was chosen; each workspace's `AGENTS.md` holds the rules needed *while writing code*. **A milestone never overrides the requirements; it sequences them.** If a milestone and the requirements disagree, the requirements win and the milestone is wrong — fix it.

**When a milestone is required:** feature work (new behavior, new UI, new endpoint). **When it isn't:** bugfixes, polish, doc updates — fix those directly (root [AGENTS.md](../AGENTS.md), rule 0).

## Status legend

| Status | Meaning |
|---|---|
| `planned` | Scoped but not started |
| `in progress` | Actively being built (a `milestone/<NNN>-<slug>` branch exists) |
| `shipped` | Merged, verified, every done-checklist box ticked |
| `blocked` | Waiting on a decision or dependency (note it in the milestone) |
| `superseded` | Replaced by a later milestone/ADR (banner in the file says which) |

The docs-sync check enforces that each file's frontmatter `status` matches its row here **verbatim**, and that a `shipped` milestone has no unchecked boxes.

## Milestones

`Lane` is the workspace(s) a milestone writes to. Two milestones are safe to build **concurrently by different agents iff their lanes write disjoint files** — when parallelising, give each agent its own git worktree. Priority: **P0** = do first.

| # | Milestone | Lane | Pri | Status |
|---|-----------|------|-----|--------|
| [001](milestones/001-example.md) | Example milestone — replace with the real first one | root (solo) | P0 | `planned` |

## Running milestones in parallel

- One agent per milestone, one branch per milestone: `milestone/<NNN>-<slug>`. An existing branch means the milestone is claimed — pick another.
- Check lanes before parallelising: overlapping lanes means serialise, not merge-and-pray.
- Give each concurrent agent its own git worktree. **DON'T `git stash` while multiple worktrees are live** — the stash stack is shared across all of them.
- A milestone that touches the root/shared config is a **solo lane**: nothing else runs beside it.
