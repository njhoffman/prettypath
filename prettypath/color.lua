local opts = require("prettypath.opts")

local hex2rgb = function(hex)
	hex = hex:gsub("#", "")
	return tonumber("0x" .. hex:sub(1, 2)), tonumber("0x" .. hex:sub(3, 4)), tonumber("0x" .. hex:sub(5, 6))
end

-- opts.color: always, never, or auto (color only when stdout is a terminal; checked once)
local stdout_tty
local function color_on()
	local mode = opts.color
	if mode == "never" then
		return false
	elseif mode == "auto" then
		if stdout_tty == nil then
			stdout_tty = require("luv").guess_handle(1) == "tty"
		end
		return stdout_tty
	end
	return true
end

-- escape sequence per hex color, computed once
local ansi_cache = {}
local to_ansi = function(text, color)
	if color == nil or text == nil or text == "" or not color_on() then
		return text
	end
	local ansi = ansi_cache[color]
	if ansi == nil then
		local r, g, b = hex2rgb(color)
		ansi = "\27[38;2;" .. r .. ";" .. g .. ";" .. b .. "m"
		ansi_cache[color] = ansi
	end
	return ansi .. text .. "\27[0m"
end

local color_icon = function(icon_data, is_missing)
	-- lua converts \ followed by decimal number to ASCII equivalent
	-- use \27 to obtain the bash \033 ESC character
	local icon_space = icon_data.double and "" or " "
	local icon = icon_data.icon .. icon_space
	if is_missing then
		return to_ansi(icon, opts.colors.missing)
	elseif opts.color_icon ~= false then
		return to_ansi(icon, icon_data.color)
	else
		return icon
	end
end

-- color_name = false prints the name plain; otherwise path_name, or the missing color for a missing file
local color_name = function(name, is_missing)
	if opts.color_name == false then
		return name
	elseif is_missing then
		return to_ansi(name, opts.colors.missing)
	end
	return to_ansi(name, opts.colors.path_name)
end

local color_dir = function(dirname, is_missing)
	if opts.colors.path_dir ~= nil then
		if is_missing then
			return to_ansi(dirname, opts.colors.missing)
		else
			return to_ansi(dirname, opts.colors.path_dir)
		end
	end
	return dirname
end

local color_score = function(score)
	if opts.colors.score ~= nil then
		return to_ansi(score, opts.colors.score)
	end
	return score
end

return {
	score = color_score,
	dir = color_dir,
	name = color_name,
	icon = color_icon,
}
