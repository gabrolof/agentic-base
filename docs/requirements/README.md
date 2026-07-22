# Requirements — authoritative source of truth

*What* this project is and must do. **These requirements take priority over any other information in the repo** — when a milestone, the code, or another doc disagrees with them, the requirements win and the other artifact is wrong; fix it. [Milestones](../milestones.md) sequence these requirements into shippable increments; [decisions](../decisions/README.md) record why paths were chosen.

Keep these files continuously current — agents and humans are equally responsible. The canonical change → doc rules live in [AGENTS.md](../../AGENTS.md); the one exercised most from here: **a feature ships → tick its row in the checklist below, in the same PR.**

One topic per file, ~200-line budget, linked from this index in the commit that creates it.

## Documents

- _none yet — add the first requirements file before the first feature milestone._

One markdown link per file, added here in the same commit that creates it (the navigability check fails on orphans). Typical first files: `product.md` (vision, core loop, platform scope, deferred work), `accounts.md` (identity, sessions, per-user persistence), `design.md` (design authority, voice, theming).

## Terminology

Define the project's nouns here once, and use them verbatim in code, docs, and UI. Divergent names for the same concept are how a codebase starts lying to the next agent.

| Term | Meaning |
|---|---|
| _—_ | _—_ |

## Feature checklist

Mark `[x]` when the covering milestone ships (same PR). `[~]` means partially shipped, and the gap is named in the milestone.

- [ ] _first feature — link its milestone_
