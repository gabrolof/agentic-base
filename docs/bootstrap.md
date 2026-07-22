# Bootstrap — turning this skeleton into a project

← back to [AGENTS.md](../AGENTS.md)

This repo ships the agentic structure and nothing else: no stack, no framework, no build tooling, no technology decisions. Those are yours to make and to record. Work this list top to bottom; each step is done when its check passes.

## 1. Claim the name and the premise

- [ ] Replace `<PROJECT>` in [AGENTS.md](../AGENTS.md) and fill its **What this is** section — one paragraph, in user/behavior terms.
- [ ] Rewrite [README.md](../README.md) for the actual project.
- [ ] Write the first [requirements](requirements/README.md) file(s). Requirements are authoritative: they outrank every other doc, including this one.
- → *verify:* someone who has never seen the repo can say what it does after reading `AGENTS.md` → requirements, without opening code.

## 2. Choose the stack — as decisions, not defaults

- [ ] Write **ADR 001** ([decisions/](decisions/README.md)) for the language/runtime/repo layout. Context, decision, consequences — including the consequences you dislike.
- [ ] Write an ADR for every other load-bearing choice as you make it (data store, auth model, deploy target, design authority). Don't batch them into one; a merged ADR can't be superseded piecewise.
- → *verify:* every technology named in `AGENTS.md` traces to an ADR.

## 3. Wire the enforcement

- [ ] `git init` (if needed), then `git config core.hooksPath .githooks`.
- [ ] Once the stack has a bootstrap step every clone runs, move that config into it so arming is automatic, and expose a short alias for `./scripts/check-docs-sync.sh --worktree`.
- [ ] Confirm the CI workflow in [.github/workflows/docs-sync.yml](../.github/workflows/docs-sync.yml) matches the branch you actually use.
- [ ] Confirm the Claude Code Stop hook in `.claude/settings.json` fires.
- → *verify:* `./scripts/test-docs-sync.sh` passes, and a deliberate violation (touch a mapped code path, commit without its doc) is **blocked** by the commit hook.

## 4. Fill the docmap as workspaces appear

- [ ] Add a `glob: [docs]` line to [docmap.yaml](docmap.yaml) for each new workspace, specific → general.
- [ ] Give each workspace an `AGENTS.md` from the [template](workspace-guide-template.md) plus a one-line `CLAUDE.md`.
- [ ] Link each workspace guide from the doc map in [AGENTS.md](../AGENTS.md).
- → *verify:* `./scripts/check-docs-sync.sh --worktree` passes and no source path falls outside every glob.

## 5. Plan the first real milestones

- [ ] Replace [milestone 001](milestones/001-example.md) with the real first milestone; update the [hub](milestones.md) and the [index](milestones/README.md) rows in the same change.
- [ ] Slice the first release into milestones with lanes, so parallel agents have disjoint files to write.
- → *verify:* every milestone step carries a `→ verify:` that names a command or an observable state.

## 6. Make runtime verification real

- [ ] Fill in [.claude/skills/verify/SKILL.md](../.claude/skills/verify/SKILL.md) with the actual recipe to boot and drive the app, including the gotchas that cost you time the first time.
- [ ] Fill in the local-dev and deploy sections of [runbooks.md](runbooks.md).
- → *verify:* a fresh agent can start the app end-to-end from the skill file alone, with no follow-up questions.

## 7. Delete the scaffolding

- [ ] Remove every `<!-- FILL -->` marker, the example milestone, and any placeholder row still saying `none yet`.
- → *verify:* `grep -rn "FILL\|<PROJECT>" --include="*.md" --include="*.yaml" .` returns nothing.

---

**The one rule that outlives this checklist:** the structure is maintained in the same change as the code. New workspace → new guide and docmap entry. New footgun → new DON'T. New choice → new ADR. Constraint now enforced by a test → delete the line it replaced. See [AGENTS.md → Keeping this system alive](../AGENTS.md#keeping-this-system-alive).
