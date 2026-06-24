# meetings/ — PRIVATE

Drop raw meeting transcripts here as plain‑text files, e.g.:

```
meetings/2026-06-24-standup.txt
meetings/2026-06-30-planning.txt
```

**These files are git‑ignored and must never be committed.** The agent reads them
locally to reconcile decisions against the live Plane workspace. Only this README
and a `.gitkeep` placeholder are tracked, so the folder exists after a fresh clone.

Suggested note format (free‑form is fine — the agent parses prose):

```
Date: 2026-06-24
Attendees: ...
Decisions:
- ...
Action items:
- <who> will <what> by <when>
```
