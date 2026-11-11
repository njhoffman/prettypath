-- 0.8.0: size and date tokens colored, --time_format, broken symlinks
local function sh_quote(s)
	return "'" .. s:gsub("'", "'\\''") .. "'"
end

local function cli(args, input)
	local inp, out, err = os.tmpname(), os.tmpname(), os.tmpname()
	local f = io.open(inp, "w")
	f:write(input)
	f:close()
	local r1, _, r3 = os.execute(
		"env -u NO_COLOR ${LUA:-lua} bin/prettypath.lua " .. args .. " < " .. inp .. " > " .. out .. " 2> " .. err
	)
	local code = type(r1) == "number" and math.floor(r1 / 256) or r3
	local o = io.open(out):read("*a")
	local e = io.open(err):read("*a")
	os.remove(inp)
	os.remove(out)
	os.remove(err)
	return o, e, code
end

local function strip(s)
	return (s:gsub("\27%[[0-9;]*m", ""))
end

local function escape_of(hex)
	local r, g, b = tonumber(hex:sub(2, 3), 16), tonumber(hex:sub(4, 5), 16), tonumber(hex:sub(6, 7), 16)
	return "\27[38;2;" .. r .. ";" .. g .. ";" .. b .. "m"
end

describe("size and date colors", function()
	local opts = require("prettypath.opts")

	it("colors %size% with colors.size and the dates with colors.date", function()
		local out = cli("--format='%size%|%mod%|%mod_ago%'", "/etc/hosts\n")
		local size, mod, ago = out:match("^(.-)|(.-)|(.-)\n$")
		assert.is_truthy(size:find(escape_of(opts.colors.size), 1, true))
		assert.is_truthy(mod:find(escape_of(opts.colors.date), 1, true))
		assert.is_truthy(ago:find(escape_of(opts.colors.date), 1, true))
	end)

	it('dims the "-" of a token without data', function()
		local out = cli("--format='%size%|%mod%'", "/nonexistent/x\n")
		assert.are.equal("-|-\n", strip(out))
		assert.are.equal(2, select(2, out:gsub(escape_of(opts.colors.missing):gsub("%[", "%%["), "")))
	end)

	it("follows --color=never and --color=256", function()
		assert.is_falsy(cli("--color=never --format=%size%%mod%", "/etc/hosts\n"):find("\27[", 1, true))
		local c256 = cli("--color=256 --format=%size%", "/etc/hosts\n")
		assert.is_truthy(c256:find("\27[38;5;", 1, true))
		assert.is_falsy(c256:find("38;2;", 1, true))
	end)
end)

describe("--time_format", function()
	it("formats %access%, %mod% and %create% with a strftime format", function()
		local out = strip(cli("--time_format='%Y-%m-%d' --format='%access%|%mod%|%create%'", "/etc/hosts\n"))
		assert.is_truthy(out:match("^%d%d%d%d%-%d%d%-%d%d|%d%d%d%d%-%d%d%-%d%d|%d%d%d%d%-%d%d%-%d%d\n$"), out)
	end)

	it("defaults to the locale's date and time, and leaves the _ago forms alone", function()
		local default = strip(cli("--format=%mod%", "/etc/hosts\n"))
		local explicit = strip(cli("--time_format='%x %X' --format=%mod%", "/etc/hosts\n"))
		assert.are.equal(explicit, default)
		local ago = strip(cli("--time_format='%Y' --format=%mod_ago%", "/etc/hosts\n"))
		assert.is_truthy(ago:match("ago\n$") or ago:match("now\n$"), ago)
	end)

	it("is read by library callers per call", function()
		local opts = require("prettypath.opts")
		local prettypath = require("prettypath")
		opts.stat_file = true
		opts.time_format = "%Y"
		local out = strip(prettypath.pretty_path("/etc/hosts", { format = "%mod%" }))
		opts.time_format = "%x %X"
		opts.stat_file = "auto"
		assert.is_truthy(out:match("^%d%d%d%d$"), out)
	end)

	it("rejects an empty format up front", function()
		local out, err, code = cli("--time_format=", "/etc/hosts\n")
		assert.are.equal("", out)
		assert.is_truthy(err:match("%-%-time_format takes"))
		assert.are.equal(2, code)
	end)
end)

describe("broken symlinks", function()
	local dir

	setup(function()
		dir = os.tmpname()
		os.remove(dir)
		os.execute(
			"mkdir -p "
				.. sh_quote(dir)
				.. " && ln -s /nonexistent/target "
				.. sh_quote(dir .. "/broken")
				.. " && ln -s /etc/hosts "
				.. sh_quote(dir .. "/good")
		)
	end)

	teardown(function()
		os.execute("rm -rf " .. sh_quote(dir))
	end)

	local function icon(args, path)
		return strip(cli(args .. " --format=%icon%", path .. "\n"))
	end

	it("get the broken-link icon when a stat runs", function()
		assert.are.equal("󰌺 \n", icon("--stat_file=true", dir .. "/broken"))
	end)

	it("are dimmed like a missing path", function()
		local opts = require("prettypath.opts")
		local out = cli("--stat_file=true --format=%icon%%name%", dir .. "/broken\n")
		assert.is_truthy(out:find(escape_of(opts.colors.missing) .. "󰌺", 1, true))
		assert.is_truthy(out:find(escape_of(opts.colors.missing) .. "broken", 1, true))
	end)

	it("leave a missing path and a working symlink their usual icons", function()
		assert.are_not.equal("󰌺 \n", icon("--stat_file=true", dir .. "/nonexistent"))
		assert.are_not.equal("󰌺 \n", icon("--stat_file=true", dir .. "/good"))
		-- without a stat nothing tells them apart
		assert.are.equal(icon("", dir .. "/good"), icon("", dir .. "/broken"))
	end)
end)
