#!/usr/bin/env lua

local VERSION = "dev-4"

local function print_version()
	print("prettypath " .. VERSION)
	os.exit(0)
end

local function print_help()
	local help = [[
prettypath - Decorate file paths with devicons and colors

Usage: prettypath [OPTIONS]
       <command> | prettypath [OPTIONS]

Options:
  -h, --help          Show this help message and exit
  -v, --version       Show version and exit
  --format=FORMAT     Output format string (default: %path% %icon% %dir%%name%)
  --stat_file=BOOL    Enable file stat for metadata tokens (default: true)
  --output_stats=BOOL Print statistics after processing (default: false)

Format Tokens:
  %path%        Original file path
  %icon%        Devicon with color
  %dir%         Directory portion (colorized)
  %name%        Filename portion (colorized)
  %score%       Numeric score (for ranked results)
  %size%        File size (human-readable)
  %access%      Last access time
  %mod%         Last modification time
  %create%      Creation time
  %access_ago%  Last access (relative, e.g. "2h ago")
  %mod_ago%     Last modification (relative)
  %create_ago%  Creation time (relative)

Examples:
  find . -type f | prettypath
  fd . | prettypath --format='%icon% %name%'
  echo "/path/to/file.lua" | prettypath --format='%size% %icon% %dir%%name%'
]]
	print(help)
	os.exit(0)
end

-- Handle -h/--help and -v/--version before loading dependencies
for _, a in ipairs(arg or {}) do
	if a == "-h" or a == "--help" then
		print_help()
	elseif a == "-v" or a == "--version" then
		print_version()
	end
end

local prettypath = require("../prettypath")
local opts = require("../prettypath/opts")
local utils = require("../prettypath/utils")

-- a bad format fails once, up front, instead of on every line
local ok_format, format_err = pcall(utils.compile_format, opts.format)
if not ok_format then
	io.stderr:write("prettypath: " .. tostring(format_err) .. "\n")
	os.exit(2)
end

local start_time = os.time()
local warned = false
for line in io.stdin:lines() do
	local ok, out = pcall(prettypath.pretty_path, line)
	if not ok then
		-- never drop a line: a consumer pairing output with input relies on one line per path
		if not warned then
			io.stderr:write("prettypath: " .. tostring(out) .. " (passed through unformatted: " .. line .. ")\n")
			warned = true
		end
		out = line
	end
	-- a closed pipe (fzf exited, head) ends the run quietly
	if not io.write(out, "\n") then
		break
	end
end

local stats = prettypath.stats or {}

local elapsed_time = os.difftime(os.time(), start_time)

if tostring(opts.output_stats) == "true" then
	print("\n------\n")
	for _, path in pairs(stats.unassigned) do
		print(path)
	end

	local avg = elapsed_time / stats.total * 1000000

  --stylua: ignore
  print(
    '\n\n' .. 'Missing:\t' .. #stats.missing ..
    '\n' .. 'Unassigned:\t' .. #stats.unassigned ..
    '\n' .. 'Total:\t\t' .. stats.total ..
    '\n' .. 'Percentage:\t' .. math.floor(100 - (#stats.unassigned / stats.total * 100)) .. '%' ..
    '\n' .. 'Average:\t' .. (math.floor(avg * 100) / 100) .. 'μs' ..
    '\n')
end
