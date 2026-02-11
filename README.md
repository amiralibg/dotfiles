# dotfiles

My personal dotfiles for macOS, managed with Git and symlinks.

## What's included

| Package     | Config path                   | Description              |
|-------------|-------------------------------|--------------------------|
| `aerospace` | `~/.config/aerospace`         | AeroSpace window manager |
| `alacritty` | `~/.config/alacritty`         | Alacritty terminal       |
| `borders`   | `~/.config/borders`           | JankyBorders utility     |
| `firefox`   | `~/Library/...`               | Firefox userChrome & Sidebery layout |
| `kitty`     | `~/.config/kitty`             | Kitty terminal           |
| `nvim`      | `~/.config/nvim`              | Neovim (lazy.nvim)       |
| `skhd`      | `~/.config/skhd`              | skhd hotkey daemon       |
| `tmux`      | `~/.tmux.conf`                | Tmux                     |
| `zsh`       | `~/.zshrc`                    | Zsh + oh-my-zsh          |

## How it works

Each package folder mirrors the path it would live at under `~`. For example,
`nvim/.config/nvim` maps to `~/.config/nvim`. Symlinks are created from the
real config locations to these files so that any edit is automatically tracked
by Git.

## Quick setup (automated)

Clone the repo and run the setup script — it will create all symlinks for you:

```bash
git clone https://github.com/amiralibg/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x setup.sh
./setup.sh
```

## Manual setup (step by step)

### 1. Clone the repository

```bash
git clone https://github.com/amiralibg/dotfiles.git ~/dotfiles
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

# Borders
ln -sf ~/dotfiles/borders/.config/borders ~/.config/borders

# Kitty
ln -sf ~/dotfiles/kitty/.config/kitty ~/.config/kitty

# Neovim
ln -sf ~/dotfiles/nvim/.config/nvim ~/.config/nvim

# skhd
ln -sf ~/dotfiles/skhd/.config/skhd ~/.config/skhd

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
