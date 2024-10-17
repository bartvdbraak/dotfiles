if [ -e $HOME/.bash_aliases ]; then
    source $HOME/.bash_aliases
fi

if command -v fzf > /dev/null; then
    source <(fzf --bash)
fi

if command -v rg > /dev/null; then
    source <(rg --generate=complete-bash)
fi

PROMPT_DIRTRIM=2
PS1='\[\033[0;33m\][\u@\h:\w]\$\[\033[0m\] '
