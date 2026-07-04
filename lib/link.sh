# lib/link.sh — idempotent symlink helper. Sourced by install.sh.
# Requires $DOTFILES to be set to the repo root.
#
#   link <path-relative-to-repo> <absolute-target>
#
# Behaviour:
#   - correct link already present  -> no-op
#   - a real file/dir is in the way -> moved aside to <target>.backup.<ts>
#   - a stale/wrong symlink         -> replaced
# Safe to run repeatedly.

link() {
    local src="$DOTFILES/$1"
    local dst="$2"

    if [ ! -e "$src" ]; then
        echo "  ✗ skip (source missing): $1"
        return 1
    fi

    mkdir -p "$(dirname "$dst")"

    # Already pointing where we want -> nothing to do.
    if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
        echo "  ✓ $dst"
        return 0
    fi

    # Something else is here (real file/dir, or a symlink elsewhere) -> back it up.
    if [ -e "$dst" ] || [ -L "$dst" ]; then
        local backup="$dst.backup.$(date +%Y%m%d%H%M%S)"
        mv "$dst" "$backup"
        echo "  ⟳ backed up existing -> $backup"
    fi

    ln -s "$src" "$dst"
    echo "  → $dst -> $src"
}
