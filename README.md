# noriah's den

*a fox den is a fox home*

hi! if you are reading this, you have found noriah's den.
a perpetual work in progress.

## structure

- [bin/](bin/) - shell scripts (and possibly binaries)
- [etc/](etc/) - this is where configuration files are
- [share/](share/) - contains things for the environment
- [nix/](nix/) - nixos and home-manager configuration
- [src/](src/) - sources for den-focused tools

## items of interest

- [legacy install script](share/foxden/install.zsh)
- [etc/zsh/](etc/zsh/) - zsh entry points
- [etc/den/](etc/den/) - environment base configurations
- [share/foxden/](share/foxden/) - base scripts for the environment
- [share/burrow/](share/burrow/) - plugin manager for den
- [nix flake](flake.nix) - nix flake configuration

*i have found nix/nixos adds too much friction for development systems.*
*i now use it only for home-manager on most of my systems.*
*updates to reflect this are coming*
