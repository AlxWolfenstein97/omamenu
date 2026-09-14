#!/usr/bin/env bash
#
# OmaMenu installer. Enables this menu clone and parks the stock omarchy.menu.
#
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
plugin_id="io.github.alxwolfenstein97.omamenu"

note() { printf 'omamenu: %s\n' "$1"; }

chmod 644 "$here"/*.qml "$here"/*.js "$here"/manifest.json "$here"/LICENSE 2>/dev/null || true
chmod 755 "$here"/install.sh "$here"/uninstall.sh "$here"/check.sh 2>/dev/null || true

omarchy-shell -q shell rescanPlugins >/dev/null 2>&1 || true

if command -v omarchy >/dev/null 2>&1; then
  # Disabling a leftover local clone frees the bar slot / cloneSourceRestores.
  omarchy plugin disable alex.menu >/dev/null 2>&1 || true
  omarchy plugin enable "$plugin_id" >/dev/null 2>&1 || true
fi

omarchy-shell -q shell rescanPlugins >/dev/null 2>&1 || true
omarchy-shell -q omarchy.menu refresh >/dev/null 2>&1 || true

note "done — Super+Space opens OmaMenu (scrolling labels)"
note "stock omarchy.menu stays disabled while this clone is enabled"
exit 0
