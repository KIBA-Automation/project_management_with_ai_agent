#!/usr/bin/env bash
# Shared helpers: resolve GitHub Project IDs from human-readable names at runtime,
# so callers never hardcode node IDs (PVT_/PVTSSF_/PVTI_…). Requires `gh` with the
# `project` token scope.
set -euo pipefail
_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "$_LIB_DIR/config.env"

_fields_json() { gh project field-list "$PROJECT_NUMBER" --owner "$OWNER" --format json; }
_items_json()  { gh project item-list  "$PROJECT_NUMBER" --owner "$OWNER" --limit 200 --format json; }

project_id() { gh project view "$PROJECT_NUMBER" --owner "$OWNER" --format json --jq '.id'; }

# field_id "<Field Name>"
field_id() {
  _fields_json | python3 -c "import sys,json
d=json.load(sys.stdin)['fields']
m=[f for f in d if f['name']==sys.argv[1]]
if not m: sys.exit('no field named: '+sys.argv[1])
print(m[0]['id'])" "$1"
}

# option_id "<Field Name>" "<Option Name>"
option_id() {
  _fields_json | python3 -c "import sys,json
d=json.load(sys.stdin)['fields']
f=[x for x in d if x['name']==sys.argv[1]][0]
m=[o for o in f.get('options',[]) if o['name']==sys.argv[2]]
if not m: sys.exit('no option %r in field %r'%(sys.argv[2],sys.argv[1]))
print(m[0]['id'])" "$1" "$2"
}

# item_id "<title substring>"  — errors if zero or multiple matches (no silent guess)
item_id() {
  _items_json | python3 -c "import sys,json
subs=sys.argv[1]
items=json.load(sys.stdin)['items']
m=[i for i in items if subs in i.get('title','')]
if not m: sys.exit('no item matches: '+subs)
if len(m)>1: sys.exit('ambiguous (%d matches) for: %s'%(len(m),subs))
print(m[0]['id'])" "$1"
}
