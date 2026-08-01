#!/bin/bash
# Description: Switch Java version by list number or version string (usage: vjava <number|version>)

INPUT="$1"

if [ -z "$INPUT" ]; then
  echo "Usage: odu utils vjava <number|version>"
  echo ""
  echo "Examples:"
  echo "  odu utils vjava 2          # pick by number from lsjava"
  echo "  odu utils vjava 17         # pick by major version"
  echo "  odu utils vjava 17.0.20    # pick by exact version"
  echo ""
  echo "Run 'odu utils lsjava' to see installed versions."
  exit 1
fi

# if input is a small integer (≤ total versions), treat as list index
TOTAL=$(/usr/libexec/java_home -V 2>&1 | grep -E "^\s+[0-9]" | wc -l | tr -d ' ')

if [[ "$INPUT" =~ ^[0-9]+$ ]] && [ "$INPUT" -le "$TOTAL" ]; then
  JAVA_LINE=$(/usr/libexec/java_home -V 2>&1 | grep -E "^\s+[0-9]" | sed -n "${INPUT}p")
  JAVA_HOME=$(echo "$JAVA_LINE" | awk '{print $NF}')
  VERSION=$(echo "$JAVA_LINE" | awk '{print $1}')
  VENDOR=$(echo "$JAVA_LINE" | grep -o '"[^"]*" - "[^"]*"' | sed 's/"[^"]*" - "//' | tr -d '"')
else
  # treat as version string — pass directly to java_home -v
  JAVA_HOME=$(/usr/libexec/java_home -v "$INPUT" 2>/dev/null)
  if [ -z "$JAVA_HOME" ]; then
    echo "Error: no Java matching \"$INPUT\" found."
    echo ""
    echo "Run 'odu utils lsjava' to see installed versions."
    exit 1
  fi
  VERSION=$(/usr/libexec/java_home -V 2>&1 | grep "$JAVA_HOME" | awk '{print $1}')
  VENDOR=$(/usr/libexec/java_home -V 2>&1 | grep "$JAVA_HOME" | grep -o '"[^"]*" - "[^"]*"' | sed 's/"[^"]*" - "//' | tr -d '"')
fi

# detect shell config file
if [ "$(basename "$SHELL")" = "zsh" ]; then
  SHELL_RC="$HOME/.zshrc"
elif [ "$(basename "$SHELL")" = "bash" ]; then
  SHELL_RC="$HOME/.bashrc"
else
  SHELL_RC="$HOME/.profile"
fi

# remove existing JAVA_HOME line and add new one
if grep -q "export JAVA_HOME=" "$SHELL_RC" 2>/dev/null; then
  sed -i.bak '/export JAVA_HOME=/d' "$SHELL_RC"
fi
echo "export JAVA_HOME=\"$JAVA_HOME\"" >> "$SHELL_RC"

echo "✓ Switched to Java $VERSION ($VENDOR)"
echo "  JAVA_HOME: $JAVA_HOME"
echo ""
echo "  Apply in current shell:"
echo "  export JAVA_HOME=\"$JAVA_HOME\""
