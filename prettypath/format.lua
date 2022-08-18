local filesize = require('filesize')

local languages = {
  long = {
    justnow = 'just now',
    minute = { singular = 'a minute ago', plural = ' minutes ago' },
    hour = { singular = 'an hour ago', plural = ' hours ago' },
    day = { singular = 'a day ago', plural = ' days ago' },
    week = { singular = 'a week ago', plural = ' weeks ago' },
    month = { singular = 'a month ago', plural = ' months ago' },
    year = { singular = 'a year ago', plural = ' years ago' }
  },
  short = {
    justnow = 'now',
    minute = { singular = 'm ago', plural = 'm ago' },
    hour = { singular = 'h ago', plural = 'h ago' },
    day = { singular = 'd ago', plural = 'd ago' },
    week = { singular = 'w ago', plural = 'w ago' },
    month = { singular = 'm ago', plural = 'm ago' },
    year = { singular = 'y ago', plural = 'y ago' }
  },
  minimal = {
    justnow = 'now',
    minute = { singular = 'm', plural = 'm' },
    hour = { singular = 'h', plural = 'h' },
    day = { singular = 'd', plural = 'd' },
    week = { singular = 'w', plural = 'w' },
    month = { singular = 'm', plural = 'm' },
    year = { singular = 'y', plural = 'y' }
  }
}

local function round(num) return math.floor(num + 0.5) end

local time_ago = function(time, lang_format)
  local now = os.time()
  local diff_seconds = os.difftime(now, time)
  local lang = languages[lang_format] or languages.short
  if diff_seconds < 45 then return lang.justnow end

  local diff_minutes = diff_seconds / 60
  if diff_minutes < 1.5 then return lang.minute.singular end
  if diff_minutes < 59.5 then
    return round(diff_minutes) .. lang.minute.plural
  end

  local diff_hours = diff_minutes / 60
  if diff_hours < 1.5 then return lang.hour.singular end
  if diff_hours < 23.5 then
    return round(diff_hours) .. lang.hour.plural
  end

  local diff_days = diff_hours / 24
  if diff_days < 1.5 then return lang.day.singular end
  if diff_days < 7.5 then
    return round(diff_days) .. lang.day.plural
  end

  local diff_weeks = diff_days / 7
  if diff_weeks < 1.5 then return lang.week.singular end
  if diff_weeks < 4.5 then
    return round(diff_weeks) .. lang.week.plural
  end

  local diff_months = diff_days / 30
  if diff_months < 1.5 then return lang.month.singular end
  if diff_months < 11.5 then
    return round(diff_months) .. lang.month.plural
  end

  local diff_years = diff_days / 365.25
  if diff_years < 1.5 then return lang.year.singular end
  return round(diff_years) .. lang.year.plural

end

local format_time = function(sec, ago)
  if ago == true then
    return time_ago(sec)
  end
  -- %a	abbreviated weekday name (e.g., Wed)
  -- %A	full weekday name (e.g., Wednesday)
  -- %b	abbreviated month name (e.g., Sep)
  -- %B	full month name (e.g., September)
  -- %c	date and time (e.g., 09/16/98 23:48:10)
  -- %d	day of the month (16) [01-31]
  -- %H	hour, using a 24-hour clock (23) [00-23]
  -- %I	hour, using a 12-hour clock (11) [01-12]
  -- %M	minute (48) [00-59]
  -- %m	month (09) [01-12]
  -- %p	either "am" or "pm" (pm)
  -- %S	second (10) [00-61]
  -- %w	weekday (3) [0-6 = Sunday-Saturday]
  -- %x	date (e.g., 09/16/98)
  -- %X	time (e.g., 23:48:10)
  -- %Y	full year (1998)
  -- %y	two-digit year (98) [00-99]
  return os.date('%x %X', sec)
end

local format_size = function(bytes)
  return filesize(bytes)
end

return {
  time = format_time,
  size = format_size,
  nop = function(str) return str end

}
