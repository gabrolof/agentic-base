---
name: verify
description: Build, run, and drive this app locally to verify a change end-to-end
---

# Verifying a change in the running app

<!-- FILL this in as soon as the app can start. Until then it is a stub, and
     "verified" claims about runtime behavior are not credible. -->

The recipe that works **in this environment** — not the idealised one from the README.

```bash
# FILL: exact commands, in order, including anything that must be exported,
# made absolute, or left running in the background.
```

Smoke checks before driving the UI:

- FILL: the one request/command that proves the whole chain is up, and what a healthy response looks like.
- FILL: the failure you'll hit first, and what it means.

Driving the UI:

- FILL: how to drive it (browser automation tool, CLI, curl), with the selectors/entry points that actually work here.
- FILL: gotchas — timing waits, overlays that hide the element you meant, expected console noise that is *not* a finding.

Cleanup:

- FILL: how to stop what you started, and what to delete before committing (screenshots, tool scratch dirs, local fixtures).

## Rules for this file

- Every gotcha that cost you more than one attempt gets a line here, the same day it bit you.
- Say what the *symptom* is, not just the fix — the next agent recognises symptoms, not causes.
- If a step here no longer works, fix the step. A stale verification recipe produces confident false "verified" reports, which is worse than having none.
