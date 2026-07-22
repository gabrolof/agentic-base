---
title: "Example milestone — delete once the real 001 exists"
status: planned
---

# Milestone 001 — Example milestone

← back to the [milestones overview](../milestones.md)

**Lane:** root (solo)   **Priority:** P0
**Depends on:** —

**Goal:** a worked example of the milestone shape, so the first real milestone has something to copy. Delete this file once a real 001 exists — and remove its rows from the [hub](../milestones.md) and the [index](README.md) in the same change.

**Definition of done:** the shape below is what every milestone in this repo looks like: a lane, a goal in behavior terms, an explicit in/out scope, and numbered steps that each carry a concrete `→ verify:`.

## Scope

**In:** the structure of a milestone file, and the standard the `→ verify:` lines must meet.

**Out (future):** anything real. This milestone builds nothing.

## Plan

1. **Write the goal in user/behavior terms**, not implementation terms. — → *verify:* the goal paragraph can be read by someone who has not seen the code and still describes an observable outcome.
2. **Give every step a check that can fail.** A named command with an expected result, or an observable state ("the value is still there after a reload"). — → *verify:* no step's verification contains the words "works", "correct", or "as expected" without saying how you'd know.
3. **Name the lane and the conflicts** so a second agent can tell whether it is safe to run beside this. — → *verify:* the Dependencies section lists the files/workspaces this writes to.

## Dependencies & conflicts

- Solo lane while the repo is a skeleton — the first real milestone replaces this file.
- Claim a milestone with `milestone/<NNN>-<slug>` before implementation.

## Done checklist

- [ ] Every plan step verified
- [ ] Status flipped to `shipped` in this file and the hub (same PR that merges the work)
- [ ] Learnings captured (AGENTS.md Do/DON'T or ADR) if anything surprised you
