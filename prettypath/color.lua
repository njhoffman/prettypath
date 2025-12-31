local opts = require("prettypath.opts")

local hex2rgb = function(hex)
	hex = hex:gsub("#", "")
	return tonumber("0x" .. hex:sub(1, 2)), tonumber("0x" .. hex:sub(3, 4)), tonumber("0x" .. hex:sub(5, 6))
end

local to_ansi = function(text, color)
	if color == nil then
		return text
	end
	local reset = "\27[0m"
	local r, g, b = hex2rgb(color)
	local ansi = "\27[38;2;" .. r .. ";" .. g .. ";" .. b .. "m"
	return ansi .. text .. reset
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

local color_name = function(name, is_missing)
	if opts.color_name ~= false then
		-- TODO: colorize name from 1-100
		return name
	elseif is_missing then
		return to_ansi(name, opts.colors.missing)
	elseif opts.colors.path_name ~= nil then
		return to_ansi(name, opts.colors.path_name)
	end
	return name
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
