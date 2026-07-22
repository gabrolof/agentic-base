# Runbooks

Deploy and ops procedures — current-state, copy-pasteable. One section per procedure. If you ran a command to fix or deploy something and it isn't here, it belongs here.

## Arming the git hooks

Every clone must arm the committed hooks once:

```bash
git config core.hooksPath .githooks
```

Once a stack is chosen, wire this into whatever bootstrap step every clone already runs, so arming is automatic rather than remembered. The `commit-msg` hook runs `scripts/check-docs-sync.sh --staged`, blocking commits whose code changes drift from their owning docs (see [docmap.yaml](docmap.yaml)); the escape hatch is a `docs-na: <reason>` commit-message trailer.

Bypass, as with any git hook: `git commit --no-verify`. CI re-runs the same script on every PR, so a bypass buys minutes, not immunity.

## Validating docs locally

```bash
./scripts/check-docs-sync.sh --worktree   # currency + navigability + tracker + budget, vs uncommitted changes
./scripts/check-docs-sync.sh --graph      # link graph / tracker / budget only
./scripts/test-docs-sync.sh               # fixture tests for the checker itself
```

**DON'T run `check-docs-sync.sh` with no mode flag** — it prints usage and exits 64 having checked nothing.

Run `test-docs-sync.sh` after any edit to `check-docs-sync.sh`. A checker that silently stops checking is worse than no checker.

## Local dev

<!-- FILL: install, env setup, how to start the app, and the ports. Exact
     commands, in the order you'd type them. Note anything that must be
     absolute, exported, or left running. -->

## Running an agent in an isolated worktree

```bash
git worktree add ../<repo>-milestone-<NNN> -b milestone/<NNN>-<slug>
```

Then install dependencies **inside the worktree** — a fresh worktree has no installed dependencies, and running the toolchain from the main checkout validates the wrong tree. Copy any gitignored env files across too.

## Deploy

<!-- FILL: the real deploy path once one exists — build, migrate, release,
     rollback. Rollback is not optional; write it before you need it. -->
