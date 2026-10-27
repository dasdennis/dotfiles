# Interactive shells only
[[ -o interactive ]] || return

# ---------------------------------------------------------------- Environment
typeset -U path PATH fpath
path=("$HOME/.local/bin" "$HOME/bin" "$HOME/.cargo/bin" $path)

export EDITOR=nvim
export VISUAL="$EDITOR"

# Only override when the user-scoped agent socket exists
[[ -S "${XDG_RUNTIME_DIR:-/run/user/$UID}/ssh-agent.socket" ]] &&
  export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR:-/run/user/$UID}/ssh-agent.socket"

# export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock"

# - Keymap
# zsh selects viins when EDITOR/VISUAL contains "vi" (nvim); force emacs
bindkey -e

# Normal-mode and application-mode sequences (Ghostty emits either)
bindkey '^[[H'    beginning-of-line
bindkey '^[OH'    beginning-of-line
bindkey '^[[F'    end-of-line
bindkey '^[OF'    end-of-line
bindkey '^[[3~'   delete-char
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^H'      backward-kill-word   # Ctrl+Backspace

#  History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

setopt SHARE_HISTORY            # implies append; do not combine with INC_APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE        # " cmd" is not recorded (secrets)
setopt HIST_REDUCE_BLANKS
setopt AUTO_CD
setopt INTERACTIVE_COMMENTS
setopt NO_BEEP

# --------------------------------------------------- Completion (cached, fpath)
_zsh_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
_comp_dir="$_zsh_cache/completions"
[[ -d $_comp_dir ]] || mkdir -p -- "$_comp_dir"
fpath=("$_comp_dir" $fpath)

# Regenerate a completion file only when the binary is newer than the cache
_regen=0
for _c in kubectl helm k9s; do
  (( $+commands[$_c] )) || continue
  _f="$_comp_dir/_$_c"
  if [[ ! -s $_f || ${commands[$_c]} -nt $_f ]]; then
    if "$_c" completion zsh >| "$_f" 2>/dev/null; then
      _regen=1
    else
      rm -f -- "$_f"
    fi
  fi
done
unset _c _f

# Full compinit if new completions or dump older than 24h; otherwise skip audit (-C)
_init_compinit() {
  emulate -L zsh
  setopt extendedglob
  local dump="$_zsh_cache/zcompdump"
  autoload -Uz compinit
  if (( $1 )) || [[ ! -s $dump || -n $dump(#qN.mh+24) ]]; then
    compinit -d "$dump"
  else
    compinit -C -d "$dump"
  fi
}
_init_compinit "$_regen"
unfunction _init_compinit
unset _regen

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "$_zsh_cache/zcompcache"

# ------------------------------------------------ Tooling (after compinit)
(( $+commands[mise] ))     && eval "$(mise activate zsh)"
(( $+commands[direnv] ))   && eval "$(direnv hook zsh)"
(( $+commands[zoxide] ))   && eval "$(zoxide init zsh --cmd cd)"
(( $+commands[starship] )) && eval "$(starship init zsh)"

# fzf: key-bindings must load before zsh-syntax-highlighting
[[ -r /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
[[ -r /usr/share/fzf/completion.zsh   ]] && source /usr/share/fzf/completion.zsh

#  Aliases
alias cls='clear'
alias g='git'
alias gs='git status -sb'
alias gl='git log --oneline --graph --decorate -15'
alias gp='git push'
alias dc='docker compose'
alias zshconfig='nvim "$HOME/dotfiles/linux/zsh/.zshrc"'
alias duh='command du -sh -- *(DN) 2>/dev/null | sort -h'
alias ports='ss -tulnp'
alias bfu='sudo btrfs filesystem usage /'

if (( $+commands[eza] )); then
  alias ls='eza --group-directories-first'
  alias ll='eza -lgh --group-directories-first'
  alias la='eza -lah --group-directories-first'
fi

if (( $+commands[bat] )); then
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
  export MANROFFOPT=-c
fi

# Plugins
# Order is mandatory: autosuggestions, then syntax-highlighting LAST
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=40

[[ -r /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] &&
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
[[ -r /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] &&
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
