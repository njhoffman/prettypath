# prettypath

Decorate file paths with [Nerd Font](https://www.nerdfonts.com/) icons and colors. prettypath reads paths on stdin
and prints each one through a format, so a file list from `fd`, `find` or `git ls-files` comes out with an icon,
a dimmed directory and a colored name, ready for `fzf --ansi`.

```sh
fd . | prettypath --format='%icon% %dir%%name%'
fd . "$PWD" | prettypath --base="$PWD" --format=$'%path%\t%icon% %dir%%name%' |
  fzf --ansi --delimiter='\t' --with-nth=2 --accept-nth=1
```

Each input line gives exactly one output line (or record, with `-0`); a line that cannot be formatted is
printed unchanged, so output can always be paired with input.

## Install

Requires Lua 5.1 or LuaJIT, [luarocks](https://luarocks.org/), and a Nerd Font in the terminal.

```sh
make install
```

`make install` runs `luarocks --local make` (installing the `luv` and `lua-filesize` dependencies) and then
puts a small launcher in place of the luarocks wrapper: it runs prettypath under `luajit` when that is
installed (about twice as fast per path) and `lua5.1` otherwise, and skips `luarocks.loader` at startup.
`PRETTYPATH_LUA=/path/to/lua` picks the interpreter at run time; `LUAROCKS=luarocks make install` installs
into the system tree. A plain `luarocks --local make prettypath-dev-4.rockspec` also works and keeps the
luarocks wrapper.

## Usage

```
<command> | prettypath [OPTIONS]
prettypath completion bash|zsh|fish
```

| Option | |
|---|---|
| `-h`, `--help` | Show the help and exit |
| `-v`, `--version` | Print `prettypath X.Y.Z` and exit |
| `--format=FORMAT` | Output format (default `%path% %icon% %dir%%name%`, see the tokens below) |
| `--stat_file=MODE` | Stat each file: `auto` (the default: only when the format has a size or date token), `true` (always; also dims missing files and gives directories the folder icon without a trailing `/`) or `false` |
| `--output_stats` | Print counts of missing paths and paths without an icon, and the time per path, to stderr when done |
| `--base=DIR` | Show directories under DIR relative to it in `%dir%` (`%path%` stays as given) |
| `--dirs` | Treat every path as a directory (for lists without a trailing `/`, such as zoxide's) |
| `--field=N` | Decorate only field N of each line (1 is the first, -1 the last) and pass the other fields through; a line without field N is printed unchanged |
| `--delimiter=D` | Field separator for `--field`, taken literally (default tab; `\t` works as typed) |
| `--line-buffered` | Flush after every record, so a consumer on a slow source shows rows as they come |
| `-0`, `--null` | Records are separated by NUL, in and out (`fd -0`, `find -print0`, `fzf --read0`) |
| `--color=MODE` | `always` (the default), `never`, `auto` (only when stdout is a terminal) or `256` (xterm-256 colors for terminals without truecolor). `NO_COLOR` makes the default `never`; an explicit `--color` wins. Icons are printed either way |

Flags can be given bare (`--dirs`) or with a value (`--dirs=false`), and `-` and `_` are the same in option
names (`--stat-file`). An unknown option, a stray argument (paths go on stdin, not on the command line) or an
invalid value exits with status 2 and a message before any input is read.

### Format tokens

| Token | |
|---|---|
| `%path%` | The path as given (a trailing `/` removed) |
| `%icon%` | The icon, colored, with its trailing space |
| `%dir%` | The directory part, colored; under `$HOME` it starts with `~`, under `--base` it is relative |
| `%name%` | The file name, colored |
| `%score%` | A score read from the start of the line (`12.5 /path`), for ranked lists |
| `%size%` | File size, human-readable |
| `%access%`, `%mod%`, `%create%` | Access, modification and change times |
| `%access_ago%`, `%mod_ago%`, `%create_ago%` | The same times, relative (`3h ago`) |

Only `%name%`-shaped tokens are read; other text, `%` included, is printed as is. The size and date tokens
print `-` for a missing file or with `--stat_file=false`. A trailing `/` marks a directory.

### Examples

```sh
# sizes and ages (these tokens make prettypath stat each file)
fd --type f . | prettypath --format='%size% %mod_ago% %icon% %dir%%name%'

# one field of tabbed input: scores stay in their column
printf '12\t/etc/hosts\n3\t/etc/passwd\n' | prettypath --field=2

# zoxide's directories, which have no trailing slash
zoxide query -l | prettypath --dirs

# names with newlines
fd -0 . | prettypath -0 --format='%icon% %name%' | fzf --read0 --ansi
```

## Shell completion

```sh
eval "$(prettypath completion bash)"                                          # in ~/.bashrc
prettypath completion zsh > "${fpath[1]}/_prettypath"                          # then compinit
prettypath completion fish > ~/.config/fish/completions/prettypath.fish
```

## Icons

Icons come from `prettypath/iconmap.lua` (generated from nvim-web-devicons) with the overrides in
`prettypath/override.lua` merged over it. To change or add one, edit `override.lua`:

- `custom`: hand-picked entries, applied last, so they win over any generated entry for the same key.
- `aliases`: a type that should reuse an existing icon, as `['ext'] = 'donor-key'` (`['o'] = 'bin'`).

```lua
['rockspec'] = { icon = '', color = '#f34436', cterm_color = '203', name = 'rockspec' },
```

Keys are extensions (`lua`) or whole file names (`Makefile`, `.gitignore`). `color` is used for truecolor
output and `cterm_color` for `--color=256`. `make icon-report DIRS="~/src ~/.config"` lists the most common
types under those directories that still have no icon.

## Library

```lua
local prettypath = require("prettypath")
prettypath.pretty_path("/etc/hosts", { format = "%icon% %name%" })  -- one path
prettypath.pretty_dir("/etc")                                       -- as a directory
prettypath.pretty_file("/etc")                                      -- as a file
prettypath.pretty_line("12\t/etc/hosts")                            -- honors opts.field
```

Options live in `require("prettypath.opts")` (a plain table: `opts.color = "never"`, `opts.base = "/src"`).
Loading the library never reads the host program's `arg`; `opts.apply_args(argv)` applies command-line style
options when wanted.

## For callers

`prettypath --version` prints `prettypath X.Y.Z` (semantic versioning since 0.1.0). Compare it to check for a
feature; [CHANGELOG.md](CHANGELOG.md) lists what each version added.

## Development

```sh
make test          # busted specs (loads the luarocks paths itself)
make lint          # luacheck
make format        # stylua (the icon data files are in .styluaignore)
make bench         # startup and µs per path; LUA=luajit to compare
make icon-report   # icon coverage over DIRS
```

## License

MIT, see [LICENSE](LICENSE).
