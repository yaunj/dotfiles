# Checks
if [[ $(uname) = 'Linux' ]]; then
    IS_LINUX=1
fi
if [[ $(uname) = 'Darwin' ]]; then
    IS_MAC=1
    export __CF_USER_TEXT_ENCODING=0x1F5:0x8000100:0x8000100
fi

source .zsh/config.zsh
source .zsh/aliases.zsh
source .zsh/completion.zsh

# Plug and play
if [[ -f /etc/zsh_command_not_found ]]; then
    source /etc/zsh_command_not_found # installed in Ubuntu
fi
