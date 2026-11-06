#!/usr/bin/env python3
"""csrf-poc-server.py - serves Task-3/csrf/ over HTTP on 127.0.0.1 so a CSRF
proof-of-concept page can be loaded like a real (lab-only) attacker page
instead of opened as file://. Binds to loopback only.

Usage: python3 csrf-poc-server.py [port]   (default 8090)
"""
import http.server
import socketserver
import sys
import os

port = int(sys.argv[1]) if len(sys.argv) > 1 else 8090
directory = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "csrf")

class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *a, **kw):
        super().__init__(*a, directory=directory, **kw)

with socketserver.TCPServer(("127.0.0.1", port), Handler) as httpd:
    print(f"Serving {directory} at http://127.0.0.1:{port}/  (Ctrl+C to stop)")
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        pass
