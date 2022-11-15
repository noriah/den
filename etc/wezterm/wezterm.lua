local wezterm = require 'wezterm'

wezterm.on('update-right-status', function(window, pane)
  -- "Wed Mar 3 08:14"
  local date = wezterm.strftime '%a %b %-d %H:%M:%S '

  window:set_right_status(wezterm.format {
    { Text = wezterm.nerdfonts.mdi_clock .. ' ' .. date },
  })
end)

return {
  font = wezterm.font_with_fallback {
    {
      family = 'Fira Code',
      weight = 'Regular',
      harfbuzz_features = { 'zero', 'calt=1', 'clit=1', 'liga=1' },
      assume_emoji_presentation = false,
    }
  },

  font_size = 10.0,
  custom_block_glyphs = false,

  color_scheme = 'noriah',
  bold_brightens_ansi_colors = true,
}

