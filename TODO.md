# prettypath

Open work, in the TODO.md format `todo-status` reads: `(p1)` urgent, `(p2)` normal (the default), `(p3)` low;
one category per item.

Measured 2026-10-26 (lua 5.1 through the luarocks wrapper): 28ms to start, 13-30µs per path with
`--stat_file=false` (15k paths in 0.45s on a busy machine; 20k in 0.26s in an earlier quiet run) and about 100µs with stat on (1.5s). fzx runs it over every file
and directory list (`fzx -m files`, `dirs`, `recent`), so the per-path cost sets how fast big lists appear.

Reviewed: 2026-11-10

## 1. Speed

- [ ] **Stat only when the format needs it** (p1) [perf]: `--stat_file` defaults to true and triples the
      per-path cost, but only `%size%`, `%mod%`, `%access%`, `%create%` and their `_ago` forms read the stat.
      Default to "auto": stat when the compiled format holds one of those tokens. Callers then stop passing
      `--stat_file=false` (fzx does on every call).
- [ ] **No bookkeeping unless --output_stats** (p2) [perf]: `pretty_path` appends every path without an
      icon to `stats.unassigned` and every missing one to `stats.missing`, for the whole run. A 100k-path
      home directory listing keeps them all in memory to report nothing. Collect only with --output_stats.
- [ ] **LuaJIT** (p2) [perf]: run under luajit when it is installed (the code is 5.1-compatible); expect
      the per-path cost to drop several times. Check `luv` builds for it
      (luajit is not installed on this machine yet).
- [ ] **Start faster** (p3) [perf]: the luarocks wrapper loads `luarocks.loader` before the script; calling
      lua5.1 directly with the same package paths started 20-55ms sooner in three (noisy) runs. Install a launcher that sets package.path directly; load the icon tables lazily
      (override_*icons only when configured).
- [ ] **Benchmark target** (p3) [test]: `make bench` over a fixed list (say 20k paths with mixed
      extensions, directories and missing files), reporting startup and µs per path with stat on and off, so
      changes show their cost.
- [ ] **Flush policy** (p3) [perf]: output is block-buffered, which is right for throughput; a
      `--line-buffered` flag for interactive consumers that want the first rows at once (fzf shows the first
      screen sooner on a slow source).

## 2. Interface for callers

- [ ] **--base DIR** (p2) [feature]: drop a directory prefix from `%dir%` (shown relative to the base, as
      `fd` and `rg` print). fzx strips `~/base/` from every display line with awk after prettypath.
- [ ] **--dirs** (p2) [feature]: treat every input path as a directory (folder icon, directory colors),
      for lists that do not end directories with "/" (zoxide, fasd, z.lua). fzx appends the slash with sed
      first today.
- [ ] **Decorate one field of tabbed input** (p2) [feature]: `--field N` (with `--delimiter`, default tab)
      formats that field and passes the other fields through, so "score<TAB>path" or "id<TAB>path<TAB>extra"
      lines keep their columns. fzx's dirs and recent modules pipe the paths through prettypath separately
      and join the results back by path with awk.
- [ ] **NO_COLOR and --color** (p2) [feature]: honor NO_COLOR and take `--color=always|never|auto` (auto:
      color when stdout is a terminal); `force_256` in opts.lua is unused, so 256-color terminals get
      24-bit escapes.
- [ ] **NUL-separated input** (p3) [feature]: `-0` / `--null` to read paths separated by NUL (`fd -0`,
      `find -print0`), for names with newlines.
- [ ] **Stat-based directory detection** (p3) [feature]: when stat runs anyway, mark directories from it,
      not only from a trailing "/".
- [ ] **Capabilities in --version** (p3) [feature]: fzx probes each prettypath binary (by path and mtime)
      to learn whether "%" and paths directly under "/" survive; a version number callers can compare (or a
      `--features` line) would replace the probe.

## 3. Correctness and packaging

- [ ] **Library use parses the host's arg** (p2) [bug]: `require("prettypath")` from other Lua code (an
      nvim plugin) reads the host program's `arg` as prettypath options. Parse arguments only in
      bin/prettypath.lua.
- [ ] **pretty_dir and pretty_file return nothing** (p2) [bug]: both call `pretty_path` without `return`.
- [ ] **Rockspec misses modules** (p2) [bug]: override_materialicons and override_webicons are not listed,
      so a luarocks install lacks them.
- [ ] **cli_spec expects dev-3** (p3) [test]: the version test still checks the old rockspec version.
- [ ] **Unassigned icons report** (p3) [chore]: run --output_stats over a large real listing (~/ghq, ~/.config)
      and add icons for the most common unassigned names and extensions.
- [ ] **bin loads a second copy of each module** (p2) [bug]: bin/prettypath.lua requires `"../prettypath"`,
      `"../prettypath/opts"` and `"../prettypath/utils"`; Lua caches those under different names than the
      `prettypath.opts` / `prettypath.utils` the library uses, so bin and library each have their own opts
      table and format cache. Harmless while both parse `arg`, but it breaks the moment only bin parses it.
      Require `prettypath.*` and put the script's parent directory on package.path (from arg[0]).
- [ ] **Metadata tokens on missing or unstatted files** (p2) [bug]: `%size%` on a missing file raises in
      lua-filesize, so the whole line passes through unformatted; `%mod%` on a missing file prints the
      current time (os.date(nil)); `%mod_ago%` with stat off prints "57y ago" (epoch). Print "" (or "-")
      when the field is nil, in prettypath/format.lua.
- [ ] **--output_stats on empty input prints nan** (p3) [bug]: Percentage and Average divide by
      stats.total = 0; elapsed time comes from os.time() (1s resolution), so Average is 0 on most runs.
      Guard the zero case and time with os.clock() or uv.hrtime(). Stats also go to stdout, mixed into the
      data; stderr would keep pipelines clean.
- [ ] **Name colors ignore missing** (p3) [bug]: color.lua's color_name returns the name uncolored when
      `color_name ~= false`, before the missing check, and carries a TODO about a 1-100 scale that
      opts.lua documents but nothing implements (default_opts.color_name = 0 is overridden by false).
      Decide what color_name means and drop the dead branch.

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
