-- scripts/install-launcher.sh: the launcher make install writes over the luarocks wrapper
local function sh_quote(s)
	return "'" .. s:gsub("'", "'\\''") .. "'"
end

local function read(path)
	local f = io.open(path)
	if not f then
		return nil
	end
	local s = f:read("*a")
	f:close()
	return s
end

-- run a shell command; returns stdout, stderr and the exit code
local function run(cmd)
	local out, err = os.tmpname(), os.tmpname()
	local r1, _, r3 = os.execute(cmd .. " > " .. out .. " 2> " .. err)
	local code = type(r1) == "number" and math.floor(r1 / 256) or r3
	local o, e = read(out), read(err)
	os.remove(out)
	os.remove(err)
	return o, e, code
end

describe("install-launcher", function()
	local cwd = io.popen("pwd"):read("*l")
	local real_lua = io.popen("command -v lua"):read("*l")
	local dir, launcher, record

	-- an interpreter that records its name and then runs the real lua
	local function fake_lua(path, name)
		local f = io.open(path, "w")
		f:write("#!/bin/sh\necho " .. name .. " >> " .. sh_quote(record) .. "\nexec " .. sh_quote(real_lua) .. ' "$@"\n')
		f:close()
		run("chmod +x " .. sh_quote(path))
	end

	local function generate(script, fallback)
		return run(
			"bash scripts/install-launcher.sh "
				.. table.concat({ sh_quote(launcher), sh_quote(cwd), sh_quote(cwd), sh_quote(script), sh_quote(fallback) }, " ")
		)
	end

	before_each(function()
		dir = os.tmpname()
		os.remove(dir)
		-- a space and a quote: the generated sh must quote the paths it holds
		dir = dir .. " it's"
		run("mkdir -p " .. sh_quote(dir .. "/bin") .. " " .. sh_quote(dir .. "/path"))
		launcher = dir .. "/prettypath"
		record = dir .. "/used"
		fake_lua(dir .. "/fallback-lua", "fallback")
		fake_lua(dir .. "/path/luajit", "luajit")
		fake_lua(dir .. "/override-lua", "override")
	end)

	after_each(function()
		run("rm -rf " .. sh_quote(dir))
	end)

	it("writes an executable launcher that runs prettypath", function()
		local _, err, code = generate(cwd .. "/bin/prettypath.lua", dir .. "/fallback-lua")
		assert.are.equal(0, code, err)
		local out = run("echo /etc/hosts | " .. sh_quote(launcher) .. " --color=never --format=%name%")
		assert.are.equal("hosts\n", out)
		assert.is_truthy(run(sh_quote(launcher) .. " --version"):match("^prettypath %d+%.%d+%.%d+"))
	end)

	it("runs a script from a path with spaces and quotes", function()
		run("cp bin/prettypath.lua " .. sh_quote(dir .. "/bin/prettypath.lua"))
		local _, err, code = generate(dir .. "/bin/prettypath.lua", dir .. "/fallback-lua")
		assert.are.equal(0, code, err)
		assert.are.equal("hosts\n", run("echo /etc/hosts | " .. sh_quote(launcher) .. " --color=never --format=%name%"))
	end)

	it("picks luajit from PATH, else the fallback; PRETTYPATH_LUA overrides both", function()
		generate(cwd .. "/bin/prettypath.lua", dir .. "/fallback-lua")
		run("mkdir -p " .. sh_quote(dir .. "/empty"))
		-- the fake luajit first on PATH; then a PATH with no luajit at all (the launcher needs only sh
		-- builtins and the fallback's absolute path)
		local with_jit = "PATH=" .. sh_quote(dir .. "/path:" .. os.getenv("PATH")) .. " "
		local no_jit = "PATH=" .. sh_quote(dir .. "/empty") .. " "
		run(with_jit .. sh_quote(launcher) .. " --version")
		run(no_jit .. sh_quote(launcher) .. " --version")
		run(with_jit .. "PRETTYPATH_LUA=" .. sh_quote(dir .. "/override-lua") .. " " .. sh_quote(launcher) .. " --version")
		assert.are.equal("luajit\nfallback\noverride\n", read(record))
	end)

	it("keeps a caller's LUA_PATH after its own", function()
		generate(cwd .. "/bin/prettypath.lua", dir .. "/fallback-lua")
		local text = read(launcher)
		assert.is_truthy(text:find('LUA_PATH="$lua_dir/?.lua;$lua_dir/?/init.lua;${LUA_PATH:-;}"', 1, true))
		assert.is_truthy(text:find('LUA_CPATH="$lib_dir/?.so;${LUA_CPATH:-;}"', 1, true))
	end)

	it("fails on a wrong argument count or a missing script, leaving no launcher", function()
		local _, err, code = run("bash scripts/install-launcher.sh " .. sh_quote(launcher))
		assert.are.equal(2, code)
		assert.is_truthy(err:match("usage"))
		_, err, code = generate(dir .. "/nope.lua", dir .. "/fallback-lua")
		assert.are.equal(1, code)
		assert.is_truthy(err:match("no script"))
		assert.is_nil(read(launcher))
	end)
end)
