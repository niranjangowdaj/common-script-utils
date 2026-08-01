#!/bin/bash
# Description: Switch Java version on macOS (usage: vjava <version>)

VERSION="$1"

if [ -z "$VERSION" ]; then
  echo "Usage: odu utils vjava <version>"
  echo "Example: odu utils vjava 17"
  echo ""
  echo "Run 'odu utils lsjava' to see installed versions."
  exit 1
fi

JAVA_HOME=$(/usr/libexec/java_home -v "$VERSION" 2>/dev/null)

if [ -z "$JAVA_HOME" ]; then
  echo "Java $VERSION not found."
  echo ""
  echo "Installed versions:"
  /usr/libexec/java_home -V 2>&1 | grep -E "^\s+[0-9]" | while read -r line; do
    echo "  $line"
  done
  exit 1
fi

# detect shell config file
if [ -n "$ZSH_VERSION" ] || [ "$(basename "$SHELL")" = "zsh" ]; then
  SHELL_RC="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ] || [ "$(basename "$SHELL")" = "bash" ]; then
  SHELL_RC="$HOME/.bashrc"
else
  SHELL_RC="$HOME/.profile"
fi

# remove existing JAVA_HOME export and add new one
if grep -q "export JAVA_HOME=" "$SHELL_RC" 2>/dev/null; then
  sed -i.bak '/export JAVA_HOME=/d' "$SHELL_RC"
fi

echo "export JAVA_HOME=\"$JAVA_HOME\"" >> "$SHELL_RC"

echo "✓ Java $VERSION selected"
echo "  JAVA_HOME: $JAVA_HOME"
echo ""
echo "  Run this to apply in your current shell:"
echo "  export JAVA_HOME=\"$JAVA_HOME\""
echo ""
echo "  Or open a new terminal — it will load automatically."
