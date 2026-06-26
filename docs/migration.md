# Migration: Plane → GitHub Projects

This project started as a **meeting-notes → Plane** reconcile agent (self-hosted
Plane at `plane.bit-habit.com`, driven via the Plane MCP server). In June 2026 we
moved the live board to **GitHub Projects** under the
[`KIBA-Automation`](https://github.com/KIBA-Automation) organization. This note
records why and how, so the decision is auditable.

## Why we moved

The reconcile workflow only ever used the **base layer** of a PM tool: a handful of
work items with a Status, a Priority, a description, and comments — driven by an AI
agent. None of Plane's differentiators (Cycles, Modules, Initiatives, Epics, Intake,
Estimates) were in use, yet we paid Plane's full cost: **self-hosting** (upgrades,
backups, uptime).

| Axis | Plane (self-hosted, via MCP) | GitHub Projects (via `gh`) |
|------|------------------------------|-----------------------------|
| Hosting / upkeep | We run & maintain the server | None (GitHub runs it) |
| Cost at our scale | Server cost | Effectively free |
| Agent automation | Rich MCP (names → IDs resolved for you) | `gh` CLI + Projects v2 GraphQL; more ID plumbing |
| Data model | PM-native (state groups, cycles, roadmap) | Issues + custom fields (simpler) |
| Link to code | Separate system | Same place as repos, issues, PRs |
| Privacy | Fully self-controlled | Metadata on GitHub (notes stay local either way) |

The deciding factors for us:

1. **The code already lives on GitHub.** Putting work items next to the repos,
   issues, and commits they relate to is worth more than a richer standalone board.
2. **Zero hosting** removes the one real ongoing cost we were paying.
3. The agent-automation gap is real but **one-time**: GitHub addresses everything by
   opaque node IDs, so we wrote [`../scripts/`](../scripts/) to resolve them by name
   — after that, the reconcile loop is as clean as it was on Plane.

We kept the exploration honest: the CLI experiment that drove Plane,
[`plane-cli-for-ai-agents`](https://github.com/bookseal/plane-cli-for-ai-agents),
is **archived** (read-only) with a note pointing here — a record of the path, not a
deletion.

## What changed

- **Board** → GitHub Project [`KIBA-Automation/projects/1`](https://github.com/orgs/KIBA-Automation/projects/1).
  Plane's five states (`Backlog / Todo / In Progress / Done / Cancelled`) were
  recreated on the Project's `Status` field (the built-in field ships with three;
  we extended it via the GraphQL `updateProjectV2Field` mutation), plus a `Priority`
  single-select (`High / Medium / Low`). All 8 work items were migrated with their
  then-current Status and Priority.
- **Write path** → the Plane MCP tools are replaced by [`../scripts/`](../scripts/)
  (`board.sh`, `reconcile.sh`) built on `gh`.
- **Repos** → `quali-fit`, `project_management_with_ai_agent` (this repo), and
  `KIBA_Meeting_Transcript` were transferred into the org and tagged with the
  `kiba` topic. Old `bookseal/…` URLs redirect automatically.

## How the repos are organized

GitHub repos are a flat namespace — there is no folder that contains repos — so
"grouping" is achieved with three things working together:

- **The organization** (`KIBA-Automation`) — one namespace owning the repos.
- **A cross-repo Project** — one board that can pull issues from any repo (replaces
  Plane as the work tracker).
- **A topic + this hub repo** — every KIBA repo carries the `kiba` topic for
  filtering, and this repo acts as the documentation / control hub.

No org-internal folders exist either, but `github.com/KIBA-Automation` + the `kiba`
topic + the Project board together give the "folder over repos" feel.

## What did NOT change

- **Meeting notes stay private and local.** Transcripts are never committed or sent
  to any external service — same as before. See the repo `.gitignore`.
- **The loop is the same.** Read note → observe board → diff → **propose** →
  human confirm → apply → report. Only the "observe" and "apply" mechanics changed
  (MCP → `gh`).
