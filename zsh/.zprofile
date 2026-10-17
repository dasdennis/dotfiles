typeset -U path PATH                       # dedupe entries
path=("$HOME/.local/bin" "$HOME/.cargo/bin" $path)

: ${LANG:=en_US.UTF-8}                     # only if unset; no LC_ALL override
export LANG

export PAGER=less
export LESS="-FRXi"

# Homebrew (Intel prefix); optional
if [[ -x /usr/local/bin/brew ]]; then
  export HOMEBREW_PREFIX=/usr/local
  export HOMEBREW_NO_ANALYTICS=1 HOMEBREW_NO_ENV_HINTS=1
fi
