#!/usr/bin/env bash

set -e

DOTFILES="$HOME/dotfiles"
CONFIG="$HOME/.config"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info()    { echo -e "${GREEN}[+]${NC} $1"; }
warn()    { echo -e "${YELLOW}[!]${NC} $1"; }
error()   { echo -e "${RED}[x]${NC} $1"; exit 1; }

link() {
  local src="$1"
  local dest="$2"

  if [ -L "$dest" ]; then
    warn "Symlink already exists: $dest — skipping"
  elif [ -e "$dest" ]; then
    warn "File/dir exists at $dest — backing up to ${dest}.bak"
    mv "$dest" "${dest}.bak"
    ln -sf "$src" "$dest"
    info "Linked $src -> $dest"
  else
    ln -sf "$src" "$dest"
    info "Linked $src -> $dest"
  fi
}

echo ""
echo "Setting up dotfiles from $DOTFILES"
echo "======================================"

# Ensure dotfiles dir exists
[ -d "$DOTFILES" ] || error "Dotfiles directory not found at $DOTFILES. Clone the repo first."

# Initialize submodules (e.g. kitty-themes)
info "Initializing git submodules..."
git -C "$DOTFILES" submodule update --init --recursive

# Ensure ~/.config exists
mkdir -p "$CONFIG"

# ── .config symlinks ──────────────────────────────────────────────────────────
link "$DOTFILES/aerospace/.config/aerospace"  "$CONFIG/aerospace"
link "$DOTFILES/alacritty/.config/alacritty"  "$CONFIG/alacritty"
link "$DOTFILES/borders/.config/borders"       "$CONFIG/borders"
link "$DOTFILES/kitty/.config/kitty"           "$CONFIG/kitty"
link "$DOTFILES/nvim/.config/nvim"             "$CONFIG/nvim"
link "$DOTFILES/ghostty/.config/ghostty"       "$CONFIG/ghostty"
link "$DOTFILES/skhd/.config/skhd"            "$CONFIG/skhd"

# ── Home directory symlinks ───────────────────────────────────────────────────
link "$DOTFILES/tmux/.tmux.conf"  "$HOME/.tmux.conf"
link "$DOTFILES/zsh/.zshrc"       "$HOME/.zshrc"

echo ""
info "Done! All symlinks are in place."
echo ""
