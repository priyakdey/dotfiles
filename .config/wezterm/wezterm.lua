local wezterm = require 'wezterm'

return {
    -- Theme
    color_scheme = "Gruvbox dark, hard (base16)",

    -- font
    font = wezterm.font("Ubuntu Sans Mono"),
    font_size = 12.5,

    -- Cursor
    default_cursor_style = "BlinkingBar",
  
    -- Window size
    initial_cols = 140,
    initial_rows = 40,

    window_padding = {
        left = 6,
        right = 6,
        top = 6,
        bottom = 6,
    },
    window_background_opacity = 0.95,
    window_decorations = "RESIZE",

    -- Scroll
    scrollback_lines = 100000, 

    -- Key bindings
    keys = {
        {key="v", mods="CTRL|SHIFT", action=wezterm.action.PasteFrom("Clipboard")},
        {key="c", mods="CTRL|SHIFT", action=wezterm.action.CopyTo("Clipboard")},
    },

    -- Disable ligatures (better for coding)
    harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
   
    -- It all boils down to Wayland being a piece of shit, I think
    -- front_end = "WebGpu",
}
