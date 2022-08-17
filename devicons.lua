local iconmap = require('iconmap')

local function override(icons, filetypes)
  for k, v in pairs(icons or {}) do iconmap.icons[k] = v end
  for k, v in pairs(filetypes or {}) do iconmap.filetypes[k] = v end
end

local function match_icon(name, ext)
  ext = ext or name:match("^.*%.(.*)$") or ""
  local icon_data = iconmap.icons[name] or iconmap.icons[ext] or iconmap.icons[""]
  return icon_data
end

return {
  get = function(...)
    return match_icon(...)
  end,
  get_by_filetype = function(ft)
    local name = iconmap.filetypes[ft]
    return match_icon(name or '', nil)
  end,
  get_icons = function()
    return iconmap.icons
  end,
  override = override
}
