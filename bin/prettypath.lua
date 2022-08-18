#!/usr/bin/env lua

local prettypath = require('prettypath')
local opts = require('prettypath.opts')
-- local utils = require('utils')

local stdin = io.stdin:lines()
local stdout = io.write
for line in stdin do
  stdout(prettypath.pretty_path(line) .. '\n')
end

local stats = prettypath.stats or {}

if opts.output_stats == true then
  print('\n------\n' ..
    'Unassigned:\t' .. #stats.unassigned ..
    '\n' .. 'Missing:\t' .. #stats.missing ..
    '\n' .. 'Total:\t\t' .. stats.total .. '\n')

  for _, path in pairs(stats.unassigned) do
    print(path)
  end
end
