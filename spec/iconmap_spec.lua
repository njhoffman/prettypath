describe("iconmap", function()
	local iconmap

	setup(function()
		iconmap = require("prettypath.iconmap")
	end)

	describe("structure", function()
		it("exports icons table", function()
			assert.is_table(iconmap.icons)
		end)

		it("exports filetypes table", function()
			assert.is_table(iconmap.filetypes)
		end)
	end)

	describe("icons", function()
		it("has directory icon", function()
			assert.is_table(iconmap.icons["/"])
			assert.equals("Directory", iconmap.icons["/"].name)
			assert.is_string(iconmap.icons["/"].icon)
			assert.is_string(iconmap.icons["/"].color)
		end)

		it("has default icon", function()
			assert.is_table(iconmap.icons[""])
			assert.equals("Default", iconmap.icons[""].name)
		end)

		it("has lua icon", function()
			assert.is_table(iconmap.icons["lua"])
			assert.equals("Lua", iconmap.icons["lua"].name)
		end)

		it("has common language icons", function()
			local languages = { "py", "js", "ts", "rb", "go", "rs", "java", "c", "cpp" }
			for _, lang in ipairs(languages) do
				assert.is_table(iconmap.icons[lang], "Missing icon for: " .. lang)
				assert.is_string(iconmap.icons[lang].icon, "Missing icon glyph for: " .. lang)
				assert.is_string(iconmap.icons[lang].color, "Missing color for: " .. lang)
				assert.is_string(iconmap.icons[lang].name, "Missing name for: " .. lang)
			end
		end)

		it("has config file icons", function()
			local configs = { "json", "yaml", "yml", "toml", "ini", "conf" }
			for _, ext in ipairs(configs) do
				assert.is_table(iconmap.icons[ext], "Missing icon for: " .. ext)
			end
		end)

		it("has dotfile icons", function()
			local dotfiles = { ".gitignore", ".bashrc", ".zshrc", ".vimrc" }
			for _, file in ipairs(dotfiles) do
				assert.is_table(iconmap.icons[file], "Missing icon for: " .. file)
			end
		end)

		it("has special file icons", function()
			local specials = { "Dockerfile", "makefile", "LICENSE" }
			for _, file in ipairs(specials) do
				assert.is_table(iconmap.icons[file], "Missing icon for: " .. file)
			end
		end)

		it("icon entries have required fields", function()
			for key, icon in pairs(iconmap.icons) do
				assert.is_string(icon.icon, "Missing icon glyph for key: " .. key)
				assert.is_string(icon.color, "Missing color for key: " .. key)
				assert.is_string(icon.name, "Missing name for key: " .. key)
			end
		end)

		it("colors are valid hex format", function()
			for key, icon in pairs(iconmap.icons) do
				assert.is_truthy(icon.color:match("^#%x%x%x%x%x%x$"), "Invalid color format for " .. key .. ": " .. icon.color)
			end
		end)
	end)

	describe("filetypes", function()
		it("maps lua filetype", function()
			assert.equals("lua", iconmap.filetypes["lua"])
		end)

		it("maps python filetype", function()
			assert.equals("py", iconmap.filetypes["python"])
		end)

		it("maps javascript filetype", function()
			assert.equals("js", iconmap.filetypes["javascript"])
		end)

		it("maps typescript filetype", function()
			assert.equals("ts", iconmap.filetypes["typescript"])
		end)

		it("maps common filetypes", function()
			local types = {
				ruby = "rb",
				rust = "rs",
				go = "go",
				java = "java",
				html = "html",
				css = "css",
			}
			for ft, ext in pairs(types) do
				assert.equals(ext, iconmap.filetypes[ft], "Incorrect mapping for filetype: " .. ft)
			end
		end)

		-- rebuilt 2026-11-10 from bin/filetype-generator.sh (vim filetypes from the current nvim-web-devicons)
		it("maps every filetype to a name that has an icon", function()
			require("prettypath") -- the overrides apply
			local devicons = require("prettypath.devicons")
			for ft in pairs(iconmap.filetypes) do
				assert.are_not.equal("Default", devicons.get_by_filetype(ft).name, ft)
			end
		end)

		it("maps filetypes the old table had wrong or lacked", function()
			assert.equals("makefile", iconmap.filetypes["make"])
			assert.equals(".gitignore", iconmap.filetypes["gitignore"])
			assert.equals("typ", iconmap.filetypes["typst"])
			-- fortran pointed at the F# icon; the generator offers no fortran icon, so there is none
			assert.are_not.equal("f#", iconmap.filetypes["fortran"])
		end)

		it("has no keys that are not vim filetypes", function()
			for _, key in ipairs({ "png", "jpg", "Brewfile", "LICENSE", "Gemfile", "javascript.jsx", "lock" }) do
				assert.is_nil(iconmap.filetypes[key], key)
			end
		end)
	end)
end)
