#!/bin/bash
# Description: Kill process running on a port (usage: kport <port>)
set -e

PORT="$1"

if [ -z "$PORT" ]; then
  echo "Usage: odu utils kport <port>"
  echo "Example: odu utils kport 3000"
  exit 1
fi

PIDS=$(lsof -ti:"$PORT" 2>/dev/null)

if [ -z "$PIDS" ]; then
  echo "Nothing running on port $PORT"
  exit 0
fi

PROCESS=$(lsof -i:"$PORT" -sTCP:LISTEN | tail -n +2 | awk '{print $1, $2}' | head -1)
echo "Killing process on port $PORT ($PROCESS)..."
echo "$PIDS" | xargs kill -9
echo "✓ Done"
