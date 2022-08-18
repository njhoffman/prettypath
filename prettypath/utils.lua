local uv = require("luv") -- "luv" when stand-alone, "uv" in luvi apps
local format = require('prettypath.format')
local opts = require('prettypath.opts')
local color = require('prettypath.color')
local inspect = require('prettypath.inspect')

local file_stat = function(path)
  -- luarocks install luv
  local stat = uv.fs_stat(path)

  if stat == nil then return stat end
  return {
    mtime = stat.mtime.sec,
    ctime = stat.ctime.sec,
    atime = stat.atime.sec,
    size  = stat.size,
    type  = stat.type
  }
end

local token_formatters = {
  path       = function(pathinfo)
    return format.nop(pathinfo.path)
  end,
  score      = function(pathinfo)
    return format.nop(pathinfo.score)
  end,
  icon       = function(pathinfo)
    return color.icon(pathinfo.icon_data, pathinfo.missing)
  end,
  dir        = function(pathinfo)
    return color.dir(pathinfo.dir, pathinfo.missing)
  end,
  name       = function(pathinfo)
    return color.name(pathinfo.name, pathinfo.missing)
  end,
  size       = function(pathinfo)
    return format.size(pathinfo.size)
  end,
  access     = function(pathinfo)
    return format.time(pathinfo.atime)
  end,
  mod        = function(pathinfo)
    return format.time(pathinfo.mtime)
  end,
  create     = function(pathinfo)
    return format.time(pathinfo.ctime)
  end,
  access_ago = function(pathinfo)
    return format.time(pathinfo.atime, true)
  end,
  mod_ago    = function(pathinfo)
    return format.time(pathinfo.mtime, true)
  end,
  create_ago = function(pathinfo)
    return format.time(pathinfo.ctime, true)
  end,
}

local parse_token = function(token, pathinfo)
  if token_formatters[token] == nil then
    return error('Invalid configuration token: ' .. token)
  end
  local token_str = token_formatters[token](pathinfo) or ''
  return string.gsub(tostring(token_str), '%%', '')
end

local format_path = function(pathinfo, user_config)
  local fmt = opts.format
  if user_config ~= nil and user_config.format ~= nil then
    fmt = user_config.format
  end
  local str = fmt
  local tokens = {}
  for token in string.gmatch(fmt, '[a-z_]+') do
    table.insert(tokens, token)
    local token_str = parse_token(token, pathinfo) or ''
    str = string.gsub(str, '%%' .. token .. '%%', token_str)
  end
  return str
end


return {
  format_path = format_path,
  file_stat   = file_stat,
  inspect     = inspect
}
