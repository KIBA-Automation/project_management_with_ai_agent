# scripts/ — drive the GitHub Project from the CLI

Small `gh`-based helpers that let a human (or the AI agent) read and update the
**KIBA Automation** GitHub Project without touching node IDs by hand. They are the
GitHub-Projects equivalent of the Plane MCP write tools this repo started with —
see [`../docs/migration.md`](../docs/migration.md) for why we switched.

## Prerequisites

- [`gh`](https://cli.github.com/) authenticated with the **`project`** scope
  (`gh auth refresh -s project` if missing).
- `python3` (used to resolve names → IDs).

Which board they act on is set in [`config.env`](config.env):

```
OWNER=KIBA-Automation
PROJECT_NUMBER=1
```

## Scripts

| Script | What it does |
|--------|--------------|
| `board.sh` | Print every item with its Status / Priority. |
| `reconcile.sh` | Propose → confirm → apply one Status/Priority change to an item. |
| `lib.sh` | Shared helpers: resolve project / field / option / item IDs **by name**. |

## Usage

```bash
# See the board
./board.sh

# Propose a change (dry-run — nothing is written, just prints the proposal)
./reconcile.sh "출장 경비" --status "In Progress" \
  --source '"오늘 이걸 업그레이드 시켜가지고…" (원장님 06-24)'

# Apply it (human-in-the-loop gate: only writes when you add --yes)
./reconcile.sh "출장 경비" --status "In Progress" --yes
```

`reconcile.sh` matches the item by **title substring** and refuses to act if the
substring matches zero or several items — it never guesses which one you meant.

## Why resolve by name?

GitHub Projects v2 addresses everything by opaque node IDs (`PVT_…`, `PVTSSF_…`,
`PVTI_…`). Hardcoding them makes scripts brittle — recreate the board and they all
change. `lib.sh` looks them up from human names (`Status`, `In Progress`, a title
substring) on each run, so the scripts keep working and read like intent.
