#!/usr/bin/env lua

local VERSION = "0.7.1"

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

-- input records: lines, or with --null NUL-separated records (a last one without a NUL counts)
local function records()
	if opts.null ~= true then
		return io.stdin:lines()
	end
	local buf, pos, done = "", 1, false
	return function()
		while true do
			local nul = buf:find("\0", pos, true)
			if nul then
				local rec = buf:sub(pos, nul - 1)
				pos = nul + 1
				return rec
			end
			if done then
				if pos <= #buf then
					local rec = buf:sub(pos)
					pos = #buf + 1
					return rec
				end
				return nil
			end
			local chunk = io.stdin:read(65536)
			if chunk == nil then
				done = true
			else
				buf = buf:sub(pos) .. chunk
				pos = 1
			end
		end
	end
end

local sep = opts.null == true and "\0" or "\n"
-- --line-buffered flushes after every record (stdio's line buffering would miss NUL-ended ones)
local flush = opts.line_buffered == true

local uv = require("luv")
local start_ns = uv.hrtime()
local warned = false
for line in records() do
	local ok, out = pcall(prettypath.pretty_line, line)
	if not ok then
		-- never drop a record: a consumer pairing output with input relies on one record per path
		if not warned then
			io.stderr:write("prettypath: " .. tostring(out) .. " (passed through unformatted: " .. line .. ")\n")
			warned = true
		end
		out = line
	end
	-- a closed pipe (fzf exited, head) ends the run quietly
	if not io.write(out, sep) or (flush and not io.stdout:flush()) then
		break
	end
end

-- the report goes to stderr, so a pipeline (prettypath --output_stats | fzf) keeps only the paths
if opts.output_stats == true then
	local stats = prettypath.stats
	local elapsed_us = (uv.hrtime() - start_ns) / 1000
	local total, unassigned, missing = stats.total, #stats.unassigned, #stats.missing
	local err = io.stderr
	err:write("\n------\n\n")
	for _, path in ipairs(stats.unassigned) do
		err:write(path, "\n")
	end
	-- no paths: no percentage or average (they would divide by zero)
	local percentage = total > 0 and (math.floor(100 - unassigned / total * 100) .. "%") or "-"
	local average = total > 0 and string.format("%.2fμs", elapsed_us / total) or "-"
	err:write(
		"\n\nMissing:\t",
		missing,
		"\nUnassigned:\t",
		unassigned,
		"\nTotal:\t\t",
		total,
		"\nPercentage:\t",
		percentage,
		"\nAverage:\t",
		average,
		"\n\n"
	)
end
