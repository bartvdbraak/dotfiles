## Initialize completion

autoload -Uz compinit
compinit

## Paths

PATH=$PATH:/usr/local/sbin
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

## Zinit Plugins

zinit light zdharma-continuum/fast-syntax-highlighting
zinit load zdharma-continuum/history-search-multi-word
zinit light zsh-users/zsh-history-substring-search
zinit light sindresorhus/pure

### Autosuggestions

ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=150
zinit ice wait"0a" lucid atload"_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions

### Enhancd

zinit ice wait"0b" lucid
# zinit light b4b4r07/enhancd

## Tab Completion

zinit ice wait"0b" lucid blockf
zinit light zsh-users/zsh-completions
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' menu select=2
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*:descriptions' format '-- %d --'
zstyle ':completion:*:processes' command 'ps -au$USER'
zstyle ':completion:complete:*:options' sort false
zstyle ':fzf-tab:complete:_zlua:*' query-string input
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm,cmd -w -w"
zstyle ':fzf-tab:complete:kill:argument-rest' extra-opts --preview=$extract'ps --pid=$in[(w)1] -o cmd --no-headers -w -w' --preview-window=down:3:wrap
zstyle ":completion:*:git-checkout:*" sort false
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

### Neovim

zinit ice from"gh-r" as"program" bpick"*appimage*" ver"nightly" mv"nvim* -> nvim" pick"nvim"
zinit light neovim/neovim

### Prettytyping

zinit ice lucid wait'' as"program" pick"prettyping" atload'alias ping=prettyping'
zinit load "denilsonsa/prettyping"

# Personal Aliases

alias pub='cat ~/.ssh/id_rsa.pub | pbcopy'
alias l='ls -CF'
alias ll='ls -alhF'
alias la='ls -A'
alias ls='ls -G'
alias grep='grep --colour=auto'
alias gcp='git add . && git commit && git push'
alias digs='dig +short'
alias k='kubectl'
alias kc='kubectl config use-context'
alias cp='cp -iv'                           # Preferred 'cp' implementation
alias mv='mv -iv'                           # Preferred 'mv' implementation
alias openssl3='/usr/local/opt/openssl@3'
compdef __start_kubectl k

# Terminal History

HISTSIZE=15000

# Kubernetes Autocompletions

source <(kubectl completion zsh)

# Python virtual environments

eval "$(pyenv init -)"
