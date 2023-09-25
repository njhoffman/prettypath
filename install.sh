#!/bin/bash

luarocks make prettypath-dev-2.rockspec
asdf reshim

cat files.txt | ./bin/prettypath.lua --format='%path% %icon% %dir%%name%'
fd --hidden --one-file-system --follow --no-ignore-vcs --color=never --full-path . | ./bin/prettypath.lua --output_stats=true
fd --hidden --one-file-system --follow --no-ignore-vcs --color=never --full-path . "$HOME" | ./bin/prettypath.lua --output_stats=true
