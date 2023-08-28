package =
  'prettypath'
version =
  'dev-2'
source =
  {
    url = 'git+https://github.com/njhoffman/prettypath',
    -- tag = "v1.0",
  }
description =
  {
    summary = 'Highly configurable path decorator with devicons',
    detailed = [[
   prettypath, CLI program to pipe filepaths through for decoration,
   including devicon output similar to nvim-web-devicons.  Also allows
   optional file scanning for additional tags (like size, date of last access, etc)
   ]],
    homepage = 'https://github.com/njhoffman/prettypath',
    license = 'MIT',
  }
dependencies =
  {
    'lua-filesize >= 0.1.1-1',
    'luv >= 1.44.2-0',
  }
build =
  {
    type = 'none',
    install = {
      bin = {
        ['prettypath'] = 'bin/prettypath.lua',
        ['prettypath_test'] = 'bin/prettypath_test.lua',
      },
      lua = {
        ['bin.prettypath'] = 'bin/prettypath.lua',
        ['bin.prettypath_test'] = 'bin/prettypath_test.lua',
        ['prettypath'] = 'prettypath/init.lua',
        ['prettypath.color'] = 'prettypath/color.lua',
        ['prettypath.devicons'] = 'prettypath/devicons.lua',
        ['prettypath.format'] = 'prettypath/format.lua',
        ['prettypath.iconmap'] = 'prettypath/iconmap.lua',
        ['prettypath.inspect'] = 'prettypath/inspect.lua',
        ['prettypath.nonicons'] = 'prettypath/nonicons.lua',
        ['prettypath.opts'] = 'prettypath/opts.lua',
        ['prettypath.override'] = 'prettypath/override.lua',
        ['prettypath.override_nonicons'] = 'prettypath/override_nonicons.lua',
        ['prettypath.utils'] = 'prettypath/utils.lua',
      },
    },
  }
