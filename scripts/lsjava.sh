#!/bin/bash
# Description: List all installed Java versions on macOS
set -e

if [ ! -f /usr/libexec/java_home ]; then
  echo "No Java installation found."
  exit 1
fi

CURRENT=$(/usr/libexec/java_home 2>/dev/null)

echo "Installed Java versions:"
echo ""

INDEX=1
/usr/libexec/java_home -V 2>&1 | grep -E "^\s+[0-9]" | while IFS= read -r line; do
  VERSION=$(echo "$line" | awk '{print $1}')
  VENDOR=$(echo "$line" | grep -o '"[^"]*" - "[^"]*"' | sed 's/"[^"]*" - "//' | tr -d '"')
  PATH_HOME=$(echo "$line" | awk '{print $NF}')

  MARKER=""
  if [ "$PATH_HOME" = "$CURRENT" ]; then
    MARKER=" ◀ current"
  fi

  printf "  [%d] %-12s  %s%s\n" "$INDEX" "$VERSION" "$VENDOR" "$MARKER"
  INDEX=$((INDEX + 1))
done

echo ""
echo "Switch with: odu utils vjava <number>"
echo "Example:     odu utils vjava 2"
