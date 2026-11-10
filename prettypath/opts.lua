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
  stat_file    = true,
  home_name    = "~",
  -- 0 (false) - 100 (true)
  color_icon   = true,
  color_name   = false,
  output_stats = false
}

opts = utils.deep_extend(default_opts, opts)

-- "true"/"false" from the command line; a plain "false" string would be truthy in Lua
local function parse_bool(val)
	val = tostring(val):lower()
	return val == "true" or val == "1" or val == "yes" or val == "on"
end

for _, command_arg in ipairs(arg or {}) do
	local key, val = command_arg:match("^%-%-([a-z_]+)=(.*)$")
	if key == "format" then
		opts.format = val
	elseif key == "stat_file" then
		opts.stat_file = parse_bool(val)
	elseif key == "output_stats" then
		opts.output_stats = parse_bool(val)
	end
end

return opts
