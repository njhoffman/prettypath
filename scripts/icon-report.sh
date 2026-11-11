#!/usr/bin/env bash
# scripts/icon-report.sh DIR...: icon coverage for every file under DIRs (.git and node_modules skipped)
# and the TOP (default 40) most common extensions and names without an icon, by count; the list
# override.lua's aliases were chosen from. Uses this checkout's bin/prettypath.lua (LUA=, default lua).
set -euo pipefail

LUA="${LUA:-lua}"
TOP="${TOP:-40}"
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
(($#)) || set -- .

tmp="$(mktemp -d)"
trap 'rm -rf -- "$tmp"' EXIT

find "$@" \( -name .git -o -name node_modules \) -prune -o -type f -print0 2> /dev/null > "$tmp/files"
"$LUA" "$root/bin/prettypath.lua" -0 --output_stats --stat_file=false --format=%name% \
  < "$tmp/files" > /dev/null 2> "$tmp/stats"

grep -E '^(Total|Unassigned|Percentage):' "$tmp/stats"
echo
echo "Most common without an icon (extension, or the whole name when it has none):"
# the unassigned paths come between the "------" line and the counts
sed -n '/^------$/,/^Missing:/p' "$tmp/stats" | grep '^/\|^\.' |
  awk -F/ '{ n = $NF; if (n ~ /^[^.].*\./) { sub(/.*\./, "", n); n = "." n } print n }' |
  sort | uniq -c | sort -rn | awk -v top="$TOP" 'NR <= top'  # not head: it closes the pipe (SIGPIPE under pipefail)
