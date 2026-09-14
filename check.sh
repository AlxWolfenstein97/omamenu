#!/usr/bin/env bash
# Lightweight self-check for OmaMenu (no shell restart required).
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fail=0
pass() { printf 'ok  %s\n' "$1"; }
bad()  { printf 'FAIL %s\n' "$1"; fail=1; }

[[ -f $here/manifest.json ]] || bad "manifest.json missing"
[[ -f $here/Menu.qml ]] || bad "Menu.qml missing"
[[ -f $here/MenuModel.js ]] || bad "MenuModel.js missing"
[[ -f $here/AppSearch.js ]] || bad "AppSearch.js missing"
[[ -f $here/BarWidget.qml ]] || bad "BarWidget.qml missing"
[[ -f $here/LICENSE ]] || bad "LICENSE missing"

id=$(jq -r '.id // empty' "$here/manifest.json")
[[ $id == io.github.alxwolfenstein97.omamenu ]] || bad "manifest id is '$id'"
cloned=$(jq -r '.omarchy.clonedFrom // empty' "$here/manifest.json")
[[ $cloned == omarchy.menu ]] || bad "clonedFrom is '$cloned'"

rg -q 'component ScrollingLabel' "$here/Menu.qml" || bad "ScrollingLabel missing"
rg -q 'launcher\.hides' "$here/Menu.qml" || bad "launcher.hides wiring missing"
rg -q 'AppSearch' "$here/Menu.qml" || bad "AppSearch import/use missing"

if command -v omarchy-plugin-validate >/dev/null 2>&1; then
  if omarchy-plugin-validate "$here" >/dev/null 2>&1; then
    pass "omarchy-plugin-validate"
  else
    bad "omarchy-plugin-validate"
  fi
fi

[[ $fail -eq 0 ]] && pass "OmaMenu structure"
exit "$fail"
