# Dotfiles

个人使用的 Ubuntu/WSL 开发环境配置。所有 Git 仓库均通过 SSH 访问。

## 在全新的 Ubuntu/WSL 中安装

### 1. 准备 GitHub SSH 访问

克隆仓库前，先安装 Git 和 OpenSSH：

```sh
sudo apt update
sudo apt install -y git openssh-client ca-certificates
```

如果这台电脑还没有 SSH 密钥，创建一对新密钥：

```sh
ssh-keygen -t ed25519 -C "your_email@example.com"
cat ~/.ssh/id_ed25519.pub
```

将输出的公钥添加到 GitHub 的 **Settings > SSH and GPG keys**，然后验证连接：

```sh
ssh -T git@github.com
```

如果私钥设置了口令，可以将它加入 SSH agent，避免每次推送都重复输入：

```sh
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

### 2. 克隆 dotfile 仓库

```sh
cd ~
git clone git@github.com:Zz1li-Wang/dotfile.git
cd ~/dotfile
```

### 3. 安装 Ubuntu/WSL 系统依赖

依赖安装脚本会安装 Shell 工具、开发工具链、稳定版 Neovim，以及该配置所需的官方
Tree-sitter CLI：

```sh
bash install_dependencies_ubuntu.sh
```

应用配置前，先检查环境：

```sh
bash check_dependencies.sh
```

预期输出：

```text
[OK] Dotfile and Neovim dependencies are ready.
```

当前最低要求为 Neovim 0.12 和 tree-sitter-cli 0.26.1。如果环境不满足要求，主安装
脚本会提前停止，并一次性列出缺少的依赖，避免进入 Neovim 后出现大量重复错误。

### 4. 应用 dotfiles

```sh
bash install.sh
```

该脚本会：

- 初始化 tmux 的 Git submodule；
- 通过 SSH 将独立的 nvim 仓库克隆到 `~/dotfile/nvim`；
- 为 Zsh、Git、tmux、Neovim 等配置创建软链接。

安装脚本不会覆盖已经存在的普通文件。如果提示目标文件冲突，请先手动确认并处理，
然后重新运行安装脚本。

### 5. 将 Zsh 设置为默认 Shell

```sh
chsh -s "$(command -v zsh)"
```

注销并重新登录。在 WSL 中，可以从 Windows PowerShell 完全关闭 WSL：

```powershell
wsl --shutdown
```

重新打开终端后验证：

```sh
echo "$SHELL"
ps -p $$ -o comm=
```

第二条命令应输出 `zsh`。

### 6. 完成 Neovim 初始化

打开 Neovim，等待首次启动完成，然后依次执行：

```vim
:Lazy sync
:TSUpdate
:checkhealth
```

首次执行 `:Lazy sync` 时不要中途退出。Mason 语言服务器、Treesitter parsers 和插件
原生库的安装可能需要几分钟。

如果 Treesitter 的工具链不完整，配置只会显示一条包含解决方法的提示，不会尝试安装
所有 parser 并连续输出错误。

### 7. 安装 tmux 插件

启动 tmux：

```sh
tmux
```

按 `prefix + I` 安装插件。默认操作是先按 `Ctrl-b`，松开后再按大写 `I`。

## 配置 Windows WezTerm

首先在 Windows 中安装 JetBrainsMono Nerd Font 的 `.ttf` 字体文件。字体必须安装在
Windows 中，只安装到 WSL 无法供 Windows 版 WezTerm 使用。

Windows 版 WezTerm 默认读取 `%USERPROFILE%\\.wezterm.lua`。使用管理员 PowerShell
创建 Windows 原生软链接，并根据实际情况替换 Linux 用户名：

```powershell
New-Item -ItemType SymbolicLink `
  -Path "$HOME\.wezterm.lua" `
  -Target "\\wsl.localhost\Ubuntu\home\ayanami\dotfile\wezterm\wezterm.lua"
```

验证软链接：

```powershell
Get-Item "$HOME\.wezterm.lua" | Format-List FullName,LinkType,Target
```

完全退出并重新启动 WezTerm。当前配置会默认进入 `WSL:Ubuntu` 并启动 `zsh -l`。

如果 WSL 发行版名称不是 `Ubuntu`，需要同时修改：

- `wezterm/wezterm.lua` 中的 `default_domain`；
- PowerShell 软链接目标中的 `\\wsl.localhost\Ubuntu`。

## 检查已有环境

更新配置或系统后，可以随时重新运行环境检查：

```sh
cd ~/dotfile
bash check_dependencies.sh
```

## 更新仓库

主 dotfile 和 nvim 是两个独立的 Git 仓库，需要分别提交和推送：

```sh
git -C ~/dotfile/nvim status
git -C ~/dotfile/nvim push origin main

git -C ~/dotfile status
git -C ~/dotfile push origin main
```
