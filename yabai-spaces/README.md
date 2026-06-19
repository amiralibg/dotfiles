# YabaiSpaces

A tiny native macOS menu-bar app for yabai. The status item shows the **name of
the Desktop you're currently on**; clicking it opens a dropdown of **every
Desktop** (grouped by display) with the **windows on each** (app icon + title).
Click a Desktop or a window to focus it.

It's a ~150-line AppKit agent (`LSUIElement`, no Dock icon) that reads everything
from `yabai -m query` — no private APIs. It refreshes on
`NSWorkspace.activeSpaceDidChangeNotification` plus a 2s safety poll.

## Build & run

```bash
./build.sh                 # compiles build/YabaiSpaces.app
open build/YabaiSpaces.app # launch it
```

- **Auto-start:** System Settings → General → **Login Items** → **+** → pick
  `build/YabaiSpaces.app`.
- **After editing `main.swift`:** re-run `./build.sh`, then quit (menu → Quit)
  and relaunch.
- If it hides in a crowded menu bar / behind the notch, a menu-bar manager like
  **Ice** or **Hidden Bar** can pin it.

`build/` is gitignored; only the source (`main.swift`, `build.sh`) is tracked.

> Requires yabai at `/opt/homebrew/bin/yabai` (edit `yabaiPath` in `main.swift`
> if yours differs). Pairs well with sketchybar **disabled** — this replaces the
> spaces widget in a single compact menu-bar label.
