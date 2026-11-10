local devicons = require("prettypath.devicons")
local opts = require("prettypath.opts")
local utils = require("prettypath.utils")

local overriden = require("prettypath.override")
devicons.override(overriden.icons)

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

-- "path", "score path" (score before an absolute path), "path/" (a directory); absolute or relative
local function parse_path(line, path_type)
	local score, pathname = line:match("^%s*(%d+%.?%d*)%s+(/.*)$")
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
	if home ~= "" and (dir == home .. "/" or starts_with(dir, home .. "/")) then
		dir = opts.home_name .. dir:sub(#home + 1)
	end
	return { dir = dir, name = name, score = parse_score(score), path = pathname, type = path_type }
end

local pretty_path = function(path, user_opts, path_type)
	-- print("pretty path called with path: " .. tostring(path) .. ", path_type: " .. tostring(path_type))
	local pathinfo = parse_path(path, path_type)

	if opts.stat_file then
		local filestat = utils.file_stat(pathinfo.path)
		if filestat == nil then
			table.insert(stats.missing, path)
			pathinfo.missing = true
		else
			stats.total = stats.total + 1
			for name, val in pairs(filestat) do
				pathinfo[name] = val
			end
		end
	else
		stats.total = stats.total + 1
	end

	pathinfo.icon_data = devicons.get(pathinfo.name, pathinfo.type)
	if pathinfo.icon_data.name == "Default" then
		table.insert(stats.unassigned, path)
	end
	-- print("Path info: " .. utils.inspect(pathinfo))

	local parsed_str = utils.format_path(pathinfo, user_opts)
	return parsed_str
end

return {
	stats = stats,
	pretty_path = pretty_path,
	pretty_dir = function(path, user_opts)
		pretty_path(path, user_opts, "directory")
	end,
	pretty_file = function(path, user_opts)
		pretty_path(path, user_opts, "file")
	end,
}
