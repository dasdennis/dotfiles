# Interactive shells only
[[ -o interactive ]] || return

# PATH
typeset -U path PATH
path=("$HOME/.local/bin" "$HOME/bin" "$HOME/.cargo/bin" $path)

# Development tools
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

# Prompt
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# Completion
autoload -Uz compinit
compinit -C

# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_REDUCE_BLANKS
setopt EXTENDED_HISTORY
setopt AUTO_CD
setopt INTERACTIVE_COMMENTS
setopt NO_BEEP

# Editor
export EDITOR=nvim
export VISUAL="$EDITOR"

# Aliases
alias cls='clear'
alias g='git'
alias gs='git status -sb'
alias gl='git log --oneline --graph --decorate -15'
alias gp='git push'
alias dc='docker compose'
alias zshconfig='nvim $HOME/dotfiles/zsh/.zshrc'
alias duh="/usr/bin/du -sh * 2>/dev/null | sort -h"
alias ports="lsof -i -P -n | grep LISTEN"

if command -v duf >/dev/null 2>&1; then
  alias df='duf'
fifa

# Optional CLI enhancements
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --group-directories-first'
  alias ll='eza -lgh --group-directories-first'
  alias la='eza -lah --group-directories-first'
fi

if command -v bat >/dev/null 2>&1; then
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
  export MANROFFOPT=-c
fi

# Optional directory navigation
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh --cmd cd)"
fi

# Optional plugins
if [[ -r /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

if [[ -r /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
