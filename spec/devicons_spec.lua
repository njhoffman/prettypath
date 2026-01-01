describe("devicons", function()
	local devicons

	setup(function()
		devicons = require("prettypath.devicons")
	end)

	describe("get", function()
		it("returns icon data for known extensions", function()
			local icon = devicons.get("test.lua", "file")
			assert.is_not_nil(icon)
			assert.equals("Lua", icon.name)
			assert.is_not_nil(icon.icon)
			assert.is_not_nil(icon.color)
		end)

		it("returns icon data for js files", function()
			local icon = devicons.get("app.js", "file")
			assert.equals("Js", icon.name)
		end)

		it("returns icon data for typescript files", function()
			local icon = devicons.get("component.tsx", "file")
			assert.equals("Tsx", icon.name)
		end)

		it("returns icon data for python files", function()
			local icon = devicons.get("script.py", "file")
			assert.equals("Py", icon.name)
		end)

		it("returns default icon for unknown extensions", function()
			local icon = devicons.get("file.unknownext", "file")
			assert.equals("Default", icon.name)
		end)

		it("returns directory icon for directories", function()
			local icon = devicons.get("somedir", "directory")
			assert.equals("Directory", icon.name)
		end)

		it("matches exact filenames", function()
			local icon = devicons.get("Dockerfile", "file")
			assert.equals("Dockerfile", icon.name)
		end)

		it("matches dotfiles", function()
			local icon = devicons.get(".gitignore", "file")
			assert.equals("GitIgnore", icon.name)
		end)

		it("matches package.json", function()
			local icon = devicons.get("package.json", "file")
			assert.equals("PackageJson", icon.name)
		end)
	end)

	describe("get_by_filetype", function()
		it("returns icon for lua filetype", function()
			local icon = devicons.get_by_filetype("lua")
			assert.equals("Lua", icon.name)
		end)

		it("returns icon for python filetype", function()
			local icon = devicons.get_by_filetype("python")
			assert.equals("Py", icon.name)
		end)

		it("returns default for unknown filetype", function()
			local icon = devicons.get_by_filetype("unknownfiletype")
			assert.equals("Default", icon.name)
		end)
	end)

	describe("get_icons", function()
		it("returns the icons table", function()
			local icons = devicons.get_icons()
			assert.is_table(icons)
			assert.is_not_nil(icons["lua"])
			assert.is_not_nil(icons["/"])
		end)
	end)

	describe("override", function()
		it("allows overriding existing icons", function()
			devicons.override({
				["testoverride"] = {
					icon = "X",
					color = "#ffffff",
					name = "TestOverride",
				},
			})
			local icon = devicons.get("file.testoverride", "file")
			assert.equals("TestOverride", icon.name)
			assert.equals("X", icon.icon)
		end)
	end)
end)
