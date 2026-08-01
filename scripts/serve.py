#!/usr/bin/env python3
# Description: Serve current directory on local network with a random 4-digit PIN

import sys
import os
import base64
import random
import socket
from http.server import SimpleHTTPRequestHandler, HTTPServer
from socketserver import ThreadingMixIn

def get_local_ip():
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(("8.8.8.8", 80))
        ip = s.getsockname()[0]
        s.close()
        return ip
    except Exception:
        return "localhost"

PORT = int(sys.argv[1]) if len(sys.argv) > 1 else 8000
PIN = str(random.randint(1000, 9999))
LOCAL_IP = get_local_ip()

class ThreadedHTTPServer(ThreadingMixIn, HTTPServer):
    daemon_threads = True

class AuthHandler(SimpleHTTPRequestHandler):
    def _authorized(self):
        auth = self.headers.get("Authorization", "")
        if not auth.startswith("Basic "):
            return False
        try:
            decoded = base64.b64decode(auth[6:]).decode()
            _, _, password = decoded.partition(":")
            return password == PIN
        except Exception:
            return False

    def _reject(self):
        self.send_response(401)
        self.send_header("WWW-Authenticate", 'Basic realm="Enter PIN"')
        self.send_header("Content-Length", "0")
        self.end_headers()

    def do_HEAD(self):
        if self._authorized(): super().do_HEAD()
        else: self._reject()

    def do_GET(self):
        if self._authorized(): super().do_GET()
        else: self._reject()

    def log_message(self, fmt, *args):
        print(f"  {self.address_string()} → {fmt % args}")

print(f"Serving: {os.getcwd()}")
print(f"Local:   http://localhost:{PORT}")
print(f"Network: http://{LOCAL_IP}:{PORT}")
print(f"")
print(f"  PIN: {PIN}")
print(f"")
print(f"Press Ctrl+C to stop.")
print(f"")

try:
    ThreadedHTTPServer(("0.0.0.0", PORT), AuthHandler).serve_forever()
except KeyboardInterrupt:
    print("\nStopped.")
