#!/usr/bin/env bash
# check-docs-sync.sh — machine-checked doc invariants for this repo.
#
#   1. Currency    — a change to code mapped in docs/docmap.yaml must touch one
#                    of its owning docs, or carry a `docs-na: <reason>` commit
#                    trailer (auditable escape hatch).
#   2. Navigability— every tracked *.md is reachable by relative links from
#                    AGENTS.md/README.md, and every internal link resolves.
#                    (CLAUDE.md files are exempt — they are one-line includes.)
#   3. Tracker     — every docs/milestones/NNN-*.md frontmatter `status`
#      honesty      matches its row in docs/milestones.md, and a `shipped`
#                    milestone has no unchecked done-checklist boxes.
#   4. Hub budget  — AGENTS.md stays within AGENTS_BUDGET lines (default 200).
#
# Usage:
#   check-docs-sync.sh --staged [commit-msg-file]   # pre-commit (via commit-msg hook)
#   check-docs-sync.sh --worktree                   # uncommitted changes vs HEAD
#   check-docs-sync.sh --range <A..B>               # CI: every commit in range
#   check-docs-sync.sh --graph                      # invariants 2-4 only
#
# Exit codes: 0 pass · 2 violation · 64 usage error.
# DON'T run with no mode flag — that is a usage error (exit 64), never a pass.

set -uo pipefail
cd "$(git rev-parse --show-toplevel)" || exit 64

AGENTS_BUDGET="${AGENTS_BUDGET:-200}"
DOCMAP="docs/docmap.yaml"
FAIL=0

err() { echo "docs-sync: FAIL — $*" >&2; FAIL=2; }
note() { echo "docs-sync: $*" >&2; }

# --- docmap parsing -----------------------------------------------------------
# Lines of the form  glob: [doc, doc]
declare -a MAP_GLOBS=() MAP_DOCS=()
load_docmap() {
  [ -f "$DOCMAP" ] || { err "$DOCMAP missing"; return; }
  while IFS= read -r line; do
    line="${line%%#*}"
    [[ "$line" =~ ^[[:space:]]*$ ]] && continue
    local glob="${line%%:*}"
    local docs="${line#*:}"
    docs="${docs//[\[\]]/}"; docs="${docs//,/ }"
    MAP_GLOBS+=("$(echo "$glob" | xargs)")
    MAP_DOCS+=("$(echo "$docs" | xargs)")
  done < "$DOCMAP"
}

glob_to_regex() { # ** → any path, * → single segment
  local g="$1"
  g="${g//./\\.}"
  g="${g//\*\*/(DOUBLESTAR)}"
  g="${g//\*/[^/]*}"
  g="${g//(DOUBLESTAR)/.*}"
  echo "^${g}$"
}

# check_currency <newline-separated changed files> <commit message> <label>
# EVERY matching glob applies — a file under two globs must satisfy both.
check_currency() {
  local changed="$1" msg="$2" label="$3"
  [ -z "$changed" ] && return
  if grep -qiE '^docs-na:[[:space:]]*[^[:space:]]' <<<"$msg"; then
    return # explicit, auditable opt-out
  fi
  local i f needed_docs touched
  for i in "${!MAP_GLOBS[@]}"; do
    local re; re="$(glob_to_regex "${MAP_GLOBS[$i]}")"
    local hit=""
    while IFS= read -r f; do
      [ -z "$f" ] && continue
      case "$f" in *.md) continue ;; esac  # a doc change never triggers currency
      [[ "$f" =~ $re ]] && { hit="$f"; break; }
    done <<<"$changed"
    [ -z "$hit" ] && continue
    touched=""
    for needed_docs in ${MAP_DOCS[$i]}; do
      grep -qxF "$needed_docs" <<<"$changed" && { touched="1"; break; }
    done
    if [ -z "$touched" ]; then
      err "$label: '$hit' (glob '${MAP_GLOBS[$i]}') changed without touching ${MAP_DOCS[$i]// / or }. Update the doc or add a 'docs-na: <reason>' trailer."
    fi
  done
}

# --- navigability graph (python3) ----------------------------------------------
# Tracked docs plus not-yet-added ones, so a new orphan is caught before commit.
check_graph() {
  command -v python3 >/dev/null || { note "python3 unavailable — skipping navigability check"; return; }
  local tmp; tmp="$(mktemp)"
  { git ls-files '*.md'; git ls-files --others --exclude-standard '*.md'; } | sort -u > "$tmp"
  python3 - "$tmp" <<'PY' || FAIL=2
import os, re, sys
tracked = [l.strip() for l in open(sys.argv[1], encoding="utf-8") if l.strip()]
tset = set(tracked)
roots = [p for p in ("AGENTS.md", "README.md") if p in tset]
link_re = re.compile(r'\[[^\]]*\]\(([^)\s]+)\)')
fail = False
seen, queue = set(roots), list(roots)
while queue:
    doc = queue.pop(0)
    try:
        text = open(doc, encoding="utf-8").read()
    except OSError:
        continue
    for target in link_re.findall(text):
        if target.startswith(("http://", "https://", "mailto:", "#")):
            continue
        target = target.split("#")[0]
        if not target:
            continue
        resolved = os.path.normpath(os.path.join(os.path.dirname(doc), target))
        if os.path.isdir(resolved):
            readme = os.path.join(resolved, "README.md")
            if readme in tset:
                resolved = readme
            else:
                print(f"docs-sync: FAIL — {doc}: directory link '{target}' has no README.md", file=sys.stderr)
                fail = True
                continue
        if not os.path.exists(resolved):
            print(f"docs-sync: FAIL — {doc}: broken link '{target}'", file=sys.stderr)
            fail = True
            continue
        if resolved.endswith(".md") and resolved in tset and resolved not in seen:
            seen.add(resolved)
            queue.append(resolved)
orphans = [p for p in tracked if p not in seen and os.path.basename(p) != "CLAUDE.md"]
for p in orphans:
    print(f"docs-sync: FAIL — orphan doc '{p}' is unreachable from AGENTS.md/README.md; link it from its parent", file=sys.stderr)
    fail = True
sys.exit(2 if fail else 0)
PY
  rm -f "$tmp"
}

# --- tracker honesty ------------------------------------------------------------
check_tracker() {
  local hub="docs/milestones.md"
  [ -f "$hub" ] || return
  local f num fstatus hubstatus
  for f in docs/milestones/[0-9]*.md; do
    [ -e "$f" ] || continue
    num="$(basename "$f" | grep -oE '^[0-9]+')"
    fstatus="$(sed -n '/^---$/,/^---$/p' "$f" | sed -n 's/^status:[[:space:]]*//p' | head -1)"
    # Extract just the backtick-quoted status token, preserving internal spaces
    # (a plain `tr -d` here would also strip the space out of a two-word status
    # like `in progress`, permanently mismatching it against the frontmatter).
    hubstatus="$(grep -oE "^\|[[:space:]]*\[${num}\].*" "$hub" | grep -oE '`[a-z ]+`[[:space:]]*\|?[[:space:]]*$' | sed -E 's/^`([a-z ]+)`.*/\1/')"
    if [ -z "$hubstatus" ]; then
      err "milestone $num has no row in $hub"
    elif [ "$fstatus" != "$hubstatus" ]; then
      err "milestone $num: frontmatter status '$fstatus' ≠ hub status '$hubstatus'"
    fi
    if [ "$fstatus" = "shipped" ] && grep -q '^- \[ \]' "$f"; then
      err "milestone $num is 'shipped' but has unchecked done-checklist boxes"
    fi
  done
}

# --- hub budget ------------------------------------------------------------------
check_budget() {
  [ -f AGENTS.md ] || return
  local lines; lines="$(wc -l < AGENTS.md)"
  if [ "$lines" -gt "$AGENTS_BUDGET" ]; then
    err "AGENTS.md is $lines lines (budget $AGENTS_BUDGET). Move detail to a workspace AGENTS.md or docs/; raising the budget is a deliberate commit."
  fi
}

# --- modes -----------------------------------------------------------------------
mode="${1:-}"
case "$mode" in
  --staged)
    load_docmap
    changed="$(git diff --cached --name-only --diff-filter=ACMRD)"
    msg=""; [ -n "${2:-}" ] && [ -f "${2:-}" ] && msg="$(cat "$2")"
    check_currency "$changed" "$msg" "staged"
    check_graph; check_tracker; check_budget
    ;;
  --worktree)
    load_docmap
    changed="$({ git diff --name-only HEAD; git ls-files --others --exclude-standard; } | sort -u)"
    check_currency "$changed" "" "worktree"
    check_graph; check_tracker; check_budget
    ;;
  --range)
    case "${2:-}" in
      *..*) ;;
      *) echo "usage: $0 --range <base>..<head>" >&2; exit 64 ;;
    esac
    load_docmap
    for c in $(git rev-list --reverse "$2"); do
      changed="$(git diff-tree --no-commit-id --name-only -r "$c")"
      msg="$(git log -1 --format=%B "$c")"
      check_currency "$changed" "$msg" "commit ${c:0:8}"
    done
    check_graph; check_tracker; check_budget
    ;;
  --graph)
    check_graph; check_tracker; check_budget
    ;;
  *)
    sed -n '2,25p' "$0" >&2
    exit 64
    ;;
esac

[ "$FAIL" -eq 0 ] && note "OK (mode $mode)"
exit "$FAIL"
