# OmaMenu

**Stock Omarchy menu, with one habit fixed: highlighted rows that would
normally die behind an ellipsis scroll far enough to read.**

![OmaMenu on Hackerman — highlighted app name mid-marquee](preview.png)

Works in Apps, Fonts, Gaming, plugin enable/disable/clone/remove (including
the id subline), and search results. Idle rows still elide. Highlighted rows
that actually overflow pause, scroll once through the hidden tail, pause,
then reset — no ping-pong, no endless wrap.

## Why

Omarchy’s menu is narrow on purpose. Long labels (`Heroic (Epic Games)`,
`RetroArch Game Launcher`, `io.github.…` plugin ids) get cut with `…`.
Hovering or arrowing onto them used to leave you guessing. OmaMenu shows the
rest when you care, and stays quiet when the name already fits.

It also keeps the stock Apps filter: `/usr/share/omarchy/default/omarchy/launcher.hides`
plus the usual `NoDisplay` / `OnlyShowIn` scan, so Avahi and friends stay out
of the list.

## Install

```sh
omarchy plugin add https://github.com/AlxWolfenstein97/omamenu.git --enable
```

That clones into `~/.config/omarchy/plugins/io.github.alxwolfenstein97.omamenu`
and replaces stock `omarchy.menu` (same `clonedFrom` routing the built-in
clone path uses). Or from a checkout:

```sh
~/.config/omarchy/plugins/io.github.alxwolfenstein97.omamenu/install.sh
```

**Needs:** Omarchy shell / Quickshell. Super+Space opens the menu.

No extra packages — OmaMenu is a Quickshell menu clone, not a Pillow mockup
carousel. (The Style theme extenders that *do* draw PNGs pull `python-pillow`
themselves; see [Chroma](https://github.com/AlxWolfenstein97/chroma) for the
family map.)

## Disable vs remove

| Action | What happens |
|--------|----------------|
| `./uninstall.sh` | Disables this clone and re-enables stock `omarchy.menu`. No packages to drop. |
| `omarchy plugin remove …` | Deletes the plugin folder after uninstall. |

**Full wipe** — copy-paste:

```sh
~/.config/omarchy/plugins/io.github.alxwolfenstein97.omamenu/uninstall.sh
omarchy plugin remove io.github.alxwolfenstein97.omamenu
```

## Notes

- Third-party menu clones do not always receive `shell.appLibrary`. OmaMenu
  falls back to `DesktopEntries` + a local `AppSearch.js` copy so Apps still
  populate, with the same hide list as stock.
- Bar widget IPC targets stay `omarchy.menu`; the shell routes them through
  `clonedFrom`.

## Limits

- **Icons** — prefer `appLibrary.iconSource` when the host wires it. This clone
  usually gets a **null** `shell.appLibrary` proxy (stock menu gets the real
  AppLibrary). Gating Image `source` on `appLibrary` alone blanks every app
  icon after a shell restart. OmaMenu therefore: (1) try the proxy when
  present, (2) run the same apps/devices + pixmaps disk scan stock uses
  (`localIconIndex`), (3) fall back to `Quickshell.iconPath`, and (4) bump
  `iconEpoch` after open / scan / `appsChanged` so Images rebind when file
  URLs land. That covers missing packs such as Vantablack’s `Yaru-gray` /
  White’s `Yaru-grey`.
- Marquee only runs on highlighted overflow rows; idle rows still elide.

## Fresh VM smoke test

```sh
omarchy plugin add https://github.com/AlxWolfenstein97/omamenu.git --enable
# disable stock menu if the clone owns the bar slot (Workshop / clone flow)
omarchy-restart-shell
# Apps submenu: icons should appear within ~1–2s of first open (disk scan).
# Switch to a theme with a missing icon pack (e.g. vantablack → Yaru-gray) if
# installed; icons should still fill in after the scan, not stay blank forever.
```
## Credits

- [Omarchy](https://omarchy.org/) — the first-party menu this clones.
- [OMCP](https://github.com/btsouth/omarchy-omcp) — MCP desktop bridge
  (screenshots, themes, window focus, …). This plugin was basically built
  through it: open the menu, poke Apps / Gaming / Fonts / plugin pickers,
  catch empty lists and mid-marquee bugs, swap to Hackerman for the preview,
  repeat. Install with
  `omarchy plugin add https://github.com/btsouth/omarchy-omcp --enable`.

## License

MIT — see [LICENSE](LICENSE). Built on Omarchy’s first-party menu.
