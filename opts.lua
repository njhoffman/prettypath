local default_opts = {
  colors      = {
    score    = '#8864fc',
    dir_icon = '#4d70aa',
    dir_path = '#4d70aa',
    date     = '#556789',
    size     = '#957769',
    missing  = '#334455',
  },
  -- size, access, mod, create, access_ago, mod_ago, create_ago
  format      = "%score% %icon% %dir%%name%",
  force_256   = false,
  color_icons = true,
  color_name  = 0,
}

local opts = {
  colors     = {
    path_dir  = '#556789',
    path_file = '#4489bb',
  },
  stat_file  = false,
  home_name  = "~",
  -- 0 (false) - 100 (true)
  color_icon = true,
  color_file = false,
}

return opts
