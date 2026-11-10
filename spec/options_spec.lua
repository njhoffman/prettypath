-- 0.2.0 options: --base, --dirs, --field/--delimiter, --color/NO_COLOR, "-" for metadata without data,
-- bare flags, and the help/completion command
local function strip(s)
	return (s:gsub("\27%[[0-9;]*m", ""))
end

local function sh_quote(s)
	return "'" .. s:gsub("'", "'\\''") .. "'"
end

-- run a shell command line, feeding it lines; returns stdout (raw), stderr and the exit code
local function run(cmd, lines)
	local input, output, err = os.tmpname(), os.tmpname(), os.tmpname()
	local f = io.open(input, "w")
	if lines then
		f:write(table.concat(lines, "\n"), "\n")
	end
	f:close()
	-- os.execute returns the raw status in Lua 5.1 (code * 256), (ok, "exit", code) in 5.2+
	local r1, _, r3 = os.execute(cmd .. " < " .. input .. " > " .. output .. " 2> " .. err)
	local code = type(r1) == "number" and math.floor(r1 / 256) or r3
	local out = io.open(output):read("*a")
	local e = io.open(err):read("*a")
	os.remove(input)
	os.remove(output)
	os.remove(err)
	return out, e, code
end

-- the CLI with NO_COLOR cleared (the caller's environment must not change the result)
local function cli(args, lines, env)
	return run("env -u NO_COLOR " .. (env or "") .. " lua bin/prettypath.lua " .. args, lines)
end

local function out_lines(s)
	local t = {}
	for line in (s .. ""):gmatch("([^\n]*)\n") do
		t[#t + 1] = strip(line)
	end
	return t
end

describe("--base", function()
	local prettypath = require("prettypath")
	local opts = require("prettypath.opts")
	local fmt = { format = "%path%|%dir%|%name%" }

	after_each(function()
		opts.base = nil
	end)

	it("drops the base from %dir% and keeps %path%", function()
		opts.base = "/srv/x"
		assert.are.equal("/srv/x/a/b.lua|a/|b.lua", strip(prettypath.pretty_path("/srv/x/a/b.lua", fmt)))
		assert.are.equal("/srv/x/b.lua||b.lua", strip(prettypath.pretty_path("/srv/x/b.lua", fmt)))
	end)

	it("shows the base itself by its name, with an empty %dir%", function()
		opts.base = "/srv/x"
		assert.are.equal("/srv/x||x", strip(prettypath.pretty_path("/srv/x", fmt)))
		assert.are.equal("/srv/x||x", strip(prettypath.pretty_path("/srv/x/", fmt)))
	end)

	it("leaves paths outside the base alone, including a sibling with the base as a name prefix", function()
		opts.base = "/srv/x"
		assert.are.equal("/srv/y/c|/srv/y/|c", strip(prettypath.pretty_path("/srv/y/c", fmt)))
		assert.are.equal("/srv/xy/c|/srv/xy/|c", strip(prettypath.pretty_path("/srv/xy/c", fmt)))
	end)

	it("ignores trailing slashes and expands ~", function()
		local home = os.getenv("HOME")
		opts.base = "/srv/x///"
		assert.are.equal("a/", strip(prettypath.pretty_path("/srv/x/a/b", { format = "%dir%" })))
		opts.base = "~/q"
		assert.are.equal("r/", strip(prettypath.pretty_path(home .. "/q/r/s.md", { format = "%dir%" })))
		-- outside the base, HOME still becomes ~
		assert.are.equal("~/z/", strip(prettypath.pretty_path(home .. "/z/s.md", { format = "%dir%" })))
	end)

	it("takes / as a base", function()
		opts.base = "/"
		assert.are.equal("a/", strip(prettypath.pretty_path("/a/b.lua", { format = "%dir%" })))
	end)

	it("works from the command line", function()
		local out = cli("--base=/srv/x/ --format='%path%|%dir%|%name%'", { "/srv/x/a/b.lua" })
		assert.are.same({ "/srv/x/a/b.lua|a/|b.lua" }, out_lines(out))
	end)
end)

describe("--dirs", function()
	it("gives every path the directory icon, as a trailing slash does", function()
		local dirs = cli("--dirs --format=%icon%", { "/nonexistent/src" })
		local slash = cli("--format=%icon%", { "/nonexistent/src/" })
		local file = cli("--format=%icon%", { "/nonexistent/src" })
		assert.are.equal(slash, dirs)
		assert.are_not.equal(file, dirs)
	end)

	it("takes --dirs=false", function()
		assert.are.equal(cli("--format=%icon%", { "/x/y" }), cli("--dirs=false --format=%icon%", { "/x/y" }))
	end)
end)

describe("--field", function()
	it("formats one field and passes the others through", function()
		local out = cli("--field=2 --format=%name%", { "12\t/etc/hosts\textra" })
		assert.are.same({ "12\thosts\textra" }, out_lines(out))
	end)

	it("counts negative fields from the end", function()
		local out = cli("--field=-1 --format=%name%", { "a\tb\t/etc/hosts", "/x/y" })
		assert.are.same({ "a\tb\thosts", "y" }, out_lines(out))
	end)

	it("prints a line without that field unchanged", function()
		local out = cli("--field=3 --format=%name%", { "1\t/etc/hosts", "/a/b", "" })
		assert.are.same({ "1\t/etc/hosts", "/a/b", "" }, out_lines(out))
	end)

	it("splits on a literal --delimiter (not a pattern), and takes \\t for a tab", function()
		assert.are.same({ "a.b.hosts" }, out_lines(cli("--field=3 --delimiter=. --format=%name%", { "a.b./etc/hosts" })))
		assert.are.same(
			{ "x::hosts::y" },
			out_lines(cli("--field=2 --delimiter=:: --format=%name%", { "x::/etc/hosts::y" }))
		)
		assert.are.same({ "1\thosts" }, out_lines(cli("--field=2 '--delimiter=\\t' --format=%name%", { "1\t/etc/hosts" })))
	end)

	it("rejects field 0, a non-number and an empty delimiter up front", function()
		for _, args in ipairs({ "--field=0", "--field=x", "--field=1.5", "--field=1 --delimiter=" }) do
			local out, err, code = cli(args, { "/etc/hosts" })
			assert.are.equal("", out, args)
			assert.is_truthy(err:match("^prettypath: "), args)
			assert.are.equal(2, code, args)
		end
	end)

	it("is available to library callers as pretty_line", function()
		local prettypath = require("prettypath")
		local opts = require("prettypath.opts")
		opts.field = 2
		local ok, out = pcall(prettypath.pretty_line, "9\t/etc/hosts", { format = "%name%" })
		opts.field = nil
		assert.is_true(ok)
		assert.are.equal("9\thosts", strip(out))
		assert.are.equal("hosts", strip(prettypath.pretty_line("/etc/hosts", { format = "%name%" })))
	end)
end)

describe("--color and NO_COLOR", function()
	local has_escape = function(s)
		return s:find("\27[", 1, true) ~= nil
	end

	it("colors by default, even into a pipe", function()
		assert.is_true(has_escape(cli("--format=%name%", { "/etc/hosts" })))
	end)

	it("--color=never prints no escapes but keeps the icon", function()
		local never = cli("--color=never --format=%icon%%name%", { "/etc/hosts" })
		assert.is_false(has_escape(never))
		assert.are.equal(strip(cli("--format=%icon%%name%", { "/etc/hosts" })), never)
	end)

	it("--color=auto prints no escapes into a pipe", function()
		assert.is_false(has_escape(cli("--color=auto --format=%name%", { "/etc/hosts" })))
	end)

	it("NO_COLOR turns color off; an explicit --color wins over it", function()
		assert.is_false(has_escape(cli("--format=%name%", { "/etc/hosts" }, "NO_COLOR=1")))
		assert.is_true(has_escape(cli("--color=always --format=%name%", { "/etc/hosts" }, "NO_COLOR=1")))
		-- an empty NO_COLOR is unset (no-color.org)
		assert.is_true(has_escape(cli("--format=%name%", { "/etc/hosts" }, "NO_COLOR=")))
	end)

	it("rejects an unknown mode up front", function()
		local out, err, code = cli("--color=sometimes", { "/etc/hosts" })
		assert.are.equal("", out)
		assert.is_truthy(err:match("always, never or auto"))
		assert.are.equal(2, code)
	end)
end)

describe("metadata tokens without data", function()
	it('print "-" for a missing file, and the rest of the line is formatted', function()
		local out, err = cli("--format='%size%|%mod%|%access_ago%|%create%|%name%'", { "/nonexistent/x.lua" })
		assert.are.same({ "-|-|-|-|x.lua" }, out_lines(out))
		assert.are.equal("", err)
	end)

	it('print "-" with --stat_file=false', function()
		local out = cli("--stat_file=false --format='%size%|%mod_ago%|%name%'", { "/etc/hosts" })
		assert.are.same({ "-|-|hosts" }, out_lines(out))
	end)

	it("still print real values for an existing file", function()
		local out = out_lines(cli("--format='%size%|%mod%'", { "/etc/hosts" }))[1]
		assert.is_falsy(out:match("^%-|"))
		assert.is_falsy(out:match("|%-$"))
	end)
end)

describe("help and completion", function()
	local cli_mod = require("prettypath.cli")

	it("help lists every option", function()
		local help = cli("--help")
		for _, o in ipairs(cli_mod.options) do
			assert.is_truthy(help:find("--" .. o.name, 1, true), o.name)
			if o.short then
				assert.is_truthy(help:find("-" .. o.short .. ", --" .. o.name, 1, true), o.name)
			end
		end
		assert.is_truthy(help:find("completion bash|zsh|fish", 1, true))
	end)

	for _, shell in ipairs({ "bash", "zsh", "fish" }) do
		it("prints a " .. shell .. " script that names every option", function()
			local out, err, code = cli("completion " .. shell)
			assert.are.equal(0, code)
			assert.are.equal("", err)
			for _, o in ipairs(cli_mod.options) do
				assert.is_truthy(out:find(o.name, 1, true), shell .. ": " .. o.name)
			end
		end)
	end

	for _, shell in ipairs({ "bash", "zsh" }) do
		it("prints " .. shell .. " that parses (" .. shell .. " -n)", function()
			if os.execute("command -v " .. shell .. " > /dev/null 2>&1") ~= 0 then
				pending(shell .. " not installed")
				return
			end
			local _, err, code = run("lua bin/prettypath.lua completion " .. shell .. " | " .. shell .. " -n")
			assert.are.equal("", err)
			assert.are.equal(0, code)
		end)
	end

	it("completes options, values and the subcommand in bash", function()
		local script = cli("completion bash")
		local f = os.tmpname()
		local h = io.open(f, "w")
		h:write(script)
		h:close()
		local driver = table.concat({
			"source " .. sh_quote(f),
			't() { COMP_WORDS=("$@"); COMP_CWORD=$((${#COMP_WORDS[@]}-1)); COMPREPLY=(); _prettypath;'
				.. ' echo "${COMPREPLY[*]}"; }',
			"t prettypath --co",
			"t prettypath --color = au",
			"t prettypath --stat_file = ''",
			"t prettypath completion z",
			"t prettypath --dirs --fi",
		}, "\n")
		local out = run("bash -c " .. sh_quote(driver))
		os.remove(f)
		assert.are.same({ "--color=", "auto", "auto true false", "zsh", "--field=" }, out_lines(out))
	end)

	it("rejects an unknown or missing shell", function()
		for _, args in ipairs({ "completion tcsh", "completion" }) do
			local out, err, code = cli(args)
			assert.are.equal("", out, args)
			assert.is_truthy(err:match("bash, zsh or fish"), args)
			assert.are.equal(2, code, args)
		end
	end)
end)

describe("bare flags", function()
	it("--output_stats alone means true", function()
		local opts = require("prettypath.opts")
		local saved = opts.output_stats
		opts.apply_args({ "--output_stats" })
		local got = opts.output_stats
		opts.output_stats = saved
		assert.is_true(got)
	end)
end)
