# Agent Operating Manual

This file instructs the AI agent (run via Claude Code) on how to manage the Plane
workspace from meeting notes. Read it fully before acting.

## Mission

Reconcile decisions captured in `meetings/*.txt` with the live Plane workspace at
`https://plane.bit-habit.com/kiba`, proposing concrete updates and applying only
those the human approves.

## The loop

1. **Read** the newest unprocessed note(s) in `meetings/`. Treat them as private —
   never echo their full contents into any external service or commit.
2. **Observe** current Plane state via the `plane` MCP server (read‑only tools).
3. **Diff** decisions against current state into a concrete change set. Skip
   operations whose effect already matches Plane (stay idempotent).
4. **Propose** the change set to the human as a numbered, reviewable list. For each
   item show: the operation, the target work item/project, and the source line
   from the note.
5. **Confirm** — wait for explicit approval. Honor the Confirmation Policy below.
6. **Apply** approved operations via MCP write tools, then **report** what changed
   with Plane links.

## Conventions

- Always name the target project before creating or moving work items.
- Prefer updating existing work items over creating duplicates — search first.
- Quote the meeting‑note line that justifies each proposed change.
- Never commit anything under `meetings/` or a real `.mcp.json`.

## Confirmation Policy

This section defines the human‑in‑the‑loop contract: what the agent may do, what
always needs sign‑off, and what it must never do.

### Allowed without asking
- Read-only observation: list/retrieve projects, work items, states, cycles,
  modules, members, and activity.
- Searching for existing work items to avoid duplicates.
- Drafting and presenting a proposed change set.

### Always requires explicit confirmation
- Any write to Plane: creating work items, changing status, reassigning,
  editing titles/descriptions, adding to or removing from cycles/modules, adding
  labels or comments.
- Default to **per-item approval**. A single bulk "approve all" is allowed only
  when the human explicitly says so after seeing the full list.
- Each proposed change must quote the source line from the meeting note that
  justifies it.

### Never allowed
- Deleting projects, work items, cycles, modules, comments, or any bulk delete.
- Touching members, roles, or permissions.
- Writing to any workspace or project other than `kiba`.

### When uncertain
- If a meeting note is ambiguous, do **not** guess — surface the ambiguity and
  ask the human to clarify before proposing the change.
