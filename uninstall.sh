#!/usr/bin/env bash
#
# Disable OmaMenu and restore stock omarchy.menu when nothing else claims it.
#
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
plugin_id="io.github.alxwolfenstein97.omamenu"

note() { printf 'omamenu: %s\n' "$1"; }

if command -v omarchy >/dev/null 2>&1; then
  omarchy plugin disable "$plugin_id" >/dev/null 2>&1 || true
  omarchy plugin enable omarchy.menu >/dev/null 2>&1 || true
fi

omarchy-shell -q shell rescanPlugins >/dev/null 2>&1 || true
omarchy-shell -q omarchy.menu refresh >/dev/null 2>&1 || true

note "done — stock omarchy.menu re-enabled; plugin files left at $here"
exit 0
