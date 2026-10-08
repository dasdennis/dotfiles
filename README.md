# Dotfiles

Personal configuration files managed with [GNU Stow](https://www.gnu.org/software/stow/).

Each top-level directory is a Stow package. Its structure mirrors the target path relative to `$HOME`.

```text
dotfiles/
├── alacritty/
├── fastfetch/
├── foot/
├── ghostty/
├── git/
├── hypr/
├── kitty/
├── lazygit/
├── mise/
├── ruby/
├── starship/
├── sublime-text/
├── tmux/
└── zsh/
```

Example:

```text
zsh/.zshrc
git/.config/git/config
hypr/.config/hypr/hyprmon.lua
```

become:

```text
~/.zshrc
~/.config/git/config
~/.config/hypr/hyprmon.lua
```

No `--dotfiles` is required.

## Restore

Preview all packages:

```bash
stow -nv */
```

Apply all packages:

```bash
stow */
```

Apply selected packages:

```bash
stow zsh git tmux mise
```

Preview a package:

```bash
stow -nv hypr
```

## Manage

Remove a package:

```bash
stow -D hypr
```

Restow a package:

```bash
stow -R hypr
```

Restow everything:

```bash
stow -R */
```

## Existing files

Stow does not overwrite conflicting files.

Preview before applying:

```bash
stow -nv <package>
```

Back up conflicting configuration files before running Stow.

## Repository workflow

Changes made through Stow-managed symlinks are changes to this repository.

```bash
git status
git diff
git add .
git commit -m "Update dotfiles"
```

## New machine

```bash
git clone <repository> ~/dotfiles
cd ~/dotfiles
stow */
```

Applications and packages are installed separately.

## Package convention

Packages must mirror their destination relative to `$HOME`.

```text
tool/.config/tool/config
```

→ `~/.config/tool/config`

```text
tool/.config/tool/config.local
```

→ `~/.config/tool/config.local`

Keep one package per independently manageable tool or component.

`sublime-text` is retained as a configuration backup/reference and is not part of the normal restore.
