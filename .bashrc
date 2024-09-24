# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# Don't overwrite existing files with redirections
set -C

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar
shopt -s extglob
shopt -s nullglob

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

## Prompt
prompt_cmd() {
    local EXITCODE="$?"
    local PROMPT_PATH="\w"
    local GIT_REPO
    local GIT_PATH REAL_PATH
    local RETCODE
    local AWS_PROMPT="${AWS_PROFILE:+(aws:\[\e[1;33m\]${AWS_PROFILE}\[\e[0m\]) }"
    local VENV_PROMPT="${VIRTUAL_ENV:+(🐍:$(basename "${VIRTUAL_ENV}")) }"

    if git rev-parse --is-inside-work-tree >&/dev/null; then
        GIT_PATH="$(git rev-parse --show-toplevel)"
        GIT_REPO="$(basename "${GIT_PATH}")"
        REAL_PATH="$(readlink -f "${PWD}")"

        PROMPT_PATH="${GIT_REPO}${REAL_PATH:${#GIT_PATH}}"
    fi

    if [ "${EXITCODE}" -ne 0 ]; then
        RETCODE="\[\e[0;31m\]${EXITCODE}\[\e[0m\] "
    fi

    export GIT_PS1_STATESEPARATOR='' GIT_PS1_SHOWSTASHSTATE=1 GIT_PS1_SHOWDIRTYSTATE=1
    export GIT_PS1_SHOWUPSTREAM=1 GIT_PS1_SHOWCOLORHINTS=1

    PS1="\A ${VENV_PROMPT}${AWS_PROMPT}\h:\[\033[01;34m\]${PROMPT_PATH}\[\033[0m\]$(__git_ps1)\[\033[00m\]\n${RETCODE}\$ "

    unset GIT_PS1_STATESEPARATOR GIT_PS1_SHOWSTASHSTATE GIT_PS1_SHOWDIRTYSTATE
    unset GIT_PS1_SHOWUPSTREAM GIT_PS1_SHOWCOLORHINTS
}
export PROMPT_COMMAND=prompt_cmd

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

if [ -r ~/.config/environment.sh ]; then
    source ~/.config/environment.sh
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

for extra_path in /usr/local/go/bin ~/go/bin ~/.cargo/bin ~/bin ~/.local/bin; do
    test -d $extra_path && PATH=$extra_path:$PATH
done
export PATH

if command -v aws_completer >/dev/null 2>&1; then
    complete -C $(command -v aws_completer) aws
fi

if command -v gh 2>/dev/null; then
    eval "$(gh completion -s bash)"
fi
