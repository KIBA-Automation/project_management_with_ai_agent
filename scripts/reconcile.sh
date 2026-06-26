#!/usr/bin/env bash
# One reconcile step on the GitHub Project, mirroring the CLAUDE.md loop:
#   Propose (quote the source line) -> Confirm -> Apply -> Report.
#
# Usage:
#   reconcile.sh "<item title substring>" [--status "<Status>"] \
#                [--priority <High|Medium|Low>] [--source "<quoted note line>"] [--yes]
#
# Dry-run by default (prints the proposal only). Add --yes to actually write.
#
# Examples:
#   reconcile.sh "출장 경비" --status "In Progress" --source '"오늘 업그레이드…" (원장님 06-24)'
#   reconcile.sh "출장 경비" --status "In Progress" --yes
set -euo pipefail
_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "$_DIR/lib.sh"

TITLE="${1:?usage: reconcile.sh \"<item title>\" [--status S] [--priority P] [--source Q] [--yes]}"
shift
STATUS=""; PRIORITY=""; SOURCE=""; APPLY=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --status)   STATUS="$2";   shift 2;;
    --priority) PRIORITY="$2"; shift 2;;
    --source)   SOURCE="$2";   shift 2;;
    --yes)      APPLY=1;       shift;;
    *) echo "unknown arg: $1" >&2; exit 1;;
  esac
done

echo "──────────── PROPOSED CHANGE ────────────"
echo "  Item     : $TITLE"
[[ -n "$STATUS"   ]] && echo "  Status   → $STATUS"
[[ -n "$PRIORITY" ]] && echo "  Priority → $PRIORITY"
[[ -n "$SOURCE"   ]] && echo "  Source   : $SOURCE"
echo "─────────────────────────────────────────"

if [[ "$APPLY" -ne 1 ]]; then
  echo "(dry-run) re-run with --yes to apply."
  exit 0
fi

PID=$(project_id)
IID=$(item_id "$TITLE")
if [[ -n "$STATUS" ]]; then
  gh project item-edit --id "$IID" --project-id "$PID" \
    --field-id "$(field_id Status)" --single-select-option-id "$(option_id Status "$STATUS")" >/dev/null
  echo "✓ Status → $STATUS"
fi
if [[ -n "$PRIORITY" ]]; then
  gh project item-edit --id "$IID" --project-id "$PID" \
    --field-id "$(field_id Priority)" --single-select-option-id "$(option_id Priority "$PRIORITY")" >/dev/null
  echo "✓ Priority → $PRIORITY"
fi
