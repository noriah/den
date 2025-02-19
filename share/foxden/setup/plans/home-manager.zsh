if den::is::nixos; then
  nix-channel --add https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz home-manager
  nix-channel --update

  den::install::ensureDir '.config'
  den::install::checkBackupHome '.config/home-manager'
  den::install::link '.config/home-manager' 'etc/nix'

  NIXPKGS_ALLOW_UNFREE=1 nix-shell '<home-manager>' -A install
else
  echo "noop";
fi
