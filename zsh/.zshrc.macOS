[[ -o interactive ]] || return

# --- History ---
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
mkdir -p "${HISTFILE:h}"
HISTSIZE=50000
SAVEHIST=50000
setopt share_history hist_ignore_all_dups hist_ignore_space hist_reduce_blanks hist_verify
setopt autocd no_beep interactive_comments

# --- Toolchain (before anything that probes tools) ---
(( $+commands[mise] )) && eval "$(mise activate zsh)"

# --- Editor ---
if   (( $+commands[nvim] )); then export EDITOR=nvim
elif (( $+commands[subl] )); then export EDITOR="subl -w"
else export EDITOR=vi; fi
export VISUAL=$EDITOR
(( $+commands[bat] )) && export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# --- Completion: full rebuild at most once per 24h ---
mkdir -p "$HOME/.cache/zsh"
autoload -Uz compinit
local -a _stale=("$HOME/.cache/zsh/zcompdump"(N.mh+24))
if (( $#_stale )); then compinit -d "$HOME/.cache/zsh/zcompdump"
else compinit -C -d "$HOME/.cache/zsh/zcompdump"; fi
unset _stale
zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.cache/zsh/zcompcache"

# --- Aliases ---
if (( $+commands[eza] )); then
  alias ls="eza --icons --group-directories-first"
  alias ll="eza -lgh --icons --group-directories-first --git"
  alias la="eza -lagh --icons --group-directories-first --git"
  alias lt="eza --tree --level=2 --icons --group-directories-first"
else
  alias ls="ls -G"; alias ll="ls -lhG"; alias la="ls -lhaG"
fi
(( $+commands[bat] )) && alias cat="bat --style=plain"

alias cls="clear"
alias ports="lsof -nP -iTCP -sTCP:LISTEN"
alias zshconfig='$EDITOR ~/.zshrc'
alias sysinfo="fastfetch"

alias d="docker" dc="docker compose" tf="terraform"
alias g="git" gs="git status -sb" gp="git push" gc="git commit -m"
alias gl="git log --oneline --graph --decorate -n 15"
alias be="bundle exec" rs="bin/rails server" rc="bin/rails console"

# --- Functions ---
extract() {
  [[ -f $1 ]] || { echo "Error: '$1' is not a valid file" >&2; return 1 }
  case $1 in
    *.tar.*|*.tgz|*.tbz2|*.txz|*.tar|*.zip|*.7z|*.rar) bsdtar -xf -- "$1" ;;
    *.gz)  gunzip -k -- "$1" ;;
    *.bz2) bunzip2 -k -- "$1" ;;
    *.Z)   uncompress -- "$1" ;;
    *)     echo "Error: '$1' format not supported" >&2; return 1 ;;
  esac
}

# --- Hooks ---
(( $+commands[zoxide] )) && eval "$(zoxide init zsh --cmd cd)"
(( $+commands[atuin]  )) && eval "$(atuin init zsh --disable-up-arrow)"
(( $+commands[starship] )) && eval "$(starship init zsh)"

# --- Plugins (git clones; syntax-highlighting must be sourced last) ---
_zp="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins"
if [[ -r $_zp/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  ZSH_AUTOSUGGEST_STRATEGY=(history)
  ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=40
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"
  source $_zp/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
if [[ -r $_zp/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  ZSH_HIGHLIGHT_MAXLENGTH=300
  source $_zp/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
unset _zp
