#!/usr/bin/env python3
"""rfi-payload-server.py - serves ONE harmless PHP marker file for the RFI
demo, from Task-3/file-inclusion/, bound to the Host-Only interface only
(not 0.0.0.0, not the internet). This is a classroom marker file, not a
real payload: it only proves the server executed something it fetched.

Usage: python3 rfi-payload-server.py [port] [bind-ip]
Default port 8091, default bind 192.168.56.10 (change if your Kali IP differs).
"""
import http.server
import socketserver
import sys
import os

port = int(sys.argv[1]) if len(sys.argv) > 1 else 8091
bind_ip = sys.argv[2] if len(sys.argv) > 2 else "192.168.56.10"
directory = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "file-inclusion")

marker = os.path.join(directory, "remote-include-demo.php")
if not os.path.exists(marker):
    with open(marker, "w") as f:
        f.write("<?php echo 'RFI-DEMO-MARKER: included from lab-hosted file, not a real payload'; ?>\n")

class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *a, **kw):
        super().__init__(*a, directory=directory, **kw)

with socketserver.TCPServer((bind_ip, port), Handler) as httpd:
    print(f"Serving {directory} at http://{bind_ip}:{port}/remote-include-demo.php")
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        pass
