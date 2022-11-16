#!/usr/bin/env lua

local prettypath = require('prettypath')
local opts = require('prettypath.opts')

local stdin = io.stdin:lines()
for line in stdin do
  -- allow pipe to be interrupted without error
  pcall(function()
    io.write(prettypath.pretty_path(line) .. '\n')
  end)
end

local stats = prettypath.stats or {}

if opts.output_stats == true then
  print('\n------\n')
  for _, path in pairs(stats.unassigned) do
    print(path)
  end

  print('\n\n' .. 'Unassigned:\t' .. #stats.unassigned ..
    '\n' .. 'Missing:\t' .. #stats.missing ..
    '\n' .. 'Total:\t\t' .. stats.total .. '\n')

end
