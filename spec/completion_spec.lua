-- shell completion behavior: zsh through its real completion system (compinit in a zpty, see
-- spec/support/zsh-complete.zsh) and fish through `complete -C`, each pending when the shell is missing.
-- The bash script is driven in options_spec.lua.
local function sh_quote(s)
	return "'" .. s:gsub("'", "'\\''") .. "'"
end

local function run(cmd)
	local out, err = os.tmpname(), os.tmpname()
	local r1, _, r3 = os.execute(cmd .. " > " .. out .. " 2> " .. err)
	local code = type(r1) == "number" and math.floor(r1 / 256) or r3
	local o = io.open(out):read("*a")
	local e = io.open(err):read("*a")
	os.remove(out)
	os.remove(err)
	return o, e, code
end

local function has(cmd)
	return run("command -v " .. cmd) ~= ""
end

local function lines(s)
	local t = {}
	for l in s:gmatch("[^\n]+") do
		t[#t + 1] = l
	end
	return t
end

local function contains(list, want)
	for _, v in ipairs(list) do
		if v == want then
			return true
		end
	end
	return false
end

describe("zsh completion", function()
	local dir

	setup(function()
		dir = os.tmpname()
		os.remove(dir)
		-- in a subshell: run() redirects the command's own stdout
		local zfile = sh_quote(dir .. "/_prettypath")
		run("(mkdir -p " .. sh_quote(dir) .. " && lua bin/prettypath.lua completion zsh > " .. zfile .. ")")
		assert.is_truthy(io.open(dir .. "/_prettypath"):read("*a"):match("^#compdef prettypath"))
	end)

	teardown(function()
		run("rm -rf " .. sh_quote(dir))
	end)

	-- the candidates zsh offers for a command line (then Tab)
	local function complete(line)
		local out = dir .. "/out"
		local _, err, code =
			run("zsh spec/support/zsh-complete.zsh " .. sh_quote(dir) .. " " .. sh_quote(out) .. " " .. sh_quote(line))
		assert.are.equal(0, code, "zsh-complete: " .. err)
		return lines(io.open(out):read("*a"))
	end

	local function skip_without_zsh()
		if not has("zsh") then
			pending("zsh not installed")
			return true
		end
		if select(3, run("zsh -fc 'zmodload zsh/zpty'")) ~= 0 then
			pending("zsh/zpty not available")
			return true
		end
	end

	it("completes option names", function()
		if skip_without_zsh() then
			return
		end
		assert.are.same({ "--color" }, complete("prettypath --co"))
		local all = complete("prettypath -")
		for _, want in ipairs({ "--base", "--dirs", "--field", "--format", "--null", "-0", "--help", "-h" }) do
			assert.is_true(contains(all, want), want)
		end
	end)

	it("completes option values", function()
		if skip_without_zsh() then
			return
		end
		assert.are.same({ "256", "always", "auto", "never" }, complete("prettypath --color="))
		assert.are.same({ "auto", "false", "true" }, complete("prettypath --stat_file="))
		assert.is_true(contains(complete("prettypath --base=/us"), "usr"))
	end)

	it("completes the completion subcommand's shells", function()
		if skip_without_zsh() then
			return
		end
		assert.are.same({ "bash", "fish", "zsh" }, complete("prettypath completion "))
	end)

	it("offers other options after -0, and nothing after --help", function()
		if skip_without_zsh() then
			return
		end
		assert.are.same({ "--color" }, complete("prettypath -0 --co"))
		assert.is_false(contains(complete("prettypath -0 -"), "--null"))
		assert.are.same({}, complete("prettypath --help --co"))
	end)
end)

describe("fish completion", function()
	local script

	setup(function()
		script = os.tmpname()
		run("(lua bin/prettypath.lua completion fish > " .. sh_quote(script) .. ")")
		assert.is_truthy(io.open(script):read("*a"):match("^# fish completion"))
	end)

	teardown(function()
		os.remove(script)
	end)

	local function fish(cmd)
		return run("fish --no-config -c " .. sh_quote("source " .. sh_quote(script) .. "; " .. cmd))
	end

	it("parses (fish --no-execute)", function()
		if not has("fish") then
			pending("fish not installed")
			return
		end
		local _, err, code = run("fish --no-execute " .. sh_quote(script))
		assert.are.equal("", err)
		assert.are.equal(0, code)
	end)

	it("completes options, values and the subcommand", function()
		if not has("fish") then
			pending("fish not installed")
			return
		end
		local function names(out)
			local t = {}
			for _, l in ipairs(lines(out)) do
				t[#t + 1] = l:match("^([^\t]+)")
			end
			return t
		end
		assert.is_true(contains(names(fish("complete -C 'prettypath --co'")), "--color"))
		local values = names(fish("complete -C 'prettypath --color='"))
		for _, want in ipairs({ "--color=always", "--color=never", "--color=auto", "--color=256" }) do
			assert.is_true(contains(values, want), want)
		end
		local shells = names(fish("complete -C 'prettypath completion '"))
		for _, want in ipairs({ "bash", "zsh", "fish" }) do
			assert.is_true(contains(shells, want), want)
		end
	end)
end)
