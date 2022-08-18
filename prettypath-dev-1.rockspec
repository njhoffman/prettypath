package = "prettypath"
version = "dev-1"
source = {
  url = "git+https://github.com/njhoffman/prettypath"
}
description = {
  summary = "Formatted path output with colored icons",
  detailed = [[
      This is an example for the LuaRocks tutorial.
      Here we would put a detailed, typically
      paragraph-long description.
   ]],
  homepage = "https://github.com/njhoffman/prettypath",
  license = "*** please specify a license ***"
}
dependencies = {
  "lua >= 5.4",
  "lua-filesize >= 0.1.1-1",
  "inspect >= 3.1.3-0",
  "luv >= 1.44.2-0"
}
build = {
  type = "none",
  install = {
    bin = {
      ["prettypath"] = "bin/prettypath.lua",
      ["prettypath_test"] = "bin/prettypath_test.lua",
    },
    lua = {
      ["bin.prettypath"]               = "bin/prettypath.lua",
      ["bin.prettypath_test"]          = "bin/prettypath_test.lua",
      ["prettypath"]                   = "prettypath/init.lua",
      ["prettypath.color"]             = "prettypath/color.lua",
      ["prettypath.devicons"]          = "prettypath/devicons.lua",
      ["prettypath.format"]            = "prettypath/format.lua",
      ["prettypath.iconmap"]           = "prettypath/iconmap.lua",
      ["prettypath.init"]              = "prettypath/init.lua",
      ["prettypath.inspect"]           = "prettypath/inspect.lua",
      ["prettypath.nonicons"]          = "prettypath/nonicons.lua",
      ["prettypath.opts"]              = "prettypath/opts.lua",
      ["prettypath.override"]          = "prettypath/override.lua",
      ["prettypath.override_nonicons"] = "prettypath/override_nonicons.lua",
      ["prettypath.utils"]             = "prettypath/utils.lua"
    },

  }
}
