# dotfiles

My personal dotfiles for macOS, managed with Git and symlinks.

## What's included

| Package      | Config path                   | Description              |
|--------------|-------------------------------|--------------------------|
| `yabai`      | `~/.config/yabai`             | yabai tiling window manager (current WM) |
| `skhd`       | `~/.config/skhd`              | skhd hotkey daemon (yabai keybinds)      |
| `borders`    | `~/.config/borders`           | JankyBorders — active-window border      |
| `sketchybar` | `~/.config/sketchybar`        | sketchybar status bar    |
| `yabai-spaces` | *(menu-bar app)*            | [YabaiSpaces](yabai-spaces/README.md) — Desktop switcher + ⌃⌥Space window search for `yabai` |
| `aerospace`  | `~/.config/aerospace`         | AeroSpace window manager (kept as a fallback) |
| `alacritty`  | `~/.config/alacritty`         | Alacritty terminal       |
| `firefox`    | `~/Library/...`               | Firefox userChrome & Sidebery layout |
| `ghostty`    | `~/.config/ghostty`           | Ghostty terminal                     |
| `kitty`      | `~/.config/kitty`             | Kitty terminal           |
| `nvim`       | `~/.config/nvim`              | Neovim (lazy.nvim)       |
| `tmux`       | `~/.tmux.conf`                | Tmux                     |
| `zsh`        | `~/.zshrc`                    | Zsh + oh-my-zsh          |

### Window manager stack

`yabai` (tiling) + `skhd` (hotkeys) + `borders` (active-window border) +
`sketchybar` (status bar) form the window-manager setup, mirroring the old
AeroSpace/Glide keybindings. The full guide — install, the SIP / scripting-addition
steps, keybindings, naming your Desktops, and theming — lives in
**[`yabai/README.md`](yabai/README.md)**.

`setup.sh` installs the brew packages (`yabai`, `skhd`, `borders`, `sketchybar`)
and the required fonts (`font-meslo-lg-nerd-font`, `font-sketchybar-app-font`).

#### YabaiSpaces — the menu-bar companion

**[`yabai-spaces/`](yabai-spaces/README.md)** is a small native macOS menu-bar app
built to sit on top of the **[`yabai` config in this repo](yabai/.config/yabai/yabairc)** —
the two are meant to be used together:

- the status item shows the **name of the Desktop you're on** (`main`, `term`,
  `code`, … — the same names `yabairc` assigns and `skhdrc` binds to `alt-1/i/c/…`),
- clicking it lists **every Desktop with the apps on it**; click one to focus it,
- **⌃⌥Space** opens a fuzzy **window switcher across all Desktops**.

Everything it shows comes from `yabai -m query`, so it stays in sync with the
window manager automatically and needs no extra permissions. It's the lightweight
alternative to running `sketchybar` just for the spaces widget — which is why
`yabairc` in this repo ships with the sketchybar signals commented out.

```bash
cd yabai-spaces && ./build.sh && open build/YabaiSpaces.app
```

## How it works

Each package folder mirrors the path it would live at under `~`. For example,
`nvim/.config/nvim` maps to `~/.config/nvim`. Symlinks are created from the
real config locations to these files so that any edit is automatically tracked
by Git.

## Quick setup (automated)

Clone the repo and run the setup script — it will create all symlinks for you:

```bash
git clone --recurse-submodules https://github.com/amiralibg/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x setup.sh
./setup.sh
```

## Manual setup (step by step)

### 1. Clone the repository

```bash
git clone --recurse-submodules https://github.com/amiralibg/dotfiles.git ~/dotfiles
```

### 2. Create config directory if it doesn't exist

```bash
mkdir -p ~/.config
```

### 3. Create symlinks for each package

```bash
# AeroSpace
ln -sf ~/dotfiles/aerospace/.config/aerospace ~/.config/aerospace

# Alacritty
ln -sf ~/dotfiles/alacritty/.config/alacritty ~/.config/alacritty

# yabai
ln -sf ~/dotfiles/yabai/.config/yabai ~/.config/yabai

# skhd
ln -sf ~/dotfiles/skhd/.config/skhd ~/.config/skhd

# Borders
ln -sf ~/dotfiles/borders/.config/borders ~/.config/borders

# sketchybar
ln -sf ~/dotfiles/sketchybar/.config/sketchybar ~/.config/sketchybar

# Ghostty
ln -sf ~/dotfiles/ghostty/.config/ghostty ~/.config/ghostty

# Kitty
ln -sf ~/dotfiles/kitty/.config/kitty ~/.config/kitty

# Neovim
ln -sf ~/dotfiles/nvim/.config/nvim ~/.config/nvim

# Tmux
ln -sf ~/dotfiles/tmux/.tmux.conf ~/.tmux.conf

# Zsh
ln -sf ~/dotfiles/zsh/.zshrc ~/.zshrc
```

### 4. Verify symlinks

```bash
ls -la ~/.config | grep dotfiles
ls -la ~ | grep dotfiles
```

## Day-to-day workflow

**Edit a config** — just edit the file directly inside `~/dotfiles/` (or through
the symlink, it's the same file). Changes are live immediately.

**Save changes to Git:**

```bash
cd ~/dotfiles
git add .
git commit -m "describe your changes"
git push
```

**Pull latest changes on another machine:**

```bash
cd ~/dotfiles
git pull
```

Symlinks don't need to be recreated after a `git pull` — they keep pointing to
the same files.
