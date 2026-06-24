# dotfiles

My personal configuration files. `setup_linux.sh` symlinks the configs into `$HOME`;
it does **not** install any tools — those are listed under [Manual install steps](#manual-install-steps).

## Current setup

| | |
|---|---|
| **Terminal** | WezTerm (`.config/wezterm/wezterm.lua`) |
| **Font** | Ubuntu Sans Mono, size 13 |
| **Shell** | Bash |
| **Multiplexer** | tmux (prefix remapped to `C-a`) |
| **Editor** | Neovim — lazy.nvim, gruvbox, telescope, treesitter, LSP for C/C++, Go, Python, Java |
| **Languages** | Go, Node (via nvm), Java/Gradle/Maven (via SDKMAN), Python 3.14 |

> The `iterm2/` profile and `.bash_profile` are leftover macOS config — kept for
> reference, not used on the current Linux machine. See the TODO about platform splits.

## Setup a new machine

```bash
git clone https://github.com/priyakdey/dotfiles ~/dev/github.com/priyakdey/dotfiles
cd ~/dev/github.com/priyakdey/dotfiles
./setup_linux.sh        # symlinks .bashrc, .bash_aliases, .gitconfig
```

Then work through the manual install steps below.

---

## Manual install steps

`setup_linux.sh` only symlinks config files. Everything below has to be installed by hand.

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

- **Ubuntu Sans Mono** (used by `wezterm.lua`)
- **JetBrains Mono** (alternate)

Drop the `.ttf` files into `~/.local/share/fonts/` then run `fc-cache -fv`.

### 3. Terminal — WezTerm

Config: `.config/wezterm/wezterm.lua`. Install from the official package/repo (apt's is stale).

### 4. Neovim (tarball, not apt)

Installed to `/opt/nvim-linux-x86_64` (already on PATH via `.bashrc`).

```bash
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
```

Plugins bootstrap themselves: `init.lua` clones **lazy.nvim** on first launch. See step 9
for the plugin-side manual bits.

### 5. Go (tarball) + gopls

Installed to `/usr/local/go`; `GOPATH=$HOME/go` (both on PATH via `.bashrc`).

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
curl -fsSL https://get.pnpm.io/install.sh | sh -   # PNPM_HOME already in .bashrc
```

### 7. JVM toolchain — SDKMAN → java / gradle / maven

```bash
curl -s "https://get.sdkman.io" | bash
# loader already at the END of .bashrc (must stay last)
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

### 11. protoc (Protocol Buffers)

`.bash_profile` references a `protoc-gen-go-json` build path:

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
| ripgrep | telescope live_grep |
| gcc / make | treesitter parsers, telescope-fzf-native |
| git-lfs | `.gitconfig` lfs filter |
| Ubuntu Sans Mono / JetBrains Mono | terminal + editor font |

---

## TODO

- [ ] Platform dependent files (`.bash_profile` is still macOS-flavored)
- [ ] Some config management to setup machines easily ([dotfiles-as-bare-repo](https://www.atlassian.com/git/tutorials/dotfiles))
- [ ] Remove hard coded path names, env variable driven

*Work in progress.*
