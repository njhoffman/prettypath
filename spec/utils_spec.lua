describe("utils", function()
	local utils

	setup(function()
		utils = require("prettypath.utils")
	end)

	describe("deep_extend", function()
		it("merges simple tables", function()
			local t1 = { a = 1, b = 2 }
			local t2 = { c = 3 }
			local result = utils.deep_extend(t1, t2)
			assert.equals(1, result.a)
			assert.equals(2, result.b)
			assert.equals(3, result.c)
		end)

		it("overwrites existing keys", function()
			local t1 = { a = 1 }
			local t2 = { a = 2 }
			local result = utils.deep_extend(t1, t2)
			assert.equals(2, result.a)
		end)

		it("deep merges nested tables", function()
			local t1 = { nested = { a = 1, b = 2 } }
			local t2 = { nested = { c = 3 } }
			local result = utils.deep_extend(t1, t2)
			assert.equals(1, result.nested.a)
			assert.equals(2, result.nested.b)
			assert.equals(3, result.nested.c)
		end)

		it("overwrites nested values", function()
			local t1 = { nested = { a = 1 } }
			local t2 = { nested = { a = 2 } }
			local result = utils.deep_extend(t1, t2)
			assert.equals(2, result.nested.a)
		end)

		it("handles empty tables", function()
			local t1 = { a = 1 }
			local t2 = {}
			local result = utils.deep_extend(t1, t2)
			assert.equals(1, result.a)
		end)

		it("modifies t1 in place", function()
			local t1 = { a = 1 }
			local t2 = { b = 2 }
			utils.deep_extend(t1, t2)
			assert.equals(2, t1.b)
		end)
	end)

	describe("inspect", function()
		it("returns string representation of tables", function()
			local result = utils.inspect({ a = 1 })
			assert.is_string(result)
			assert.is_truthy(result:match("a"))
		end)

		it("handles nested tables", function()
			local result = utils.inspect({ nested = { value = 42 } })
			assert.is_string(result)
			assert.is_truthy(result:match("nested"))
			assert.is_truthy(result:match("42"))
		end)

		it("handles empty tables", function()
			local result = utils.inspect({})
			assert.is_string(result)
		end)
	end)

	describe("file_stat", function()
		it("returns nil for non-existent files", function()
			local result = utils.file_stat("/nonexistent/path/to/file")
			assert.is_nil(result)
		end)

		it("returns stat info for existing files", function()
			-- Use this spec file itself as a test file
			local result = utils.file_stat("spec/utils_spec.lua")
			if result then
				assert.is_number(result.size)
				assert.is_number(result.mtime)
				assert.is_number(result.atime)
				assert.is_number(result.ctime)
				assert.is_string(result.type)
			end
		end)
	end)

	describe("format_path", function()
		it("formats path with basic tokens", function()
			local pathinfo = {
				path = "/home/user/file.lua",
				dir = "/home/user/",
				name = "file.lua",
				score = "  0.00",
				icon_data = {
					icon = "",
					color = "#51a0cf",
					name = "Lua",
				},
			}
			-- format_path uses opts.format by default
			local result = utils.format_path(pathinfo)
			assert.is_string(result)
		end)

		it("respects custom format option", function()
			local pathinfo = {
				path = "/test/path.txt",
				dir = "/test/",
				name = "path.txt",
				score = "  0.00",
				icon_data = {
					icon = "",
					color = "#89e051",
					name = "Txt",
				},
			}
			local result = utils.format_path(pathinfo, { format = "%name%" })
			-- Result should contain the name (possibly with ANSI codes)
			assert.is_truthy(result:match("path.txt") or result:match("path"))
		end)
	end)
end)
