-- README.md keeps up with the CLI: every option in prettypath/cli.lua (the table --help and the completions
-- are built from) and every format token is documented
describe("README.md", function()
	local readme = io.open("README.md"):read("*a")

	it("documents every option", function()
		for _, o in ipairs(require("prettypath.cli").options) do
			assert.is_truthy(readme:find("`--" .. o.name, 1, true), "--" .. o.name)
			if o.short then
				assert.is_truthy(readme:find("`-" .. o.short .. "`", 1, true), "-" .. o.short)
			end
		end
	end)

	it("documents every format token", function()
		local utils = require("prettypath.utils")
		-- every token compile_format accepts: probe the formatter table through a format of each name
		local names = { "path", "icon", "dir", "name", "score" }
		for token in pairs(utils.stat_tokens) do
			names[#names + 1] = token
		end
		for _, token in ipairs(names) do
			assert.has_no.errors(function()
				utils.compile_format("%" .. token .. "%")
			end, token)
			assert.is_truthy(readme:find("`%" .. token .. "%`", 1, true), token)
		end
	end)

	it("documents the completion command and the --version contract", function()
		assert.is_truthy(readme:find("prettypath completion bash|zsh|fish", 1, true))
		assert.is_truthy(readme:find("prints `prettypath X.Y.Z`", 1, true))
	end)
end)
