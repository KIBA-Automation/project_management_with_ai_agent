# 0003 — Agent proposes, human confirms — never auto-writes

- **Status:** Accepted
- **Date:** 2026-06

## Context

The board is driven by an AI agent reading private meeting notes. An agent that writes
to the board on its own could mis-read intent, act on an ambiguous line, or take an
irreversible action (delete, reassign, write to the wrong repo) — with no one in the
loop. The board is the org's source of record, so a wrong write has real cost.

## Decision

Adopt an explicit **human-in-the-loop contract**, codified in
[`../../CLAUDE.md`](../../CLAUDE.md):

- The agent may freely **read** and **propose**, but **every write requires explicit
  confirmation**, defaulting to per-item approval.
- Each proposed change must **quote the meeting-note line** that justifies it.
- A hard **"never allowed"** list fences off irreversible / out-of-scope actions
  (deletes, touching access control, writing outside the designated board, editing the
  code/issues behind the board, exposing meeting notes).
- When a note is ambiguous, the agent **surfaces it and asks** instead of guessing.

## Consequences

- **+** Safe to let an agent operate a real board; a bad proposal costs a glance, not a
  cleanup.
- **+** Every change is auditable back to a transcript line.
- **+** Privacy: notes stay local and are never echoed to an external service.
- **−** Slower than full automation — a human is on the critical path for every write.
  Accepted deliberately: trust is the point.

## Alternatives considered

- **Full automation** — rejected: unacceptable blast radius on the source of record.
- **Post-hoc review** (write first, audit later) — rejected: irreversible actions can't
  be un-done after the fact.
