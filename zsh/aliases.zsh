ls --color=auto &>/dev/null &&
    alias ls="ls -F --color=auto" || alias ls="ls -F -G"

if [[ $IS_LINUX -eq 1 ]]; then
    alias open=xdg-open
elif [[ $IS_MAC -eq 1 ]]; then
    alias locatemd='mdfind kMDItemDisplayName \=\= '

    local MACVIM=/Applications/MacVim.app/Contents/MacOS/Vim
    test -x $MACVIM && alias vim=$MACVIM
    unset MACVIM
fi

alias :q=exit
alias :wq=exit

alias tohtml="vim -c ':let html_number_lines = 1' -c ':let use_xhtml = 1' -c ':let html_use_css = 1' -c ':TOhtml' -c ':w' -c ':q' -c ':q'"
