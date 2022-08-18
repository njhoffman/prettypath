local devicons = require('prettypath.devicons')
local opts = require('prettypath.opts')
local utils = require('prettypath.utils')

local overriden = require("prettypath.override")
devicons.override(overriden.icons)

local stats = {
  unassigned = {},
  missing    = {},
  total      = 0,
  time_start = os.time(),
  config     = opts,
}

local pretty_path = function(path, user_opts, path_type)
  local dir = path:match("(.*[/\\])")
  local pathinfo = { dir = dir or '', name = path or '', path = path }
  if path_type ~= nil then pathinfo.type = path_type end

  if dir ~= nil then
    dir = string.gsub(dir, "^./", "")
    pathinfo.dir = string.gsub(dir, os.getenv('HOME') or '', '~')
    pathinfo.name = path:match("^.+/(.+)$")
  end

  if (opts.stat_file) then
    local filestat = utils.file_stat(pathinfo.path)
    if filestat == nil then
      table.insert(stats.missing, path)
      pathinfo.missing = true
    else
      stats.total = stats.total + 1
      for name in pairs(filestat) do
        pathinfo[name] = filestat[name]
      end
    end
  else
    stats.total = stats.total + 1
  end

  pathinfo.icon_data = devicons.get(pathinfo.name, pathinfo.type)
  if pathinfo.icon_data.name == 'Default' then
    table.insert(stats.unassigned, path)
  end
  local parsed_str = utils.format_path(pathinfo, user_opts)
  return parsed_str
end

return {
  stats = stats,
  pretty_path = pretty_path,
  pretty_dir = function(path, user_opts)
    pretty_path(path, user_opts, 'directory')
  end,
  pretty_file = function(path, user_opts)
    pretty_path(path, user_opts, 'file')
  end,
}
