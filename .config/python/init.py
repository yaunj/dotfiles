import atexit
import os
import sys
from pathlib import Path
from pprint import pprint

try:
    # This part might be redundant with newer Python releases (>= 3.10)
    import readline

    if readline.get_current_history_length() == 0:
        state_home = os.environ.get("XDG_STATE_HOME")
        if state_home is None:
            state_home = Path.home() / ".local" / "state"
        else:
            state_home = Path(state_home)

        history_path = state_home / "python_history"
        if history_path.is_dir():
            raise OSError(f"'{history_path}' cannot be a directory")

        histfile = str(history_path)

        readline.parse_and_bind("tab: complete")

        try:
            readline.read_history_file(histfile)
        except OSError:
            pass  # It doesn't exist yet.

        def write_history():
            try:
                readline.write_history_file(histfile)
            except OSError:
                print("Unable to save Python command history")

        atexit.register(write_history)
except ImportError:
    if sys.platform == "win32":
        print("Try installing pyreadline3")
    pass

# Pretty-print at the command prompt for more readable dicts and lists.
_builtins = __import__("builtins")


def mydisplayhook(value, show=pprint, bltin=_builtins):
    if value is not None:
        bltin._ = value
        show(value)


sys.displayhook = mydisplayhook
