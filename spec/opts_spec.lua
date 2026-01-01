describe("opts", function()
	local opts

	setup(function()
		opts = require("prettypath.opts")
	end)

	describe("default values", function()
		it("has format option", function()
			assert.is_string(opts.format)
			assert.is_truthy(opts.format:match("%%"))
		end)

		it("has stat_file option", function()
			assert.is_not_nil(opts.stat_file)
		end)

		it("has output_stats option", function()
			assert.is_not_nil(opts.output_stats)
		end)

		it("has color_icon option", function()
			assert.is_not_nil(opts.color_icon)
		end)

		it("has color_name option", function()
			assert.is_not_nil(opts.color_name)
		end)

		it("has home_name option", function()
			assert.equals("~", opts.home_name)
		end)
	end)

	describe("colors", function()
		it("has colors table", function()
			assert.is_table(opts.colors)
		end)

		it("has score color", function()
			assert.is_string(opts.colors.score)
			assert.is_truthy(opts.colors.score:match("#"))
		end)

		it("has path_dir color", function()
			assert.is_string(opts.colors.path_dir)
		end)

		it("has path_name color", function()
			assert.is_string(opts.colors.path_name)
		end)

		it("has missing color", function()
			assert.is_string(opts.colors.missing)
		end)
	end)

	describe("default format", function()
		it("includes path token", function()
			assert.is_truthy(opts.format:match("%%path%%"))
		end)

		it("includes icon token", function()
			assert.is_truthy(opts.format:match("%%icon%%"))
		end)

		it("includes dir token", function()
			assert.is_truthy(opts.format:match("%%dir%%"))
		end)

		it("includes name token", function()
			assert.is_truthy(opts.format:match("%%name%%"))
		end)
	end)
end)
