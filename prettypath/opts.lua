local utils = require("prettypath.utils")

--stylua: ignore
local default_opts = {
  colors      = {
    score = '#8864fc',
    date  = '#556789',
    size  = '#957769',
  },
}

--stylua: ignore
local opts = {
  colors = {
    missing   = '#334455',
    path_dir  = '#556789',
    path_name = '#4489bb',
  },
  -- \u00a0
  -- format       = "%score% %icon% %dir%%name%",
  format       = "%path% %icon% %dir%%name%",
  -- format       = "%path%: %icon%: %dir%:%name%",
  -- format       = "%path% %icon% %dir%%name%",
  stat_file    = "auto",
  home_name    = "~",
  -- color the icon and the name (false: print them plain; a missing file's icon is still dimmed)
  color_icon   = true,
  color_name   = true,
  output_stats = false,
  -- always | never | auto (only when stdout is a terminal) | 256 (xterm-256 escapes instead of truecolor);
  -- NO_COLOR (non-empty) makes the default never
  color        = "always",
  -- drop this directory prefix from %dir% (nil: none)
  base         = nil,
  -- treat every path as a directory
  dirs         = false,
  -- format only this field of each line (1-based; negative counts from the end), split on delimiter
  field        = nil,
  delimiter    = "\t",
  -- flush after every line (for a consumer that shows rows as they come, on a slow source)
  line_buffered = false,
  -- records separated by NUL instead of newline, in and out
  null         = false,
  -- os.date (strftime) format for %access%, %mod% and %create%
  time_format  = "%x %X",
}

local no_color = os.getenv("NO_COLOR")
if no_color ~= nil and no_color ~= "" then
	opts.color = "never"
end

opts = utils.deep_extend(default_opts, opts)

-- "true"/"false" from the command line; a plain "false" string would be truthy in Lua
local bools =
	{ ["true"] = true, ["1"] = true, yes = true, on = true, ["false"] = false, ["0"] = false, no = false, off = false }
local function parse_bool(val, name)
	local b = bools[tostring(val):lower()]
	if b == nil then
		error("--" .. (name or "option") .. " takes true or false, not '" .. tostring(val) .. "'", 0)
	end
	return b
end

-- stat_file: "auto" (stat only when the format has a metadata token), true or false
local function parse_stat(val)
	val = tostring(val):lower()
	if val == "auto" then
		return "auto"
	end
	local b = bools[val]
	if b == nil then
		error("--stat_file takes auto, true or false, not '" .. val .. "'", 0)
	end
	return b
end

local color_modes = { always = true, never = true, auto = true, ["256"] = true }

-- the options prettypath/cli.lua describes, by key ("-" and "_" are the same in a name): the arg
-- placeholder, or false for a flag without a value
local known, shorts
local function known_options()
	if known == nil then
		known, shorts = {}, {}
		for _, o in ipairs(require("prettypath.cli").options) do
			local key = o.name:gsub("%-", "_")
			known[key] = o.arg or false
			if o.short then
				shorts[o.short] = o.name
			end
		end
	end
	return known, shorts
end

-- Apply --key=value (or a bare --flag, meaning true) command-line arguments. Only bin/prettypath.lua
-- calls this: a library caller's global `arg` belongs to the host program, not to prettypath.
-- An unknown option, a stray argument or an invalid value is an error (the CLI reports it, exits 2).
local function apply_args(argv)
	local options, short_names = known_options()
	for _, command_arg in ipairs(argv or {}) do
		local name, val = command_arg:match("^%-%-([%w_%-]+)=(.*)$")
		if name == nil then
			name = command_arg:match("^%-%-([%w_%-]+)$")
			val = nil
		end
		-- a short alias of a flag: -0 is --null
		if name == nil and short_names[command_arg:match("^%-(%w)$") or ""] then
			name = short_names[command_arg:sub(2)]
		end
		if name == nil then
			if command_arg:sub(1, 1) == "-" and command_arg ~= "-" then
				error("unknown option '" .. command_arg .. "' (see --help)", 0)
			end
			error("unexpected argument '" .. command_arg .. "': prettypath reads paths from stdin (see --help)", 0)
		end
		local key = name:gsub("%-", "_")
		local takes = options[key]
		if takes == nil then
			error("unknown option '--" .. name .. "' (see --help)", 0)
		end
		if val == nil then
			-- a bare flag means true; an option that takes a value needs one
			if takes and takes ~= "BOOL" then
				error("--" .. name .. " needs a value (--" .. name .. "=" .. takes .. ")", 0)
			end
			val = "true"
		end
		if key == "format" then
			opts.format = val
		elseif key == "stat_file" then
			opts.stat_file = parse_stat(val)
		elseif key == "output_stats" then
			opts.output_stats = parse_bool(val, name)
		elseif key == "dirs" then
			opts.dirs = parse_bool(val, name)
		elseif key == "base" then
			opts.base = val ~= "" and val or nil
		elseif key == "color" then
			val = val:lower()
			if not color_modes[val] then
				error("--color takes always, never, auto or 256, not '" .. val .. "'", 0)
			end
			opts.color = val
		elseif key == "field" then
			local n = tonumber(val)
			if n == nil or n == 0 or n ~= math.floor(n) then
				error("--field takes a field number (1 is the first, -1 the last), not '" .. val .. "'", 0)
			end
			opts.field = n
		elseif key == "delimiter" then
			-- "\t" as typed (no $'\t' in the shell) means a tab
			val = val == "\\t" and "\t" or val
			if val == "" then
				error("--delimiter cannot be empty", 0)
			end
			opts.delimiter = val
		elseif key == "line_buffered" then
			opts.line_buffered = parse_bool(val, name)
		elseif key == "null" then
			opts.null = parse_bool(val, name)
		elseif key == "time_format" then
			-- os.date rejects some conversions (5.2+, luajit); fail up front, not on the first file
			local ok = val ~= "" and pcall(os.date, val, 0)
			if not ok then
				error("--time_format takes an os.date (strftime) format, not '" .. val .. "'", 0)
			end
			opts.time_format = val
		end
	end
	return opts
end

-- a metatable keeps apply_args out of pairs(opts) (stats.config, deep_extend)
return setmetatable(opts, { __index = { apply_args = apply_args } })
