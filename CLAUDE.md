# Agent Operating Manual

This file instructs the AI agent (run via Claude Code) on how to manage the
**KIBA-Automation** GitHub Projects board from meeting notes. Read it fully before
acting.

## Mission

Reconcile decisions captured in `meetings/*.txt` with the live GitHub Project at
`https://github.com/orgs/KIBA-Automation/projects/1`, proposing concrete updates and
applying only those the human approves.

## The loop

1. **Read** the newest unprocessed note(s) in `meetings/`. Treat them as private —
   never echo their full contents into any external service or commit.
2. **Observe** the current board read-only via `gh` — `scripts/board.sh`, or
   `gh project item-list`.
3. **Diff** decisions against current state into a concrete change set. Skip
   operations whose effect already matches the board (stay idempotent).
4. **Propose** the change set to the human as a numbered, reviewable list. For each
   item show: the operation, the target board item, and the source line from the note.
5. **Confirm** — wait for explicit approval. Honor the Confirmation Policy below.
6. **Apply** approved operations via `scripts/reconcile.sh` (or `gh`), then **report**
   what changed with links to the board.

## Conventions

- The board is the source of *record*; the meeting note is the source of *intent*.
- Prefer updating existing items over creating duplicates — match by title first.
- Quote the meeting-note line that justifies each proposed change.
- **Status** is the Project's built-in single-select field; its options
  (`Backlog / Todo / In Progress / Done / Cancelled`) carry over the old Plane states.
  The human moves items to **In Progress** themselves — don't auto-start.
- **Priority** (`High / Medium / Low`) is a custom single-select field, used as a
  focus lens (group/filter a saved view by it), not just an importance label.
- Not every directive becomes a task or a status bump — some decisions are scope
  guardrails best recorded as a note, not a new item. Note: a Project *item* only has
  a comment thread once it's backed by an Issue/PR; a plain draft item has none. Don't
  inflate the board.
- Never commit anything under `meetings/`.

## Confirmation Policy

This section defines the human-in-the-loop contract: what the agent may do, what
always needs sign-off, and what it must never do.

### Allowed without asking
- Read-only observation: list/inspect the project, items, fields, status, priority.
- Searching the board for existing items to avoid duplicates.
- Drafting and presenting a proposed change set.

### Always requires explicit confirmation
- Any write to the board: changing Status/Priority, adding items (draft or an
  existing Issue/PR), editing item titles/bodies, commenting on an Issue/PR-backed
  item, or adding to / archiving from the Project.
- Default to **per-item approval**. A single bulk "approve all" is allowed only when
  the human explicitly says so after seeing the full list.
- Each proposed change must quote the source line from the meeting note that
  justifies it.

### Never allowed
- Deleting anything: removing items from the Project (`item-delete`), deleting the
  Project itself, or any bulk delete. Removing a board item is irreversible — archive
  is the reversible alternative, and even that requires confirmation.
- Touching access control: changing org / repo / Project collaborators, roles,
  visibility, or permissions; transferring or archiving repositories.
- Writing outside the designated board: any write to a Project or repo other than the
  one in `scripts/config.env` (`KIBA-Automation` / project `1`).
- Touching the issues, PRs, or code behind the board: closing, merging, reopening, or
  editing Issues / Pull Requests, or pushing commits. This agent reconciles the
  board's items and fields — not the code under them.
- Exposing meeting notes: committing anything under `meetings/`, or echoing note
  contents into any GitHub-visible surface (item bodies, issue/PR comments, commits).

### When uncertain
- If a meeting note is ambiguous, do **not** guess — surface the ambiguity and ask
  the human to clarify before proposing the change.
