local wezterm = require 'wezterm'
local act = wezterm.action

-- Ctrl+C: copy if there is a selection, otherwise send SIGINT to the process
local function smart_copy(window, pane)
    local sel = window:get_selection_text_for_pane(pane)
    if sel and sel ~= '' then
        window:perform_action(act.CopyTo('ClipboardAndPrimarySelection'), pane)
        window:perform_action(act.ClearSelection, pane)
    else
        window:perform_action(act.SendKey { key = 'c', mods = 'CTRL' }, pane)
    end
end

-- Ctrl+X: copy mode, unless a full-screen app wants the key for itself
local function smart_copy_mode(window, pane)
    if pane:is_alt_screen_active() then
        window:perform_action(act.SendKey { key = 'x', mods = 'CTRL' }, pane)
    else
        window:perform_action(act.ActivateCopyMode, pane)
    end
end

local keys = {
    { key = 'c', mods = 'CTRL', action = wezterm.action_callback(smart_copy) },
    { key = 'v', mods = 'CTRL', action = act.PasteFrom('Clipboard') },
    { key = 'x', mods = 'CTRL', action = wezterm.action_callback(smart_copy_mode) },
    { key = 't', mods = 'CTRL', action = act.SpawnTab('CurrentPaneDomain') },
}

-- Ctrl+1..9 switches tabs (Ctrl+digit sends nothing to the shell anyway)
for i = 1, 9 do
    table.insert(keys, { key = tostring(i), mods = 'CTRL', action = act.ActivateTab(i - 1) })
end

return {
    -- Theme
  --   color_scheme = "Gruvbox dark, hard (base16)",
    color_scheme = "Google (dark) (terminal.sexy)",

    -- font
    font = wezterm.font("Ubuntu Sans Mono"),
    font_size = 13,

    -- Cursor
    default_cursor_style = "BlinkingBar",

    -- Window size
    initial_cols = 200,
    initial_rows = 40,

    window_padding = {
        left = 6,
        right = 6,
        top = 6,
        bottom = 6,
    },
    window_background_opacity = 1.0,
    window_decorations = "RESIZE",

    -- Scroll
    scrollback_lines = 100000,

    -- Key bindings
    keys = keys,

    -- Disable ligatures (better for coding)
    harfbuzz_features = { "calt=0", "clig=0", "liga=0" },

    -- Disable bell
    audible_bell = "Disabled"

    -- It all boils down to Wayland being a piece of shit, I think
    -- front_end = "WebGpu",
}
