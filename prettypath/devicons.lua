local iconmap = require("prettypath.iconmap")

-- icons: entries merged over iconmap; aliases: key -> the key of an entry (after the merge) whose icon and
-- color it reuses, under its own name. An alias to a missing entry is an error, so a renamed donor shows up.
local override = function(icons, filetypes, aliases)
  for k, v in pairs(icons or {}) do
    iconmap.icons[k] = v
  end
  for k, v in pairs(filetypes or {}) do
    iconmap.filetypes[k] = v
  end
  for k, donor in pairs(aliases or {}) do
    local d = iconmap.icons[donor]
    if d == nil then
      error("icon alias " .. k .. " -> " .. donor .. ": no such icon", 0)
    end
    iconmap.icons[k] = { icon = d.icon, color = d.color, cterm_color = d.cterm_color, double = d.double, name = k }
  end
end

local match_icon = function(name, path_type)
  local icon_data = iconmap.icons["/"]
  if path_type ~= "directory" then
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
    return match_icon(name or "")
  end,
  get_icons = function()
    return iconmap.icons
  end,
  override = override,
}
