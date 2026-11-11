# prettypath

Open work, in the TODO.md format `todo-status` reads: `(p1)` urgent, `(p2)` normal (the default), `(p3)` low;
one category per item.

Measured 2026-10-26 (lua 5.1 through the luarocks wrapper): 28ms to start, 13-30µs per path with
`--stat_file=false` (15k paths in 0.45s on a busy machine; 20k in 0.26s in an earlier quiet run) and about 100µs with stat on (1.5s). fzx runs it over every file
and directory list (`fzx -m files`, `dirs`, `recent`), so the per-path cost sets how fast big lists appear.
`make bench` (bench/bench.sh; `LUA=luajit` to compare) reports startup and µs per path, in CPU time, on a
fixed generated list; its header shows the load average, since even CPU time varies 2x on a busy machine.
Under luajit all modules load in about 4 ms (iconmap and override about 2 of it; the override_*icons sets are
never loaded) and luv adds nothing measurable, so lazy loading the icon tables was dropped (2026-11-10).

Reviewed: 2026-11-10

## 1. Speed

- [x] **Stat only when the format needs it** (p1) [perf]: `--stat_file` defaults to true and triples the
      per-path cost, but only `%size%`, `%mod%`, `%access%`, `%create%` and their `_ago` forms read the stat.
      Default to "auto": stat when the compiled format holds one of those tokens. Callers then stop passing
      `--stat_file=false` (fzx does on every call).
- [x] **No bookkeeping unless --output_stats** (p2) [perf]: `pretty_path` appends every path without an
      icon to `stats.unassigned` and every missing one to `stats.missing`, for the whole run. A 100k-path
      home directory listing keeps them all in memory to report nothing. Collect only with --output_stats.
- [x] **LuaJIT** (p2) [perf]: run under luajit when it is installed (the code is 5.1-compatible).
      Checked 2026-11-10 (LuaJIT 2.1, apt): the existing 5.1 luarocks tree (luv 1.51, lua-filesize) loads
      unchanged, and all specs pass under `busted --lua=luajit`. `make bench` CPU time on a loaded machine:
      default format 3.0 vs 6.3-14.6 µs/path, metadata format 11.9 vs 22.6-41.5, stat true 14.4 vs 15.9-32;
      about 2x where formatting dominates, little where stat does. Left: the installed binary is the
      luarocks wrapper, which hardcodes /usr/bin/lua5.1. Done: `make install` writes a launcher
      (scripts/install-launcher.sh) that runs luajit when installed.
- [x] **Start faster** (p3) [perf]: the luarocks wrapper loads `luarocks.loader` before the script; calling
      lua5.1 directly with the same package paths started 20-55ms sooner in three (noisy) runs. Done: the
      `make install` launcher sets the module paths itself and skips luarocks.loader.
- [x] **Benchmark target** (p3) [test]: `make bench` over a fixed list (say 20k paths with mixed
      extensions, directories and missing files), reporting startup and µs per path with stat on and off, so
      changes show their cost.
- [x] **Flush policy** (p3) [perf]: output is block-buffered, which is right for throughput; a
      `--line-buffered` flag for interactive consumers that want the first rows at once (fzf shows the first
      screen sooner on a slow source).

## 2. Interface for callers

- [x] **--base DIR** (p2) [feature]: drop a directory prefix from `%dir%` (shown relative to the base, as
      `fd` and `rg` print). fzx strips `~/base/` from every display line with awk after prettypath.
- [x] **--dirs** (p2) [feature]: treat every input path as a directory (folder icon, directory colors),
      for lists that do not end directories with "/" (zoxide, fasd, z.lua). fzx appends the slash with sed
      first today.
- [x] **Decorate one field of tabbed input** (p2) [feature]: `--field N` (with `--delimiter`, default tab)
      formats that field and passes the other fields through, so "score<TAB>path" or "id<TAB>path<TAB>extra"
      lines keep their columns. fzx's dirs and recent modules pipe the paths through prettypath separately
      and join the results back by path with awk.
- [x] **NO_COLOR and --color** (p2) [feature]: honor NO_COLOR and take `--color=always|never|auto` (auto:
      color when stdout is a terminal); `force_256` in opts.lua is unused, so 256-color terminals get
      24-bit escapes.
- [ ] **NUL-separated input** (p3) [feature]: `-0` / `--null` to read paths separated by NUL (`fd -0`,
      `find -print0`), for names with newlines.
- [ ] **Stat-based directory detection** (p3) [feature]: when stat runs anyway, mark directories from it,
      not only from a trailing "/".
- [ ] **Capabilities in --version** (p3) [feature]: fzx probes each prettypath binary (by path and mtime)
      to learn whether "%" and paths directly under "/" survive; a version number callers can compare (or a
      `--features` line) would replace the probe.
- [ ] **256-color output** (p3) [feature]: `force_256` in opts.lua is unused, so 256-color terminals get
      24-bit escapes. Add `--color=256`: icons use their `cterm_color`, the hex colors in opts.colors map to
      the nearest xterm-256 index (computed once per color, like the truecolor cache in color.lua).
- [x] **Unknown options are ignored** (p3) [bug]: `--colr=never` or `--feild=2` is silently dropped by
      opts.apply_args. Reject any `--name` not in prettypath/cli.lua's option table, exit 2, as bad values do.
- [ ] **zsh and fish completions are only syntax-checked** (p3) [test]: specs run `zsh -n` and drive the bash
      completion function; zsh's `_arguments` behavior is untested and fish is not installed here. Add a
      zpty-driven zsh check and a `fish --no-execute` one where fish exists.

## 3. Correctness and packaging

- [x] **Library use parses the host's arg** (p2) [bug]: `require("prettypath")` from other Lua code (an
      nvim plugin) reads the host program's `arg` as prettypath options. Parse arguments only in
      bin/prettypath.lua.
- [x] **pretty_dir and pretty_file return nothing** (p2) [bug]: both call `pretty_path` without `return`.
- [x] **Rockspec misses modules** (p2) [bug]: override_materialicons and override_webicons are not listed,
      so a luarocks install lacks them.
- [x] **cli_spec expects dev-3** (p3) [test]: the version test still checks the old rockspec version.
- [ ] **Unassigned icons report** (p3) [chore]: run --output_stats over a large real listing (~/ghq, ~/.config)
      and add icons for the most common unassigned names and extensions.
- [x] **bin loads a second copy of each module** (p2) [bug]: bin/prettypath.lua requires `"../prettypath"`,
      `"../prettypath/opts"` and `"../prettypath/utils"`; Lua caches those under different names than the
      `prettypath.opts` / `prettypath.utils` the library uses, so bin and library each have their own opts
      table and format cache. Harmless while both parse `arg`, but it breaks the moment only bin parses it.
      Require `prettypath.*` and put the script's parent directory on package.path (from arg[0]).
- [x] **Metadata tokens on missing or unstatted files** (p2) [bug]: `%size%` on a missing file raises in
      lua-filesize, so the whole line passes through unformatted; `%mod%` on a missing file prints the
      current time (os.date(nil)); `%mod_ago%` with stat off prints "57y ago" (epoch). Print "" (or "-")
      when the field is nil, in prettypath/format.lua.
- [x] **--output_stats on empty input prints nan** (p3) [bug]: Percentage and Average divide by
      stats.total = 0; elapsed time comes from os.time() (1s resolution), so Average is 0 on most runs.
      Guard the zero case and time with os.clock() or uv.hrtime(). Stats also go to stdout, mixed into the
      data; stderr would keep pipelines clean.
- [x] **Name colors ignore missing** (p3) [bug]: color.lua's color_name returns the name uncolored when
      `color_name ~= false`, before the missing check, and carries a TODO about a 1-100 scale that
      opts.lua documents but nothing implements (default_opts.color_name = 0 is overridden by false).
      Decide what color_name means and drop the dead branch.
- [ ] **Custom icons in override.lua are overwritten** (p3) [bug]: the hand-picked entries at the top of
      override.lua's icons table (mp3, wav, `Gemfile$`, zip, tar) are defined again further down the same
      table literal, and the later entry wins (luacheck W314), so the custom icons and colors never apply.
      Keep one entry per key: move the custom ones after the generated block, or into their own table merged last.
- [ ] **Icon data modules: dead code and missing returns** (p3) [chore]: iconmap.lua exports
      `directory_icon`, which is never defined (nil); override_materialicons.lua and override_webicons.lua
      build their tables but return nothing, so `require` gives `true`; nonicons.lua has an unused
      generate_icons with unreachable code. Return the tables (or drop the modules) so luacheck is clean.

## 4. Tooling and docs

- [ ] **Tests need luarocks paths in the environment** (p3) [test]: `make test` fails with "module 'luv'
      not found" unless the shell has `eval "$(luarocks --local path)"`; busted and the CLI specs run plain
      `lua`. Have the Makefile test targets set LUA_PATH/LUA_CPATH from `luarocks path`.
- [ ] **Makefile is mostly dead lunamark targets** (p3) [chore]: ROCKSPEC/rockspec.in/REVISION, bench (Markdown
      test files that do not exist), prof, coverage (bin/shtest), docs, website, standalone and the
      install target do not apply to this project. Remove them; the Benchmark target item replaces bench.
- [ ] **install.sh is stale** (p3) [chore]: it builds prettypath-dev-2.rockspec and reads files.txt,
      both gone. Update it to the current rockspec or delete it in favor of `make rock`.
- [ ] **Rockspec installs scripts as modules** (p3) [chore]: build.install.lua maps `bin.prettypath` and
      `bin.prettypath_test` as Lua modules, and installs prettypath_test as a user-facing binary.
- [ ] **No README** (p3) [docs]: the only usage docs are CLAUDE.md and --help; the rockspec homepage points
      at a repo with no README. Add one with install, options, tokens and icon overrides.
