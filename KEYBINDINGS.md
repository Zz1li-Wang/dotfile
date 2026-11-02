# Dotfiles 按键功能速查表

> 本表与实际配置同步，括号内标注了定义按键的配置文件，方便查改。
> Prefix（tmux 前缀键）= `Ctrl-g`；Leader（Neovim 引导键）= `空格`。

---

## 目录

- [WezTerm 终端](#wezterm-终端)
- [Zsh](#zsh)
- [tmux](#tmux)
- [Neovim 核心](#neovim-核心)
- [Oil.nvim 文件管理器](#oilnvim-文件管理器)
- [Yazi.nvim](#yazinvim)
- [fzf-lua](#fzf-lua)
- [Trouble / Quickfix](#trouble--quickfix)
- [Vim ↔ tmux 统一导航](#vim--tmux-统一导航)
- [tmux-sessionizer](#tmux-sessionizer)
- [高频操作速查](#高频操作速查)

---

## WezTerm 终端

> 配置（在 **Windows** 侧）：`C:\Users\zjgsh\.config\wezterm\wezterm.lua`。
> 启动即进入 WSL（`default_domain = "WSL:Ubuntu"`），默认 shell 为 zsh。
> 终端层快捷键统一用 **Ctrl+Shift**，刻意避开 tmux 的 `Alt`/`Alt+Shift`，防止抢键。

| 按键 | 功能 | 说明 |
|------|------|------|
| `Ctrl+Shift+V` | 粘贴剪贴板 | ⚠️ 已从 `Ctrl+V` 改来——把 `Ctrl+V` 让给 nvim 可视块 / tmux copy-mode 矩形选择 / Oil 竖分屏 |
| `Shift+Insert` | 粘贴剪贴板 | |
| `Ctrl+Insert` / `Ctrl+Shift+Insert` | 粘贴主选区（Primary） | |
| `Ctrl+Shift+C` | 复制选中区域 | |
| `Ctrl+Shift+\` | 左右分屏（WezTerm 自身的 pane） | 竖分隔线 |
| `Ctrl+Shift+'` | 上下分屏（WezTerm 自身的 pane） | |
| `Ctrl+Shift+Tab` | 切换到下一个 tab | |
| `Ctrl+Shift+N` | 新建窗口 | |
| `Ctrl+Shift+W` | 关闭当前 tab（不确认） | |
| `Ctrl+Shift+T` | 显示启动器（Launcher） | |
| `Ctrl+Shift+Enter` | 模糊启动菜单 | tabs / 启动项 |
| `Ctrl+Shift+F` | 搜索（git hash 等） | |
| `Ctrl+Shift++` / `Ctrl+Shift+_` | 字体增大 / 减小 | |
| `Ctrl+Shift+PageUp` / `PageDown` | 向上 / 向下翻页 | |
| `Ctrl+Shift+↑` / `↓` | 向上 / 向下滚动一行 | |
| `F11` | 切换全屏 | |
| `Ctrl+点击` | 打开鼠标下的链接 | 鼠标绑定 |
| `Ctrl+滚轮` | 放大 / 缩小字体 | 鼠标绑定 |

> 💡 日常在 WezTerm 里通常**不用**它自带的分屏（`Ctrl+Shift+\`、`Ctrl+Shift+'`），分屏交给 tmux（`Alt-_` / `Alt-+`）；WezTerm 分屏仅作不开 tmux 时的备用。

---

## Zsh

> 配置：`zsh/.zshrc`、`zsh/.zsh_profile`、`zsh/fzf-tmux-cd.zsh`、`zsh/plugins/`

| 按键 | 功能 | 说明 |
|------|------|------|
| `Tab` | 交互式补全 | 由 `fzf-tab`（Aloxaf/fzf-tab）接管原生补全，候选项进入 fzf 界面，可模糊筛选、预览。 |
| `Ctrl-T` | 模糊查找文件并插入命令行 | fzf 官方 `--zsh` 集成；候选来自 `FZF_DEFAULT_COMMAND`，即 `fd --type file --follow --hidden --exclude .git`（含隐藏文件、跟随软链、排除 `.git`）。 |
| `Ctrl-R` | 模糊搜索命令历史 | fzf 官方 `--zsh` 集成；历史去重（`HIST_IGNORE_ALL_DUPS` / `HIST_FIND_NO_DUPS`），历史容量 65 万条。 |
| `Alt-C` | 进入子目录（fzf cd） | fzf 官方集成默认绑定，递归列出子目录并 `cd`。 |
| `Alt-t` | 跳到任意 tmux pane 的当前目录 | 自定义 ZLE widget（`fzf-tmux-cd.zsh`）：`tmux list-panes -a` 收集所有 pane 的 cwd 去重，选中后 `cd` 过去并立即刷新 p10k 提示符路径段。仅在 tmux 内生效。 |
| `Esc Esc` | 给上一条命令加 `sudo` | `plugins/sudo.zsh`：双击 Esc 在行首插入/移除 `sudo`。 |
| `↑` / `↓` | 历史子串搜索 | `zsh-history-substring-search`：按已输入前缀向上/下匹配历史。 |
| `→` | 接受自动建议 | `zsh-autosuggestions` 的灰字补全（行尾接受整条）。 |

**常用别名**（`zsh/.zsh_profile`）：`vim`→`nvim`、`ts`→`tmux-sessionizer`、`ll`→`ls -lh`、`fzfp`→带 bat 预览的 fzf、`zi`→zoxide 交互式跳转、`cls`→`clear`。

---

## tmux

> 配置：`.config/tmux/tmux.conf`。鼠标已开启（`mouse on`），窗口/面板从 1 开始编号并自动重排。

### 前缀键

| 按键 | 功能 |
|------|------|
| `Ctrl-g` | tmux Prefix（已从默认 `Ctrl-b` 改绑） |
| `Prefix` + `Ctrl-a` | 向内层程序发送一次原始 Prefix（兼容嵌套 tmux / 透传给应用） |

### Pane（面板）导航 — 无需 Prefix

| 按键 | 功能 |
|------|------|
| `Alt-h` / `Alt-←` | 切到左侧 Pane |
| `Alt-j` / `Alt-↓` | 切到下方 Pane |
| `Alt-k` / `Alt-↑` | 切到上方 Pane |
| `Alt-l` / `Alt-→` | 切到右侧 Pane |
| `Prefix` + `h/j/k/l` | 同上（带前缀的等价绑定） |

### Window（窗口）导航 — 无需 Prefix

| 按键 | 功能 |
|------|------|
| `Alt-H`（Shift+Alt+h） | 上一个窗口 |
| `Alt-L`（Shift+Alt+l） | 下一个窗口 |

`Shift+方向键` 留给 Codex 等面板内程序，直接按即可，无需 Prefix；tmux 不再用 `Shift-←/→` 切换窗口。

### 分屏与新窗口

| 按键 | 功能 | 说明 |
|------|------|------|
| `Alt-_` | 上下分屏（水平分割线） | 保持当前路径，无需 Prefix |
| `Alt-+` | 左右分屏（垂直分割线） | 保持当前路径，无需 Prefix |
| `Prefix` + `"` | 上下分屏 | 保持当前路径 |
| `Prefix` + `%` | 左右分屏 | 保持当前路径 |
| `Prefix` + `c` | 在当前窗口右侧新建窗口 | 保持当前路径（`-a` 紧邻插入） |

### Popup（弹出层，覆盖在当前画面上）

| 按键 | 功能 | 说明 |
|------|------|------|
| `Prefix` + `g` | 弹出 Neogit | `nvim +Neogit`，80%×80% 居中弹窗，退出即关 |
| `Prefix` + `r` / `Alt-r` | 切换 popup 会话 | 进入/退出名为 `popup` 的临时会话（`Alt-r` 在会话内按则 detach 回去） |
| `F5` | 当前目录开临时 Shell | 80%×80% 弹窗，用完即走 |
| `Prefix` + `f` | 打开 tmux-sessionizer | 在新窗口运行项目/会话选择器 |

### Copy Mode（Vi 风格复制）

| 按键 | 功能 |
|------|------|
| `Prefix` + `v` | 进入 Copy Mode |
| `v` | 开始选择 |
| `Ctrl-v` | 切换矩形（块）选择 |
| `y` | 复制选区并退出（`tmux-yank`，经 `xclip` 写入系统剪贴板，修复 WSL 下 UTF-8 乱码） |

> 插件由 TPM 管理：`tmux-resurrect` + `tmux-continuum`（自动保存/恢复会话）、`tmux-yank`、`tmux-prefix-highlight`、网速与 CPU/MEM 状态栏等。

---

## Neovim 核心

> 配置：`nvim/lua/keymaps.lua`。`<Space>` 设为 Leader（其本身映射为 `<NOP>`）。

### 搜索与滚动（始终居中）

| 按键 | 功能 | 说明 |
|------|------|------|
| `n` | 下一个搜索结果 | `nzzzv`：跳转后居中并展开折叠 |
| `N` | 上一个搜索结果 | `Nzzzv`：同上 |
| `Ctrl-d` | 下翻半页 | `<C-d>zz`：翻页后光标行居中 |
| `Ctrl-u` | 上翻半页 | `<C-u>zz`：同上 |
| `Esc` | 清除搜索高亮 | 映射为 `:noh` |

### 移动与编辑

| 按键 | 模式 | 功能 | 说明 |
|------|------|------|------|
| `j` / `k` | Normal | 智能上下移动 | 无 count 时按显示行移动（`gj`/`gk`），软换行也能逐行走；有 count（如 `5j`）则按物理行 |
| `J` | Normal | 合并下一行 | `mzJ\`z`：合并后光标位置不动 |
| `J` / `K` | Visual | 选区下移 / 上移 | 移动后自动重新缩进并保持选中 |
| `<leader>s` | Normal | 全文替换光标下单词 | 预填 `:%s/\<word\>/word/gI`，光标停在替换词上待输入 |
| `<leader>p` | Visual | 粘贴但不覆盖寄存器 | `"_dP`，粘贴后仍可重复粘同一内容 |
| `<leader>d` | Normal/Visual | 删除到黑洞寄存器 | `"_d`，不污染默认寄存器 |
| `Ctrl-c` | Insert | 等价 `Esc` | |
| `Alt-z` | Normal | 切换当前窗口自动换行 | `Helper.change_window_wrap` |

### 文件浏览入口

| 按键 | 功能 |
|------|------|
| `<leader>e` | 打开 Oil（当前文件所在目录） |

### Emacs 风格行内编辑（Insert / 命令行模式）

> 让 Insert 与 `:` 命令行也能用 Emacs 光标键。

| 按键 | 功能 |
|------|------|
| `Ctrl-a` | 行首（Home） |
| `Ctrl-e` | 行尾（End，仅 Insert） |
| `Ctrl-f` / `Ctrl-b` | 右移 / 左移一个字符 |
| `Ctrl-n` / `Ctrl-p` | 下一行 / 上一行 |
| `Ctrl-d` | 向后删除一个字符（Del） |
| `Ctrl-h` | 向前删除（Backspace） |

---

## Oil.nvim 文件管理器

> 配置：`nvim/lua/plugins/oil-nvim.lua`（fork：`zhu-jiyuan/oil.nvim`）。已替代 netrw，默认显示隐藏文件、删除走回收站、用自定义键位（关闭了默认键位）。

### 打开

| 按键 | 功能 |
|------|------|
| `<leader>e` | 在当前文件位置打开 Oil（像编辑文本一样编辑目录） |

### Oil 内部操作

| 按键 | 功能 | 说明 |
|------|------|------|
| `<CR>` | 打开文件/进入目录 | |
| `-` | 返回上级目录 | |
| `_` | 跳到当前工作目录（cwd） | `actions.open_cwd` |
| `` ` `` | 把 Oil 目录设为 Vim cwd | `:cd` |
| `~` | 把 Oil 目录设为标签页 cwd | `:tcd` |
| `Ctrl-v` | 垂直分屏打开 | |
| `Ctrl-s` | 水平分屏打开 | |
| `Ctrl-t` | 新标签页打开 | |
| `Ctrl-p` | 预览光标项 | |
| `Ctrl-c` | 关闭 Oil | |
| `g.` | 显示/隐藏隐藏文件 | |
| `g\` | 进入回收站视图 | `toggle_trash` |
| `gd` | 切换详情视图 | 在「仅图标」与「权限+大小+修改时间+图标」之间切换 |
| `gs` | 切换排序方式 | |
| `gx` | 用外部程序打开 | |
| `g?` | 显示帮助 | |

> 注意：Oil 内 `Ctrl-h/j/k/l` 已被禁用，以让位给 vim-tmux-navigator。

---

## Yazi.nvim

> 配置：`nvim/lua/plugins/yazi.lua`。Yazi 内按 `F1` 看帮助。

| 按键 | 功能 |
|------|------|
| `<leader>ra` | 在当前文件位置打开 Yazi |
| `<leader>cw` | 在 Neovim 工作目录打开 Yazi |
| `<leader>rr` | 切换/恢复上次 Yazi 会话 |

---

## fzf-lua

> 配置：`nvim/lua/plugins/fzf-lua.lua`。grep 启用 `rg_glob`，与 Trouble 集成（`alt-t` 把结果送入 Trouble）。

### 文件 / 文本搜索

| 按键 | 功能 | 说明 |
|------|------|------|
| `<leader>ff` | 查找文件 | |
| `<leader>fg` | 全局 live grep | 支持 rg glob 语法过滤 |
| `<leader>/` | 当前 buffer 内 grep | `lgrep_curbuf` |
| `<leader>fw` | 搜索光标下单词 | `grep_cword` |
| `<leader>fW` | 搜索光标下 WORD | `grep_cWORD` |
| `<leader>fb` | Buffer 列表 | |
| `<leader>fo` | 最近文件 | `oldfiles` |
| `<leader>fl` | 恢复上次搜索 | `resume` |
| `<leader>f?` | 列出所有 fzf-lua 内置命令 | `builtin` |

### 代码导航（LSP）

| 按键 | 功能 |
|------|------|
| `<leader>fr` | LSP References（引用） |
| `<leader>fi` | LSP Implementations（实现） |
| `<leader>fm` | Marks（标记） |
| `<leader>fj` | Jumps（跳转列表） |

> 更多 LSP 入口在 `nvim/lua/lsp_setting.lua`：`gd` 定义、`gr` 引用、`gI` 实现、`<leader>ds` 文档符号、`<leader>ws` 工作区符号、`<leader>da` 工作区诊断等。

### Git / 历史 / 工具

| 按键 | 功能 |
|------|------|
| `<leader>fc` | 命令历史 |
| `<leader>ft` | 切换配色方案 |
| `<leader>gst` | Git Status |
| `<leader>gb` | Git 分支 |
| `<leader>fz` | Zoxide 项目切换（选中后 `tcd` 并用 Oil 打开；`Ctrl-t` 在新标签页打开） |
| `<leader>fh` | 帮助标签（help_tags） |

> fzf 二进制：使用 `~/.local/bin/fzf`（v0.73.1）。系统旧版 Debian fzf 0.44.1 已移除——它过旧，会导致 fzf-lua 浮窗因不支持 `--highlight-line` 等参数而打不开。

---

## Trouble / Quickfix

> 配置：`nvim/lua/keymaps.lua` 的 `smart_jump`。

| 按键 | 功能 | 说明 |
|------|------|------|
| `Alt-n` | 下一项 | Trouble 打开时跳 Trouble，否则 `:cnext`（quickfix） |
| `Alt-p` | 上一项 | 同上逻辑，否则 `:cprev` |
| `]q` | quickfix 下一项 | |
| `[q` | quickfix 上一项 | |

---

## Vim ↔ tmux 统一导航

> 配置：`nvim/lua/plugins/utils.lua`（`christoomey/vim-tmux-navigator`）。

| 按键 | 功能 |
|------|------|
| `Ctrl-h` | 左侧窗口（到边界时交给 tmux 左侧 Pane） |
| `Ctrl-j` | 下方窗口 / Pane |
| `Ctrl-k` | 上方窗口 / Pane |
| `Ctrl-l` | 右侧窗口 / Pane |

> ⚠️ 当前 tmux 侧的 vim-tmux-navigator 绑定在 `tmux.conf` 中被注释掉了，因此 `Ctrl-h/j/k/l` 目前只在 Neovim 内部的分割窗口间生效；要实现「nvim 分屏 ↔ tmux pane」无缝跳转，需在 `tmux.conf` 启用对应绑定。tmux pane 之间的切换请用 `Alt-h/j/k/l`。

---

## tmux-sessionizer

> 配置：`.config/tmux-sessionizer/tmux-sessionizer.conf`。搜索路径包含 `~/dev`、`~/learning`、`~/personal/dev`、`~/company`、`~/workspace`、`~/.config/nvim/local_plugins` 等；选中项目后默认执行 `nvim .`。

| 按键 | 功能 |
|------|------|
| `Prefix` + `f` | 在 tmux 内打开 Sessionizer |
| `ts` | 在 Shell 中打开 Sessionizer（别名 → `tmux-sessionizer`） |

---

## 高频操作速查

| 场景 | 按键 |
|------|------|
| 文件浏览（Oil） | `<leader>e` |
| 文件管理（Yazi） | `<leader>ra` |
| 查找文件 | `<leader>ff` |
| 全局搜索 | `<leader>fg` |
| 当前 buffer 搜索 | `<leader>/` |
| Buffer 切换 | `<leader>fb` |
| 最近文件 | `<leader>fo` |
| 项目切换（zoxide） | `<leader>fz` |
| Session 切换 | `Prefix f` / `ts` |
| Git UI（Neogit 弹窗） | `Prefix g` |
| 临时 Shell 弹窗 | `F5` |
| tmux Pane 切换 | `Alt-h/j/k/l` |
| tmux Window 切换 | `Alt-H` / `Alt-L` |
| tmux 分屏 | `Alt-_`（上下） / `Alt-+`（左右） |
| 命令历史搜索 | `Ctrl-R` |
| 文件模糊查找（Shell） | `Ctrl-T` |
| 跳到其他 pane 目录 | `Alt-t` |
