#!/bin/bash
# Description: List all processes listening on ports
set -e

echo "PORT      PID     PROCESS"
echo "--------  ------  -------"

lsof -iTCP -sTCP:LISTEN -n -P | tail -n +2 | awk '{
  split($9, a, ":")
  port = a[length(a)]
  printf "%-8s  %-6s  %s\n", port, $2, $1
}' | sort -n
