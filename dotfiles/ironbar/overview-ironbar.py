#!/usr/bin/env python3
"""
Listens to niri's overview events and shows/hides ironbar accordingly.

Uses ironbar's IPC to explicitly set visibility state, avoiding race conditions
that occur with signal-based toggling.
"""
from json import loads
from os import environ
from subprocess import run
from socket import AF_UNIX, socket, SHUT_WR
import sys

BAR_NAME = "main"

def set_bar_visible(visible: bool) -> None:
    """Explicitly set ironbar visibility state."""
    run(
        ["ironbar", "bar", "set-visible", BAR_NAME, str(visible).lower()],
        check=False
    )

def main():
    try:
        niri_socket = socket(AF_UNIX)
        niri_socket.connect(environ["NIRI_SOCKET"])
        file = niri_socket.makefile("rw")
        file.write('"EventStream"')
        file.flush()
        niri_socket.shutdown(SHUT_WR)

        for line in file:
            event = loads(line)
            overview_state = event.get("OverviewOpenedOrClosed")
            if overview_state is not None:
                # overview_state is True when overview opens, False when it closes
                # Show bar when overview is open, hide when closed
                set_bar_visible(overview_state)

    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    main()
