{ ... }:
{
  imports = [
    # generic apps
    ./ebook-reader.nix
    ./irc-client.nix
    ./microblogger.nix
    ./pdf-reader.nix
    ./screenshot.nix
    ./terminal.nix
    # ./dictionary.nix
    # ./password-manager.nix
    # ./web-browser.nix

    # specific apps
    ./_1password.nix
    ./alacritty.nix
    ./albert.nix
    ./budgie.nix
    ./firefox.nix
    ./git.nix
    ./gnome.nix
    ./go.nix
    ./helix.nix
    ./hyprland.nix
    ./i3.nix
    ./jamesdsp.nix
    ./julia.nix
    ./neofetch.nix
    ./openrgb.nix
    ./picom.nix
    ./polybar.nix
    ./rust.nix
    ./spotify.nix
    ./syncthing.nix
    ./tmux.nix
    ./tor.nix
    ./ulauncher.nix
    ./vim.nix
    ./vscode.nix
    ./wezterm.nix
  ];
}
