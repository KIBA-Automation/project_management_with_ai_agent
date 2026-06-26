# 0002 — Model work as Draft → Issue → Epic, at three altitudes

- **Status:** Accepted
- **Date:** 2026-06

## Context

After moving to GitHub Projects (see [0001](0001-migrate-plane-to-github-projects.md)),
the 8 migrated items were all **draft items** with titles like `AP-6 …알림 시스템`,
carried over from Plane's key-prefixed style. Two questions surfaced while learning the
tool: (1) when should a draft become a real issue, and (2) at what *altitude* should an
item's title sit — the ultimate goal, or a granular checklist?

## Decision

1. **Capture as a draft, promote to an issue when defined + homed.** A draft is a
   board-only quick capture; convert it to an issue (which forces choosing a repo —
   that choice *is* the link to code) only once the work is real and its repo is known.
2. **Pick the tool by altitude, then the title writes itself:**
   - **Goal** → a **Milestone** (dated bucket) or an **Epic** (parent issue with
     sub-issues + an auto progress bar).
   - **Task** → an **Issue**. *This is where the item title lives.*
   - **Checklist** → **sub-issues** or a `- [ ]` task list in the issue body.
3. **Titles are `verb + object`, no key prefix.** The issue `#number` is the identity;
   categorization goes in Labels / Repository / Milestone / Priority, not the title.

## Consequences

- **+** Drafts without a repo home stay drafts instead of becoming orphan issues.
- **+** Epic ↔ sub-issue structure gives a free `Sub-issues progress` roll-up.
- **+** Titles stay short and searchable.
- **−** More upfront judgment per item (which altitude? which repo?) than blindly
  converting everything 1:1.

## Alternatives considered

- **Convert every draft to an issue immediately** — rejected: many have no repo home or
  firm definition yet; would create orphan/oversized issues.
- **Keep `AP-n` prefixes in titles** — rejected: duplicates the native issue number and
  reads as Jira/Plane, not GitHub.

> The full conventions live in
> [`../github-projects-playbook.md`](../github-projects-playbook.md).
