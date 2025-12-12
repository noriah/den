{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.den.development.rust;
in
{
  options.den.development.rust.enable = mkEnableOption "rust language";

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      cargo
      # rustup
      rust-analyzer
    ];

    home.sessionVariables = {
      RUSTUP_HOME = "${config.den.dir.opt}/rustup";
      CARGO_HOME = "${config.den.dir.opt}/cargo";
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
