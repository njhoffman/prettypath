# Changelog

All notable changes to prettypath are recorded here, in the [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
format. Versions before semantic versioning were published only as luarocks dev rockspecs (dev-2 to dev-4)
and were never tagged; their history is summarized under Unreleased.

## [Unreleased]

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
