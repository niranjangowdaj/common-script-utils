#!/bin/bash
# Description: List all installed Java versions on macOS
set -e

if ! command -v java &>/dev/null && [ ! -f /usr/libexec/java_home ]; then
  echo "No Java installation found."
  exit 1
fi

echo "Installed Java versions:"
echo ""

/usr/libexec/java_home -V 2>&1 | grep -E "^\s+[0-9]" | while read -r line; do
  echo "  $line"
done

echo ""
CURRENT=$(/usr/libexec/java_home 2>/dev/null || echo "none")
CURRENT_VERSION=$(java -version 2>&1 | head -1 | awk -F '"' '{print $2}')
echo "Current: $CURRENT_VERSION ($CURRENT)"
