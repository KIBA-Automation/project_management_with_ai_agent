#!/usr/bin/env bash
# Print the current board (every item with its Status / Priority).
set -euo pipefail
_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "$_DIR/config.env"

gh project item-list "$PROJECT_NUMBER" --owner "$OWNER" --limit 200 --format json --jq \
  '.items | sort_by(.priority, .title)[]
   | "  " + (.title | .[0:40]) + "  [" + (.status // "-") + " / " + (.priority // "-") + "]"'
