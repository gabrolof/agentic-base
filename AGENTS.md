# AGENTS.md — <PROJECT>

The hub for working in this repo. `CLAUDE.md` files are one-line includes of their sibling `AGENTS.md` — **AGENTS.md is always the canonical file; never edit a CLAUDE.md directly.** As workspaces appear — whatever this project deploys or versions independently — each gets its own expert `AGENTS.md` with workspace-specific invariants and Do/DON'T lists; this file covers repo-level context and how to work.

New repo? Start at [docs/bootstrap.md](docs/bootstrap.md) — the checklist that turns this skeleton into a real project.

> **Tradeoff:** these rules bias toward caution over speed. For genuinely trivial, mechanical fixes (a typo, a broken link, a one-line doc correction), use judgment.

## How to work here

These rules govern *how* you work — they hold above everything else in the repo.

0. **Plan features to a milestone first.** Feature work starts from a milestone in [docs/milestones.md](docs/milestones.md) — if nothing covers the request, write the milestone before touching code. Do **not** start unplanned work: surface it and either draft/extend a milestone for approval or ask which existing milestone it belongs to. If the request contradicts the milestone, name the conflict and resolve it in the plan first. Bugfixes, polish, and doc updates are exempt: fix directly, but still capture learnings (rule 6). Claim a milestone by checking out `milestone/<NNN>-<slug>` — one agent per milestone; an existing branch (`git branch -a | grep milestone/<NNN>`) means another agent owns it, so pick a different one. Keep the tracker honest: update the milestone's status in `docs/milestones.md` as work lands, in the same change.
1. **Think before coding.** Never infer when something is less than 100% clear — stop and ask. State assumptions explicitly; if multiple interpretations exist, present them instead of silently picking one. If a simpler approach exists, say so — push back when warranted. A wrong guess costs more than a question.
2. **Simplicity first.** Minimum code that solves the problem, nothing speculative: no features beyond what was asked, no abstractions for single-use code, no unrequested "flexibility", no error handling for impossible scenarios. If you write 200 lines and it could be 50, rewrite it. Ask: "would a senior engineer say this is overcomplicated?"
3. **Surgical changes.** Touch only what you must. Don't "improve" adjacent code, comments, or formatting; don't refactor what isn't broken; match existing style even if you'd do it differently. Remove imports/variables/functions that *your* change orphaned; leave pre-existing dead code alone (mention it instead). The test: every changed line traces directly to the request.
4. **Verify every step.** Transform tasks into verifiable goals ("add validation" → "write tests for invalid inputs, then make them pass"). Plans and milestones state a concrete `→ verify:` check per step — "value sticks after reload" beats "works". Run the check before claiming done; strong criteria let you loop independently.
5. **Follow established patterns.** Copy the shape of the nearest existing example. Don't introduce a parallel way to do something that already has a way. If the pattern isn't 100% clear, ask — don't infer one; choosing a structure the repo then has to live with is exactly the ambiguity to surface first. If something genuinely needs a new pattern, say so, get agreement, then document it so the next addition can follow it.
6. **Capture learnings after a struggle.** Every struggle — a wrong assumption, a multi-attempt fix, a footgun — is a doc gap. Close it in the same change: add a blunt Do/DON'T entry to the *most specific* `AGENTS.md` (workspace-level if workspace-scoped, this file if cross-cutting). Be blunt and specific — "DON'T run X without flag Y — it exits 0 while checking nothing" beats "be careful with X." One entry, surgical: state the trap, state the rule, stop. Already documented? You missed it — go read the doc you skipped; don't duplicate it.
7. **Grow this structure with the repo.** The agentic layer is not scaffolding you set up once — it is maintained in the same change as the code it describes. See [Keeping this system alive](#keeping-this-system-alive) below. A change that adds a workspace, a pattern, or a footgun and leaves the docs untouched is an incomplete change.
8. **Report straight.** State outcomes exactly as they are. If a check failed, paste what failed. If you skipped a step, say which and why. If you're unsure it works, say you're unsure — never "should work", never "this is now fully handled" for something you didn't run. Don't soften a broken result into a partial success, don't bury the caveat at the end, and don't pad with what went well. Precision over comfort: name the thing that is wrong, in the first sentence.
9. **DON'T use `git stash` when the repo has multiple worktrees in use.** The stash stack (`refs/stash`) is shared by ALL worktrees — `git stash pop` in one worktree can pop a stash created in another, silently swapping your WIP for another agent's. For a throwaway baseline diff, use `git show HEAD:path/to/file` (or a scratch copy) instead.

### Change → doc map

| When you change… | …also touch |
|---|---|
| A workspace's behavior/invariants | that workspace's `AGENTS.md` |
| Product behavior or a requirement | the relevant [docs/requirements/](docs/requirements/README.md) file (and tick its checklist row when a feature ships) |
| An architectural choice (new pattern, tradeoff) | a new ADR in [docs/decisions/](docs/decisions/README.md) |
| Milestone scope/status | the milestone file **and** its row in [docs/milestones.md](docs/milestones.md) |
| Deploy/ops procedure | [docs/runbooks.md](docs/runbooks.md) |
| A new workspace | its `AGENTS.md` (from the [template](docs/workspace-guide-template.md)), a [docmap.yaml](docs/docmap.yaml) entry, and a link in the doc map below |

Enforced by `scripts/check-docs-sync.sh` (commit hook + Stop hook + CI) against [docs/docmap.yaml](docs/docmap.yaml). A code-only commit that genuinely needs no doc touch carries a `docs-na: <one-sentence reason>` commit-message trailer — the escape hatch, auditable in history. The trailer only exempts `--staged`/`--range` runs (it's read from the commit message); `--worktree` has no message to read. **Add a `docmap.yaml` entry for every new workspace** — nothing falls outside the system.

## Keeping this system alive

This structure is expected to *expand as the repo does*. Not periodically — in the same change.

- **New workspace →** copy [docs/workspace-guide-template.md](docs/workspace-guide-template.md) to `<workspace>/AGENTS.md`, add a one-line `CLAUDE.md` (`@AGENTS.md`), add its glob to [docmap.yaml](docs/docmap.yaml), and link it from the doc map below. Same commit that creates the workspace.
- **New footgun / wrong assumption / multi-attempt fix →** one blunt DO or DON'T in the most specific `AGENTS.md` (rule 6). Name the symptom, not the vibe.
- **New architectural choice →** an ADR (why), plus the minimum line in an `AGENTS.md` that an agent needs to write correct code without opening the ADR.
- **Rule fully encoded in types, constants, tests, or a check →** delete the `AGENTS.md` line; the ADR keeps the history. This **demotion rule** is what keeps the always-loaded files small enough to actually be read.
- **A file hits its budget →** split it and link the parts. Raising `AGENTS_BUDGET` is allowed but deliberate: do it in the commit that needs the room and justify why the content must be always-loaded instead of behind a link.
- **A rule produced a bad outcome →** say so and change the rule in the same breath. Silently ignoring a rule that no longer fits is the failure mode that rots this whole system.
- **Prune, don't accrete.** A Do/DON'T that is now false gets deleted, not appended around. Docs describe the present.

## Doc governance — keep this repo agent-navigable

The end goal: anyone (human or agent) who pulls this repo can build a correct understanding of it by starting at this file and following links — always. Four invariants are machine-checked by `scripts/check-docs-sync.sh` (git `commit-msg` hook in `.githooks/`, Claude Code Stop hook in `.claude/settings.json`, and CI on every PR):

1. **Currency** — a commit changing code mapped in [docs/docmap.yaml](docs/docmap.yaml) must touch one of its owning docs, or carry the `docs-na:` trailer.
2. **Navigability** — every tracked `*.md` is reachable by relative links from `AGENTS.md`/`README.md`, and every link resolves. No orphans, no rot.
3. **Hub budget** — `AGENTS.md` stays within 200 lines; raising the budget is a deliberate, justified commit.
4. **Tracker honesty** — every milestone file's frontmatter `status` matches its row in the [milestones hub](docs/milestones.md) **verbatim**, and a `shipped` milestone has no unchecked done-checklist boxes. The PR that completes a milestone flips it to `shipped` in that same PR; `shipped` means *merged + verified* — don't pre-flip.

Authoring conventions:

- **Current-state prose, not changelogs** — docs describe how things *are*; history lives in git. No "as of …" / "we recently changed …" phrasing.
- **One topic per file, ~200-line budget** — split (and link) before a file becomes a scroll. Exempt: flat reference catalogs with uniform entries you look up by heading — there the discipline is terse entries, not splitting.
- **Every new doc is linked from its parent** in the same commit that creates it.
- **Relative markdown links** for internal references; link a directory via its README: `[decisions/](docs/decisions/README.md)`. A bare `dir/` link fails the check.

**DON'T run `check-docs-sync.sh` with no mode flag** — it prints usage and exits without checking anything. Validate locally with `--worktree`.

## What this is

<!-- FILL: one paragraph — what this project is, for whom, and the core loop. Then the authoritative spec link. -->

Full spec: [docs/requirements/](docs/requirements/README.md) (authoritative — requirements beat every other doc; if a milestone or the code disagrees, the requirements win).

Stack: <!-- FILL: languages, runtimes, workspaces — one line each, with the ADR that chose them. Nothing is inherited; every choice gets its own ADR. -->

## Commands

```bash
# FILL: the handful of commands an agent actually needs — install, dev, test,
# typecheck/lint, and the doc check. Keep it to what you'd type, not a catalog.
./scripts/check-docs-sync.sh --worktree   # doc-sync invariants vs the worktree
```

First run and environment setup: [docs/runbooks.md](docs/runbooks.md).

## Critical invariants (cross-workspace)

Workspace-scoped invariants live in each workspace's `AGENTS.md` — this list is only what crosses workspace boundaries.

- _None yet._

## Doc map

- [README.md](README.md) — public-facing overview
- [docs/bootstrap.md](docs/bootstrap.md) — first-run checklist for a new project on this skeleton
- [docs/requirements/](docs/requirements/README.md) — authoritative product requirements (*what* to build; wins over everything else)
- [docs/milestones.md](docs/milestones.md) — planning hub + live progress tracker; per-milestone plans in [docs/milestones/](docs/milestones/README.md)
- [docs/decisions/](docs/decisions/README.md) — ADR index (*why* choices were made; superseded ADRs are marked, never deleted)
- [docs/runbooks.md](docs/runbooks.md) — deploy and ops procedures
- [docs/workspace-guide-template.md](docs/workspace-guide-template.md) — the shape every workspace `AGENTS.md` follows
- [docs/docmap.yaml](docs/docmap.yaml) — code paths → owning docs (drives `check-docs-sync.sh`)
- [.claude/skills/verify/SKILL.md](.claude/skills/verify/SKILL.md) — recipe to run + drive the app locally for end-to-end verification
- Workspace expert guides: <!-- FILL: one link per workspace as they appear -->

---

These rules are working if: fewer unnecessary changes in diffs, fewer rewrites due to overcomplication, new additions match existing patterns instead of introducing parallel structures, struggles become Do/DON'T entries instead of being repeated, and clarifying questions come before implementation rather than after mistakes.
