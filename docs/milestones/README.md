# Milestone plans

← back to the [milestones overview](../milestones.md)

One file per milestone, numbered in creation order, named `NNN-short-slug.md`. The [hub table](../milestones.md) is the live tracker; these files hold the detailed plans. The docs-sync check requires every file here to be linked from this index and its frontmatter `status` to match the hub row.

## Template

Every milestone file follows this shape (see [001](001-example.md) for a filled-in example):

```markdown
---
title: <short title>
status: planned | in progress | shipped | blocked | superseded
---

# Milestone NNN — <title>

← back to the [milestones overview](../milestones.md)

**Lane:** <workspace(s) this writes to>   **Priority:** P0–P3
**Depends on:** <milestone/ADR links, if any>

**Goal:** one paragraph — the outcome in user/behavior terms.

**Definition of done:** the crisp, verifiable end state.

## Scope

**In:** what gets built.
**Out:** what is explicitly deferred (tag each with "future").

## Plan

1. <step> — → *verify:* <concrete check>
2. …

## Dependencies & conflicts

Which milestones/lanes this must sequence behind or must not overlap.

## Done checklist

- [ ] Every plan step verified
- [ ] Status flipped to `shipped` in this file and the hub (same PR that merges the work)
- [ ] Learnings captured (AGENTS.md Do/DON'T or ADR) if anything surprised you
```

**The `→ verify:` per step is not decoration.** "works" / "looks right" / "should be fine" are not verifications. A verification names the command to run or the observable state to check, and its expected result.

## Index

| # | Milestone | Status |
|---|-----------|--------|
| [001](001-example.md) | Example milestone — replace with the real first one | `planned` |

To add one: copy the highest-numbered file here, bump the number, fill in the plan, then add a row both here and in the [hub table](../milestones.md). State the milestone's **lane** (the workspace[s] it writes to) so the parallelisation view stays accurate. Backlog milestones may carry a lighter plan — **detail the numbered plan (with `→ verify:` per step) when claiming one**, before writing code.
