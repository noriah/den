if den::is::nixos; then
  NIXPKGS_ALLOW_UNFREE=1 nix-shell '<home-manager>' --flake "$DEN" switch
else
  echo "noop";
fi
