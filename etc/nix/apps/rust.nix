{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.den.apps.rust;
in
{
  options.den.apps.rust = {
    enable = mkEnableOption "rust language";
  };

  config = mkIf cfg.enable {

    home.packages = [
      pkgs.rust-analyzer
    ];

    home.sessionVariables = {
      RUSTUP_HOME = "${config.den.homeOptDir}/rustup";
      CARGO_HOME = "${config.den.homeOptDir}/cargo";

    };

    programs.helix.languages = mkIf config.programs.helix.enable {
      language-server.rustls.command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
      language = [
        {
          name = "rust";
          auto-format = false;
          language-servers = [ "rustls" ];
        }
      ];
    };

  };
}
