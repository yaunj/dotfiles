# vim: set ft=sh
HISTSIZE=10000
SAVEHIST=10000

export EDITOR=vim
export VISUAL=vim

export LESS="-F -g -i -M -R -S -w -X -z-4"
LESSPIPE=$(which lesspipe)
if [ $? -ne 0 ]; then
    LESSPIPE=$(which lesspipe.sh)
fi
if [ -n "${LESSPIPE}" ]; then
    export LESSOPEN="| ${LESSPIPE} %s"
    export LESSCLOSE="| ${LESSPIPE} %s %s"
fi
unset LESSPIPE

if [ -f ~/.config/python/init.py ]; then
    export PYTHONSTARTUP=~/.config/python/init.py
fi

test "$COLORTERM" = "gnome-terminal" && export TERM=xterm-256color
