describe("cli", function()
	describe("help flag", function()
		it("outputs help with --help", function()
			local handle = io.popen("lua bin/prettypath.lua --help 2>&1")
			local result = handle:read("*a")
			handle:close()
			assert.is_truthy(result:match("prettypath"))
			assert.is_truthy(result:match("Usage:"))
			assert.is_truthy(result:match("Options:"))
			assert.is_truthy(result:match("Format Tokens:"))
			assert.is_truthy(result:match("Examples:"))
		end)

		it("outputs help with -h", function()
			local handle = io.popen("lua bin/prettypath.lua -h 2>&1")
			local result = handle:read("*a")
			handle:close()
			assert.is_truthy(result:match("prettypath"))
			assert.is_truthy(result:match("Usage:"))
		end)

		it("documents all format tokens", function()
			local handle = io.popen("lua bin/prettypath.lua --help 2>&1")
			local result = handle:read("*a")
			handle:close()
			local tokens = {
				"%%path%%",
				"%%icon%%",
				"%%dir%%",
				"%%name%%",
				"%%score%%",
				"%%size%%",
				"%%access%%",
				"%%mod%%",
				"%%create%%",
				"%%access_ago%%",
				"%%mod_ago%%",
				"%%create_ago%%",
			}
			for _, token in ipairs(tokens) do
				assert.is_truthy(result:match(token), "Missing token: " .. token)
			end
		end)

		it("documents all options", function()
			local handle = io.popen("lua bin/prettypath.lua --help 2>&1")
			local result = handle:read("*a")
			handle:close()
			assert.is_truthy(result:match("%-h, %-%-help"))
			assert.is_truthy(result:match("%-v, %-%-version"))
			assert.is_truthy(result:match("%-%-format="))
			assert.is_truthy(result:match("%-%-stat_file="))
			assert.is_truthy(result:match("%-%-output_stats="))
		end)
	end)

	describe("version flag", function()
		it("outputs version with --version", function()
			local handle = io.popen("lua bin/prettypath.lua --version 2>&1")
			local result = handle:read("*a")
			handle:close()
			assert.is_truthy(result:match("prettypath"))
			assert.is_truthy(result:match("dev%-3") or result:match("%d+%.%d+"))
		end)

		it("outputs version with -v", function()
			local handle = io.popen("lua bin/prettypath.lua -v 2>&1")
			local result = handle:read("*a")
			handle:close()
			assert.is_truthy(result:match("prettypath"))
		end)
	end)

	describe("exit codes", function()
		it("exits 0 on --help", function()
			local result = os.execute("lua bin/prettypath.lua --help > /dev/null 2>&1")
			-- Lua 5.1 returns exit code directly, 5.2+ returns true/nil, code, signal
			if type(result) == "boolean" then
				assert.is_true(result)
			else
				assert.equals(0, result)
			end
		end)

		it("exits 0 on --version", function()
			local result = os.execute("lua bin/prettypath.lua --version > /dev/null 2>&1")
			if type(result) == "boolean" then
				assert.is_true(result)
			else
				assert.equals(0, result)
			end
		end)
	end)
end)
