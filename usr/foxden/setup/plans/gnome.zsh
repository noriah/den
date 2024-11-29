apply_gsettings() {
  # key bindings
  gsettings set org.gnome.desktop.wm.keybindings activate-window-menu "['<Alt>space']"
  gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-left "['<Super><Shift>Page_Up']"
  gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-right "['<Super><Shift>Page_Down']"
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left "['<Super>Page_Up']"
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right "['<Super>Page_Down']"
  gsettings set org.gnome.desktop.wm.keybindings close "['<Super>q']"
  
  gsettings set org.gnome.mutter.keybindings switch-monitor "['XF86Display']"

  gsettings set org.gnome.shell.keybindings shift-overview-down "['']"
  gsettings set org.gnome.shell.keybindings shift-overview-up "['']"
  gsettings set org.gnome.shell.keybindings toggle-overview "['<Super>c']"
  gsettings set org.gnome.settings-daemon.plugins.media-keys screensaver "['<Control><Super>q']"

  # resize with mouse
  gsettings set org.gnome.desktop.wm.preferences mouse-button-modifier "'<Control><Super>'"
  gsettings set org.gnome.desktop.wm.preferences resize-with-right-button true
  
  # stop overlay
  gsettings set org.gnome.mutter overlay-key "''"

  echo "set gnome settings"
}

if den::is::linux; then
  apply_gsettings
else
  echo "noop"
fi

unset -f apply_gsettings
