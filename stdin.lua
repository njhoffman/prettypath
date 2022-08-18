#!/usr/bin/env lua

local prettyfile = require('prettyfile')
-- local utils = require('utils')

local stdin = io.stdin:lines()
local stdout = io.write
for line in stdin do
  stdout(prettyfile.pretty_path(line) .. '\n')
end

local stats = prettyfile.stats or {}

print('\n------\n' ..
  'Unassigned:\t' .. #stats.unassigned ..
  '\n' .. 'Missing:\t' .. #stats.missing ..
  '\n' .. 'Total:\t\t' .. stats.total .. '\n')

-- for _, path in pairs(stats.unassigned) do
--   print(path)
-- end
