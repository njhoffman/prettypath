describe("format", function()
	local format

	setup(function()
		format = require("prettypath.format")
	end)

	describe("size", function()
		it("formats bytes to human readable", function()
			local result = format.size(1024)
			assert.is_string(result)
			-- lua-filesize returns "1 KB" or similar
			assert.is_truthy(result:match("1"))
		end)

		it("formats large sizes", function()
			local result = format.size(1048576) -- 1 MB
			assert.is_string(result)
			assert.is_truthy(result:match("1"))
		end)

		it("formats zero bytes", function()
			local result = format.size(0)
			assert.is_string(result)
		end)
	end)

	describe("time", function()
		it("formats timestamp to date string", function()
			local now = os.time()
			local result = format.time(now)
			assert.is_string(result)
			-- Should contain date components
			assert.is_truthy(result:match("%d"))
		end)

		it("formats time ago when ago=true", function()
			local now = os.time()
			local result = format.time(now, true)
			assert.is_string(result)
			-- Should be "just now" or similar
			assert.is_truthy(result:match("now") or result:match("ago") or result:match("m") or result:match("h"))
		end)

		it("returns 'just now' for recent times", function()
			local now = os.time()
			local result = format.time(now, true)
			assert.equals("now", result)
		end)

		it("returns minutes ago for times within an hour", function()
			local ten_minutes_ago = os.time() - (10 * 60)
			local result = format.time(ten_minutes_ago, true)
			assert.is_truthy(result:match("10") or result:match("m"))
		end)

		it("returns hours ago for times within a day", function()
			local two_hours_ago = os.time() - (2 * 60 * 60)
			local result = format.time(two_hours_ago, true)
			assert.is_truthy(result:match("2") or result:match("h"))
		end)

		it("returns days ago for times within a week", function()
			local three_days_ago = os.time() - (3 * 24 * 60 * 60)
			local result = format.time(three_days_ago, true)
			assert.is_truthy(result:match("3") or result:match("d"))
		end)
	end)

	describe("nop", function()
		it("returns input unchanged", function()
			assert.equals("test", format.nop("test"))
			assert.equals("/path/to/file", format.nop("/path/to/file"))
			assert.equals("", format.nop(""))
		end)
	end)
end)
