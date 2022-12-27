local wezterm = require 'wezterm'

return {
  font = wezterm.font_with_fallback {
    {
      family = 'Fira Code',
      weight = 'Regular',
      harfbuzz_features = { 'zero', 'calt=1', 'clig=1', 'liga=1' },
      assume_emoji_presentation = false,
    }
  },

  font_size = 9.0,
  custom_block_glyphs = false,

  hide_tab_bar_if_only_one_tab = true,

  color_scheme = 'noriah',
  bold_brightens_ansi_colors = true,
}

