{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  # these still need to be updated. for now i manually symlink
  clientConfPath = "${config.xdg.configHome}/Code/User";
  serverConfPath = "${config.den.dir.home}/.vscode-server/data/Machine";
  srcPath = "${config.den.dir.self}/share/vscode";

  cfg = config.den.apps.vscode;

  vscodium-pkg = pkgs.vscodium.overrideAttrs (old: {
    name = "vscodium-ms-marketplace-overridden";
    postInstall = ''
      substituteInPlace $out/lib/vscode/resources/app/product.json \
        --replace "open-vsx.org/vscode/gallery" "marketplace.visualstudio.com/_apis/public/gallery" \
        --replace "open-vsx.org/vscode/item" "marketplace.visualstudio.com/items"
    '';

  });
in
{
  options.den.apps.vscode = {

    enable = mkEnableOption "vscode";

    client = mkOption {
      type = types.bool;
      default = false;
    };

    # clientPackage = mkPackageOption pkgs "vscode" { };

    server = mkOption {
      type = types.bool;
      default = false;
    };

  };

  config = mkIf cfg.enable (mkMerge [

    (mkIf cfg.client {
      # den.unfree = [ "vscode" ];

      # home.packages = [ cfg.clientPackage ];
      home.packages = [ vscodium-pkg ];

      systemd.user.tmpfiles.rules = [
        "L+ ${clientConfPath}/settings.json - - - - ${srcPath}/settings/client.niji.json"
        "L+ ${clientConfPath}/keybindings.json - - - - ${srcPath}/settings/keybindings.linux.json"
        "L+ ${clientConfPath}/snippets - - - - ${srcPath}/snippets"
      ];
    })

    (mkIf cfg.server {
      systemd.user.tmpfiles.rules = [
        "L+ ${serverConfPath}/settings.json - - - - ${srcPath}/settings/server.json"
      ];
    })

  ]);
}
