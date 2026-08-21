local wezterm = require "wezterm"

local config = {}
if wezterm.config_builder then
    config = wezterm.config_builder()
end

--- wsl_domains
local wsl_domains = wezterm.default_wsl_domains()
for _, domain in ipairs(wsl_domains) do
    domain.default_prog = { "zsh", "-l" }
end
config.default_domain = "WSL:Ubuntu"
config.wsl_domains = wsl_domains
--

-- fps
config.animation_fps = 120
config.max_fps = 120


config.window_close_confirmation = 'NeverPrompt'


config.font = wezterm.font_with_fallback({
    { family = "JetBrainsMono Nerd Font Mono", weight = "Regular" },
    { family = "MesloLGS NF" },
})

config.color_scheme = "Catppuccin Mocha"

-- Tab bar & window frame colors (Catppuccin Mocha)
config.window_frame = {
    active_titlebar_bg   = "#1e1e2e",
    inactive_titlebar_bg = "#1e1e2e",
    button_fg            = "#cdd6f4",
    button_bg            = "#1e1e2e",
    button_hover_fg      = "#11111b",
    button_hover_bg      = "#cba6f7",
}
config.colors = {
    tab_bar = {
        background        = "#11111b",
        active_tab        = { bg_color = "#cba6f7", fg_color = "#11111b" },
        inactive_tab      = { bg_color = "#1e1e2e", fg_color = "#cdd6f4" },
        inactive_tab_hover= { bg_color = "#313244", fg_color = "#cdd6f4" },
        new_tab           = { bg_color = "#1e1e2e", fg_color = "#cdd6f4" },
        new_tab_hover     = { bg_color = "#45475a", fg_color = "#cdd6f4" },
    },
}

-- 透明背景
config.window_background_opacity = 0.9
-- 取消 Windows 原生标题栏
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
-- 滚动条尺寸为 15 ，其他方向不需要 pad
config.window_padding = { left = 0, right = 20, top = 0, bottom = 0 }
    -- tab bar
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = true
-- config.tab_max_width = 25,
config.show_tab_index_in_tab_bar = false
config.switch_to_last_active_tab_when_closing_tab = true


-- 启用滚动条
config.enable_scroll_bar = true
config.scrollback_lines = 100000
config.min_scroll_bar_height = "2cell"

config.window_background_opacity = 0.95
config.text_background_opacity = 0.98
config.adjust_window_size_when_changing_font_size = true


-- config.disable_default_key_bindings = true

local act = wezterm.action
config.keys = {
    -- 透传 Ctrl+V/T 给终端内程序（Neovim 需要这两个键），粘贴请用 Ctrl+Shift+V 或 Shift+Insert
    { key = 'v',      mods = 'CTRL',       action = act.SendKey { key = 'v', mods = 'CTRL' } },
    { key = 't',      mods = 'CTRL',       action = act.SendKey { key = 't', mods = 'CTRL' } },
    -- Ctrl+Shift+Tab 遍历 tab
    { key = 'Tab',       mods = 'SHIFT|CTRL', action = act.ActivateTabRelative(1) },
    -- F11 切换全屏
    { key = 'F11',       mods = 'NONE',       action = act.ToggleFullScreen },
    -- Ctrl+Shift++ 字体增大
    { key = '+',         mods = 'SHIFT|CTRL', action = act.IncreaseFontSize },
    -- Ctrl+Shift+- 字体减小
    { key = '_',         mods = 'SHIFT|CTRL', action = act.DecreaseFontSize },
    -- Ctrl+Shift+C 复制选中区域
    { key = 'C',         mods = 'SHIFT|CTRL', action = act.CopyTo 'Clipboard' },
    -- Ctrl+Shift+N 新窗口
    { key = 'N',         mods = 'SHIFT|CTRL', action = act.SpawnWindow },
    -- Ctrl+Shift+T 新 tab
    { key = 'T',         mods = 'SHIFT|CTRL', action = act.ShowLauncher },
    -- Ctrl+Shift+Enter 显示启动菜单
    { key = 'Enter',     mods = 'SHIFT|CTRL', action = act.ShowLauncherArgs { flags = 'FUZZY|TABS|LAUNCH_MENU_ITEMS' } },
    -- Ctrl+Shift+V 粘贴剪切板的内容
    -- Ctrl+Shift+W 关闭 tab 且不进行确认
    { key = 'W',         mods = 'SHIFT|CTRL', action = act.CloseCurrentTab { confirm = false } },
    -- Ctrl+Shift+PageUp 向上滚动一页
    { key = 'PageUp',    mods = 'SHIFT|CTRL', action = act.ScrollByPage(-1) },
    -- Ctrl+Shift+PageDown 向下滚动一页
    { key = 'PageDown',  mods = 'SHIFT|CTRL', action = act.ScrollByPage(1) },
    -- Ctrl+Shift+UpArrow 向上滚动一行
    { key = 'UpArrow',   mods = 'SHIFT|CTRL', action = act.ScrollByLine(-1) },
    -- Ctrl+Shift+DownArrow 向下滚动一行
    { key = 'DownArrow', mods = 'SHIFT|CTRL', action = act.ScrollByLine(1) },
    { key = "Insert", mods = "SHIFT",      action = act { PasteFrom = "Clipboard" } },
    { key = "Insert", mods = "CTRL",       action = act { PasteFrom = "PrimarySelection" } },
    { key = "Insert", mods = "CTRL|SHIFT", action = act { PasteFrom = "PrimarySelection" } },
    -- 分屏改用 Ctrl+Shift,避开与 tmux 的 Alt+Shift+-/+(M-_/M-+)冲突。
    -- 注意:Alt+Shift 那两个键留给 tmux,wezterm 不再占用。
    -- Ctrl+Shift+\ 左右分屏(竖分隔线 |)
    { key = '\\',     mods = 'SHIFT|CTRL',  action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    -- Ctrl+Shift+' 上下分屏
    { key = "'",      mods = 'SHIFT|CTRL',  action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
    { key = 'N', mods = 'SHIFT|CTRL', action = act.SpawnWindow },

    -- search for things that look like git hashes
    {
        key = 'F',
        mods = 'SHIFT|CTRL',
        action = act.Search("CurrentSelectionOrEmptyString"),
    },

}

-- config.disable_default_mouse_bindings = true
config.mouse_bindings = {
    -- and make CTRL-Click open hyperlinks
    {
        event = { Up = { streak = 1, button = "Left" } },
        mods = "CTRL",
        action = act.OpenLinkAtMouseCursor
    },
    -- Scrolling up while holding CTRL increases the font size
    {
        event = { Down = { streak = 1, button = { WheelUp = 1 } } },
        mods = 'CTRL',
        action = act.IncreaseFontSize,
    },

    -- Scrolling down while holding CTRL decreases the font size
    {
        event = { Down = { streak = 1, button = { WheelDown = 1 } } },
        mods = 'CTRL',
        action = act.DecreaseFontSize,
    },
}

return config
