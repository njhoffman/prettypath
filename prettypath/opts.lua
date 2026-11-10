local utils = require("prettypath.utils")

--stylua: ignore
local default_opts = {
  colors      = {
    score = '#8864fc',
    date  = '#556789',
    size  = '#957769',
  },
  -- size, access, mod, create, access_ago, mod_ago, create_ago
  force_256   = false,
  color_icons = true,
  color_name  = 0,
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
  -- 0 (false) - 100 (true)
  color_icon   = true,
  color_name   = false,
  output_stats = false,
  -- always | never | auto (only when stdout is a terminal); NO_COLOR (non-empty) makes the default never
  color        = "always",
  -- drop this directory prefix from %dir% (nil: none)
  base         = nil,
  -- treat every path as a directory
  dirs         = false,
  -- format only this field of each line (1-based; negative counts from the end), split on delimiter
  field        = nil,
  delimiter    = "\t",
}

local no_color = os.getenv("NO_COLOR")
if no_color ~= nil and no_color ~= "" then
	opts.color = "never"
end

opts = utils.deep_extend(default_opts, opts)

-- "true"/"false" from the command line; a plain "false" string would be truthy in Lua
local function parse_bool(val)
	val = tostring(val):lower()
	return val == "true" or val == "1" or val == "yes" or val == "on"
end

-- stat_file: "auto" (stat only when the format has a metadata token), true or false
local function parse_stat(val)
	if tostring(val):lower() == "auto" then
		return "auto"
	end
	return parse_bool(val)
end

local color_modes = { always = true, never = true, auto = true }

-- Apply --key=value (or a bare --flag, meaning true) command-line arguments. Only bin/prettypath.lua
-- calls this: a library caller's global `arg` belongs to the host program, not to prettypath.
-- An invalid value is an error (the CLI reports it and exits 2).
local function apply_args(argv)
	for _, command_arg in ipairs(argv or {}) do
		local key, val = command_arg:match("^%-%-([a-z_]+)=(.*)$")
		if key == nil then
			key = command_arg:match("^%-%-([a-z_]+)$")
			val = "true"
		end
		if key == "format" then
			opts.format = val
		elseif key == "stat_file" then
			opts.stat_file = parse_stat(val)
		elseif key == "output_stats" then
			opts.output_stats = parse_bool(val)
		elseif key == "dirs" then
			opts.dirs = parse_bool(val)
		elseif key == "base" then
			opts.base = val ~= "" and val or nil
		elseif key == "color" then
			val = val:lower()
			if not color_modes[val] then
				error("--color takes always, never or auto, not '" .. val .. "'", 0)
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
		end
	end
	return opts
end

-- a metatable keeps apply_args out of pairs(opts) (stats.config, deep_extend)
return setmetatable(opts, { __index = { apply_args = apply_args } })
