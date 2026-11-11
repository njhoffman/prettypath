-- prettypath/override.lua: custom entries win over generated ones, aliases reuse an existing icon, and no
-- table literal repeats a key (Lua keeps the last one silently)
describe("override.lua", function()
	local override = require("prettypath.override")
	local devicons = require("prettypath.devicons")
	require("prettypath") -- applies the overrides

	-- the keys of each top-level table literal, in order, read from the source
	local function table_keys(src, name)
		local start = src:find("\nlocal " .. name .. " =", 1, true)
		assert.is_truthy(start, name)
		local body = src:sub(start)
		local stop = body:find("\n  }\n", 1, true) or body:find("\n}\n", 1, true)
		body = body:sub(1, stop)
		local keys = {}
		for line in body:gmatch("[^\n]+") do
			-- an entry at the table's first level: 4 spaces (icons, custom) or 2 (aliases)
			local k = line:match("^    %[['\"]([^'\"]+)['\"]%]%s*=")
				or line:match("^    ([%a_][%w_]*)%s*=%s*{")
				or line:match("^  %[['\"]([^'\"]+)['\"]%]%s*=")
			if k then
				keys[#keys + 1] = k
			end
		end
		return keys
	end

	local src = io.open("prettypath/override.lua"):read("*a")

	for _, name in ipairs({ "custom", "icons", "aliases" }) do
		it("has no repeated key in " .. name, function()
			local seen, dups = {}, {}
			local keys = table_keys(src, name)
			assert.is_true(#keys > 0, name)
			for _, k in ipairs(keys) do
				if seen[k] then
					dups[#dups + 1] = k
				end
				seen[k] = true
			end
			assert.are.same({}, dups)
		end)
	end

	it("lets a custom entry win over a generated one for the same key", function()
		local custom = {}
		for _, k in ipairs(table_keys(src, "custom")) do
			custom[k] = true
		end
		local generated = {}
		for _, k in ipairs(table_keys(src, "icons")) do
			generated[k] = true
		end
		local both = 0
		for k in pairs(custom) do
			if generated[k] then
				both = both + 1
			end
		end
		-- the case this guards: mp3 is in both, and the custom icon is the one used
		assert.is_true(custom.mp3 and generated.mp3)
		assert.is_true(both > 0)
		local custom_mp3 = src:match("local custom =.-%['mp3'%] = {%s*icon = '([^']+)'")
		assert.are.equal(custom_mp3, devicons.get("song.mp3").icon)
	end)

	it("resolves every alias to its donor's icon and color, under its own name", function()
		local icons = devicons.get_icons()
		for k, donor in pairs(override.aliases) do
			local got = icons[k]
			assert.is_table(got, k)
			assert.are.equal(icons[donor].icon, got.icon, k)
			assert.are.equal(icons[donor].color, got.color, k)
			assert.are.equal(k, got.name, k)
			assert.are_not.equal("Default", got.name, k)
		end
	end)

	it("gives the aliased and color-scheme types an icon in paths", function()
		for _, name in ipairs({ "a.o", "libz.so", "Makefile.am", "conf.rasi", "x.itermcolors", ".gitkeep", "t.bats" }) do
			assert.are_not.equal("Default", devicons.get(name).name, name)
		end
	end)

	it("rejects an alias to an icon that does not exist", function()
		assert.has_error(function()
			devicons.override(nil, nil, { zz = "no-such-icon-key" })
		end, "icon alias zz -> no-such-icon-key: no such icon")
	end)
end)
