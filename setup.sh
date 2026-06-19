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

# ── Zsh dependencies ────────────────────────────────────────────────────────
# Powerlevel10k
if [ ! -d "$HOME/.powerlevel10k" ]; then
  info "Cloning powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/.powerlevel10k"
else
  warn "powerlevel10k already installed — skipping"
fi

# zsh-autosuggestions (oh-my-zsh plugin)
ZSH_AUTOSUGGESTIONS="$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
if [ ! -d "$ZSH_AUTOSUGGESTIONS" ]; then
  info "Cloning zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_AUTOSUGGESTIONS"
else
  warn "zsh-autosuggestions already installed — skipping"
fi

# zsh-syntax-highlighting (via Homebrew)
if ! brew list zsh-syntax-highlighting &>/dev/null; then
  info "Installing zsh-syntax-highlighting via Homebrew..."
  brew install zsh-syntax-highlighting
else
  warn "zsh-syntax-highlighting already installed — skipping"
fi

# ── Window manager (yabai + skhd + JankyBorders + sketchybar) ─────────────────
for pkg in koekeishiya/formulae/yabai koekeishiya/formulae/skhd \
           FelixKratz/formulae/borders FelixKratz/formulae/sketchybar \
           font-meslo-lg-nerd-font font-sketchybar-app-font; do
  name="${pkg##*/}"
  if ! brew list "$name" &>/dev/null; then
    info "Installing $name via Homebrew..."
    brew install "$pkg"
  else
    warn "$name already installed — skipping"
  fi
done

# ── .config symlinks ──────────────────────────────────────────────────────────
link "$DOTFILES/aerospace/.config/aerospace"  "$CONFIG/aerospace"
link "$DOTFILES/alacritty/.config/alacritty"  "$CONFIG/alacritty"
link "$DOTFILES/borders/.config/borders"       "$CONFIG/borders"
link "$DOTFILES/kitty/.config/kitty"           "$CONFIG/kitty"
link "$DOTFILES/nvim/.config/nvim"             "$CONFIG/nvim"
link "$DOTFILES/ghostty/.config/ghostty"       "$CONFIG/ghostty"
link "$DOTFILES/skhd/.config/skhd"            "$CONFIG/skhd"
link "$DOTFILES/yabai/.config/yabai"           "$CONFIG/yabai"
link "$DOTFILES/sketchybar/.config/sketchybar" "$CONFIG/sketchybar"

# ── Home directory symlinks ───────────────────────────────────────────────────
link "$DOTFILES/tmux/.tmux.conf"  "$HOME/.tmux.conf"
link "$DOTFILES/zsh/.zshrc"       "$HOME/.zshrc"

echo ""
info "Done! All symlinks are in place."
echo ""
