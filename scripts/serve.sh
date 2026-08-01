#!/bin/bash
# Description: Serve current directory on local network (usage: serve [port] [--pass <code>])
set -e

PORT="8000"
PASSCODE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --pass) PASSCODE="$2"; shift 2 ;;
    [0-9]*) PORT="$1"; shift ;;
    *) echo "Usage: odu utils serve [port] [--pass <code>]"; exit 1 ;;
  esac
done

# get local network IP
LOCAL_IP=$(ipconfig getifaddr en0 2>/dev/null || hostname -I 2>/dev/null | awk '{print $1}')

echo "Serving: $(pwd)"
echo "Local:   http://localhost:$PORT"
if [ -n "$LOCAL_IP" ]; then
  echo "Network: http://$LOCAL_IP:$PORT"
fi
if [ -n "$PASSCODE" ]; then
  echo "Passcode: $PASSCODE"
fi
echo ""
echo "Press Ctrl+C to stop."
echo ""

if [ -n "$PASSCODE" ]; then
  # spin up Python server with Basic Auth
  python3 - "$PORT" "$PASSCODE" <<'EOF'
import sys
import base64
from http.server import SimpleHTTPRequestHandler, HTTPServer

PORT = int(sys.argv[1])
PASSCODE = sys.argv[2]
EXPECTED = base64.b64encode(f"odu:{PASSCODE}".encode()).decode()

class AuthHandler(SimpleHTTPRequestHandler):
    def do_HEAD(self): self._check_auth() and super().do_HEAD()
    def do_GET(self):  self._check_auth() and super().do_GET()

    def _check_auth(self):
        auth = self.headers.get("Authorization", "")
        if auth == f"Basic {EXPECTED}":
            return True
        self.send_response(401)
        self.send_header("WWW-Authenticate", 'Basic realm="odu serve"')
        self.end_headers()
        return False

    def log_message(self, fmt, *args):
        print(f"  {self.address_string()} - {fmt % args}")

HTTPServer(("0.0.0.0", PORT), AuthHandler).serve_forever()
EOF
else
  python3 -m http.server "$PORT" --bind 0.0.0.0
fi
