#!/usr/bin/env bash

set -euo pipefail

if [ ! -r /etc/os-release ] || ! grep -qE '^(ID|ID_LIKE)=.*(ubuntu|debian)' /etc/os-release; then
    echo '[ERROR] This installer only supports Ubuntu/Debian (including WSL).'
    exit 1
fi

sudo apt-get update
sudo apt-get install -y \
    bat build-essential curl fd-find fzf git golang-go nodejs npm \
    python3 python3-venv ripgrep tar unzip zoxide zsh

# Ubuntu names these executables differently from the upstream tools.
if ! command -v batcat >/dev/null 2>&1 && command -v bat >/dev/null 2>&1; then
    sudo ln -sf "$(command -v bat)" /usr/local/bin/batcat
fi
if ! command -v fd >/dev/null 2>&1 && command -v fdfind >/dev/null 2>&1; then
    sudo ln -sf "$(command -v fdfind)" /usr/local/bin/fd
fi

machine=$(uname -m)
case "$machine" in
    x86_64)
        nvim_arch='x86_64'
        tree_sitter_arch='x64'
        ;;
    aarch64|arm64)
        nvim_arch='arm64'
        tree_sitter_arch='arm64'
        ;;
    *)
        echo "[ERROR] Unsupported architecture: $machine"
        exit 1
        ;;
esac

tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' EXIT

# The nvim-treesitter main branch requires Neovim >= 0.12. Use the latest
# stable archive so fresh machines get a supported, reproducible release line.
curl -fL \
    "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${nvim_arch}.tar.gz" \
    -o "$tmp_dir/nvim.tar.gz"

# Do not extract over an older installation. Files removed by a newer Neovim
# release would otherwise remain in runtime/ and could be loaded by the new
# binary, producing hard-to-diagnose internal API errors.
tar -C "$tmp_dir" -xzf "$tmp_dir/nvim.tar.gz"
nvim_install_dir="$tmp_dir/nvim-linux-${nvim_arch}"
if [ ! -x "$nvim_install_dir/bin/nvim" ]; then
    echo '[ERROR] The downloaded Neovim archive has an unexpected layout.'
    exit 1
fi
sudo rm -rf -- "/opt/nvim-linux-${nvim_arch}"
sudo mv -- "$nvim_install_dir" "/opt/nvim-linux-${nvim_arch}"
sudo ln -sf "/opt/nvim-linux-${nvim_arch}/bin/nvim" /usr/local/bin/nvim

# nvim-treesitter requires the official tree-sitter CLI >= 0.26.1 (not npm).
curl -fL \
    "https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-${tree_sitter_arch}.gz" \
    -o "$tmp_dir/tree-sitter.gz"
gzip -d "$tmp_dir/tree-sitter.gz"
chmod +x "$tmp_dir/tree-sitter"
sudo install -m 0755 "$tmp_dir/tree-sitter" /usr/local/bin/tree-sitter

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
bash "$script_dir/check_dependencies.sh"

echo '[DONE] Ubuntu/WSL dependencies installed.'
