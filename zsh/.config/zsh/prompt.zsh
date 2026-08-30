# ~/.config/zsh/prompt.zsh

# Prevent Python virtualenv from polluting the prompt
export VIRTUAL_ENV_DISABLE_PROMPT=1

# Ensure Starship config path is set
export STARSHIP_CONFIG="${STARSHIP_CONFIG:-${ZDOTDIR:-$HOME/.config/zsh}/starship.toml}"

FUNCNEST=100

eval "$(starship init zsh)"

