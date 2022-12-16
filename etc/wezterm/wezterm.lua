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

  color_scheme = 'noriah',
  bold_brightens_ansi_colors = true,
}

