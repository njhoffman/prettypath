#!/usr/bin/env lua

local prettyfile = require('prettyfile')
local utils = require('utils')

local stdin = io.stdin:lines()
local stdout = io.write
local formatters = {
  "%score% %icon% %dir%%name%",
  "%size% %icon% %dir%%name%",
  "%access% %icon% %dir%%name%",
  "%mod% %icon% %dir%%name%",
  "%create% %icon% %dir%%name%",
  "%access_ago% %icon% %dir%%name%",
  "%mod_ago% %icon% %dir%%name%",
  "%create_ago% %icon% %dir%%name%",
}

for line in stdin do
  stdout('\n------\n')

  for _, formatter in pairs(formatters) do
    stdout('\n\27[31;30;1m' .. formatter .. '\27[0m\n')
    stdout(prettyfile.pretty_path(line, { format = formatter }) .. '\n')
  end
end


print(utils.inspect(prettyfile.stats))
