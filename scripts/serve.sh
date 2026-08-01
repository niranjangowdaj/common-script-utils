#!/bin/bash
# Description: Start a local HTTP server in the current directory (usage: serve [port])
set -e

PORT="${1:-8000}"

echo "Serving current directory on http://localhost:$PORT"
echo "Press Ctrl+C to stop."
echo ""

if command -v python3 &>/dev/null; then
  python3 -m http.server "$PORT"
elif command -v python &>/dev/null; then
  python -m SimpleHTTPServer "$PORT"
else
  echo "Error: python3 is required but not installed"
  exit 1
fi
