# zsh rc/env

zsh environment scripts

### [zshenv](zshenv) - zsh environment script
---

loaded by zsh for all shells

- defines several common paths
- defines the cache directories
- defines some language paths
- adds language paths to the `PATH` environment variable

### [zshrc](zshrc) - zsh interactive script
---

loaded by zsh interactive/login shells

- creates the zsh cache directory if it does not exist
- sources [fox den](/share/foxden/) - the environment loader
- sources `$HOME/.zaliases` if it exists
- sources the [home configuration](/etc/den/home.zsh)
