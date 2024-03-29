# Add auto-completion and a stored history file of commands to your Python
# interactive interpreter. Requires Python 2.0+, readline. Autocomplete is
# bound to the Esc key by default (you can change it - see readline docs).

import atexit
import os
import readline
import rlcompleter

historyPath = os.path.expanduser(
  os.getenv("HISTORY", "~/var/history")) + "/python"
    # os.getenv("PYTHON_HISTORY",
    #           os.path.join(os.getenv("HISTORY", "~/var/history"), "python")))


def save_history(historyPath=historyPath):
  import readline
  readline.write_history_file(historyPath)

if os.path.exists(historyPath):
  readline.read_history_file(historyPath)

atexit.register(save_history)

del os, atexit, readline, rlcompleter, save_history, historyPath
