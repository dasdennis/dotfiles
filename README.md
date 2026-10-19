# dotfiles

Personal configuration, managed with [GNU Stow](https://www.gnu.org/software/stow/).

```text
common/     shared across platforms
linux/      Linux (Omarchy / Hyprland)
macos/      macOS (Sequoia, Intel)
reference/  manual reference, never stowed (VSCode, Sublime Text)
bin/        install script
```

Each layer holds one package per tool. A package mirrors its target path relative to `$HOME`:

```text
common/git/.config/git/config  ->  ~/.config/git/config
```

## Install

Requires `stow`.

```bash
git clone https://github.com/dasdennis/dotfiles.git ~/dotfiles
~/dotfiles/bin/install --dry-run   # preview
~/dotfiles/bin/install             # apply common/ + current OS layer
```

Packages are linked with `--no-folding` (only files become symlinks). The script aborts if both layers provide the same path.

## Platform overrides

A shared base plus a per-OS fragment, instead of duplicated files:

| Tool    | Mechanism                                                     |
|---------|---------------------------------------------------------------|
| git     | `[include]` of `config.os` and an untracked `config.local`    |

Per-machine and secret files (`*.local`) are untracked and live only in `$HOME`.

## Manage

```bash
cd ~/dotfiles
stow -D -d linux -t "$HOME" hypr   # remove a package
```

Symlinked files are repo files: review with `git diff` before committing.

## Conventions

- One package per independently managed tool.
- A path must exist in only one layer.
- Do not run `stow --adopt` on a dirty working tree.
- Applications are installed separately.
