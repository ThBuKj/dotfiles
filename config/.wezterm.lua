# /home/thomas/.wezterm.lua

local wezterm = require 'wezterm'
local act = wezterm.action  -- Vi skapar en genväg som heter "act"


if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- HÄR ÄNDRAR DU TEMAT:
config.color_scheme = 'Dracula'

-- Andra inställningar
config.font_size = 12.0

-- (Valfritt) Ta bort fönsterramen för en renare look om du vill
config.window_decorations = "RESIZE"



config.keys = {
  -- 1. HANTERA SPLITTAR (PANES)
  -- Dela skärmen vertikalt med Ctrl+Shift+E (som i "Equal" - delar lika)
  {
    key = 'h',
    mods = 'ALT',
    action = act.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  -- Dela skärmen horisontellt med Ctrl+Shift+O (som i "Open" new below)
  {
    key = 'j',
    mods = 'ALT',
    action = act.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  -- Stäng nuvarande ruta med Ctrl+Shift+W
  {
    key = 'w',
    mods = 'ALT',
    action = act.CloseCurrentPane { confirm = true },
  },

  -- 2. NAVIGERA MELLAN RUTOR
  -- Använd Alt + Piltangenter för att hoppa mellan rutorna
  { key = 'LeftArrow',  mods = 'ALT', action = act.ActivatePaneDirection 'Left' },
  { key = 'RightArrow', mods = 'ALT', action = act.ActivatePaneDirection 'Right' },
  { key = 'UpArrow',    mods = 'ALT', action = act.ActivatePaneDirection 'Up' },
  { key = 'DownArrow',  mods = 'ALT', action = act.ActivatePaneDirection 'Down' },

  -- 3. HANTERA FLIKAR (TABS)
  -- Ny flik med Ctrl+Shift+T
  { key = 't', mods = 'CTRL|SHIFT', action = act.SpawnTab 'CurrentPaneDomain' },
  -- Byt flik med Ctrl+Tab och Ctrl+Shift+Tab
  { key = 'Tab', mods = 'CTRL', action = act.ActivateTabRelative(1) },
  { key = 'Tab', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(-1) },
}


-- Vi lägger till lite luft (padding) runt texten.
-- Ofta räcker det med några få pixlar i botten för att "knuffa upp" texten.
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 27, -- Testa att öka denna siffra om det fortfarande är klippt
}

return config
