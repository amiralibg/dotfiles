# yabai + skhd + JankyBorders + sketchybar

A tiling-window-manager setup for macOS that mirrors the AeroSpace / Glide
keybindings already in this dotfiles repo.

- **yabai** — the tiling window manager (BSP layout, spaces, rules)
- **skhd** — the hotkey daemon that sends commands to yabai
- **JankyBorders** (`borders`) — coloured active/inactive window borders
- **sketchybar** — top status bar (spaces, front app, clock, battery, volume, Wi-Fi)

```
dotfiles/
├── yabai/.config/yabai/yabairc              # tiling, gaps, spaces, app rules
├── skhd/.config/skhd/skhdrc                 # all keybindings
├── borders/.config/borders/bordersrc        # border colours/width
└── sketchybar/.config/sketchybar/
    ├── sketchybarrc                         # bar layout
    ├── colors.sh                            # palette (matches borders)
    └── plugins/*.sh                         # space/app/clock/battery/volume/wifi
```

`setup.sh` installs all four brew packages (+ Symbols Nerd Font) and symlinks
each `.config` folder into `~/.config`.

---

## ⚠️ The SIP / scripting-addition reality (read this)

yabai needs its **scripting addition** for space management (focus/move spaces,
per-app space rules). That needs **SIP partially disabled**. On this machine SIP
is already configured and the addition loads — `--focus`, `--label`, `--space`,
and the per-app rules all work.

**BUT** on **macOS 26.x**, `yabai -m space --create` is **broken**
(`"cannot create space due to an error with the scripting-addition"`), even with
SIP disabled and the `-arm64e_preview_abi` boot-arg set. This is a yabai-vs-new-
macOS issue, not a config problem.

**Consequence:** the config does **not** auto-create Desktops. You create them
manually in Mission Control (see below), and yabai just labels whatever exists.

| Feature | Status here |
|---|:---:|
| BSP tiling, focus, warp/move, resize, balance, float, fullscreen | ✅ |
| Focus space, move window to space, per-app space rules | ✅ |
| Move space to another monitor | ✅ |
| **Create spaces** (`space --create`) | ❌ broken on macOS 26.x → use Mission Control |

> If a future `brew upgrade yabai` (or `brew install yabai --HEAD`) fixes space
> creation on macOS 26, you can re-introduce auto-creation. Check
> <https://github.com/koekeishiya/yabai/issues>.

---

## Spaces — how the named workspaces work

yabai uses real macOS Desktops (numeric), so AeroSpace's *named* workspaces are
recreated as **labels** on Desktops. `yabairc` labels the Desktops that exist,
in **priority order** (most-used first), so the important ones work even with few
Desktops. Keys focus **by label**, so a key simply no-ops until its Desktop
exists.

Priority order → label → key → apps:

| label | key | apps assigned by rule |
|---|---|---|
| `main` | `alt-1` | WireGuard, Happ, Cisco Secure Client, Telegram |
| `term` | `alt-i` | Alacritty, Warp, kitty, Ghostty |
| `code` | `alt-c` | VS Code, VS Code Insiders, Zed, Helium |
| `web` | `alt-b` | Brave, Zen |
| `chat` | `alt-d` | Discord, Mattermost |
| `ai` | `alt-g` | ChatGPT, T3 Code, Claude |
| `design` | `alt-o` | Figma |
| `two`,`three`,`five`…`nine` | `alt-2/3/5/6/7/8/9` | scratch |

With your current **6 Desktops** you get: `main, term, code, web, chat, ai`.
`design` and the scratch numbers need more Desktops.

### Adding more Desktops (one-time, manual on macOS 26)

1. Open **Mission Control** (swipe up with 3–4 fingers, or `Ctrl + ↑`).
2. Hover the row of Desktops at the top → click the **`＋`** to add one. Repeat
   until you have as many as you want (e.g. 14 for the full set). Add them on the
   **same display** you want the named spaces on.
3. Back in a terminal: `yabai --restart-service` — yabai relabels in priority
   order and re-applies the app rules.

> Multi-monitor note: new Desktops land on whichever display is active. Labels
> follow global Desktop index (display 1's Desktops first, then display 2's). To
> move a Desktop between monitors, drag it in Mission Control, then
> `yabai --restart-service`.

---

## Install / bootstrap

```bash
./setup.sh    # installs yabai/skhd/borders/sketchybar + Symbols Nerd Font, symlinks configs
```

Manual equivalent:

```bash
brew install koekeishiya/formulae/yabai koekeishiya/formulae/skhd
brew install FelixKratz/formulae/borders FelixKratz/formulae/sketchybar
brew install font-symbols-only-nerd-font
```

### Start / stop services

```bash
yabai --start-service          # or --restart-service (bound to ctrl+alt+r)
skhd  --start-service
brew services start sketchybar
# borders is launched by yabairc; or: brew services start borders
```

The first time yabai/skhd start, grant **Accessibility** in System Settings →
Privacy & Security → Accessibility. Re-toggle after every version upgrade.

### Scripting-addition sudoers entry

So `yabairc`'s `sudo yabai --load-sa` doesn't prompt for a password:

```bash
echo "$(whoami) ALL=(root) NOPASSWD: sha256:$(shasum -a 256 $(which yabai) | cut -d " " -f 1) $(which yabai) --load-sa" | sudo tee /private/etc/sudoers.d/yabai
```

> ⚠️ Re-run this after every `brew upgrade yabai` (the line embeds yabai's hash).

---

## Keybindings

`alt` = Option (⌥). Matches the AeroSpace config; a few extras come from Glide.

### Windows

| Keys | Action |
|---|---|
| `alt + h / j / k / l` | Focus window left / down / up / right |
| `alt + shift + h/j/k/l` | Move (re-tile) window in direction |
| `alt + f` · `alt + shift + x` | Toggle zoom-fullscreen |
| `alt + shift + space` | Toggle float + center window |
| `alt + \` | Flip split orientation |
| `alt + /` · `alt + ,` | Space layout → **bsp** / **stack** |
| `alt + drag` · `alt + right-drag` | Move / resize with the mouse |

> Resizing with the keyboard lives **only in resize mode** now (it used to be on
> `alt+ctrl+hjkl`, which collided with monitor-focus). See *Resize mode* below.

### Spaces

| Keys | Action |
|---|---|
| `alt + 1` | Focus `main` |
| `alt + i / c / b / d / g / o` | Focus `term` / `code` / `web` / `chat` / `ai` / `design` |
| `alt + 2/3/5/6/7/8/9` | Focus scratch spaces |
| `alt + tab` | Focus the previous space (back-and-forth) |
| `alt + shift + <same keys>` | Move focused window to that space |

### Monitors

| Keys | Action |
|---|---|
| `alt + lctrl + h / l` | Focus monitor west / east |
| `shift + alt + lctrl + h / l` | **Move focused window to monitor west / east** (and follow) |
| `alt + shift + tab` | Move current space to next monitor (wraps) |

### Resize mode — `alt + shift + r` to enter

| Key | Action |
|---|---|
| `h / l` | Shrink / grow width |
| `j / k` | Grow / shrink height |
| `-` / `=` | Shrink / grow width |
| `b` | Balance all windows |
| `enter` / `esc` | Exit mode |

### Misc

| Keys | Action |
|---|---|
| `alt + lctrl + t` | Open Ghostty |
| `ctrl + alt + r` | Restart yabai + reload skhd |

> The AeroSpace **service mode** was dropped — its actions (join-with, close
> others) don't map cleanly to yabai's auto-managed BSP tree. Balance lives in
> resize mode; float-toggle is `alt+shift+f`; split-flip is `alt+\`.

---

## Per-app assignment & fixing app names

yabai rules match an app's **display name** with a regex. Real names on this
machine were verified with:

```bash
yabai -m query --windows | jq -r '.[].app' | sort -u
# Claude, Code, Figma, Ghostty, Happ, Mattermost, T3 Code (Alpha), Zen, ...
```

`T3 Code (Alpha)` is matched by the prefix rule `^T3 Code`. If you rename/replace
an app and it stops landing on its space, update the regex in `yabairc` and run
`yabai --restart-service`.

Floating / unmanaged apps (mirrors AeroSpace `layout floating`): Finder, Qv2ray,
Hiddify, qBittorrent, Simulator, System Settings, Archive Utility, Brave PiP.

---

## sketchybar

A top bar themed to match your JankyBorders gradient (mauve → peach).

- **Left:**  Apple (→ System Settings) · one pill per Desktop, tagged with its
  keybind (`1 I C B D G …`), focused pill highlighted · front-app name.
- **Right:** Wi-Fi · volume · battery · clock.

Implementation notes:

- yabai reserves space for the bar via `external_bar all:37:0` in `yabairc`, and
  pings sketchybar on space/window/display changes via `yabai -m signal`.
- Plugins are plain shell (`plugins/*.sh`); colours live in `colors.sh`.
- **macOS 26 quirks already handled:** sketchybar runs configs with the system
  `/bin/bash 3.2` (no associative arrays → we use a `case` statement); and the
  Wi-Fi SSID is redacted from the CLI, so the Wi-Fi item shows connected/off
  based on whether the Wi-Fi interface has an IP (not the network name).
- Icons use **Symbols Nerd Font**. If any icon shows as a box, confirm the font:
  `brew install font-symbols-only-nerd-font`.

Reload after edits: `sketchybar --reload` (or `brew services restart sketchybar`).

---

## AeroSpace → yabai cheatsheet / caveats

- **Workspaces vs spaces** — AeroSpace workspaces are virtual; yabai uses real
  macOS Desktops. Hence labels + manual Desktop creation.
- **`move` → `--warp`** — closest match to AeroSpace's tree re-insert.
- **`accordion` → `stack`** — yabai has no accordion (`alt + ,`).
- **`flatten-workspace-tree` → `--balance`** — equalises sibling sizes.

---

## Troubleshooting

| Symptom | Fix |
|---|---|
| Nothing tiles | Grant **Accessibility** to yabai (re-grant after upgrades) |
| A space key does nothing | That Desktop doesn't exist — add it in Mission Control, then `yabai --restart-service` |
| `space --create` errors | Expected on macOS 26.x — create Desktops manually |
| App opens on the wrong space | App name regex is off — see *Fixing app names* |
| App stayed put after reload | `yabai -m rule --apply` (also run automatically by `yabairc`) |
| sketchybar icons are boxes | Install `font-symbols-only-nerd-font` |
| Wi-Fi shows network name? | Not possible on macOS 26 (SSID redacted); item shows connected/off |
| Hotkeys dead | `skhd --restart-service`; `tail -f /tmp/skhd_$USER.err.log` |
| Logs | yabai `/tmp/yabai_$USER.{out,err}.log` · skhd `/tmp/skhd_$USER.{out,err}.log` |
