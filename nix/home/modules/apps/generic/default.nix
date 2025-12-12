# generic application definitions
{ ... }:
{
  imports = [
    # ./dictionary.nix
    ./ebook-reader.nix
    ./irc-client.nix
    ./microblogger.nix
    # ./password-manager.nix
    ./pdf-reader.nix
    ./screenshot.nix
    ./terminal.nix
    # ./web-browser.nix
  ];
}
