# 0001 — Move the board from self-hosted Plane to GitHub Projects

- **Status:** Accepted
- **Date:** 2026-06

## Context

The reconcile workflow only ever used the **base layer** of a PM tool: a handful of
work items with a Status, a Priority, a description, and comments — driven by an AI
agent. None of Plane's differentiators (Cycles, Modules, Initiatives, Epics, Intake,
Estimates) were in use, yet we paid Plane's full cost: **self-hosting** it
(upgrades, backups, uptime) at `plane.bit-habit.com`. Meanwhile the code we manage
already lives on GitHub.

## Decision

Move the live board to **GitHub Projects** (Projects v2) under the
[`KIBA-Automation`](https://github.com/KIBA-Automation) org, and replace the Plane MCP
write path with `gh`-based [scripts](../../scripts/).

## Consequences

- **+** Zero hosting/upkeep; effectively free at our scale.
- **+** Work items now sit next to the repos, issues, and commits they relate to.
- **+** One cross-repo board spanning the org.
- **−** GitHub addresses everything by opaque node IDs, so we had to write helpers to
  resolve them by human-readable names. This was a **one-time** cost — see
  [`../../scripts/lib.sh`](../../scripts/lib.sh).
- **−** A simpler data model (Issues + custom fields) — acceptable, since we never used
  the richer Plane primitives.

## Alternatives considered

- **Stay on Plane** — rejected: we paid for hosting + features we did not use.
- **Jira / Linear** — rejected: another external system away from the code, with its
  own cost and lock-in.

> Full narrative and the comparison table: [`../migration.md`](../migration.md).
