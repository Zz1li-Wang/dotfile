#!/usr/bin/env bash

set -euo pipefail

# nvim 配置是独立仓库（被 .gitignore 排除），需要单独克隆进 dotfile/nvim
nvim_repo="git@github.com:Zz1li-Wang/nvim.git"

######### START INSTALL #########

# cd to the directory of this script
cd -- "$(dirname -- "${BASH_SOURCE[0]}")"
dotfile_dir=$(pwd)

# Fail once, before Neovim starts installing plugins, with an actionable list.
bash "$dotfile_dir/check_dependencies.sh"

# 拉取 submodule（tmux 的 tpm 插件等）
git submodule update --init --recursive

# 克隆 nvim 配置（仅当 nvim 目录为空时）
if [ ! -e "$dotfile_dir/nvim/.git" ]; then
    echo "[INFO]: cloning nvim config into $dotfile_dir/nvim"
    git clone "$nvim_repo" "$dotfile_dir/nvim"
else
    echo "[INFO]: nvim config already exists, skip cloning."
fi

# 创建所有配置软链接（zsh / tmux / nvim / git ... 详见 create_link.sh）
bash "$dotfile_dir/create_link.sh"

echo
echo "[DONE]: dotfile installed."
echo "        启动 tmux 后按 prefix + I 安装 tmux 插件。"
