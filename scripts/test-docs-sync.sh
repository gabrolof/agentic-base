#!/usr/bin/env bash
# Fixture tests for scripts/check-docs-sync.sh — the checker checks the repo,
# this checks the checker. Run it after ANY edit to check-docs-sync.sh.
#
#   ./scripts/test-docs-sync.sh
#
# Each sandbox() call builds a throwaway git repo in mktemp with a small
# docmap; check() asserts the script's exit code.
set -uo pipefail

SCRIPT="$(cd "$(dirname "$0")" && pwd)/check-docs-sync.sh"
PASS=0; FAILED=0

sandbox() {
  SB="$(mktemp -d)"; cd "$SB" || exit 1
  git init -q
  git config user.email test@test; git config user.name test
  mkdir -p docs src/core app
  cat > docs/docmap.yaml <<'EOF'
src/core/**: [AGENTS.md, docs/cross.md]
app/**: [docs/app.md]
src/**: [AGENTS.md]
EOF
  echo '# agents' > AGENTS.md
  printf '# readme\n[agents](AGENTS.md)\n[cross](docs/cross.md)\n[app](docs/app.md)\n' > README.md
  echo '# cross' > docs/cross.md
  echo '# app' > docs/app.md
  git add -A; git commit -qm init
}

check() { # name  expected-exit  args...
  local name="$1" want="$2"; shift 2
  "$SCRIPT" "$@" >/dev/null 2>&1; local got=$?
  if [ "$got" = "$want" ]; then
    PASS=$((PASS+1)); echo "ok   $name"
  else
    FAILED=$((FAILED+1)); echo "FAIL $name (want exit $want, got $got)"
  fi
}

# --- usage --------------------------------------------------------------------
sandbox
check "usage: no mode flag is exit 64, never a pass" 64

# --- currency: staged mode (git commit-msg hook) ------------------------------
sandbox
echo x > src/core/foo.txt; git add .
echo 'feat: x' > msg
check "staged: code without mapped doc blocks" 2 --staged msg

echo y >> docs/cross.md; echo z >> AGENTS.md; git add .
check "staged: code + every mapped doc passes" 0 --staged msg

sandbox
echo x > app/page.txt; git add .
printf 'chore: x\n\ndocs-na: build config only, no behaviour change\n' > msg
check "staged: docs-na trailer passes" 0 --staged msg

sandbox
echo y >> docs/app.md; git add .
echo 'docs: y' > msg
check "staged: docs-only change passes" 0 --staged msg

sandbox
mkdir -p src/other; echo x > src/other/index.txt; git add .
echo 'feat: x' > msg
check "staged: catch-all glob requires AGENTS.md" 2 --staged msg
echo z >> AGENTS.md; git add .
check "staged: catch-all satisfied by AGENTS.md" 0 --staged msg

# --- currency: every matching glob applies, not just the first ----------------
sandbox
echo x > src/core/foo.txt; echo y >> docs/cross.md; git add .
echo 'feat: x' > msg
check "staged: specific glob satisfied but catch-all not blocks" 2 --staged msg

# --- currency: worktree mode (Claude Code Stop hook) --------------------------
sandbox
echo x > src/core/foo.txt
check "worktree: untracked code without mapped doc blocks" 2 --worktree

echo y >> docs/cross.md; echo z >> AGENTS.md
check "worktree: code + mapped docs passes" 0 --worktree

# --- currency: range mode (CI, PR diff vs merge-base) -------------------------
sandbox
BASE=$(git rev-parse HEAD)
echo x > src/core/foo.txt; git add .; git commit -qm 'feat: x'
check "range: code without mapped doc blocks" 2 --range "$BASE..HEAD"
git commit -q --amend -m 'feat: x

docs-na: fixture test, no doc impact'
check "range: docs-na trailer in that commit passes" 0 --range "$BASE..HEAD"
check "range: argument without dots is usage error" 64 --range nodots

# --- hub budget ----------------------------------------------------------------
sandbox
seq -f 'line %g' 1 201 > AGENTS.md
check "budget: AGENTS.md over budget blocks" 2 --graph
seq -f 'line %g' 1 200 > AGENTS.md
check "budget: AGENTS.md at budget passes" 0 --graph

# --- navigability: graph mode --------------------------------------------------
sandbox
check "graph: healthy tree passes" 0 --graph

sandbox
printf '# cross\n[gone](missing.md)\n' > docs/cross.md
check "graph: broken relative link blocks" 2 --graph

sandbox
echo '# lonely' > docs/lonely.md; git add docs/lonely.md
check "graph: orphan doc blocks" 2 --graph

sandbox
echo '# lonely' > docs/lonely.md
check "graph: untracked orphan doc blocks" 2 --graph

sandbox
echo '@AGENTS.md' > CLAUDE.md; git add CLAUDE.md
check "graph: CLAUDE.md include is exempt from the orphan rule" 0 --graph

sandbox
mkdir -p docs/sub
printf '# sub\nstuff\n' > docs/sub/README.md
printf '# readme\n[agents](AGENTS.md)\n[cross](docs/cross.md)\n[app](docs/app.md)\n[sub](docs/sub/)\n' > README.md
git add -A
check "graph: directory link resolves via its README" 0 --graph

# --- tracker honesty -----------------------------------------------------------
sandbox
mkdir -p docs/milestones
printf -- '---\ntitle: Milestones\n---\n\n| # | Milestone | Status |\n|---|---|---|\n| [001](milestones/001-x.md) | X | `in progress` |\n' > docs/milestones.md
printf -- '---\ntitle: X\nstatus: in progress\n---\n\n# Milestone 001\n' > docs/milestones/001-x.md
printf '# readme\n[agents](AGENTS.md)\n[cross](docs/cross.md)\n[app](docs/app.md)\n[ms](docs/milestones.md)\n[m1](docs/milestones/001-x.md)\n' > README.md
git add -A
check "tracker: matching multi-word status passes" 0 --graph

printf -- '---\ntitle: X\nstatus: shipped\n---\n\n# Milestone 001\n' > docs/milestones/001-x.md
check "tracker: frontmatter/hub status mismatch blocks" 2 --graph

printf -- '---\ntitle: Milestones\n---\n\n| # | Milestone | Status |\n|---|---|---|\n| [001](milestones/001-x.md) | X | `shipped` |\n' > docs/milestones.md
printf -- '---\ntitle: X\nstatus: shipped\n---\n\n# Milestone 001\n\n- [ ] not done\n' > docs/milestones/001-x.md
check "tracker: shipped with unchecked boxes blocks" 2 --graph

echo
echo "$PASS passed, $FAILED failed"
[ "$FAILED" = 0 ]
