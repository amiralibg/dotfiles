# YabaiSpaces

A tiny native macOS menu-bar app for [yabai](https://github.com/koekeishiya/yabai),
built as the companion to the **[yabai config in this dotfiles repo](../yabai/README.md)**
([`yabairc`](../yabai/.config/yabai/yabairc) · [`skhdrc`](../skhd/.config/skhd/skhdrc)).
The two are designed to be used together — the Desktop names it shows are the
ones `yabairc` assigns, and the keys in the dropdown are the ones `skhdrc` binds.

- **Status item** — the **name of the Desktop you're currently on**
  (`main`, `term`, `code`, `web`, `chat`, `ai`, `design`).
- **Click it** — a row per Desktop (index pill + the app icons on it), grouped by
  display. Click a row to focus that Desktop.
- **⌃⌥Space** — a blurred, fuzzy **window switcher across every Desktop**: app
  icon, app name, dimmed window title, and a Desktop badge. Type to filter,
  ↑/↓ to move, ⏎ to focus, esc to dismiss.

It's an AppKit agent (`LSUIElement`, no Dock icon) that reads everything from
`yabai -m query` — no private APIs. It refreshes on
`NSWorkspace.activeSpaceDidChangeNotification` plus a 2s safety poll, and
registers its hotkey with Carbon `RegisterEventHotKey`, so it needs **no
Accessibility permission** of its own.

## Build & run

```bash
./build.sh                 # compiles build/YabaiSpaces.app
open build/YabaiSpaces.app # launch it
```

- **Auto-start:** System Settings → General → **Login Items** → **+** → pick
  `build/YabaiSpaces.app`.
- **After editing `main.swift`:** re-run `./build.sh`, then quit (menu → Quit)
  and relaunch.
- **Rebind the hotkey:** change the keycode/modifiers in `installHotKey` in
  `main.swift` (currently `kVK_Space` + control + option).
- If it hides in a crowded menu bar / behind the notch, a menu-bar manager like
  **Ice** or **Hidden Bar** can pin it.

`build/` is gitignored; only the source (`main.swift`, `build.sh`) is tracked.

> Requires yabai at `/opt/homebrew/bin/yabai` (edit `yabaiPath` in `main.swift`
> if yours differs). Replaces sketchybar's spaces widget with a single compact
> menu-bar label — which is why the sketchybar signal block in
> [`yabairc`](../yabai/.config/yabai/yabairc) ships commented out.
