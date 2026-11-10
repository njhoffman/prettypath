#!/usr/bin/env bash
# scripts/install-launcher.sh OUT LUA_DIR LIB_DIR SCRIPT FALLBACK_LUA
# Write the prettypath launcher to OUT (make install puts it over the luarocks wrapper). The launcher runs
# SCRIPT under luajit when it is installed (about 2x faster per path), else FALLBACK_LUA, with LUA_DIR and
# LIB_DIR (the luarocks tree's modules) put first on the module paths. It skips the luarocks wrapper's
# luarocks.loader, which costs more than the rest of startup. PRETTYPATH_LUA=interpreter overrides the
# choice at run time.
set -euo pipefail

if (($# != 5)); then
  echo "usage: $0 OUT LUA_DIR LIB_DIR SCRIPT FALLBACK_LUA" >&2
  exit 2
fi
out="$1" lua_dir="$2" lib_dir="$3" script="$4" fallback="$5"

[[ -f "$script" ]] || { echo "install-launcher: no script at $script" >&2; exit 1; }

# single-quote a value for sh
q() {
  printf "'%s'" "$(printf '%s' "$1" | sed "s/'/'\\\\''/g")"
}

tmp="$(mktemp "${out}.XXXXXX")"
cat > "$tmp" << EOF
#!/bin/sh
# prettypath launcher, written by \`make install\` (scripts/install-launcher.sh); run it again after moving
# the luarocks tree. luajit when installed, else the interpreter luarocks uses; PRETTYPATH_LUA overrides.
lua_dir=$(q "$lua_dir")
lib_dir=$(q "$lib_dir")
script=$(q "$script")
if [ -n "\${PRETTYPATH_LUA:-}" ]; then
  lua=\$PRETTYPATH_LUA
elif command -v luajit > /dev/null 2>&1; then
  lua=luajit
else
  lua=$(q "$fallback")
fi
# ";;" (an unset path) stands for the interpreter's default path
LUA_PATH="\$lua_dir/?.lua;\$lua_dir/?/init.lua;\${LUA_PATH:-;}" \\
  LUA_CPATH="\$lib_dir/?.so;\${LUA_CPATH:-;}" \\
  exec "\$lua" "\$script" "\$@"
EOF
chmod 755 "$tmp"
mv -f -- "$tmp" "$out"
