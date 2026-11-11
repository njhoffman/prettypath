#!/usr/bin/env zsh
# spec/support/zsh-complete.zsh FPATH_DIR OUT LINE: the completion candidates zsh offers for LINE (as typed,
# then Tab), one per line in OUT, using the _prettypath found in FPATH_DIR. Runs an interactive zsh -f in a
# zpty with compadd replaced by one that records the matches instead of adding them. Exit 3: no zsh/zpty;
# exit 4: the shell did not answer (10s).
zmodload zsh/zpty 2> /dev/null || exit 3
dir=$1 out=$2 line=$3
: > "$out"

zpty z zsh -f -i
zpty -w z "PS1=''; RPS1=''; unsetopt zle_bracketed_paste 2> /dev/null"
zpty -w z "fpath=(${(q)dir} \$fpath); autoload -Uz compinit; compinit -u -D"
zpty -w z "compadd() { local -a __m; builtin compadd -O __m \"\$@\"; ((\$#__m)) && print -rl -- \$__m >> ${(q)out}; }"
zpty -w z "bindkey '^I' complete-word"
# wait until the setup has run: input typed while compinit runs is dropped
zpty -w z "print -r -- __ready__ >> ${(q)out}"
wait_for() {
  local _
  for _ in {1..200}; do
    grep -q "^$1\$" "$out" 2> /dev/null && return 0
    sleep 0.05
  done
  return 1
}
wait_for __ready__ || { zpty -d z; exit 4; }
# then ^U (kill-whole-line: plain input, so zle handles it after the Tab, unlike ^C, a signal that can cut the
# completion short) and a marker command: once the marker is written, completion has finished
zpty -w -n z "$line"$'\t'
zpty -w z $'\x15'"print -r -- __done__ >> ${(q)out}"

wait_for __done__ || { zpty -d z; exit 4; }
zpty -d z
grep -v -e '^__done__$' -e '^__ready__$' "$out" | sort -u > "$out.tmp" && mv -f -- "$out.tmp" "$out"
