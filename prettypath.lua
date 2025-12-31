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

local function parse_path(path, path_type)
	-- Try to match with score first (number followed by whitespace then path)
	local score, pathname = path:match("^%s*(%d+%.?%d*)%s+(/.+)$")
	pathname = pathname or path:match("^%s*(/.+)$")
	pathname = string.gsub(pathname, "/$", "")
	local dir = pathname:match("(.*[/\\])")
	local pathinfo = { dir = dir, name = pathname, score = parse_score(score), path = pathname, type = path_type }

	if pathinfo.dir ~= nil then
		dir = string.gsub(dir, "^./", "")
		pathinfo.dir = string.gsub(dir, os.getenv("HOME") or "", "~")
		pathinfo.name = path:match("^.+/(.+)$")
	end

	return pathinfo
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
