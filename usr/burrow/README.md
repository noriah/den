# burrow

plugin manager for den.

- [plans/](plans/) - built in plugins

```zsh
burrow COMMAND [ARGUMENTS]

  Commands
    plugin      load a plugin
    lib         load a library
    path        print the path to a plugin or library
    check       check for the existence of a plugin or library
    update      check downloaded repos for updates from upstream


  plugin NAME [REPO_URI|PATH SOURCED_FILE_PATH]

      loads a plugin into the environment

    Arguments
      NAME                   name of the plugin
      REPO_URI               uri of the repo (github/<user>/<repo>)
      SOURCED_FILE_PATH      path to file inside repo to source

    Usage
      if only name is provided, burrow checks for a file with the plugin name
        (name.zsh) in the plans directory. if found, it sources the file.
        if not found, burrow adds an entry to the plugin list
        this is useful for enabling features based on enabled plugins
      if a repo uri and file path are provided, burrow fetches the repo to a
        directory in $HOME/opt, and sources the file at the path provided.


  lib NAME REPO_URI

      downloads a repo for use by other plugins.

    Arguments
      NAME      name of the library
      REPO_URI  uri of the repo (github/<user>/<repo>)


  path NAME

      get the path to a plugin or library (if it has a repo)

    Arguments
      NAME      name of the plugin or library

    Usage
      echos out the repo directory name for the plugin or library and
        returns 0 if a repo exists
      returns 1 if the plugin/library/repo does not exist


  check NAME

      check for if a plugin or library is loaded in the enviornment

    Arguments
      NAME      name of the plugin or library

    Usage
      returns 0 if the plugin or library is loaded in the environment
        else returns 1


  update

      check repos for updates from upstream

    Usage
      runs git fetch inside all loaded plugins and libraries
```

