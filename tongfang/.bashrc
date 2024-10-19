if [ -e $HOME/.bash_aliases ]; then
    source $HOME/.bash_aliases
fi

if command -v fzf > /dev/null; then
    source <(fzf --bash)
fi

if command -v rg > /dev/null; then
    source <(rg --generate=complete-bash)
fi

if [ -z "$SSH_AUTH_SOCK" ]; then
    eval $(ssh-agent -s) &>/dev/null
fi

function ensure_ssh_key {
    if ! ssh-add -l &>/dev/null; then
        ssh-add -t 3600 ~/.ssh/id_ed25519
    fi
}

PROMPT_DIRTRIM=2
PS1='\[\033[0;33m\][\u@\h:\w]\$\[\033[0m\] '
