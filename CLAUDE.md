# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

prettypath is a Lua CLI tool that decorates file paths with devicons (Nerd Font icons) and ANSI colors. It reads file paths from stdin and outputs formatted paths with icons, colors, and optional file metadata (size, timestamps).

## Build & Install

```bash
# Install via luarocks (recommended)
luarocks make prettypath-dev-4.rockspec

# Local install
luarocks --local make prettypath-dev-4.rockspec
```

## Linting & Formatting

```bash
# Run luacheck linter
make lint

# Format code with stylua
make format

# Check formatting without modifying
make format-check
```

Configuration files:
- `.luacheckrc` - Luacheck linter settings
- `stylua.toml` - StyLua formatter settings
- `.editorconfig` - Editor configuration

## Running

```bash
# Basic usage - pipe paths through prettypath
find . -type f | prettypath

# With custom format
echo "/path/to/file.lua" | ./bin/prettypath.lua --format='%path% %icon% %dir%%name%'

# With stats output
fd . | ./bin/prettypath.lua --output_stats=true

# Test different formatters
echo "/path/to/file.lua" | ./bin/prettypath_test.lua
```

## Architecture

### Entry Points
- `bin/prettypath.lua` - Main CLI script, reads stdin line by line
- `bin/prettypath_test.lua` - Test script that runs multiple format patterns

### Core Module (`prettypath.lua`)
Main API returning `pretty_path(path, user_opts, path_type)`. Parses paths, optionally stats files via luv, retrieves icons from devicons module.

### Module Structure (`prettypath/`)
- `opts.lua` - Configuration options, parses CLI args (`--format=`, `--stat_file=`, `--output_stats=`)
- `devicons.lua` - Icon lookup by filename/extension, wraps iconmap
- `iconmap.lua` - Base icon definitions (icon char, color, name) keyed by filename/extension
- `override.lua` - Custom icon overrides merged into iconmap (primary customization point)
- `color.lua` - ANSI color output using 24-bit truecolor (`\27[38;2;R;G;B;m`)
- `format.lua` - Time/size formatting, uses `lua-filesize` for human-readable sizes
- `utils.lua` - Format string parsing, file stat via luv, deep table extend

### Format Tokens
Used in `--format=` option:
- `%path%` - Original path
- `%icon%` - Devicon with color
- `%dir%` - Directory portion (colorized)
- `%name%` - Filename portion (colorized)
- `%score%` - Optional numeric score (for ranked results)
- `%size%`, `%access%`, `%mod%`, `%create%` - File metadata
- `%access_ago%`, `%mod_ago%`, `%create_ago%` - Relative timestamps

### Icon Customization
To add/override icons, edit `prettypath/override.lua`. Icon entries:
```lua
['extension'] = {
  icon = '',      -- Nerd Font glyph
  color = '#hex',   -- Hex color for truecolor terminals
  cterm_color = '0', -- 256-color fallback
  name = 'Name',
}
```

## Testing

Tests use busted framework. Test files are in `spec/` directory.

```bash
# Run all tests
make test

# Run tests with verbose output
make test-verbose

# Run unit tests only (exclude integration)
make test-unit

# Run tests in watch mode
make test-watch

# Run with coverage
make test-coverage

# Run busted directly
busted

# Run specific test file
busted spec/devicons_spec.lua
```

## Dependencies
- `luv` (libuv bindings) - File stat operations
- `lua-filesize` - Human-readable file sizes
- `busted` (test only) - Testing framework
