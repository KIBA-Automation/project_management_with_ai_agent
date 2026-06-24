# Project Management with an AI Agent

An AI agent that turns **meeting notes into project management actions** on a live
[Plane](https://plane.so) workspace — with a human in the loop on every change.

You drop a plain‑text meeting transcript into a local folder. The agent reads it,
compares what was discussed against the *current* state of your Plane projects
(via the Plane **MCP** server), and proposes a concrete set of updates: new work
items, status changes, re‑assignments, new cycles, and so on. **Nothing is written
to Plane until you confirm it.**

> Live workspace this was built against: `https://plane.bit-habit.com/kiba`

---

## Why this exists

Meetings produce decisions; project trackers drift out of date. The gap between
"what we agreed in the room" and "what the board says" is where work gets lost.
This project closes that gap by treating the meeting note as the source of intent
and the Plane workspace as the source of record — and using an agent to reconcile
the two, under human supervision.

It's also a portfolio piece demonstrating an **agentic, human‑in‑the‑loop
workflow** built on the Model Context Protocol.

---

## How it works

```
  meetings/*.txt            ┌──────────────────────┐         Plane MCP server
  (private, local only)  ─▶ │      AI agent        │ ◀──────▶ plane.bit-habit.com
                            │  (Claude Code + MCP) │          (read + write)
  current Plane state    ─▶ │                      │
                            └──────────┬───────────┘
                                       │
                              proposes a change set
                                       │
                                       ▼
                            ┌──────────────────────┐
                            │   YOU confirm / edit  │  ◀── human in the loop
                            └──────────┬───────────┘
                                       │ approved only
                                       ▼
                                 writes to Plane
```

1. **Read** — the agent reads the new meeting note(s) from `meetings/`.
2. **Observe** — it queries the live Plane workspace (projects, work items,
   states, cycles, assignees) through the MCP server.
3. **Diff** — it reconciles the meeting's decisions against the current board and
   builds a proposed change set.
4. **Confirm** — it presents the change set and waits for your explicit approval.
   You can approve, reject, or edit individual items.
5. **Apply** — only approved changes are written back to Plane.

---

## Worked example

A real reconciliation run, anonymized. The agent had read a daily‑standup
transcript and the live board (8 work items across Backlog / Todo / In Progress).

**1 — Agent proposes a change set** (nothing is written yet):

```
📋 Proposed changes — 2025-xx-xx standup → <project>

✅ High confidence
[1] TASK-8  "<cost-analysis task>"      Backlog → Todo
    ↳ source: "...we'll start discussing this from the next meeting"
[2] TASK-7  "<expense-automation task>" Backlog → Todo
    ↳ source: "...calculate it and report back in 24 hours"
[3] TASK-2  "<licensing task>"          + comment (reviewer feedback)
    ↳ source: "...the direction is wrong, requirements need re-checking first"

⚠️ Needs clarification
[4] New task? "<idea-queue dashboard>"  — may duplicate TASK-4. Confirm?

⏸️ Held back (low confidence)
    Priority bump on TASK-7 — not explicitly stated, won't guess.
```

**2 — Human decides:**

```
> apply 1, 2, 3.  #4 is already handled — skip it.
```

**3 — Agent applies only the approved items and reports back:**

```
✅ TASK-8  Backlog → Todo
✅ TASK-7  Backlog → Todo
✅ TASK-2  comment added
   #4 skipped (per your call). No other writes.
```

Note how the agent **quotes the transcript line** behind every proposal, **flags
ambiguity instead of guessing**, and **writes only what was approved** — the
held‑back priority change never happened.

---

## Privacy

**Meeting notes never leave your machine.** Everything under `meetings/` is
git‑ignored, and so is the live `.mcp.json` (which holds your Plane API token).
Only the public scaffolding — README, architecture, and example config — is
committed. See [`.gitignore`](.gitignore).

---

## Setup

1. **Clone & install prerequisites** — [Claude Code](https://claude.com/claude-code)
   (or any MCP‑capable client) and access to a Plane instance.
2. **Configure MCP** — copy the example and fill in your own values:
   ```bash
   cp .mcp.json.example .mcp.json   # .mcp.json is git-ignored
   ```
   Put your Plane API token and workspace URL in `.mcp.json`.
3. **Add a meeting note** — save a transcript as `meetings/2026-06-24-standup.txt`.
4. **Run the agent** and ask it to reconcile the latest note with Plane. It will
   propose changes and wait for your confirmation before writing anything.

---

## Repository layout

```
.
├── README.md              # you are here
├── CLAUDE.md              # the agent's operating manual (behaviour + confirmation policy)
├── .gitignore             # keeps meeting notes & secrets out of git
├── .mcp.json.example      # template MCP config (no secrets)
├── docs/
│   └── ARCHITECTURE.md    # data flow & design decisions
└── meetings/              # PRIVATE — local meeting notes live here (git-ignored)
    └── README.md
```

---

## Tech

- **Plane** — open‑source project management, self‑hosted.
- **Model Context Protocol (MCP)** — gives the agent typed, tool‑level access to
  the Plane API.
- **Claude Code** — the agent runtime driving the read → diff → confirm → apply loop.
