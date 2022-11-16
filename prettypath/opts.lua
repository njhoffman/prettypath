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

for _, command_arg in ipairs(arg) do
  for key in string.gmatch(command_arg, '--([a-z_]+)=') do
    local val = command_arg:gsub('--' .. key .. '=', '')
    if key == 'format' and val ~= nil then
      opts.format = val
    elseif key == 'stat_file' and val ~= nil then
      opts.stat_file = val
    elseif key == 'output_stats' and val ~= nil then
      opts.output_stats = val
    end
  end
end

return opts
