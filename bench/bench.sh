#!/usr/bin/env bash
# bench/bench.sh: startup CPU time and CPU µs per path for bin/prettypath.lua over a fixed, generated list.
# LUA=interpreter (default lua), PATHS=list size (default 20000), RUNS=best of N (default 5).
# The list mixes existing files (varied extensions and names), directories (trailing /) and missing paths,
# in a temporary tree, so runs are comparable across machines and changes.
set -euo pipefail

LUA="${LUA:-lua}"
PATHS="${PATHS:-20000}"
RUNS="${RUNS:-5}"
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# the modules' dependencies (luv, lua-filesize) from the user's luarocks tree when not already on the path
if ! "$LUA" -e 'require("luv")' 2> /dev/null; then
  eval "$(luarocks --local path 2> /dev/null)" || :
  export LUA_PATH LUA_CPATH
  "$LUA" -e 'require("luv")' || { echo "bench: $LUA cannot load luv" >&2; exit 1; }
fi

tmp="$(mktemp -d)"
trap 'rm -rf -- "$tmp"' EXIT

# 1000 files over 50 directories, ~60% of the list; the rest directories and missing paths
exts=(lua py js ts go rs c h md json yaml toml sh txt png svg html css "" lock)
names=(Makefile Dockerfile README.md .gitignore package.json Cargo.toml)
for d in $(seq 1 50); do
  mkdir -p "$tmp/tree/d$d"
done
for i in $(seq 1 1000); do
  d=$((i % 50 + 1))
  if ((i % 25 == 0)); then
    f="${names[$((i / 25 % ${#names[@]}))]}"
  else
    e="${exts[$((i % ${#exts[@]}))]}"
    f="file$i${e:+.$e}"
  fi
  : > "$tmp/tree/d$d/$f"
done
mapfile -t files < <(find "$tmp/tree" -type f | sort)
{
  for ((i = 0; i < PATHS; i++)); do
    case $((i % 10)) in
      0 | 1 | 2 | 3 | 4 | 5) printf '%s\n' "${files[$((i % ${#files[@]}))]}" ;;
      6 | 7) printf '%s/tree/d%d/\n' "$tmp" $((i % 50 + 1)) ;;
      *) printf '%s/missing/m%d.lua\n' "$tmp" "$i" ;;
    esac
  done
} > "$tmp/paths.txt"

# best CPU time (user + sys) in µs of RUNS runs of: prettypath ARGS < INPUT. CPU time, not wall time:
# other load on the machine (a test suite, a build) stretches wall time several-fold but CPU time little.
best_us() {
  local input="$1" best="" t us TIMEFORMAT='%3U %3S'
  shift
  for ((r = 0; r < RUNS; r++)); do
    t=$({ time "$LUA" "$root/bin/prettypath.lua" "$@" < "$input" > /dev/null; } 2>&1)
    us=$(echo "(${t% *} + ${t#* }) * 1000000 / 1" | bc)
    [[ -z "$best" || $us -lt $best ]] && best=$us
  done
  echo "$best"
}

: > "$tmp/empty.txt"
startup_us=$(best_us "$tmp/empty.txt")
printf '%s (%s), %d paths, CPU time, best of %d, load %s\n' "$("$LUA" -v 2>&1 | head -1)" "$LUA" "$PATHS" "$RUNS" \
  "$(cut -d' ' -f1 /proc/loadavg 2> /dev/null || echo '?')"
printf '  %-28s %8.1f ms\n' "startup" "$(echo "$startup_us / 1000" | bc -l)"
report() {
  local label="$1" us
  shift
  us=$(best_us "$tmp/paths.txt" "$@")
  printf '  %-28s %8.1f ms  %6.1f µs/path\n' "$label" "$(echo "$us / 1000" | bc -l)" \
    "$(echo "($us - $startup_us) / $PATHS" | bc -l)"
}
report "default format, stat auto"
report "default format, stat true" --stat_file=true
report "default format, stat false" --stat_file=false
report "%size% %mod_ago% (stats)" --format='%size% %mod_ago% %icon% %dir%%name%'
