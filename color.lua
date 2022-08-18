local opts = require('opts')

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

local color_name = function(name)
  if opts.color_name == false then
    if opts.colors.path_file ~= nil then
      return to_ansi(name, opts.colors.path_name)
    end
    return name
  end
end

local color_dir = function(dirname)
  if opts.colors.path_dir ~= nil then
    return to_ansi(dirname, opts.colors.path_dir)
  else
    return dirname
  end
end

return {
  dir  = color_dir,
  name = color_name,
  icon = color_icon,
}
