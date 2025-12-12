{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  gtk-theme = "Juno-mirage";
  icon-theme = "Qogir";
  icon-theme-package = pkgs.qogir-icon-theme;
  cursor-theme = "Adwaita";
  cfg = config.den.apps.budgie;
in
{
  options.den.apps.budgie.enable = mkEnableOption "budgie dm";

  config = mkIf cfg.enable {

    den.apps.xorg.enable = mkDefault true;

    services.gpg-agent.pinentry.package = pkgs.pinentry-gnome3;

    home.packages = with pkgs; [
      qogir-icon-theme
      noto-fonts
      juno-theme
    ];

    gtk = {
      enable = true;

      cursorTheme.package = pkgs.vanilla-dmz;
      cursorTheme.name = cursor-theme;
      cursorTheme.size = 24;

      iconTheme.package = icon-theme-package;
      iconTheme.name = icon-theme;

      theme.name = gtk-theme;

      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };

      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };

    dconf.settings = with lib.hm.gvariant; {

      "org/buddiesofbudgie/budgie-desktop-view" = {
        click-policy = "double";
        show = true;
        show-active-mounts = true;
        show-home-folder = false;
        show-trash-folder = false;
      };

      "com/solus-project/budgie-wm" = {
        button-layout = "appmenu:minimize,maximize,close";
        button-style = "traditional";
        caffeine-mode = false;
        # center-windows = false;
        clear-notifications = [ ];
        toggle-notifications = [ ];
        toggle-raven = [ "<Primary><Shift><Super>a" ];
      };

      "org/gnome/desktop/interface" = {
        clock-format = "24h";
        clock-show-weekday = true;
        cursor-theme = cursor-theme;
        gtk-theme = gtk-theme;
        icon-theme = icon-theme;
        accent-color = "pink";
        color-scheme = "prefer-dark";
        show-battery-percentage = true;
        document-font-name = "Noto Sans 10";
        monospace-font-name = "Fira Code 10";
      };

      "org/gnome/desktop/peripherals/mouse" = {
        accel-profile = "flat";
      };

      #"org/gnome/desktop/session" = {
      #  idle-delay = mkUint32 0;
      #};

      "org/gnome/desktop/wm/keybindings" = {
        activate-window-menu = [ "<Alt>space" ];
        close = [ "<Super>q" ];
        maximize = [ ];
        move-to-monitor-down = [ ];
        move-to-monitor-left = [ ];
        move-to-monitor-right = [ ];
        move-to-monitor-up = [ ];
        move-to-workspace-1 = [ ];
        move-to-workspace-last = [ ];
        move-to-workspace-left = [ "<Super><Shift>Home" ];
        move-to-workspace-right = [ "<Super><Shift>End" ];
        panel-run-dialog = [ "<Super>space" ];
        # we are using budgie-extras-wpreviews
        switch-applications = [ ];
        switch-applications-backwad = [ ];
        switch-group = [ ];
        switch-group-backward = [ ];
        switch-input-source = [ ];
        switch-input-source-backward = [ ];
        switch-to-workspace-1 = [ ];
        switch-to-workspace-first = [ ];
        switch-to-workspace-last = [ ];
        switch-to-workspace-left = [ "<Super>Home" ];
        switch-to-workspace-right = [ "<Super>End" ];
        unmaximize = [ ];
      };

      "org/gnome/mutter" = {
        # this is dumb. why can i not set this to a chord of keys?
        # mutter has so many random broken things, and so many 3rd party apps
        # just go with them.
        # /shrug
        overlay-key = "Alt_L" ;
      };

      "org/gnome/desktop/wm/preferences" = {
        button-layout = "appmenu:minimize,maximize,close";
        mouse-button-modifier = "<Control><Super>";
        resize-with-right-button = true;
        titlebar-font = "Noto Sans Bold 10";
        theme = gtk-theme;
      };

      "org/gnome/mutter/keybindings" = {
        toggle-tiled-left = [ ];
        toggle-tiled-right = [ ];
      };

      "org/gnome/mutter/wayland/keybindings" = {
        restore-shortcuts = [ ];
      };

      "org/buddiesofbudgie/settings-daemon/plugins/media-keys" = {
        help = [ ];
        screensaver = [ "<Primary><Super>q" ];
      };

    };
  };
}
