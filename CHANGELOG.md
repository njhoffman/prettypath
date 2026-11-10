# Changelog

All notable changes to prettypath are recorded here, in the [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
format. Versions before semantic versioning were published only as luarocks dev rockspecs (dev-2 to dev-4)
and were never tagged; their history is summarized at the end of 0.1.0.

## [Unreleased]

## [0.3.0] - 2026-11-10

### Added
- `make install` installs with luarocks and then replaces the luarocks wrapper with a launcher
  (scripts/install-launcher.sh) that runs prettypath under luajit when it is installed (about twice as fast
  per path) and lua5.1 otherwise, with the module paths set directly instead of through luarocks.loader, so
  it also starts sooner. `PRETTYPATH_LUA=interpreter` picks the interpreter; `LUAROCKS="luarocks"` installs
  into the system tree. A plain `luarocks make` still works and keeps the wrapper.

## [0.2.1] - 2026-11-10

### Added
- `make bench` reports startup and µs per path in CPU time (stat auto, true and false, and a metadata format) over
  a fixed generated list of 20k files, directories and missing paths; `LUA=luajit`, `PATHS` and `RUNS`
  adjust it. It replaces the Makefile's leftover bench and prof targets.

## [0.2.0] - 2026-11-10

### Added
- `--base=DIR` shows directories under DIR relative to it in `%dir%` (`~` and trailing slashes allowed);
  `%path%` is unchanged.
- `--dirs` treats every path as a directory, for lists that do not end directories with `/` (zoxide).
- `--field=N` decorates one field of each line and passes the others through; `-1` is the last field, and a
  line without field N is printed unchanged. `--delimiter=D` sets the separator (default tab; `\t` works
  as typed). Library callers get the same through `pretty_line`.
- `--color=always|never|auto` and `NO_COLOR`: `never` drops the color escapes but keeps the icons, `auto`
  colors only when stdout is a terminal. The default stays `always` (prettypath usually feeds fzf through a
  pipe), or `never` when `NO_COLOR` is set; an explicit `--color` wins.
- `prettypath completion bash|zsh|fish` prints a completion script for options, their values and directories
  for `--base`; `--help` says how to install each.
- Flags can be given bare: `--dirs` is `--dirs=true`.

### Changed
- An invalid `--color`, `--field` or `--delimiter` fails up front with exit status 2, like an unknown format
  token.

### Fixed
- `%size%`, `%mod%`, `%access%`, `%create%` and their `_ago` forms print `-` for a missing file or with
  `--stat_file=false`. Before, `%size%` left the whole line unformatted, `%mod%` printed the current time
  and `%mod_ago%` printed "57y ago".

## [0.1.0] - 2026-11-10

First semantic version; `--version` now prints `prettypath 0.1.0`.

### Changed
- `--stat_file` takes `auto`, the new default: files are statted only when the format has a metadata token
  (`%size%`, `%access%`, `%mod%`, `%create%` and their `_ago` forms). Formats without one run about three
  times faster and no longer dim missing files; pass `--stat_file=true` to keep the old behavior.
- `--output_stats` is the only thing that collects the unassigned and missing path lists; without it a long
  run no longer keeps every such path in memory.
- `require("prettypath")` from other Lua code no longer reads the host program's `arg` as prettypath
  options; the CLI applies its arguments with `opts.apply_args(arg)`.

### Fixed
- `pretty_dir` and `pretty_file` return the formatted string instead of nothing.
- The CLI loads one copy of each module, found next to the script, so it also runs from any directory.
- The rockspec installs `prettypath.override_materialicons` and `prettypath.override_webicons`.

### Fixed (earlier, unreleased dev versions)
- A `%` in a file name or path is kept in the output instead of being dropped.
- Paths directly under `/`, relative paths, `./` paths and paths with a trailing `/` (marked as directories)
  are formatted instead of rejected.
- `$HOME` is replaced by `~` only as a literal prefix of the directory.
- `--stat_file=false` and `--output_stats=false` now turn the options off (any string used to count as true).
- Only `%token%` is read as a token; other text in `--format`, `%` included, is printed as is.
- An unknown format token fails once at startup with exit status 2, instead of on every line.
- A line that fails to format is printed unchanged, with one warning on stderr, so output keeps one line per
  input line; a closed pipe ends the run quietly.

### Changed
- Formats are compiled once and color escapes cached, cutting the per-path cost.

### Added (dev-4)
- `-h/--help` and `-v/--version`.
- busted test suite, luacheck, stylua, luacov and editorconfig setup.

### Added (dev-3 and earlier)
- CLI that reads paths from stdin and prints them with devicons and truecolor ANSI colors.
- `--format` tokens for path, icon, dir, name, score, size and access/modify/create times (absolute and
  relative), and `--output_stats` with counts of missing and unassigned paths and timing.
- Icon overrides in prettypath/override.lua.
