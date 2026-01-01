-- luacheck configuration
-- https://luacheck.readthedocs.io/en/stable/config.html

std = "lua51+luajit"
codes = true
ranges = true

-- Global objects
globals = {
	"vim",
}

read_globals = {
	"arg",
	"jit",
}

-- Ignore patterns
ignore = {
	"212", -- unused argument (common in callbacks)
	"213", -- unused loop variable
}

-- File-specific settings
files["spec/**/*.lua"] = {
	std = "+busted",
	globals = {
		"describe",
		"it",
		"before_each",
		"after_each",
		"setup",
		"teardown",
		"pending",
		"spy",
		"stub",
		"mock",
		"assert",
		"finally",
		"insulate",
		"expose",
		"randomize",
		"async",
	},
}

files["bin/*.lua"] = {
	ignore = {
		"411", -- redefining local variable
	},
}

-- Exclude vendor/external code
exclude_files = {
	"prettypath/inspect.lua",
	".luarocks/**",
	"lua_modules/**",
}

-- Max line length
max_line_length = 120
max_code_line_length = 120
max_string_line_length = 200
max_comment_line_length = 150
