# Auto Start TMUX
#if [ -z "$TMUX" ]
#then
#    tmux attach -t Alien || tmux new -s Alien
#fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# fnm
export PATH=/home/$USER/.fnm:$PATH
eval "$(fnm env --use-on-cd --version-file-strategy=recursive)"

# android
export ANDROID_SDK_ROOT=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_SDK_ROOT/emulator
export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools

# Flutter Path
export PATH="$PATH:/Users/amiralibg/Development/flutter/bin"

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
alias yabaiInstall="sudo yabai --install-sa"
alias yabaiLoad="sudo yabai --load-sa"
alias cl="clear"

source ~/.powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# zsh color syntax
source /Users/amiralibg/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# bun completions
[ -s "/Users/amiralibg/.bun/_bun" ] && source "/Users/amiralibg/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

PATH=~/.console-ninja/.bin:$PATH