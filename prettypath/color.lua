local opts = require("prettypath.opts")

local hex2rgb = function(hex)
	hex = hex:gsub("#", "")
	return tonumber("0x" .. hex:sub(1, 2)), tonumber("0x" .. hex:sub(3, 4)), tonumber("0x" .. hex:sub(5, 6))
end

-- opts.color -> "truecolor", "256" or false (no color): always, never, auto (truecolor only when stdout is a
-- terminal; checked once) or 256
local stdout_tty
local function color_mode()
	local mode = opts.color
	if mode == "never" then
		return false
	elseif mode == "256" then
		return "256"
	elseif mode == "auto" then
		if stdout_tty == nil then
			stdout_tty = require("luv").guess_handle(1) == "tty"
		end
		return stdout_tty and "truecolor"
	end
	return "truecolor"
end

-- nearest xterm-256 index to an RGB color: the 6x6x6 cube (16-231) or the gray ramp (232-255), whichever is
-- closer (squared RGB distance)
local cube_levels = { 0, 95, 135, 175, 215, 255 }
local function nearest_level(v)
	local best, index
	for i, level in ipairs(cube_levels) do
		local d = math.abs(v - level)
		if best == nil or d < best then
			best, index = d, i - 1
		end
	end
	return index
end

local function xterm256(r, g, b)
	local ri, gi, bi = nearest_level(r), nearest_level(g), nearest_level(b)
	local cr, cg, cb = cube_levels[ri + 1], cube_levels[gi + 1], cube_levels[bi + 1]
	local cube_d = (r - cr) ^ 2 + (g - cg) ^ 2 + (b - cb) ^ 2
	local gray = math.floor(((r + g + b) / 3 - 8) / 10 + 0.5)
	gray = math.max(0, math.min(23, gray))
	local v = 8 + 10 * gray
	local gray_d = (r - v) ^ 2 + (g - v) ^ 2 + (b - v) ^ 2
	if gray_d < cube_d then
		return 232 + gray
	end
	return 16 + 36 * ri + 6 * gi + bi
end

-- escape sequence per color and mode, computed once. cterm: a curated 256-color index (the icons'
-- cterm_color), used in 256 mode instead of the nearest match to the hex color
local ansi_cache = { truecolor = {}, ["256"] = {} }
local to_ansi = function(text, color, cterm)
	if color == nil or text == nil or text == "" then
		return text
	end
	local mode = color_mode()
	if not mode then
		return text
	end
	local key = mode == "256" and cterm and ("c" .. cterm) or color
	local ansi = ansi_cache[mode][key]
	if ansi == nil then
		local r, g, b = hex2rgb(color)
		if mode == "256" then
			local index = tonumber(cterm)
			if index == nil or index < 0 or index > 255 or index ~= math.floor(index) then
				index = xterm256(r, g, b)
			end
			ansi = "\27[38;5;" .. index .. "m"
		else
			ansi = "\27[38;2;" .. r .. ";" .. g .. ";" .. b .. "m"
		end
		ansi_cache[mode][key] = ansi
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
		return to_ansi(icon, icon_data.color, icon_data.cterm_color)
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

-- a size or a date token's text in opts.colors.size / opts.colors.date; the "-" printed for one without
-- data (a missing file, no stat) in the missing color
local function color_meta(text, color)
	if text == "-" then
		return to_ansi(text, opts.colors.missing)
	end
	return to_ansi(text, color)
end

local color_size = function(text)
	return color_meta(text, opts.colors.size)
end

local color_date = function(text)
	return color_meta(text, opts.colors.date)
end

return {
	xterm256 = xterm256,
	score = color_score,
	size = color_size,
	date = color_date,
	dir = color_dir,
	name = color_name,
	icon = color_icon,
}
