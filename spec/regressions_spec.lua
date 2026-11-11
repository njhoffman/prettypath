-- regressions: "%" in names, paths parse_path used to reject, stat_file=false, literal format text,
-- lines that fail to format
local function strip(s)
	return (s:gsub("\27%[[0-9;]*m", ""))
end

-- run the CLI on input lines; returns stdout lines and stderr text
local function cli(args, lines)
	local input = os.tmpname()
	local err = os.tmpname()
	local f = io.open(input, "w")
	f:write(table.concat(lines, "\n"), "\n")
	f:close()
	local output = os.tmpname()
	-- os.execute returns the raw status in Lua 5.1 (code * 256), (ok, "exit", code) in 5.2+
	local r1, _, r3 =
		os.execute("env -u NO_COLOR lua bin/prettypath.lua " .. args .. " < " .. input .. " > " .. output .. " 2> " .. err)
	local code = type(r1) == "number" and math.floor(r1 / 256) or r3
	local out = {}
	for line in io.lines(output) do
		out[#out + 1] = strip(line)
	end
	local e = io.open(err):read("*a")
	os.remove(input)
	os.remove(output)
	os.remove(err)
	return out, e, code
end

-- raw CLI output (escapes kept) for one missing file
local function raw(args)
	local h = io.popen("echo /nonexistent/x.lua | env -u NO_COLOR lua bin/prettypath.lua " .. args)
	local out = h:read("*a")
	h:close()
	return out
end

describe("regressions", function()
	local prettypath

	setup(function()
		prettypath = require("prettypath")
	end)

	it("keeps % in names and paths", function()
		local out = strip(prettypath.pretty_path("/tmp/50%off.txt", { format = "%path%|%name%" }))
		assert.are.equal("/tmp/50%off.txt|50%off.txt", out)
	end)

	it("formats top-level, trailing-slash, relative and ./ paths", function()
		local fmt = { format = "%path%|%dir%|%name%" }
		assert.are.equal("/etc|/|etc", strip(prettypath.pretty_path("/etc", fmt)))
		assert.are.equal("/etc|/|etc", strip(prettypath.pretty_path("/etc/", fmt)))
		assert.are.equal("/||/", strip(prettypath.pretty_path("/", fmt)))
		assert.are.equal("lib/x.sh|lib/|x.sh", strip(prettypath.pretty_path("lib/x.sh", fmt)))
		assert.are.equal("README.md||README.md", strip(prettypath.pretty_path("README.md", fmt)))
		assert.are.equal("./a/b.txt|a/|b.txt", strip(prettypath.pretty_path("./a/b.txt", fmt)))
	end)

	it("replaces HOME only as a prefix, literally", function()
		local home = os.getenv("HOME")
		local fmt = { format = "%dir%" }
		assert.are.equal("~/x/", strip(prettypath.pretty_path(home .. "/x/y.lua", fmt)))
		assert.are.equal("/srv" .. home .. "/", strip(prettypath.pretty_path("/srv" .. home .. "/y", fmt)))
	end)

	it("still reads a score before an absolute path", function()
		local out = strip(prettypath.pretty_path("12.5 /etc/hosts", { format = "%score%|%path%" }))
		assert.are.equal(" 12.50|/etc/hosts", out)
	end)

	it("treats a trailing slash as a directory", function()
		local dir = prettypath.pretty_path("/nonexistent/dir/", { format = "%icon%" })
		local file = prettypath.pretty_path("/nonexistent/dir", { format = "%icon%" })
		assert.are_not.equal(dir, file)
	end)

	it("treats only %token% as tokens; other text and % are literal", function()
		local out = strip(prettypath.pretty_path("/etc/hosts", { format = "file: %name% (100%)" }))
		assert.are.equal("file: hosts (100%)", out)
	end)

	describe("cli", function()
		it("fails once, up front, on an unknown token", function()
			local out, err, code = cli("--format=%nope%", { "/etc/hosts" })
			assert.are.equal(0, #out)
			assert.is_truthy(err:match("unknown format token %%nope%%"))
			assert.are.equal(2, code)
		end)

		it("--stat_file=false does not stat (a missing file is not marked missing)", function()
			local missing = cli("--stat_file=true --format=%name%", { "/nonexistent/x.lua" })
			local nostat = cli("--stat_file=false --format=%name%", { "/nonexistent/x.lua" })
			assert.are.equal("x.lua", missing[1])
			assert.are.equal("x.lua", nostat[1])
			assert.are_not.equal(raw("--stat_file=true --format=%name%"), raw("--stat_file=false --format=%name%"))
		end)

		it("--stat_file=auto (the default) stats only formats with a metadata token", function()
			local default = raw("--format=%name%")
			assert.are.equal(raw("--stat_file=false --format=%name%"), default)
			assert.are.equal(raw("--stat_file=auto --format=%name%"), default)
			-- %mod% needs the stat: the missing file is dimmed, as with --stat_file=true (dates stripped: the
			-- two runs may straddle a second)
			local function nodate(s)
				return (s:gsub("%d+/%d+/%d+ %d+:%d+:%d+", ""))
			end
			local auto = nodate(raw("--format=%name%%mod%"))
			assert.are.equal(nodate(raw("--stat_file=true --format=%name%%mod%")), auto)
			assert.are_not.equal(nodate(raw("--stat_file=false --format=%name%%mod%")), auto)
		end)

		it("prints the size of an existing file by default", function()
			local f = os.tmpname()
			local h = io.open(f, "w")
			h:write(string.rep("x", 2048))
			h:close()
			local out = cli("--format=%size%", { f })
			os.remove(f)
			assert.is_truthy(out[1]:match("^2"))
			assert.is_truthy(out[1]:match("[kK]"))
		end)

		it("finds its modules when run from another directory", function()
			local cwd = io.popen("pwd"):read("*l")
			local out =
				io.popen("cd / && echo /etc/hosts | lua " .. cwd .. "/bin/prettypath.lua --format='%name%|%dir%' 2>&1")
					:read("*a")
			assert.are.equal("hosts|/etc/", strip(out):gsub("\n$", ""))
		end)

		it("prints one line per input line", function()
			local input = { "/etc", "/etc/", "lib/x.sh", "", "/a b/c%d.txt", "README.md" }
			local out = cli("--stat_file=false --format=%path%", input)
			assert.are.same({ "/etc", "/etc", "lib/x.sh", "", "/a b/c%d.txt", "README.md" }, out)
		end)
	end)
end)

describe("library use", function()
	insulate("require() with the host program's arg", function()
		it("does not read arg as prettypath options", function()
			local saved = _G.arg
			_G.arg = { "--format=%name%", "--stat_file=false", "--output_stats=true" }
			for name in pairs(package.loaded) do
				if name == "prettypath" or name:match("^prettypath%.") then
					package.loaded[name] = nil
				end
			end
			local opts = require("prettypath.opts")
			_G.arg = saved
			-- the default format separates tokens with U+2007 (figure space); only check arg was not applied
			assert.are_not.equal("%name%", opts.format)
			assert.is_truthy(opts.format:find("%path%", 1, true))
			assert.are.equal("auto", opts.stat_file)
			assert.is_false(opts.output_stats)
		end)
	end)

	describe("opts.apply_args", function()
		local opts
		local saved

		before_each(function()
			opts = require("prettypath.opts")
			saved = { format = opts.format, stat_file = opts.stat_file, output_stats = opts.output_stats }
		end)

		after_each(function()
			for k, v in pairs(saved) do
				opts[k] = v
			end
		end)

		it("parses format, stat_file (auto/bool) and output_stats", function()
			opts.apply_args({ "--format=%name%", "--stat_file=AUTO", "--output_stats=yes" })
			assert.are.equal("%name%", opts.format)
			assert.are.equal("auto", opts.stat_file)
			assert.is_true(opts.output_stats)
			opts.apply_args({ "--stat_file=false" })
			assert.is_false(opts.stat_file)
			opts.apply_args({ "--stat_file=true" })
			assert.is_true(opts.stat_file)
		end)

		it("is not an option key", function()
			for k in pairs(opts) do
				assert.are_not.equal("apply_args", k)
			end
		end)
	end)

	describe("pretty_dir and pretty_file", function()
		local prettypath = require("prettypath")

		it("return the formatted string", function()
			local fmt = { format = "%icon%|%name%" }
			local dir = prettypath.pretty_dir("/nonexistent/src", fmt)
			local file = prettypath.pretty_file("/nonexistent/src", fmt)
			assert.is_string(dir)
			assert.is_string(file)
			assert.is_truthy(strip(dir):match("|src$"))
			assert.are.equal(prettypath.pretty_path("/nonexistent/src/", fmt), dir)
			assert.are_not.equal(dir, file)
		end)
	end)

	describe("compile_format.needs_stat", function()
		local utils = require("prettypath.utils")

		it("is set only by metadata tokens", function()
			assert.is_nil(utils.compile_format("%path% %icon% %dir%%name% %score%").needs_stat)
			for token in pairs(utils.stat_tokens) do
				assert.is_true(utils.compile_format("%name% %" .. token .. "%").needs_stat, token)
			end
		end)
	end)

	describe("stats bookkeeping", function()
		local prettypath = require("prettypath")
		local opts = require("prettypath.opts")

		after_each(function()
			opts.output_stats = false
			opts.stat_file = "auto"
		end)

		it("keeps no path lists without output_stats", function()
			local unassigned, missing = #prettypath.stats.unassigned, #prettypath.stats.missing
			opts.stat_file = true
			prettypath.pretty_path("/nonexistent/x.zzunknown")
			assert.are.equal(unassigned, #prettypath.stats.unassigned)
			assert.are.equal(missing, #prettypath.stats.missing)
		end)

		it("collects unassigned and missing paths with output_stats", function()
			local unassigned, missing = #prettypath.stats.unassigned, #prettypath.stats.missing
			opts.output_stats = true
			opts.stat_file = true
			prettypath.pretty_path("/nonexistent/x.zzunknown")
			assert.are.equal(unassigned + 1, #prettypath.stats.unassigned)
			assert.are.equal(missing + 1, #prettypath.stats.missing)
		end)
	end)
end)

describe("rockspec", function()
	it("installs only the CLI as a command, and no scripts as modules", function()
		local spec = io.open("prettypath-dev-4.rockspec"):read("*a")
		assert.is_falsy(spec:find('["bin.', 1, true))
		assert.is_falsy(spec:find("prettypath_test", 1, true))
		assert.is_truthy(spec:find('["prettypath"] = "bin/prettypath.lua"', 1, true))
	end)

	it("installs every module in prettypath/", function()
		local spec = io.open("prettypath-dev-4.rockspec"):read("*a")
		for file in io.popen("ls prettypath/*.lua"):lines() do
			local mod = file:match("^prettypath/(.+)%.lua$")
			assert.is_truthy(spec:find('["prettypath.' .. mod .. '"]', 1, true), mod .. " missing from rockspec")
		end
	end)
end)
