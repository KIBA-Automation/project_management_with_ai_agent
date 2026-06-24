# Architecture

## Overview

Three actors, one loop:

| Actor | Role |
|-------|------|
| **Meeting notes** (`meetings/*.txt`) | Source of *intent* — what people decided. Private, local only. |
| **Plane workspace** (via MCP) | Source of *record* — the current board state. |
| **AI agent** | Reconciles intent against record, proposes changes, applies approved ones. |

## The reconciliation loop

```
read note ─▶ observe Plane ─▶ diff ─▶ propose ─▶ [human confirm] ─▶ apply ─▶ report
                                          ▲                              │
                                          └────────── reject/edit ───────┘
```

### 1. Read
Parse the newest unprocessed note(s) in `meetings/`. Notes are free‑form prose;
the agent extracts decisions and action items.

### 2. Observe
Query the live workspace through the Plane MCP server — projects, work items and
their states, cycles, modules, and assignees. This is *read‑only* and needs no
confirmation.

### 3. Diff
Map each extracted decision to a concrete operation against current state:
create work item, change status, reassign, add to cycle, etc. Items that already
match current state produce no operation (idempotent).

### 4. Propose & confirm
Present the change set as a reviewable list. **No write happens without explicit
human approval.** The confirmation policy — which operations are allowed, which
always require sign‑off, and which are forbidden — is defined in
[`../CLAUDE.md`](../CLAUDE.md).

### 5. Apply & report
Execute approved operations via the MCP write tools, then report what changed
with links back to Plane.

## Design decisions

- **Read freely, write only on approval.** Observation is non‑destructive, so the
  agent reads Plane without asking. Mutations are gated behind human confirmation.
- **Idempotent diffs.** Re‑running on the same note should produce no new changes
  if Plane already reflects it — the agent compares against live state, not a log.
- **Secrets and notes stay local.** The token (`.mcp.json`) and transcripts
  (`meetings/`) are git‑ignored; only scaffolding is published.
