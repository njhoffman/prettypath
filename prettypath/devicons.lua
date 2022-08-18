local iconmap = require('prettypath.iconmap')

local override = function(icons, filetypes)
  for k, v in pairs(icons or {}) do iconmap.icons[k] = v end
  for k, v in pairs(filetypes or {}) do iconmap.filetypes[k] = v end
end

local match_icon = function(name, path_type)
  local icon_data = iconmap.icons['/']
  if path_type ~= 'directory' then
    local ext = name:match("^.*%.(.*)$") or ""
    icon_data = iconmap.icons[name] or iconmap.icons[ext] or iconmap.icons[""]
  end
  return icon_data
end

return {
  get = function(...)
    return match_icon(...)
  end,
  get_by_filetype = function(ft)
    local name = iconmap.filetypes[ft]
    return match_icon(name or '')
  end,
  get_icons = function()
    return iconmap.icons
  end,
  override = override
}
