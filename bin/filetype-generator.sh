#!/usr/bin/env bash

## Credit: @B0o (Maddison Hellstrom)

set -euo pipefail

# Prints the `filetypes` table for prettypath/iconmap.lua (vim filetype -> the icon names that map to it)
# and the icon names vim gives no filetype, from the current nvim-web-devicons. The output is for review:
# paste the tables into iconmap.lua by hand. NVIM=path, DEVICONS_REPO=url (default nvim-tree's).
NVIM="${NVIM:-$(command -v nvim)}"
DEVICONS_REPO="${DEVICONS_REPO:-https://github.com/nvim-tree/nvim-web-devicons}"

# get_icon_names DIR: every icon name (file names and extensions) nvim-web-devicons defines, sorted. The
# plugin keeps its tables in several modules (lua/nvim-web-devicons/default/*) and expects vim, so it is
# cloned into DIR and asked for its icons inside a headless nvim.
function get_icon_names() {
  git clone --quiet --depth 1 "$DEVICONS_REPO" "$1/devicons"
  "$NVIM" --headless -u NONE --noplugin --cmd "set rtp+=$1/devicons" +'lua
    local names = {}
    -- string keys only: get_icons() also holds a few numbered entries, not names
    for name in pairs(require("nvim-web-devicons").get_icons()) do
      if type(name) == "string" then
        names[#names + 1] = name
      end
    end
    table.sort(names)
    vim.fn.writefile(names, "/dev/stdout")
  ' +qa
}

function main() {
  local tmp names
  tmp="$(mktemp -d)"
  # shellcheck disable=2064
  trap "rm -rf -- '$tmp'" EXIT
  [[ -x "$NVIM" ]] || { echo "filetype-generator: no nvim (set NVIM)" >&2; exit 1; }
  names="$(get_icon_names "$tmp")"
  [[ -n "$names" ]] || { echo "filetype-generator: no icon names from $DEVICONS_REPO" >&2; exit 1; }
  mkdir "$tmp/files"
  cd "$tmp/files"
  local file
  local -A filetypes=()
  local -a missing=()
  while read -r pat; do
    if [[ "$pat" =~ ^\. ]]; then
      file="$pat"
    else
      file="test.$pat"
    fi
    touch "./$file"
    local ft
    ft="$("$NVIM" -u NORC --noplugin --headless "./$file" +'lua
      local ok, err = pcall(vim.fn.writefile, { vim.bo.filetype }, "/dev/stdout")
      if not ok then
        print(err .. "\n")
        vim.cmd "cquit"
      end
      vim.cmd "quit"
    ')"
    rm "./$file"
    if [[ -n "$ft" ]]; then
      if [[ -v filetypes["$ft"] ]]; then
        filetypes["$ft"]="${filetypes["$ft"]}, '$pat'"
      else
        filetypes["$ft"]="'$pat'"
      fi
    else
      missing+=("$pat")
    fi
  done <<< "$names"

  echo "local filetypes = {"
  for ft in "${!filetypes[@]}"; do
    echo "  ['$ft'] = { ${filetypes[$ft]} },"
  done
  echo "}"
  echo
  echo "local missing = {"
  printf "  '%s',\n" "${missing[@]}"
  echo "}"
}

main "$@"
