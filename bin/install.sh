#!/usr/bin/env bash
set -euo pipefail
shopt -s nullglob

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
readonly ROOT
readonly TARGET="${DOTFILES_TARGET:-$HOME}"

die() { printf 'error: %s\n' "$*" >&2; exit 1; }

command -v stow >/dev/null || die "stow not found in PATH"

case "${DOTFILES_OS:-$(uname -s)}" in
  Darwin|macos) os=macos ;;
  Linux|linux)  os=linux ;;
  *) die "unsupported OS: $(uname -s)" ;;
esac

# --no-folding: only files are symlinked; dirs stay real, so layers can share them
stow_flags=(--restow --no-folding --target="$TARGET" --verbose=1)
case "${1:-}" in -n|--dry-run) stow_flags+=(--simulate) ;; esac

# Relative file paths a layer would install, one per line
layer_targets() {
  local pkg
  for pkg in "$ROOT/$1"/*/; do
    (cd "$pkg" && find . \( -type f -o -type l \) -print)
  done | sort
}

# stow cannot detect same-path collisions across separate invocations
dups="$(comm -12 <(layer_targets common) <(layer_targets "$os"))"
[[ -z "$dups" ]] || die $'same target provided by both layers:\n'"$dups"

for layer in common "$os"; do
  pkgs=()
  for dir in "$ROOT/$layer"/*/; do
    pkgs+=("$(basename "$dir")")
  done
  (( ${#pkgs[@]} )) || continue
  # One invocation per layer: stow plans all packages first, applies all-or-nothing
  stow "${stow_flags[@]}" --dir="$ROOT/$layer" "${pkgs[@]}"
done
