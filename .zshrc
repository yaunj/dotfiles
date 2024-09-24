# source environment vars
test -r ${HOME}/.config/environment.sh && source ${HOME}/.config/environment.sh

export HISTFILE=${ZDOTDIR:-${HOME}}/.zsh_history
export EDITOR=${EDITOR:-vim}
export VISUAL=${VISUAL:-vim}

# Include files
source ${ZDOTDIR:-${HOME}}/.config/zsh/config.zsh
source ${ZDOTDIR:-${HOME}}/.config/zsh/aliases.zsh
source ${ZDOTDIR:-${HOME}}/.config/zsh/completion.zsh
