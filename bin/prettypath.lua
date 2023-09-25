#!/usr/bin/env lua

local prettypath = require('prettypath')
local opts = require('prettypath.opts')
local start_time = os.time()
local stdin = io.stdin:lines()
for line in stdin do
  -- allow pipe to be interrupted without error
  pcall(function()
    io.write(prettypath.pretty_path(line) .. '\n')
  end)
end

local stats = prettypath.stats or {}

local elapsed_time = os.difftime(os.time(), start_time)

if tostring(opts.output_stats) == "true" then
  print('\n------\n')
  for _, path in pairs(stats.unassigned) do
    print(path)
  end

  local avg = elapsed_time / stats.total * 1000000

  print(
    '\n\n' .. 'Missing:\t' .. #stats.missing ..
    '\n' .. 'Unassigned:\t' .. #stats.unassigned ..
    '\n' .. 'Total:\t\t' .. stats.total ..
    '\n' .. 'Percentage:\t' .. Math.floor(100 - (#stats.unassigned / stats.total * 100)) .. '%' ..
    '\n' .. 'Average:\t' .. (math.floor(avg * 100) / 100) .. 'μs' ..
    '\n')
end
