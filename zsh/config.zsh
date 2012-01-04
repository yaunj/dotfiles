autoload -U url-quote-magic
zle -N self-insert url-quote-magic
autoload run-help             # try pressing meta-h while writing a command
autoload colors; colors;

dircolors &>/dev/null
if [[ $? -eq 0 ]]; then
    eval "$(dircolors -b)"
else
    # dircolors not available, set up a fallback
    export LSCOLORS="Gxfxcxdxbxegedabagacad"
fi

# Add our own functions to fpath and load all of them
fpath=(~/.zsh/functions $fpath)
autoload -U ~/.zsh/functions/*(:t)

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

setopt extended_glob

test -f /etc/zsh_command_not_found && source /etc/zsh_command_not_found

# Formats and setup for vcs_info
zstyle ':vcs_info:*' actionformats '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:git:*' formats '%F{0}%s/%F{3}%b%f%c%u'
zstyle ':vcs_info:*'     formats '%F{0}%s/%F{3}%b%f'
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%F{3}%b:%r%f'
zstyle ':vcs_info:*' branchformat '%F{5}%b%f'
zstyle ':vcs_info:*' enable git hg svn
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr " %F{red}✗%f"
zstyle ':vcs_info:*' stagedstr   " %F{green}%B↑%b%f"

bindkey -e
bindkey '^[[1;5C' forward-word       # ctrl-right
bindkey '^[[1;5D' backward-word      # ctrl-left
bindkey '^[[A' up-line-or-search     # up to search history
bindkey '^[[B' down-line-or-search   # down to search history
bindkey '\e[Z' reverse-menu-complete # shift-tab

# Use custom prompt
prompt_yaunj_setup
