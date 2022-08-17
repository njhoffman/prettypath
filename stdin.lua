#!/usr/bin/env lua

local prettyfile = require('prettyfile')
local stdin = io.stdin:lines()
local stdout = io.write
for line in stdin do
  stdout(prettyfile.pretty_path(line) .. '\n')
end
