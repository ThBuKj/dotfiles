local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

-- =========================================================
-- UTSEENDE: ALLT ÄR DET SVART (HIGH CONTRAST)
-- =========================================================

config.color_scheme = 'Dracula'
config.font_size = 12.0
config.window_decorations = "RESIZE"

-- Här sker magin för färgerna
config.colors = {
  -- 1. Huvudfönstret (Svart)
  background = '#000000',

  -- 2. Flik-raden (Tab bar)
  tab_bar = {
    -- Bakgrunden bakom flikarna
    background = '#000000',

    -- Den aktiva fliken (Svart bakgrund, vit text)
    active_tab = {
      bg_color = '#000000',
      fg_color = '#f8f8f2', -- Vit text
      intensity = 'Bold',
    },

    -- Inaktiva flikar (Svart bakgrund, grå text)
    inactive_tab = {
      bg_color = '#000000',
      fg_color = '#6272a4', -- Grå/Lila text (Dracula comment color)
    },

    -- Knappen för ny flik
    new_tab = {
      bg_color = '#000000',
      fg_color = '#f8f8f2',
    },
  },
}

-- Din padding (lyfter texten från botten)
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 27,
}

-- =========================================================
-- KNAPPAR (Mina egna inställningar)
-- =========================================================
config.keys = {
  -- Splitta fönster
  { key = 'h', mods = 'ALT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = 'j', mods = 'ALT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = 'w', mods = 'ALT', action = act.CloseCurrentPane { confirm = true } },

  -- Navigera
  { key = 'LeftArrow', mods = 'ALT', action = act.ActivatePaneDirection 'Left' },
  { key = 'RightArrow', mods = 'ALT', action = act.ActivatePaneDirection 'Right' },
  { key = 'UpArrow', mods = 'ALT', action = act.ActivatePaneDirection 'Up' },
  { key = 'DownArrow', mods = 'ALT', action = act.ActivatePaneDirection 'Down' },



  -- Flikar
  { key = 't', mods = 'CTRL', action = act.SpawnTab 'CurrentPaneDomain' },
 { key = 'RightArrow', mods = 'CTRL', action = act.ActivateTabRelative(1) },
  { key = 'LeftArrow', mods = 'CTRL', action = act.ActivateTabRelative(-1) },
}

return config
