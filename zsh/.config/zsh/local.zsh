# local.zsh — machine-specific overrides (loaded last from .zshrc:123)
# This file is gitignored via .gitignore:local.zsh, but we track a template.
# Your real secrets should stay here; committed version is a curated baseline.

# =========================================================
# fnm — fast Node manager (replaces old /home/$USER/.fnm linux path)
# =========================================================
if command -v fnm >/dev/null 2>&1; then
  eval "$(fnm env --use-on-cd --version-file-strategy=recursive)"
else
  # Fallback: ensure fnm on PATH
  export PATH="$HOME/.local/share/fnm:$PATH"
  command -v fnm >/dev/null 2>&1 && eval "$(fnm env --use-on-cd --version-file-strategy=recursive)"
fi

# =========================================================
# Toolchains migrated from old ~/dotfiles/zsh/.zshrc
# =========================================================

# Android
export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
export PATH="$PATH:$ANDROID_SDK_ROOT/emulator:$ANDROID_SDK_ROOT/platform-tools"

# Flutter
export PATH="$HOME/Develop/flutter/bin:$PATH"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Windsurf
export PATH="$HOME/.codeium/windsurf/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Antigravity (deduped)
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

# Java
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"

# LM Studio
export PATH="$PATH:$HOME/.lmstudio/bin"

# GapCode
export PATH="$HOME/.gapcode/bin:$PATH"

# Pi / fnm node-versions fallback (kept for compatibility)
export PATH="$HOME/.local/share/fnm/node-versions/v24.13.1/installation/bin:$PATH"

# opencode
export PATH="$HOME/.opencode/bin:$PATH"

# =========================================================
# Legacy integrations (optional — keep if you use them)
# =========================================================

# iTerm2 shell integration
test -e "$HOME/.iterm2_shell_integration.zsh" && source "$HOME/.iterm2_shell_integration.zsh"

# Docker completions — already handled by compinit, but keep fpath for docker
if [[ -d "$HOME/.docker/completions" ]]; then
  fpath=("$HOME/.docker/completions" $fpath)
fi

# Powerlevel10k — NOT used with starship; uncomment if you switch back from starship
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# syntax-highlighting fallback (new config uses fast-syntax-highlighting via plugins.zsh)
# source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# History — old used 999999999, new uses 100000. Override here if you want huge history:
# HISTFILE="$XDG_STATE_HOME/zsh/history"
# HISTSIZE=999999999
# SAVEHIST=$HISTSIZE
