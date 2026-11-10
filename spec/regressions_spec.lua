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
	local r1, _, r3 = os.execute("lua bin/prettypath.lua " .. args .. " < " .. input .. " > " .. output .. " 2> " .. err)
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
			local missing = cli("--format=%name%", { "/nonexistent/x.lua" })
			local nostat = cli("--stat_file=false --format=%name%", { "/nonexistent/x.lua" })
			assert.are.equal("x.lua", missing[1])
			assert.are.equal("x.lua", nostat[1])
			local raw_missing = io.popen("echo /nonexistent/x.lua | lua bin/prettypath.lua --format=%name%"):read("*a")
			local raw_nostat = io.popen("echo /nonexistent/x.lua | lua bin/prettypath.lua --stat_file=false --format=%name%")
				:read("*a")
			assert.are_not.equal(raw_missing, raw_nostat)
		end)

		it("prints one line per input line", function()
			local input = { "/etc", "/etc/", "lib/x.sh", "", "/a b/c%d.txt", "README.md" }
			local out = cli("--stat_file=false --format=%path%", input)
			assert.are.same({ "/etc", "/etc", "lib/x.sh", "", "/a b/c%d.txt", "README.md" }, out)
		end)
	end)
end)
