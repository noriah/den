# fox den

contains helper functions and scripts used by the rest of [den](https://github.com/noriah/den).

### [rc.zsh](rc.zsh) - environment loader
---
- loads several scripts that configure the base enviornment
- configures and runs compinit

### [install.zsh](install.zsh) - enviornment installation script.
---
- creates `$HOME/opt/` directory
- creates `$DEN/var/` directory
- adds symlinks from the home directory to [`$DEN/etc`](/etc), [`$DEN/usr`](/usr) and `$DEN/var`
- sources [`$DEN/etc/zsh/zshrc`](/etc/zsh/zshrc) and [`$DEN/etc/zsh/zshenv`](/etc/zsh/zshenv) from `$HOME/zsh{rc,env}`
- runs scripts in [`$DEN/usr/foxden/setup/plans`](setup/plans/)

In the future the script will take care of downloading the den repo, and moving it to the `$HOME/opt/` directory, making it a one command install.
