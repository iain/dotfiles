local wezterm = require("wezterm")
local act = wezterm.action

local config = wezterm.config_builder()

-- appearance
config.font = wezterm.font({ family = "JetBrainsMono Nerd Font", weight = "Light" })
config.font_size = 14.0
config.harfbuzz_features = { "calt=1", "clig=1", "liga=1" }
config.default_cursor_style = "BlinkingBlock"
config.window_padding = { left = 12, right = 12, top = 8, bottom = 8 }
config.window_decorations = "RESIZE"
config.use_fancy_tab_bar = true

-- behavior
config.hide_mouse_cursor_when_typing = true
-- config.scrollback_lines = 100000

-- macOS
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false
config.native_macos_fullscreen_mode = false

-- custom colorscheme (mirrors spectral/ghostty/spectral-amber)
config.color_schemes = {
  ["spectral-amber"] = {
    background = "#181818",
    foreground = "#D8D4CC",
    cursor_bg = "#FFB000",
    cursor_fg = "#181818",
    cursor_border = "#FFB000",
    selection_bg = "#3D3D3D",
    selection_fg = "#D8D4CC",
    ansi = {
      "#262626", "#FF3B30", "#B5E853", "#FFD60A",
      "#4A9EFF", "#C678DD", "#30D5C8", "#D8D4CC",
    },
    brights = {
      "#5C5C5C", "#FF6B5A", "#C5F873", "#FFE63A",
      "#6AB4FF", "#D698FD", "#50E5D8", "#FFFFFF",
    },
  },
}

local function scheme_for(appearance)
  if appearance:find("Dark") then
    return "spectral-amber"
  end
  return "Monokai Pro Light (Gogh)"
end

config.color_scheme = scheme_for(wezterm.gui.get_appearance())

wezterm.on("window-config-reloaded", function(window)
  local overrides = window:get_config_overrides() or {}
  local desired = scheme_for(window:get_appearance())
  if overrides.color_scheme ~= desired then
    overrides.color_scheme = desired
    window:set_config_overrides(overrides)
  end
end)

-- maximize on launch
wezterm.on("gui-startup", function(cmd)
  local _, _, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

-- copy on select to system clipboard
config.mouse_bindings = {
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "NONE",
    action = act.CompleteSelection("Clipboard"),
  },
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "SHIFT",
    action = act.CompleteSelection("Clipboard"),
  },
}

-- keybinds
config.keys = {
  -- clear screen + scrollback
  { key = "r", mods = "CMD",      action = act.ClearScrollback("ScrollbackAndViewport") },

  -- vim-style split navigation
  { key = "h", mods = "CTRL",     action = act.ActivatePaneDirection("Left") },
  { key = "j", mods = "CTRL",     action = act.ActivatePaneDirection("Down") },
  { key = "k", mods = "CTRL",     action = act.ActivatePaneDirection("Up") },
  { key = "l", mods = "CTRL",     action = act.ActivatePaneDirection("Right") },

  -- vim-style split resizing
  { key = "h", mods = "CMD|CTRL", action = act.AdjustPaneSize({ "Left", 10 }) },
  { key = "j", mods = "CMD|CTRL", action = act.AdjustPaneSize({ "Down", 10 }) },
  { key = "k", mods = "CMD|CTRL", action = act.AdjustPaneSize({ "Up", 10 }) },
  { key = "l", mods = "CMD|CTRL", action = act.AdjustPaneSize({ "Right", 10 }) },
}

return config
