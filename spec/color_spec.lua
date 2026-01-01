describe("color", function()
	local color

	setup(function()
		color = require("prettypath.color")
	end)

	describe("icon", function()
		it("returns icon with ANSI color codes", function()
			local icon_data = {
				icon = "",
				color = "#51a0cf",
				name = "Lua",
			}
			local result = color.icon(icon_data, false)
			assert.is_string(result)
			-- Should contain the icon
			assert.is_truthy(result:match(""))
			-- Should contain ANSI escape codes
			assert.is_truthy(result:match("\27%["))
		end)

		it("uses missing color when is_missing is true", function()
			local icon_data = {
				icon = "",
				color = "#51a0cf",
				name = "Lua",
			}
			local result = color.icon(icon_data, true)
			assert.is_string(result)
			-- Should still contain the icon
			assert.is_truthy(result:match(""))
		end)

		it("handles double-width icons", function()
			local icon_data = {
				icon = "謹",
				color = "#e37933",
				name = "Xml",
				double = true,
			}
			local result = color.icon(icon_data, false)
			assert.is_string(result)
			-- Double icons should not have trailing space
			assert.is_truthy(result:match("謹"))
		end)
	end)

	describe("name", function()
		it("returns the name string", function()
			local result = color.name("test.lua", false)
			assert.is_string(result)
			assert.is_truthy(result:match("test.lua"))
		end)

		it("handles missing files", function()
			local result = color.name("missing.lua", true)
			assert.is_string(result)
		end)
	end)

	describe("dir", function()
		it("returns the directory with color", function()
			local result = color.dir("/home/user/", false)
			assert.is_string(result)
			assert.is_truthy(result:match("/home/user/") or result:match("home"))
		end)

		it("handles missing directories", function()
			local result = color.dir("/missing/path/", true)
			assert.is_string(result)
		end)

		it("handles empty dirname", function()
			local result = color.dir("", false)
			assert.is_string(result)
		end)
	end)

	describe("score", function()
		it("returns score with color", function()
			local result = color.score("  42.50")
			assert.is_string(result)
			assert.is_truthy(result:match("42") or result:match("\27%["))
		end)
	end)
end)
