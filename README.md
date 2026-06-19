# dotfiles

My personal dotfiles for macOS, managed with Git and symlinks.

## What's included

| Package      | Config path                   | Description              |
|--------------|-------------------------------|--------------------------|
| `yabai`      | `~/.config/yabai`             | yabai tiling window manager (current WM) |
| `skhd`       | `~/.config/skhd`              | skhd hotkey daemon (yabai keybinds)      |
| `borders`    | `~/.config/borders`           | JankyBorders — active-window border      |
| `sketchybar` | `~/.config/sketchybar`        | sketchybar status bar    |
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
