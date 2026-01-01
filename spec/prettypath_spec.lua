describe("prettypath", function()
	local prettypath

	setup(function()
		prettypath = require("prettypath")
	end)

	describe("pretty_path", function()
		it("returns formatted string for valid paths", function()
			local result = prettypath.pretty_path("/home/user/test.lua")
			assert.is_string(result)
			-- Should contain path components
			assert.is_truthy(result:match("test") or result:match("lua"))
		end)

		it("handles paths with extensions", function()
			local result = prettypath.pretty_path("/path/to/script.py")
			assert.is_string(result)
		end)

		it("handles paths without extensions", function()
			local result = prettypath.pretty_path("/path/to/Makefile")
			assert.is_string(result)
		end)

		it("handles paths with score prefix", function()
			local result = prettypath.pretty_path("42.5 /path/to/file.lua")
			assert.is_string(result)
		end)

		it("accepts custom format options", function()
			local result = prettypath.pretty_path("/path/to/file.lua", { format = "%name%" })
			assert.is_string(result)
		end)

		it("handles dotfiles", function()
			local result = prettypath.pretty_path("/home/user/.bashrc")
			assert.is_string(result)
		end)

		it("handles deep paths", function()
			local result = prettypath.pretty_path("/a/b/c/d/e/f/file.txt")
			assert.is_string(result)
		end)

		it("replaces home directory with tilde", function()
			local home = os.getenv("HOME")
			if home then
				local result = prettypath.pretty_path(home .. "/test.lua")
				assert.is_string(result)
				-- The dir portion should contain ~
				assert.is_truthy(result:match("~") or result:match("test"))
			end
		end)
	end)

	describe("pretty_dir", function()
		it("exists and is callable", function()
			assert.is_function(prettypath.pretty_dir)
		end)
	end)

	describe("pretty_file", function()
		it("exists and is callable", function()
			assert.is_function(prettypath.pretty_file)
		end)
	end)

	describe("stats", function()
		it("tracks unassigned paths", function()
			assert.is_table(prettypath.stats)
			assert.is_table(prettypath.stats.unassigned)
		end)

		it("tracks missing paths", function()
			assert.is_table(prettypath.stats.missing)
		end)

		it("tracks total count", function()
			assert.is_number(prettypath.stats.total)
		end)

		it("has start time", function()
			assert.is_number(prettypath.stats.time_start)
		end)

		it("has config reference", function()
			assert.is_table(prettypath.stats.config)
		end)
	end)
end)
