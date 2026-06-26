# Decision Log (ADRs)

This folder is a **Decision Log** — a numbered series of **ADRs**
(*Architecture Decision Records*). Each ADR is a one-page note that captures a single
significant decision:

> **what** we decided · **why** (the context/forces) · **what else** we considered ·
> **what it costs** us (the trade-offs / consequences).

**Why keep one?** Code shows *what* the system does; an ADR shows *why* it is that way.
Months later — or to a stranger reading this repo — the reasoning is still here, so
decisions can be revisited on purpose instead of re-argued from scratch. It is also
the clearest evidence of how the author exercises engineering judgment.

A decision recorded here is not frozen forever: if a later decision overrides an
earlier one, we add a *new* ADR and mark the old one `Superseded` — we never rewrite
history.

## Format

Each file is `NNNN-short-title.md` with: **Status · Date · Context · Decision ·
Consequences · Alternatives considered**. Copy an existing one as a template.

## Index

| # | Decision | Status |
|---|----------|--------|
| [0001](0001-migrate-plane-to-github-projects.md) | Move the board from self-hosted Plane to GitHub Projects | Accepted |
| [0002](0002-model-work-as-draft-issue-epic.md) | Model work as Draft → Issue → Epic, at three altitudes | Accepted |
| [0003](0003-human-in-the-loop-confirmation.md) | Agent proposes, human confirms — never auto-writes | Accepted |
