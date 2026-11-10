#!/usr/bin/env lua

local VERSION = "0.2.0"

local function print_version()
	print("prettypath " .. VERSION)
	os.exit(0)
end

-- Find the modules next to this script (a checkout: <root>/bin/prettypath.lua) before installed ones.
-- Requiring them as "prettypath.*" everywhere keeps one copy of each module: bin and the library share
-- the same opts table and format cache.
local script = (arg and arg[0]) or ""
local root = script:match("^(.*)/bin/[^/]+$") or (script:match("^bin/[^/]+$") and ".")
if root then
	package.path = root .. "/?.lua;" .. root .. "/?/init.lua;" .. package.path
end

-- help, version and completion run before the rest loads (prettypath.cli has no dependencies)
local cli = require("prettypath.cli")
if arg and arg[1] == "completion" then
	local text, err = cli.completion(arg[2])
	if text == nil then
		io.stderr:write("prettypath: " .. err .. "\n")
		os.exit(2)
	end
	io.write(text)
	os.exit(0)
end
for _, a in ipairs(arg or {}) do
	if a == "-h" or a == "--help" then
		io.write(cli.help())
		os.exit(0)
	elseif a == "-v" or a == "--version" then
		print_version()
	end
end

local prettypath = require("prettypath")
local opts = require("prettypath.opts")
local utils = require("prettypath.utils")

-- a bad option or format fails once, up front, instead of on every line
local ok_args, args_err = pcall(opts.apply_args, arg)
local ok_format, format_err = true, nil
if ok_args then
	ok_format, format_err = pcall(utils.compile_format, opts.format)
end
if not (ok_args and ok_format) then
	-- on success pcall's second value is apply_args' result (opts), so pick the error by which call failed
	io.stderr:write("prettypath: " .. tostring(ok_args and format_err or args_err) .. "\n")
	os.exit(2)
end

local start_time = os.time()
local warned = false
for line in io.stdin:lines() do
	local ok, out = pcall(prettypath.pretty_line, line)
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
