# dotfiles

My configuration files, symlinked into place. The live config **is** the repo
file, so the workflow is just git:

```
edit a config  ->  git commit && push     # on machine A
git pull                                   # on machine B, changes are already live
```

No copying between machines — ever. `install.sh` only symlinks configs; it does
**not** install any tools — those are under [Manual install steps](#manual-install-steps).

## Current setup

| | |
|---|---|
| **WM (Linux)** | i3 (`i3/config`) — launcher: rofi, compositor: picom, bar: polybar |
| **Terminal** | WezTerm (`wezterm/wezterm.lua`) |
| **Font** | Ubuntu Sans Mono, size 13 |
| **Shell** | Bash |
| **Multiplexer** | tmux (prefix remapped to `C-a`) |
| **Editor** | Neovim — lazy.nvim, gruvbox, telescope, treesitter, LSP for C/C++, Go, Python, Java, JS/TS/React |
| **Languages** | Go, Node (via nvm), Java/Gradle/Maven (via SDKMAN), Python 3.14 |

## Setup a new machine

```bash
git clone https://github.com/priyakdey/dotfiles dotfiles
cd dotfiles
./install.sh            # detects OS, symlinks everything into $HOME (safe to re-run)
```

`install.sh` locates the repo from its own path (clone it anywhere) and backs up
any existing real file to `<file>.backup.<timestamp>` before replacing it. Then
work through the manual install steps below.

## Layout

```
install.sh          entrypoint: detects OS, symlinks everything (idempotent)
lib/link.sh         the symlink helper
shell/
  common.sh         shared bash: prompt, aliases, nvm, sdkman   -> ~/.bash_common
  bash_profile.macos   macOS login shell                        -> ~/.bash_profile
  bashrc.linux         Linux interactive shell                  -> ~/.bashrc
  .bash_aliases     shared aliases                              -> ~/.bash_aliases
nvim/               -> ~/.config/nvim        (shared)
wezterm/            -> ~/.config/wezterm     (shared)
tmux/.tmux.conf     -> ~/.tmux.conf          (shared)
git/.gitconfig      -> ~/.gitconfig          (shared)
ssh/config          -> ~/.ssh/config         (shared)
colors/.dircolors   -> ~/.dircolors          (Linux)
i3/                 -> ~/.config/i3          (Linux)
picom/              -> ~/.config/picom       (Linux)
polybar/            -> ~/.config/polybar     (Linux)
iterm2/profile.json  imported manually       (macOS)
```

Most configs are identical across OSes and are shared as a single file. Only
bash differs (macOS login shell vs Linux `.bashrc`); both source `common.sh`
for the parts they have in common.

## Machine-local overrides (kept out of git)

- **git**: add `[include] path = ~/.gitconfig.local` to `git/.gitconfig` for
  per-machine identity/credentials.
- **ssh**: add `Include ~/.ssh/config.d/*` at the top of `ssh/config` for
  per-machine hosts.
- **secrets**: `~/.sonar.env` etc. are sourced only if present.

---

## Manual install steps

`install.sh` only symlinks config files. Everything below has to be installed by hand.

Order matters: later steps assume earlier ones (e.g. `gopls` needs Go, `jdtls` needs a
JDK, Neovim plugins need a C compiler + `make`).

### 1. System packages (apt)

```bash
sudo apt update
sudo apt install -y \
  build-essential \   # gcc / g++ / make — needed by treesitter & telescope-fzf-native
  git \
  curl wget unzip \
  clangd \            # C/C++ LSP used by nvim
  tmux \
  ripgrep \           # rg — required by telescope live_grep
  fzf \
  git-lfs \           # referenced in .gitconfig [filter "lfs"]
  python3.14 python3.14-venv \
  pipx
git lfs install       # once per machine
pipx ensurepath
```

### 2. Fonts

- **Ubuntu Sans Mono** (used by `wezterm.lua`, i3 and polybar) — on Ubuntu:
  `sudo apt install fonts-ubuntu`; other distros: drop the `.ttf`s manually
- **Symbols Nerd Font** (polybar icons — `font-1` in `polybar/config.ini`;
  without it every icon in the bar renders as □)
- **JetBrains Mono** (alternate)

Manual installs: drop the `.ttf` files into `~/.local/share/fonts/` then run
`fc-cache -fv`. For the Nerd Font symbols:

```bash
curl -LO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/NerdFontsSymbolsOnly.tar.xz
tar -xf NerdFontsSymbolsOnly.tar.xz
cp SymbolsNerdFont*-Regular.ttf ~/.local/share/fonts/ && fc-cache -f
```

### 3. Terminal — WezTerm

Config: `wezterm/wezterm.lua`. Install from the official package/repo (apt's is stale).

### 4. Neovim (tarball, not apt)

Installed to `/opt/nvim-linux-x86_64` (already on PATH via `~/.bashrc`).

```bash
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
```

Plugins bootstrap themselves: `init.lua` clones **lazy.nvim** on first launch. See step 9
for the plugin-side manual bits.

### 5. Go (tarball) + gopls

Installed to `/usr/local/go`; `GOPATH=$HOME/go` (both on PATH via `~/.bashrc`).

```bash
# download current go<ver>.linux-amd64.tar.gz from https://go.dev/dl/
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go<ver>.linux-amd64.tar.gz
go install golang.org/x/tools/gopls@latest    # lands in $HOME/go/bin
```

### 6. Node toolchain — nvm → node → pnpm

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
# restart shell, then:
nvm install --lts
curl -fsSL https://get.pnpm.io/install.sh | sh -   # PNPM_HOME already set in the shell config
npm install -g typescript typescript-language-server   # ts_ls — nvim JS/TS/React LSP
```

### 7. JVM toolchain — SDKMAN → java / gradle / maven

```bash
curl -s "https://get.sdkman.io" | bash
# loader already at the END of shell/common.sh (must stay last)
# restart shell, then:
sdk install java
sdk install gradle
sdk install maven
```

### 8. Python tooling — pylsp + ruff

The nvim Python LSP is `pylsp` with the `ruff` plugin. Installed to `~/.local/bin` via pipx:

```bash
pipx install python-lsp-server
pipx inject python-lsp-server python-lsp-ruff
pipx install ruff
```

### 9. Neovim plugin-side steps

After first `nvim` launch (lazy.nvim has installed plugins):

```vim
:MasonInstall jdtls     " Java LSP — Mason is used ONLY for jdtls (needs JDK from step 7)
:TSUpdate               " build treesitter parsers (needs gcc/make from step 1)
```

`telescope-fzf-native` compiles via `make` on install (build step in `init.lua`).

### 10. Containers / Kubernetes

Aliased in `.bash_aliases` (`k=kubectl`, `mk=minikube`).

```bash
# docker — official convenience script or distro repo
# kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -m 0755 kubectl /usr/local/bin/kubectl
# minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
```

### 11. Linux desktop — i3 / rofi / picom / polybar (Linux only)

The window manager stack. `install.sh` links `i3/`, `picom/`, `polybar/` into
`~/.config` on Linux only. rofi has **no config file** — it runs on defaults and
just needs installing.

```bash
sudo apt install -y \
  i3 i3lock \             # WM + screen locker (i3 config locks via xss-lock + i3lock)
  rofi \                  # launcher, bound to $mod+d
  picom \                 # compositor (shadows, rounded corners, vsync)
  polybar \               # status bar (i3 launches: polybar bar)
  dex \                   # runs XDG autostart .desktop files
  xss-lock \              # locks screen before suspend
  network-manager-gnome \ # nm-applet tray icon
  pulseaudio-utils \      # pactl — volume keybindings
  psmisc                  # killall — used to restart polybar on i3 reload
```

Polybar and i3 both render with **Ubuntu Sans Mono**, and polybar's icons need
**Symbols Nerd Font** (both in Fonts above). The polybar CPU/GPU modules read
`nvidia-smi` (NVIDIA driver) and the `k10temp`/`amdgpu` sysfs sensors; a missing
sensor degrades to `?%` rather than breaking the bar.
Select the "i3" session on the login screen after installing.

### 12. protoc (Protocol Buffers)

`shell/bash_profile.macos` references a `protoc-gen-go-json` build path (macOS):

```bash
sudo apt install -y protobuf-compiler
go install github.com/mitchellh/protoc-gen-go-json@v1.1.0
```

### What each tool is for

| Tool | Needed by |
|---|---|
| clangd | nvim C/C++ LSP |
| gopls | nvim Go LSP |
| pylsp + ruff | nvim Python LSP + lint/format |
| jdtls (Mason) + JDK | nvim Java LSP |
| typescript-language-server (ts_ls) | nvim JS/TS/React LSP |
| ripgrep | telescope live_grep |
| gcc / make | treesitter parsers, telescope-fzf-native |
| git-lfs | `.gitconfig` lfs filter |
| Ubuntu Sans Mono / JetBrains Mono | terminal + editor font |

---

## Not yet automated

- iTerm2 profile import (macOS) — see the note `install.sh` prints.
- `vim/`, `zsh/`, `vscode/`, `idea/` are kept in the repo but not linked by
  `install.sh` (not part of the active setup).

## TODO

- [ ] Package installs (the manual steps above) scripted per-OS
- [ ] Fold the wezterm titlebar fix (`window_decorations = "TITLE | RESIZE"`)

*Work in progress.*
