local uv = require("luv") -- "luv" when stand-alone, "uv" in luvi apps
local format = require("prettypath.format")
local inspect = require("prettypath.inspect")

local parse_token = function(token, info)
	local color = require("prettypath.color")
	local token_formatters = {
		path = function(pathinfo)
			return format.nop(pathinfo.path)
		end,
		score = function(pathinfo)
			return color.score(pathinfo.score)
		end,
		icon = function(pathinfo)
			return color.icon(pathinfo.icon_data, pathinfo.missing)
		end,
		dir = function(pathinfo)
			return color.dir(pathinfo.dir, pathinfo.missing)
		end,
		name = function(pathinfo)
			return color.name(pathinfo.name, pathinfo.missing)
		end,
		size = function(pathinfo)
			return format.size(pathinfo.size)
		end,
		access = function(pathinfo)
			return format.time(pathinfo.atime)
		end,
		mod = function(pathinfo)
			return format.time(pathinfo.mtime)
		end,
		create = function(pathinfo)
			return format.time(pathinfo.ctime)
		end,
		access_ago = function(pathinfo)
			return format.time(pathinfo.atime, true)
		end,
		mod_ago = function(pathinfo)
			return format.time(pathinfo.mtime, true)
		end,
		create_ago = function(pathinfo)
			return format.time(pathinfo.ctime, true)
		end,
	}

	if token_formatters[token] == nil then
		return error("Invalid configuration token: " .. token)
	end
	local token_str = token_formatters[token](info) or ""
	return string.gsub(tostring(token_str), "%%", "")
end

local M = {}

M.file_stat = function(path)
	-- luarocks install luv
	local stat = uv.fs_stat(path)

	if stat == nil then
		return stat
	end
	return {
		mtime = stat.mtime.sec,
		ctime = stat.ctime.sec,
		atime = stat.atime.sec,
		size = stat.size,
		type = stat.type,
	}
end

M.format_path = function(pathinfo, user_config)
	local fmt = require("prettypath.opts").format
	if user_config ~= nil and user_config.format ~= nil then
		fmt = user_config.format
	end
	local str = fmt
	local tokens = {}
	for token in string.gmatch(fmt, "[a-z_]+") do
		table.insert(tokens, token)
		local token_str = parse_token(token, pathinfo) or ""
		str = string.gsub(str, "%%" .. token .. "%%", token_str)
	end
	return str
end

M.deep_extend = function(t1, t2)
	for k, v in pairs(t2) do
		if type(t1[k]) == "table" and type(v) == "table" then
			-- If both values are tables, recurse
			M.deep_extend(t1[k], v)
		else
			-- Otherwise, set or overwrite the value in t1
			t1[k] = v
		end
	end
	return t1
end

M.inspect = function(obj)
	return inspect.inspect(obj)
end

return M
