local uv = require("luv") -- "luv" when stand-alone, "uv" in luvi apps
local format = require("prettypath.format")
local inspect = require("prettypath.inspect")

-- opts.time_format (strftime) for %access%, %mod% and %create%; read per call, so a library caller can change it
local function time_format()
	return require("prettypath.opts").time_format
end

-- %token% -> function(pathinfo); built on first use (color requires opts, which requires this module)
local token_formatters
local function formatters()
	if token_formatters then
		return token_formatters
	end
	local color = require("prettypath.color")
	token_formatters = {
		path = function(p)
			return p.path
		end,
		score = function(p)
			return color.score(p.score)
		end,
		icon = function(p)
			return color.icon(p.icon_data, p.missing)
		end,
		dir = function(p)
			return color.dir(p.dir, p.missing)
		end,
		name = function(p)
			return color.name(p.name, p.missing)
		end,
		size = function(p)
			return color.size(format.size(p.size))
		end,
		access = function(p)
			return color.date(format.time(p.atime, false, time_format()))
		end,
		mod = function(p)
			return color.date(format.time(p.mtime, false, time_format()))
		end,
		create = function(p)
			return color.date(format.time(p.ctime, false, time_format()))
		end,
		access_ago = function(p)
			return color.date(format.time(p.atime, true))
		end,
		mod_ago = function(p)
			return color.date(format.time(p.mtime, true))
		end,
		create_ago = function(p)
			return color.date(format.time(p.ctime, true))
		end,
	}
	return token_formatters
end

local M = {}

-- M.file_stat(path): mtime, ctime, atime, size and type, or nil and true for a broken symlink (nil and
-- false for a path that does not exist)
M.file_stat = function(path)
	-- luarocks install luv
	local stat = uv.fs_stat(path)

	if stat == nil then
		-- a symlink whose target is gone: fs_stat follows it and fails, fs_lstat sees the link itself
		local link = uv.fs_lstat(path)
		return nil, link ~= nil and link.type == "link"
	end
	return {
		mtime = stat.mtime.sec,
		ctime = stat.ctime.sec,
		atime = stat.atime.sec,
		size = stat.size,
		type = stat.type,
	}
end

-- M.compile_format(fmt): the format as a list of literal strings and token functions, compiled once per
-- format. Only %name% (lowercase letters and _) is a token; any other text, "%" included, is literal.
-- An unknown token is an error. parts.needs_stat is true when a token reads file metadata, parts.needs_score
-- when the format shows %score%.
local stat_tokens = {
	size = true,
	access = true,
	mod = true,
	create = true,
	access_ago = true,
	mod_ago = true,
	create_ago = true,
}
M.stat_tokens = stat_tokens
local compiled = {}
M.compile_format = function(fmt)
	if compiled[fmt] then
		return compiled[fmt]
	end
	local fns = formatters()
	local parts, pos = {}, 1
	while true do
		local s, e, token = fmt:find("%%([a-z_]+)%%", pos)
		if s == nil then
			break
		end
		if fns[token] == nil then
			error("unknown format token %" .. token .. "%", 0)
		end
		if s > pos then
			parts[#parts + 1] = fmt:sub(pos, s - 1)
		end
		parts[#parts + 1] = fns[token]
		if stat_tokens[token] then
			parts.needs_stat = true
		elseif token == "score" then
			parts.needs_score = true
		end
		pos = e + 1
	end
	if pos <= #fmt then
		parts[#parts + 1] = fmt:sub(pos)
	end
	compiled[fmt] = parts
	return parts
end

-- token output is inserted as is (no gsub replacement strings, so "%" in a name survives)
M.format_path = function(pathinfo, user_config)
	local fmt = require("prettypath.opts").format
	if user_config ~= nil and user_config.format ~= nil then
		fmt = user_config.format
	end
	local parts = M.compile_format(fmt)
	local out = {}
	for i = 1, #parts do
		local part = parts[i]
		if type(part) == "string" then
			out[i] = part
		else
			out[i] = tostring(part(pathinfo) or "")
		end
	end
	return table.concat(out)
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
