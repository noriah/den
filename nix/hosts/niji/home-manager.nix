{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:

{
  imports = [ inputs.home-manager + "/nixos"  ];

  config = {
    home-manager.users.vix =
      { ... }:
      {
        home.stateVersion = "24.11";
      };
  };
}
