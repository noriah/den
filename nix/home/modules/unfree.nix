{ config, lib, ... }:
{
  options.den.unfree = lib.mkOption {
    type = with lib.types; listOf str;
    default = [ ];
    description = "A list of unfree packages that are allowed to be installed";
  };

  config.nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) config.den.unfree;
}
