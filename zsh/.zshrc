# fnm (must be before p10k instant prompt to avoid console output warnings)
export PATH=/home/$USER/.fnm:$PATH
eval "$(fnm env --use-on-cd --version-file-strategy=recursive)"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Auto Start TMUX
#if [ -z "$TMUX" ]
#then
#    tmux attach -t Alien || tmux new -s Alien
#fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# android
export ANDROID_SDK_ROOT=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_SDK_ROOT/emulator
export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools

# Flutter Path
export PATH="$HOME/Develop/flutter/bin:$PATH"

export PATH=/Users/amiralibg/.local/bin:$PATH

#Zsh Config
ZSH_THEME="avit"
HISTFILE=~/.zsh_history
HISTSIZE=999999999
SAVEHIST=$HISTSIZE

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

plugins=(git sudo zsh-autosuggestions vi-mode)

source $ZSH/oh-my-zsh.sh

#Aliases
alias zshconfig="sudo nvim ~/.zshrc"
alias cdP="cd ~/Programming"
alias cdPgw="cd ~/Programming/Git/Web"
alias cdPg="cd ~/Programming/Git"
alias cdpl="cd ~/Programming/Locale"
alias ls="ls -la --color"
alias cl="clear"

source ~/.powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# zsh color syntax
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# bun completions
[ -s "/Users/amiralibg/.bun/_bun" ] && source "/Users/amiralibg/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Added by Windsurf
export PATH="/Users/amiralibg/.codeium/windsurf/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/amiralibg/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Added by Antigravity
export PATH="/Users/amiralibg/.antigravity/antigravity/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/amiralibg/.lmstudio/bin"
# End of LM Studio CLI section


# Added by Antigravity
export PATH="/Users/amiralibg/.antigravity/antigravity/bin:$PATH"

# GapCode
export PATH="/Users/amiralibg/.gapcode/bin:$PATH"

# Pi
export PATH="/Users/amiralibg/.local/share/fnm/node-versions/v24.13.1/installation/bin:$PATH"
