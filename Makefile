LUAROCKS ?= luarocks --local
DEV_ROCKSPEC = prettypath-dev-4.rockspec
LUA_SOURCES = bin/*.lua prettypath.lua prettypath/*.lua spec/*.lua

.PHONY: all install rock lint check format format-check test test-unit test-watch test-verbose test-coverage \
	bench icon-report clean

all: lint test

# luarocks install, then the launcher over its wrapper (luajit when installed, no luarocks.loader at startup);
# LUAROCKS="luarocks" for a system-wide tree
install:
	$(LUAROCKS) make $(DEV_ROCKSPEC)
	bash scripts/install-launcher.sh \
		"$$($(LUAROCKS) config deploy_bin_dir)/prettypath" \
		"$$($(LUAROCKS) config deploy_lua_dir)" \
		"$$($(LUAROCKS) config deploy_lib_dir)" \
		"$$($(LUAROCKS) show --rock-dir prettypath)/bin/prettypath" \
		"$$($(LUAROCKS) config variables.LUA)"

# plain luarocks install: keeps the luarocks wrapper (lua5.1, slower startup)
rock:
	$(LUAROCKS) make $(DEV_ROCKSPEC)

# Linting and formatting (.styluaignore keeps the generated icon data out of format runs)
lint:
	luacheck $(LUA_SOURCES)

check: lint format-check

format:
	stylua --respect-ignores $(LUA_SOURCES)

format-check:
	stylua --respect-ignores --check $(LUA_SOURCES)

# Testing. The specs (and the CLI they run) load luv and lua-filesize from the user's luarocks tree:
# put its paths in the environment first, so a plain shell needs no `eval "$(luarocks path)"`.
LUAROCKS_ENV = eval "$$($(LUAROCKS) path 2> /dev/null)" && export LUA_PATH LUA_CPATH &&

test:
	$(LUAROCKS_ENV) busted

test-unit:
	$(LUAROCKS_ENV) busted --exclude-tags=integration

test-watch:
	$(LUAROCKS_ENV) busted --watch

test-verbose:
	$(LUAROCKS_ENV) busted --verbose

test-coverage:
	$(LUAROCKS_ENV) busted --coverage && luacov

# startup and µs per path over a fixed generated list; LUA=luajit, PATHS=N, RUNS=N
bench:
	LUA="$(or $(LUA),lua)" bash bench/bench.sh

# icon coverage over real listings and the most common types without an icon; DIRS="~/ghq ~/.config", TOP=40
icon-report:
	$(LUAROCKS_ENV) bash scripts/icon-report.sh $(or $(DIRS),.)

clean:
	-rm -f luacov.stats.out luacov.report.out
