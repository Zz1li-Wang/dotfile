#!/usr/bin/env bash

set -u

missing=()

require_command() {
    if ! command -v "$1" >/dev/null 2>&1; then
        missing+=("$1")
    fi
}

for command_name in \
    zsh git fzf zoxide batcat nvim curl tar cc tree-sitter \
    node npm python3 go rg; do
    require_command "$command_name"
done

if command -v nvim >/dev/null 2>&1; then
    nvim_version=$(nvim --version | head -n 1 | sed 's/^NVIM v//; s/[^0-9.].*$//')
    if ! printf '%s\n%s\n' "0.12.0" "$nvim_version" | sort -V -C; then
        printf '[ERROR] Neovim >= 0.12.0 is required (found %s).\n' "$nvim_version"
        missing+=("nvim>=0.12.0")
    fi
fi

if command -v tree-sitter >/dev/null 2>&1; then
    tree_sitter_version=$(tree-sitter --version | sed -n 's/^tree-sitter \([0-9.]*\).*/\1/p')
    if [ -z "$tree_sitter_version" ] || ! printf '%s\n%s\n' "0.26.1" "$tree_sitter_version" | sort -V -C; then
        printf '[ERROR] tree-sitter-cli >= 0.26.1 is required (found %s).\n' "${tree_sitter_version:-unknown}"
        missing+=("tree-sitter>=0.26.1")
    fi
fi

if ((${#missing[@]})); then
    printf '[ERROR] Missing required tools: %s\n' "${missing[*]}"
    printf '        On Ubuntu/WSL run: bash install_dependencies_ubuntu.sh\n'
    exit 1
fi

printf '[OK] Dotfile and Neovim dependencies are ready.\n'
