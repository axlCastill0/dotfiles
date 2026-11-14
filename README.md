# dotfiles

Stow-managed on Unix, symlinked directly on Windows.

| Package | Linked to |
|---|---|
| `nvim` | `~/.config/nvim` (Unix), `%LOCALAPPDATA%\nvim` (Windows) |
| `zsh` | `~/.zshrc` |
| `ghostty` | `~/.config/ghostty` |
| `i3` | `~/.config/i3` (Linux only) |

## Install

**Linux / macOS**:

```bash
./install.sh
```

It checks the toolchain first (`git`, `stow`, `node`, `luarocks`, a C compiler) and
stops with the exact install command if something is missing. To install the missing
pieces automatically via brew / apt / pacman / dnf:

```bash
./install.sh --deps
```

**Windows** — needs PowerShell 5.1+, and symlink permission (Developer Mode on, or an
elevated shell):

```powershell
./install.ps1
```

Same check, reported as a warning rather than a stop. `./install.ps1 -Deps` installs
the missing ones with winget.

## Neovim prerequisites

The config bootstraps lazy.nvim and installs its own LSP servers through mason, but
it cannot install a toolchain. Without these, parts fail silently.

### All platforms

| Tool | Needed for | Hard requirement |
|---|---|---|
| `git` | lazy.nvim bootstrap, gitsigns | yes |
| C compiler (`cc`/`gcc`/`clang`/`cl`/`zig`) | treesitter parsers | yes — highlighting falls back to regex without it |
| Node.js | vtsls, eslint, pyright, prismals, tailwindcss (all npm packages) | yes, for LSP — mason cannot install its servers without it |
| `luarocks` | lazy.nvim builds any plugin shipping a rockspec; oxocarbon.nvim does | yes — the colorscheme fails to load without it |
| Nerd Font in the terminal | devicons, lualine, alpha header, diagnostic signs | cosmetic |
| `lazygit` | `<leader>gg` | optional, degrades with a message |

The config warns on startup if no C compiler is found, rather than leaving treesitter
quietly inert.

`prettier` and `sqlfluff` are installed by mason automatically on first start.
conform still prefers a project-local `node_modules/.bin/prettier` when one exists.

### Windows specifics

mason needs, per `:h mason-requirements`: `pwsh` or `powershell`, `git`, `tar`, and
one of 7zip / peazip / archiver / winzip / WinRAR.

```powershell
winget install Git.Git
winget install OpenJS.NodeJS.LTS
winget install DEVCOM.Lua
winget install LuaRocks.LuaRocks
winget install zig.zig          # satisfies the treesitter compiler requirement
winget install 7zip.7zip
winget install JesseDuffield.lazygit
```

`telescope-fzf-native` builds with cmake + MSVC Build Tools on Windows (the config
selects this automatically); plain `make` only works under MinGW. If you would rather
skip the native sorter, drop the dependency — telescope works without it.

LuaSnip's optional `jsregexp` build is skipped on Windows, since its Makefile shells
out to `rm`/`cp`. Only LSP snippet regex transforms are lost.

### Not applicable on Windows

`vim-tmux-navigator` stays installed and still maps `<C-h/j/k/l>` to plain window
navigation when `$TMUX` is unset, so it is harmless.
