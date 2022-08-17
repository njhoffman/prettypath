local devicons = require('devicons')
local filestat = require('filestat')
local opts = require('opts')

-- if nonicons font enabled...
-- local overriden = require("override")
-- devicons.override(overriden.icons)

local hex2rgb = function(hex)
  hex = hex:gsub("#", "")
  return tonumber("0x" .. hex:sub(1, 2)), tonumber("0x" .. hex:sub(3, 4)), tonumber("0x" .. hex:sub(5, 6))
end

local to_ansi = function(text, color)
  if color == nil then return text end
  local reset = '\27[0m'
  local r, g, b = hex2rgb(color)
  local ansi = '\27[38;2;' .. r .. ';' .. g .. ';' .. b .. 'm'
  return ansi .. text .. reset
end

local color_icon = function(icon_data)
  if opts.color_icon == false then return icon_data.icon end
  -- lua converts \ followed by decimal number to ASCII equivalent
  -- use \27 to obtain the bash \033 ESC character
  local ansi = to_ansi(icon_data.icon, icon_data.color)
  return ansi
end

local color_file = function(filename)
  if opts.color_file == false then
    if opts.colors.path_file ~= nil then
      return to_ansi(filename, opts.colors.path_file)
    else
      return filename
    end
  end
end

local color_dir = function(dirname)
  if opts.colors.path_dir ~= nil then
    return to_ansi(dirname, opts.colors.path_dir)
  else
    return dirname
  end
end

local format_path = function(pathinfo)
  return color_icon(pathinfo.icon_data) .. ' ' ..
    color_dir(pathinfo.dir) ..
    color_file(pathinfo.file)
end

local pretty_path = function(path)
  local dir = path:match("(.*[/\\])")
  local pathinfo = { dir = dir or '', file = path or '', path = path }

  if dir ~= nil then
    dir = string.gsub(dir, "^./", "")
    pathinfo.dir = string.gsub(dir, os.getenv('HOME') or '', '~')
    pathinfo.file = path:match("^.+/(.+)$")
  end
  pathinfo.icon_data = devicons.get(pathinfo.file)
  if (opts.stat_file) then
    pathinfo.stat = filestat(pathinfo.path)
  end
  return format_path(pathinfo)
end

return {
  pretty_path = pretty_path,
  pretty_dir = pretty_path,
  pretty_file = pretty_path,
}
