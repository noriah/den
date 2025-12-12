{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.den.apps.terminal;
in
{
  options.den.apps.terminal = {
    enable = mkEnableOption "terminal";

    package = mkPackageOption pkgs "alacritty" { };
    backupTerminalPackage = mkPackageOption pkgs "st" { };
  };

  config = mkIf cfg.enable {

    home.packages = [
      cfg.package
      cfg.backupTerminalPackage
    ];
  };

# # add to dconf later
# [org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9]
# audible-bell=true
# background-color='rgb(38,34,40)'
# bold-color='rgb(255,255,255)'
# bold-color-same-as-fg=false
# bold-is-bright=false
# cursor-colors-set=false
# default-size-columns=80
# default-size-rows=30
# font='FiraCode Nerd Font 10'
# foreground-color='rgb(247,247,247)'
# highlight-background-color='rgb(222,113,56)'
# highlight-colors-set=true
# highlight-foreground-color='rgb(38,34,40)'
# palette=['rgb(59,77,87)', 'rgb(212,56,108)', 'rgb(139,195,74)', 'rgb(252,165,38)', 'rgb(33,150,243)', 'rgb(149,117,205)', 'rgb(0,188,212)', 'rgb(236,239,241)', 'rgb(97,125,138)', 'rgb(253,67,129)', 'rgb(156,204,101)', 'rgb(255,183,77)', 'rgb(66,165,245)', 'rgb(179,157,219)', 'rgb(38,198,218)', 'rgb(255,255,255)']
# use-system-font=false
# use-theme-colors=false
# visible-name='noriah'
}
