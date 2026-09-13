# non-interactive guard — skip heavy init for non-interactive shells
[[ $- != *i* ]] && return

# Runtime manager — MUST be early, before compinit
eval "$(mise activate zsh)"
eval "$(starship init zsh)"

# environment & paths
export EDITOR="nvim"
export VISUAL="$EDITOR"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"
export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$HOME/bin:/usr/local/bin:$PATH"

# SSH agent socket — validate existence
ssh_sock="$(gpgconf --list-dirs agent-ssh-socket 2>/dev/null)"
if [[ -S "$ssh_sock" ]]; then
  export SSH_AUTH_SOCK="$ssh_sock"
else
  export SSH_AUTH_SOCK="${SSH_AUTH_SOCK:-/run/user/$(id -u)/keyring/ssh}"
fi

# history
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
setopt append_history share_history inc_append_history hist_reduce_blanks hist_verify
setopt hist_ignore_dups hist_ignore_all_dups
setopt autocd no_beep extended_glob interactive_comments

# completion — build cache every 24h
zcompdump="$HOME/.cache/zsh/zcompdump-${ZSH_VERSION}"
mkdir -p "${zcompdump:h}"

autoload -Uz compinit
if [[ -f "$zcompdump"(#qN.mh-24) ]]; then
  # Cache < 24h, use it
  compinit -C -d "$zcompdump"
else
  # Cache > 24h or missing, rebuild
  compinit -d "$zcompdump"
fi

zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# aliases — modern rust tooling with guards
if command -v eza >/dev/null 2>&1; then
  alias ls="eza --icons --group-directories-first --git"
  alias ll="eza -lgh --icons --group-directories-first --git"
  alias la="eza -lagh --icons --group-directories-first --git"
  alias lt="eza --tree --level=2 --icons --group-directories-first"
else
  alias ls="ls --color=auto"
  alias ll="ls -lh --color=auto"
  alias la="ls -lha --color=auto"
fi

if command -v bat >/dev/null 2>&1; then
  alias cat='bat --style=plain'
fi

if command -v rg >/dev/null 2>&1; then
  alias grep='rg'
fi

if command -v fd >/dev/null 2>&1; then
  alias find='fd'
fi

if command -v sd >/dev/null 2>&1; then
  alias sed='sd'
fi

if command -v btm >/dev/null 2>&1; then
  alias top='btm'
fi

if command -v procs >/dev/null 2>&1; then
  alias ps='procs'
fi

if command -v duf >/dev/null 2>&1; then
  alias df='duf'
fi

if command -v dust >/dev/null 2>&1; then
  alias du='dust -d 1'
fi

if command -v tokei >/dev/null 2>&1; then
  alias loc='tokei'
fi

# utility aliases
alias cls="clear"
alias dfh="df -h"
alias duh="du -sh * 2>/dev/null | sort -h"
alias ports="lsof -i -P -n | grep LISTEN"
alias zshconfig="nvim ~/.config/zsh/zshrc"

# git/docker
alias d='docker'
alias dc='docker compose'
alias g='git'
alias gs="git status -sb"
alias gp='git push'
alias gc='git commit -m'
alias gl="git log --oneline --graph --decorate -n 15"

# utility functions
extract() {
  if [[ -f "$1" ]]; then
    case "$1" in
      *.tar.bz2)   tar xvjf "$1"    ;;
      *.tar.gz)    tar xvzf "$1"    ;;
      *.bz2)       bunzip2 "$1"     ;;
      *.rar)       unrar x "$1"     ;;
      *.gz)        gunzip "$1"      ;;
      *.tar)       tar xvf "$1"     ;;
      *.tbz2)      tar xvjf "$1"    ;;
      *.tgz)       tar xvzf "$1"    ;;
      *.zip)       unzip "$1"       ;;
      *.Z)         uncompress "$1"  ;;
      *.7z)        7z x "$1"        ;;
      *)           echo "Error: '$1' format not supported" ;;
    esac
  else
    echo "Error: '$1' is not a valid file"
  fi
}

# atuin — sqlite-based history (ctrl+r for visual search)
if command -v atuin >/dev/null 2>&1; then
  eval "$(atuin init zsh --disable-up-arrow)"
  bindkey '^r' _atuin_search_widget
fi

# zoxide — smarter cd
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh --cmd cd)"
fi

# keybindings
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

# native zsh plugins (arch linux paths) — autosuggestions BEFORE syntax-highlighting
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null

# syntax-highlighting LAST — wraps zle widgets from prior plugins
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

# startup banner — hyprland-only, interactive-only
if [[ -n "$HYPRLAND_INSTANCE_SIGNATURE" && -z "$SSH_CONNECTION" ]]; then
  if [[ ! -f "/tmp/.fastfetch-shown-${HYPRLAND_INSTANCE_SIGNATURE}" ]]; then
    fastfetch 2>/dev/null
    touch "/tmp/.fastfetch-shown-${HYPRLAND_INSTANCE_SIGNATURE}"
  fi
fi
