{
  lib,
  pkgs,
  config,
  ...
}:

{
  imports = [ <home-manager/nixos> ];

  config = {
    home-manager.users.vix =
      { ... }:
      {
        home.stateVersion = "24.11";
      };
  };
}
