local devicons = require("prettypath.devicons")
local opts = require("prettypath.opts")
local utils = require("prettypath.utils")

local overriden = require("prettypath.override")
devicons.override(overriden.icons, nil, overriden.aliases)

local stats = {
	unassigned = {},
	missing = {},
	total = 0,
	time_start = os.time(),
	config = opts,
}

local function parse_score(score)
	score = tonumber(score) or 0
	return string.format("%6.2f", score)
end

local home = os.getenv("HOME") or ""

-- plain prefix test (no Lua patterns: paths are full of magic characters)
local function starts_with(str, prefix)
	return prefix ~= "" and str:sub(1, #prefix) == prefix
end

-- opts.base as given ("~/x", "/x/", ...) -> the base path ("/home/me/x") and the prefix dropped from %dir%
-- ("/home/me/x/"); nil when unset. Normalized once per value (opts.base may be set by a library caller).
local cached_raw, cached_path, cached_prefix
local function base_dir()
	local raw = opts.base
	if raw == nil or raw == "" then
		return nil
	end
	if raw ~= cached_raw then
		local b = raw
		if home ~= "" and (b == "~" or starts_with(b, "~/")) then
			b = home .. b:sub(2)
		end
		if #b > 1 then
			b = b:gsub("/+$", "")
			if b == "" then
				b = "/"
			end
		end
		cached_raw, cached_path = raw, b
		cached_prefix = b == "/" and "/" or b .. "/"
	end
	return cached_path, cached_prefix
end

-- "path", "score path", "path/" (a directory); absolute or relative. A score before an absolute path is
-- always read; before a relative one only when ranked (the format shows %score%), so a file named
-- "2024 report.pdf" stays one name otherwise. A directory under opts.base is shown relative to it, then a
-- directory under HOME with "~"; HOME itself is shown as "~".
local function parse_path(line, path_type, ranked)
	local score, pathname = line:match("^%s*(%d+%.?%d*)%s+(/.*)$")
	if score == nil and ranked then
		score, pathname = line:match("^%s*(%d+%.?%d*)%s+(%S.*)$")
	end
	pathname = pathname or line
	-- a trailing slash marks a directory (fd --type d, ls -p); "/" itself stays
	if #pathname > 1 and pathname:sub(-1) == "/" then
		pathname = pathname:gsub("/+$", "")
		if pathname == "" then
			pathname = "/"
		end
		path_type = path_type or "directory"
	end
	local dir, name = pathname:match("^(.*/)([^/]+)$")
	if dir == nil then
		-- no slash (a relative name) or "/" itself
		dir, name = "", pathname
	end
	if starts_with(dir, "./") then
		dir = dir:sub(3)
	end
	local base, base_prefix = base_dir()
	if base ~= nil then
		if pathname == base then
			dir = ""
		elseif starts_with(dir, base_prefix) then
			dir = dir:sub(#base_prefix + 1)
		end
	end
	if home ~= "" and (dir == home .. "/" or starts_with(dir, home .. "/")) then
		dir = opts.home_name .. dir:sub(#home + 1)
	elseif home ~= "" and pathname == home and not (base ~= nil and pathname == base) then
		-- HOME itself (zoxide and fzx's dirs list it): "~", unless it is the --base, shown by its name
		dir, name = "", opts.home_name
	end
	return { dir = dir, name = name, score = parse_score(score), path = pathname, type = path_type }
end

-- stat_file = "auto" stats only for formats with a metadata token (%size%, %mod%, ...)
local function wants_stat(parts)
	local stat_file = opts.stat_file
	if stat_file == "auto" then
		return parts.needs_stat == true
	end
	return stat_file == true
end

local pretty_path = function(path, user_opts, path_type)
	-- an empty line (or field, or record) stays empty: no icon for no path
	if path == "" then
		return ""
	end
	if path_type == nil and opts.dirs == true then
		path_type = "directory"
	end
	local parts = utils.compile_format((user_opts and user_opts.format) or opts.format)
	local pathinfo = parse_path(path, path_type, parts.needs_score)
	-- the path lists are only reported by --output_stats; skip them otherwise (a long run would keep them all)
	local collect = opts.output_stats == true

	if wants_stat(parts) then
		local filestat = utils.file_stat(pathinfo.path)
		if filestat == nil then
			if collect then
				table.insert(stats.missing, path)
			end
			pathinfo.missing = true
		else
			stats.total = stats.total + 1
			for name, val in pairs(filestat) do
				if name ~= "type" then
					pathinfo[name] = val
				end
			end
			-- the stat marks a directory the input did not (no trailing "/"); an explicit type wins
			pathinfo.stat_type = filestat.type
			if pathinfo.type == nil and filestat.type == "directory" then
				pathinfo.type = "directory"
			end
		end
	else
		stats.total = stats.total + 1
	end

	pathinfo.icon_data = devicons.get(pathinfo.name, pathinfo.type)
	if collect and pathinfo.icon_data.name == "Default" then
		table.insert(stats.unassigned, path)
	end

	local parsed_str = utils.format_path(pathinfo, user_opts)
	return parsed_str
end

-- split on a literal delimiter (not a pattern); "" yields one empty field
local function split_plain(line, delim)
	local fields, pos = {}, 1
	while true do
		local s, e = line:find(delim, pos, true)
		if s == nil then
			fields[#fields + 1] = line:sub(pos)
			return fields
		end
		fields[#fields + 1] = line:sub(pos, s - 1)
		pos = e + 1
	end
end

-- One input line: the whole line is the path, or with opts.field only that field of it (the other fields
-- pass through, rejoined with opts.delimiter). A line without that field is returned unchanged.
local pretty_line = function(line, user_opts)
	local n = opts.field
	if n == nil then
		return pretty_path(line, user_opts)
	end
	local delim = opts.delimiter
	local fields = split_plain(line, delim)
	local i = n < 0 and #fields + n + 1 or n
	if i < 1 or i > #fields then
		return line
	end
	fields[i] = pretty_path(fields[i], user_opts)
	return table.concat(fields, delim)
end

return {
	stats = stats,
	pretty_path = pretty_path,
	pretty_line = pretty_line,
	pretty_dir = function(path, user_opts)
		return pretty_path(path, user_opts, "directory")
	end,
	pretty_file = function(path, user_opts)
		return pretty_path(path, user_opts, "file")
	end,
}
