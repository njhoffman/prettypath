local file_stat_external = function(path)
  local f = io.popen("stat -c %Y " .. path)
  local last_modified = f and f:read()
  return os.date("%c", last_modified)
end

local file_stat = function(path)
  -- luarocks install luv
  local uv = require("luv") -- "luv" when stand-alone, "uv" in luvi apps
  local stats = uv.fs_stat(path)
  -- blksize 4096
  -- gid     1000
  -- ino     19248220
  -- ctime
  -- sec     1660702550
  -- nsec    685434739
  -- birthtime       table: 0x559a6d01da30
  -- mtime   table: 0x559a6d01d8d0
  -- flags   0
  -- gen     0
  -- type    file
  -- atime   table: 0x559a6d01d7c0
  -- rdev    0
  -- size    2179
  -- dev     66306
  -- uid     1000
  -- blocks  8
  -- mode    33261
  -- nlink   1
end

return file_stat
