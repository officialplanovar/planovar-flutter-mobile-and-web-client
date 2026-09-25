#!/usr/bin/env bash
#
# Increments the build number (the "+N" after the version name) in pubspec.yaml
# and prints the new "name+number". Called by the release build targets so every
# store upload gets a unique, monotonically increasing build number.
#
# Usage:
#   ./tool/bump_build.sh            # 1.0.0+4  ->  1.0.0+5
#   ./tool/bump_build.sh 1.2.0      # set name to 1.2.0, bump build -> 1.2.0+<n+1>
#
set -euo pipefail

PUBSPEC="$(cd "$(dirname "$0")/.." && pwd)/pubspec.yaml"

current="$(grep -E '^version:' "$PUBSPEC" | head -1 | sed -E 's/^version:[[:space:]]*//')"
name="${current%%+*}"
num="${current##*+}"
# If there was no "+N", treat the build number as 0.
[ "$num" = "$current" ] && num=0

# Optional new version name argument.
if [ "${1:-}" != "" ]; then
  name="$1"
fi

next=$((num + 1))
new="${name}+${next}"

# BSD (macOS) sed in-place.
sed -i '' -E "s/^version:.*/version: ${new}/" "$PUBSPEC"

echo "$new"
