#!/usr/bin/env python3
from json import loads
from os import environ
from signal import SIGUSR1
from subprocess import Popen, DEVNULL, run
from socket import AF_UNIX, socket, SHUT_WR
import sys

def main():
    waybar_proc = None
    try:
        niri_socket = socket(AF_UNIX)
        niri_socket.connect(environ["NIRI_SOCKET"])
        file = niri_socket.makefile("rw")
        file.write('"EventStream"')
        file.flush()
        niri_socket.shutdown(SHUT_WR)

        # Start waybar (it will start hidden due to config)
        waybar_proc = Popen(
            ["waybar", "--config", f"{environ['HOME']}/.config/waybar/config", "--style", f"{environ['HOME']}/.config/waybar/style.css"],
            stdout=DEVNULL,
            stderr=DEVNULL
        )

        for line in file:
            event = loads(line)
            if event.get("OverviewOpenedOrClosed"):
                # Toggle waybar visibility using SIGUSR1
                run(["pkill", "-SIGUSR1", "waybar"], check=False)
                
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        if waybar_proc:
            waybar_proc.terminate()
        sys.exit(1)

if __name__ == "__main__":
    main()