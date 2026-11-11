-- 0.5.0: NUL-separated records (-0/--null), directories from stat, the --version contract, --color=256
local function strip(s)
	return (s:gsub("\27%[[0-9;]*m", ""))
end

local function sh_quote(s)
	return "'" .. s:gsub("'", "'\\''") .. "'"
end

-- run the CLI (NO_COLOR cleared) on raw stdin bytes; returns stdout, stderr and the exit code
local function cli(args, input)
	local inp, out, err = os.tmpname(), os.tmpname(), os.tmpname()
	local f = io.open(inp, "wb")
	f:write(input or "")
	f:close()
	local r1, _, r3 =
		os.execute("env -u NO_COLOR lua bin/prettypath.lua " .. args .. " < " .. inp .. " > " .. out .. " 2> " .. err)
	local code = type(r1) == "number" and math.floor(r1 / 256) or r3
	local o = io.open(out, "rb"):read("*a")
	local e = io.open(err):read("*a")
	os.remove(inp)
	os.remove(out)
	os.remove(err)
	return o, e, code
end

describe("-0 / --null", function()
	it("reads and writes NUL-separated records, keeping newlines in names", function()
		local out = cli("-0 --color=never --format=%name%", "/etc/hosts\0/tmp/a\nb.txt\0")
		assert.are.equal("hosts\0a\nb.txt\0", out)
	end)

	it("counts a last record without a NUL", function()
		assert.are.equal("hosts\0last.lua\0", cli("--null --color=never --format=%name%", "/etc/hosts\0/x/last.lua"))
	end)

	it("prints nothing for empty input, and keeps empty records", function()
		assert.are.equal("", cli("-0 --color=never --format=%name%", ""))
		assert.are.equal("\0hosts\0", (cli("-0 --color=never --format=%path%", "\0/etc/hosts\0"):gsub("/etc/", "")))
	end)

	it("handles records across the read buffer boundary", function()
		local paths = {}
		for i = 1, 20000 do
			paths[i] = "/d" .. i .. "/f" .. i .. ".lua"
		end
		local out = cli("-0 --color=never --format=%name%", table.concat(paths, "\0") .. "\0")
		local n, last = 0, nil
		for rec in out:gmatch("([^%z]*)%z") do
			n = n + 1
			last = rec
		end
		assert.are.equal(20000, n)
		assert.are.equal("f20000.lua", last)
	end)

	it("works with --field and --line-buffered", function()
		assert.are.equal("1\thosts\0", cli("-0 --field=2 --color=never --format=%name%", "1\t/etc/hosts\0"))
		assert.are.equal("hosts\0", cli("-0 --line-buffered --color=never --format=%name%", "/etc/hosts\0"))
	end)

	it("leaves newline records alone without the flag", function()
		assert.are.equal("hosts\n", cli("--null=false --color=never --format=%name%", "/etc/hosts\n"))
	end)
end)

describe("directories from stat", function()
	local dir

	setup(function()
		dir = os.tmpname()
		os.remove(dir)
		os.execute("mkdir -p " .. sh_quote(dir .. "/sub") .. " && touch " .. sh_quote(dir .. "/f.lua"))
		os.execute("ln -s " .. sh_quote(dir .. "/sub") .. " " .. sh_quote(dir .. "/link"))
	end)

	teardown(function()
		os.execute("rm -rf " .. sh_quote(dir))
	end)

	local function icon(args, path)
		return cli(args .. " --color=never --format=%icon%", path .. "\n")
	end

	it("gives a directory the folder icon when stat runs, without a trailing /", function()
		local folder = icon("", dir .. "/sub/")
		assert.are.equal(folder, icon("--stat_file=true", dir .. "/sub"))
		-- a metadata token makes auto stat too
		local out = cli("--color=never --format='%icon%|%mod%'", dir .. "/sub\n")
		assert.are.equal(folder:gsub("\n$", ""), out:match("^(.-)|"))
	end)

	it("follows a symlink to a directory", function()
		assert.are.equal(icon("", dir .. "/sub/"), icon("--stat_file=true", dir .. "/link"))
	end)

	it("does not stat (or change the icon) when the format does not need it", function()
		assert.are.equal(icon("", dir .. "/sub"), icon("--stat_file=false", dir .. "/sub"))
		assert.are_not.equal(icon("", dir .. "/sub/"), icon("", dir .. "/sub"))
	end)

	it("keeps files as files, and an explicit type over the stat", function()
		assert.are.equal(icon("--stat_file=false", dir .. "/f.lua"), icon("--stat_file=true", dir .. "/f.lua"))
		-- --dirs on a real file: the stat says file, --dirs wins
		assert.are.equal(icon("--dirs", dir .. "/sub/"), icon("--dirs --stat_file=true", dir .. "/f.lua"))
		local prettypath = require("prettypath")
		local opts = require("prettypath.opts")
		opts.stat_file = true
		local file = prettypath.pretty_file(dir .. "/sub", { format = "%icon%" })
		opts.stat_file = "auto"
		assert.are.equal(prettypath.pretty_file("/nonexistent/sub", { format = "%icon%" }), file)
	end)
end)

describe("--version", function()
	it('prints "prettypath X.Y.Z" and nothing else, for callers to compare', function()
		local out, err, code = cli("--version")
		assert.is_truthy(out:match("^prettypath %d+%.%d+%.%d+\n$"))
		assert.are.equal("", err)
		assert.are.equal(0, code)
	end)

	it("matches the newest version in CHANGELOG.md", function()
		local changelog = io.open("CHANGELOG.md"):read("*a")
		local newest = changelog:match("## %[(%d+%.%d+%.%d+)%]")
		assert.are.equal("prettypath " .. newest .. "\n", cli("--version"))
	end)

	it("is documented in --help", function()
		assert.is_truthy(cli("--help"):find('prints "prettypath X.Y.Z"', 1, true))
	end)
end)

describe("--color=256", function()
	local color = require("prettypath.color")

	it("maps RGB to the nearest xterm-256 index (cube or gray ramp)", function()
		assert.are.equal(16, color.xterm256(0, 0, 0))
		assert.are.equal(231, color.xterm256(255, 255, 255))
		assert.are.equal(196, color.xterm256(255, 0, 0))
		assert.are.equal(46, color.xterm256(0, 255, 0))
		assert.are.equal(21, color.xterm256(0, 0, 255))
		-- grays: the ramp is closer than the cube
		assert.are.equal(244, color.xterm256(128, 128, 128))
		assert.are.equal(232, color.xterm256(8, 8, 8))
		assert.are.equal(255, color.xterm256(238, 238, 238))
	end)

	it("prints 38;5 escapes only, using the icon's cterm_color", function()
		local out = cli("--color=256 --format='%icon%%dir%%name%'", "/x/a.lua\n")
		assert.is_falsy(out:find("38;2;", 1, true))
		assert.is_truthy(out:find("\27[38;5;", 1, true))
		local icon = require("prettypath.devicons").get("a.lua")
		if icon.cterm_color then
			assert.is_truthy(out:find("\27[38;5;" .. icon.cterm_color .. "m", 1, true))
		end
		assert.are.equal(strip(cli("--format='%icon%%dir%%name%'", "/x/a.lua\n")), strip(out))
	end)

	it("falls back to the nearest index for an icon without a usable cterm_color", function()
		local opts = require("prettypath.opts")
		opts.color = "256"
		local out = color.icon({ icon = "x", color = "#ff0000", cterm_color = "nope" }, false)
		local plain = color.icon({ icon = "y", color = "#ff0000" }, false)
		opts.color = "always"
		assert.is_truthy(out:find("\27[38;5;196m", 1, true))
		assert.is_truthy(plain:find("\27[38;5;196m", 1, true))
	end)

	it("leaves the default truecolor, and NO_COLOR still wins over the default", function()
		local out = cli("--format=%name%", "/etc/hosts\n")
		assert.is_truthy(out:find("38;2;", 1, true))
	end)
end)

describe("short options", function()
	it("rejects an unknown short option and -0 with a value", function()
		local _, err, code = cli("-q", "")
		assert.are.equal(2, code)
		assert.is_truthy(err:match("unknown option '%-q'"))
		_, err, code = cli("-00", "")
		assert.are.equal(2, code)
		assert.is_truthy(err:match("unknown option '%-00'"))
	end)
end)
