# Changelog

All notable changes to prettypath are recorded here, in the [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
format. Versions before semantic versioning were published only as luarocks dev rockspecs (dev-2 to dev-4)
and were never tagged; their history is summarized at the end of 0.1.0.

## [Unreleased]

## [0.6.0] - 2026-11-10

### Added
- Icons for common types that had none, found by `--output_stats` over a 280k-file listing: object files and
  libraries (`.o`, `.a`, `.so`), automake and make files (`.am`, `.in`, `.Po`, `.make`, `.mk`), build output
  (`.out`, `.timestamp`), config formats (`.properties`, `.config`, `.rasi`, `.reg`), translations (`.po`),
  Sublime/TextMate snippets, binary data (`.msgpack`, `.parquet`, `.rmeta`), `.gitkeep`, `.cheat`, `.bats`,
  and a palette icon for color schemes (`.itermcolors`, `.colors`, `.colorscheme`, `.termcolors`, `.xrdb`,
  `.theme`). Each reuses the icon of a type of the same kind.

### Fixed
- The hand-picked icons in override.lua (mp3, wav, zip, tar) are used again; generated entries for the same
  keys had replaced them.
- zsh completion offers the other options after `-0` (it treated `-0` like `--help`, which ends the command).
- `make test` works in a plain shell: the test targets load the luarocks paths themselves.

## [0.5.0] - 2026-11-10

### Added
- `-0` / `--null` reads and writes NUL-separated records (`fd -0`, `find -print0`, `fzf --read0`), for names
  with newlines. A last record without a NUL counts.
- When a file is statted anyway (`--stat_file=true`, or a size or date token), a directory gets the folder
  icon and directory colors without a trailing `/`; a symlink to a directory counts as one.
- `--color=256` prints xterm-256 escapes for terminals without truecolor: each icon's curated 256-color
  value, and the nearest match for other colors. The default stays truecolor.
- `--help` documents the `--version` output (`prettypath X.Y.Z`, semantic versioning since 0.1.0) as what
  callers compare to check for a feature.

### Fixed
- With a stat, an explicit type (`--dirs`, `pretty_file`) is no longer replaced by the file's stat type.
- `--line-buffered` flushes after every record, which also covers NUL-ended ones.

### Removed
- The unused `force_256` option in opts.lua (`--color=256` replaces it).

## [0.4.0] - 2026-11-10

### Added
- `--line-buffered` sends each line as soon as it is made, so fzf on a slow source shows rows as they come.
- Option names take `-` and `_` alike (`--stat-file`, `--output-stats`).

### Changed
- An unknown option (`--colr=never`, `-x`), a stray argument (`prettypath *.lua`; paths come on stdin), a bare
  option that needs a value (`--format`) and a boolean that is not one (`--dirs=x`) now fail with exit status 2
  and a message, instead of being ignored or read as false.
- `--output_stats` writes its report to stderr, so `prettypath --output_stats | fzf` gets only the paths, and
  times the run in microseconds instead of whole seconds.
- `color_name` in opts.lua is a plain boolean like `color_icon`: true (the default, same output as before)
  colors the name, false prints it plain. The unimplemented 0-100 scale is gone.

### Fixed
- `--output_stats` on empty input prints `-` for the percentage and average instead of `nan`.
- A missing file's name gets the missing color whenever names are colored.

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
