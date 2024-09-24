autoload -U url-quote-magic
zle -N self-insert url-quote-magic
autoload run-help             # try pressing meta-h while writing a command
autoload colors; colors;

WORDCHARS="${WORDCHARS:s@/@}"
dircolors &>/dev/null
if [[ $? -eq 0 ]]; then
    eval "$(dircolors -b)"
else
    # dircolors not available, set up a fallback
    export LSCOLORS="Gxfxcxdxbxegedabagacad"
fi

# Add our own functions to fpath and load all of them
fpath=(${ZDOTDIR}/.config/zsh/functions $fpath)
autoload -U ${ZDOTDIR}/.config/zsh/functions/*(:t)

setopt auto_name_dirs
setopt auto_pushd             # use pushd implicitly
setopt pushd_ignore_dups
setopt no_beep
setopt auto_cd                # cd by typing directory
setopt multios                # allow multiple file redirects
setopt cdable_vars            # try stuff

setopt hist_ignore_all_dups   # no duplicates
setopt hist_reduce_blanks     # no superfluous blanks
setopt share_history          # share history between shells
setopt extended_history       # timestamp, etc
setopt hist_verify            # ask before performing !command
setopt hist_ignore_space      # don't log lines starting with space

setopt no_bg_nice             # don't nice background tasks
setopt no_hup
setopt local_options          # allow functions to have local options
setopt local_traps            # allow functions to have local traps
setopt prompt_subst           # do substitution for vars in prompt
setopt correct                # spell corrections
setopt complete_in_word

#setopt extended_glob

test -f /etc/zsh_command_not_found && source /etc/zsh_command_not_found

# Formats and setup for vcs_info
zstyle ':vcs_info:*' actionformats '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:git:*' formats '%F{yellow}%s/%b%f%c%u'
zstyle ':vcs_info:*'     formats '%F{yellow}%s/%b%f'
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%F{3}%b:%r%f'
zstyle ':vcs_info:*' branchformat '%F{5}%b%f'
zstyle ':vcs_info:*' enable git hg svn
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr " %F{red}-%f"
zstyle ':vcs_info:*' stagedstr   " %F{green}+%f"

case $TERM in
    linux)
        zstyle ':prompt:yaunj' str-ok ':)'
        zstyle ':prompt:yaunj' str-not-ok ':('
        zstyle ':prompt:yaunj' str-bg 'bg:'
        zstyle ':prompt:yaunj' color-time gray
        ;;
    *)
        zstyle ':prompt:yaunj' str-ok '%%'
        zstyle ':prompt:yaunj' str-not-ok '%%'
esac

bindkey -e
if [[ -n $TMUX ]]; then
else
    bindkey '^[[1;5C' forward-word       # ctrl-right
    bindkey '^[[1;5D' backward-word      # ctrl-left
fi
bindkey '^[[A' up-line-or-search     # up to search history
bindkey '^[[B' down-line-or-search   # down to search history
bindkey '\e[Z' reverse-menu-complete # shift-tab
bindkey "${terminfo[khome]}" beginning-of-line # home
bindkey "${terminfo[kend]}"  end-of-line       # end
bindkey '^@' push-line               # ctrl-space

# Use custom prompt
prompt_yaunj_setup

function preexec()
{
    __CMD_START_TIME=$(date +%s)
    __CMD_NAME=${1%% *}
}

function precmd()
{
    __CMD_END_TIME=$(date +%s)
    # In new shells, no commands have been run and start time is not set.
    local diff=$((${__CMD_END_TIME} - ${__CMD_START_TIME:-$__CMD_END_TIME}))

    # If command took three seconds or more: print elapsed time
    if [[ $diff -ge 3 ]]; then
        local days=$(($(date -u -d @${diff} +'%-j') - 1))
        local time="$(date -u -d @${diff} +'%-H %-M %-S')"
        time=(${(s: :)time})
        local elapsed=""
        if [[ "${days}"    -gt 0 ]]; then elapsed="${days}d "; fi
        if [[ "${time[1]}" -gt 0 ]]; then elapsed="${elapsed}${time[1]}h "; fi
        if [[ "${time[2]}" -gt 0 ]]; then elapsed="${elapsed}${time[2]}m "; fi
        if [[ "${time[3]}" -gt 0 ]]; then elapsed="${elapsed}${time[3]}s "; fi
        echo "... ${__CMD_NAME} took ${elapsed}" >&2
    fi
}
