#!/usr/bin/env python3
# Description: Serve current directory on local network with a random passcode

import sys
import os
import base64
import random
import string
import socket
from http.server import SimpleHTTPRequestHandler, HTTPServer

def get_local_ip():
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(("8.8.8.8", 80))
        ip = s.getsockname()[0]
        s.close()
        return ip
    except Exception:
        return "localhost"

def gen_passcode(length=8):
    return "".join(random.choices(string.ascii_letters + string.digits, k=length))

PORT = int(sys.argv[1]) if len(sys.argv) > 1 else 8000
PASSCODE = gen_passcode()
EXPECTED = base64.b64encode(f"odu:{PASSCODE}".encode()).decode()
LOCAL_IP = get_local_ip()

class AuthHandler(SimpleHTTPRequestHandler):
    def _authorized(self):
        return self.headers.get("Authorization", "") == f"Basic {EXPECTED}"

    def _reject(self):
        self.send_response(401)
        self.send_header("WWW-Authenticate", 'Basic realm="odu serve"')
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
print(f"  Passcode: {PASSCODE}")
print(f"")
print(f"Press Ctrl+C to stop.")
print(f"")

try:
    HTTPServer(("0.0.0.0", PORT), AuthHandler).serve_forever()
except KeyboardInterrupt:
    print("\nStopped.")
