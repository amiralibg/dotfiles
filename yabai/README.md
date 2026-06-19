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
    ├── sketchybarrc                         # bar + defaults
    ├── variables.sh                         # Tokyonight theme + fonts
    ├── icon_map.sh                          # app name → icon ligature
    ├── items/*.sh                           # spaces, front_app, spotify, clock, …
    └── plugins/*.sh                         # event scripts
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

## Spaces — naming your Desktops (you control this)

yabai uses real macOS Desktops (numeric), so AeroSpace's *named* workspaces are
recreated as **labels** on Desktops. Keys focus **by label** (`alt-b` → `web`),
so a key follows its name to whatever Desktop currently holds it.

**The single source of truth is the `SPACE_LABELS` list in `yabairc`.** The Nth
name labels the Nth macOS Desktop, counted **left → right** across Mission
Control (display 1's Desktops first, then display 2's):

```bash
SPACE_LABELS=(
  main     # Desktop 1   → alt-1
  term     # Desktop 2   → alt-i
  code     # Desktop 3   → alt-c
  web      # Desktop 4   → alt-b
  chat     # Desktop 5   → alt-d
  ai       # Desktop 6   → alt-g
  design   # Desktop 7   → alt-o
  …
)
```

### To rename / reorder which Desktop is which

1. Edit the order of names in `SPACE_LABELS` (in `yabairc`).
2. `yabai --restart-service` — it relabels every Desktop by this order and
   re-applies the app rules.

The key for each name is fixed in `skhdrc` (e.g. `alt - b : … --focus web`), and
the sketchybar pill tag is in `items/spaces.sh` → `space_tag`. So **reordering
the list is all you need** to change which Desktop is `web`, `code`, etc.

### To add a brand-new named space (e.g. `music` on `alt-m`)

1. Add `music` to `SPACE_LABELS` at the Desktop position you want.
2. In `skhdrc` add:   `alt - m : yabai -m space --focus music`   and
   `alt + shift - m : yabai -m window --space music`.
3. (optional) In `items/spaces.sh` → `space_tag`, add `music) echo "M" ;;` for
   the bar pill.
4. Create the Desktop in Mission Control if needed, then `yabai --restart-service`.

### Adding Desktops (manual on macOS 26)

`space --create` is broken on macOS 26.x, so add Desktops in **Mission Control**
(`Ctrl + ↑` → hover the Desktop row → **`＋`**), then `yabai --restart-service`.

> ⚠️ **Why names "scramble" when you insert a Desktop:** labels are assigned by
> position. If you add a Desktop *in the middle*, every Desktop after it shifts
> by one, so the names land on different Desktops. Fixes: add Desktops at the
> **end**, or just reorder `SPACE_LABELS` to match and restart yabai. A restart
> always re-enforces the list, so you can't get permanently stuck — one
> `yabai --restart-service` re-applies clean names.

> Multi-monitor note: new Desktops land on whichever display is active. To move a
> Desktop between monitors, drag it in Mission Control, then restart yabai.

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
| `alt + shift + tab` | Send focused window to next monitor (wraps) |

> Moving a whole *space* to another monitor is broken on macOS 26.x
> (scripting-addition error), so `alt+shift+tab` moves the focused **window**
> instead.

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

A **Tokyonight** floating bar (rounded, blurred, shadowed) structured like the
popular reference config: `variables.sh` (theme) + `items/` (item definitions) +
`plugins/` (event scripts).

- **Left:** a bracketed **spaces** block — one pill per Desktop whose **icon is
  its keybind tag** (`1 I C B D G …`) and whose **label shows the app icons of
  the windows on that space** (via sketchybar-app-font); focused pill turns red.
  Then the **front-app** name pill.
- **Center (left of notch):** now-playing (Spotify/media), shown only when playing.
- **Right:** clock · calendar · battery · volume · cpu · Wi-Fi (each a coloured
  bordered pill).

### Fonts (installed by `setup.sh`)

| Font | Used for |
|---|---|
| `MesloLGS Nerd Font` (`font-meslo-lg-nerd-font`) | all text + status icons |
| `sketchybar-app-font` (`font-sketchybar-app-font`) | app icons inside space pills |

`icon_map.sh` (committed in the repo, from the sketchybar-app-font release) maps
app names → icon ligatures. If an app shows a generic `:default:` icon, it isn't
in the map — add a `case` arm, or check the upstream font for the right name.

### How the space → app-icons stay in sync

- `items/spaces.sh` defines a custom event `space_windows` and one `space.N` item
  per existing yabai Desktop.
- `yabairc` fires `sketchybar --trigger space_windows` on yabai
  `window_created/destroyed/focused`, `space_changed`, `application_front_switched`.
- `plugins/space.sh` then queries yabai for that space's apps and updates the pill.
- yabai reserves room for the floating bar with `external_bar all:40:0`.

### macOS 26 quirks handled

- sketchybar runs configs with system **bash 3.2** (no associative arrays) → the
  space-tag map is a `case` statement.
- The Wi-Fi **SSID is redacted** from CLI tools → the Wi-Fi item shows
  connected/off from the interface IP, not the network name.

Reload after edits: `sketchybar --reload` (or `brew services restart sketchybar`).
If any glyph is a box, the font isn't active: `brew install --cask
font-meslo-lg-nerd-font font-sketchybar-app-font`.

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
