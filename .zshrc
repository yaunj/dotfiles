# source environment vars
test -r ${HOME}/.config/environment.sh && source ${HOME}/.config/environment.sh

export HISTFILE=${ZDOTDIR:-${HOME}}/.zsh_history
export EDITOR=${EDITOR:-vim}
export VISUAL=${VISUAL:-vim}

ZDOTDIR=${ZDOTDIR:-${HOME}}

# Include files
source ${ZDOTDIR}/.config/zsh/config.zsh
source ${ZDOTDIR}/.config/zsh/aliases.zsh
source ${ZDOTDIR}/.config/zsh/completion.zsh
