from __future__ import annotations

import argparse
import os
import secrets
import socket

READY_PREFIX = "__BIODOE_JUPYTER_READY__"


def find_free_port(ip: str) -> int:
    """Ask the OS for an unused TCP port."""
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
        sock.bind((ip, 0))
        return int(sock.getsockname()[1])


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--ip",
        default="127.0.0.1",
        help="IP address JupyterLab listens on.",
    )
    parser.add_argument(
        "--port",
        type=int,
        default=0,
        help="Remote port. 0 selects an available port automatically.",
    )
    args = parser.parse_args()

    host = socket.gethostname().split(".")[0]
    port = args.port or find_free_port(args.ip)
    token = secrets.token_urlsafe(32)

    env = os.environ.copy()
    env["JUPYTER_TOKEN"] = token

    print(
        f"{READY_PREFIX} host={host} port={port} token={token}",
        flush=True,
    )

    command = [
        "jupyter",
        "lab",
        "--no-browser",
        f"--ip={args.ip}",
        f"--port={port}",
        "--ServerApp.port_retries=0",
    ]

    os.execvpe(command[0], command, env)


if __name__ == "__main__":
    main()
