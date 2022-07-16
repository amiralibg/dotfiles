# Auto Start TMUX
if [ -z "$TMUX" ]
then
    tmux attach -t Alien || tmux new -s Alien
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Path nvm
export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  

# Flutter Path
export PATH="$PATH:/Users/amiralibg/Development/flutter/bin"

ZSH_THEME="avit"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

plugins=(git sudo zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

#Aliases
alias zshconfig="sudo nvim ~/.zshrc"
alias cdP="cd ~/Programming"
alias cdPw="cd ~/Programming/Git"
alias cdpl="cd ~/Programming/Locale"
alias ls="ls -la --color"
alias yabaiInstall="sudo yabai --install-sa"
alias yabaiLoad="sudo yabai --load-sa"

#source ~/.powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
#[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# zsh color syntax
source /Users/amiralibg/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
