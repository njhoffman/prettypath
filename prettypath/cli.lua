-- Command-line interface text: the option table that --help and the shell completions are both built
-- from, so they cannot drift apart. No dependencies: bin/prettypath.lua loads it before anything else.
local M = {}

M.shells = { "bash", "zsh", "fish" }

-- name: long option; short: short alias; arg: the value placeholder (nil: a flag without a value);
-- values: fixed choices to complete; complete: "dir" to complete directories; desc: help lines
--stylua: ignore
M.options = {
	{ name = "help", short = "h", desc = { "Show this help message and exit" } },
	{ name = "version", short = "v", desc = { "Show version and exit" } },
	{ name = "format", arg = "FORMAT", desc = { "Output format string (default: %path% %icon% %dir%%name%)" } },
	{ name = "stat_file", arg = "MODE", values = { "auto", "true", "false" }, desc = {
		"Stat each file: auto (only when the format has a metadata",
		"token: size, access, mod, create and their _ago forms),",
		"true (always; also dims missing files) or false (default: auto)",
	} },
	{ name = "output_stats", arg = "BOOL", values = { "true", "false" },
		desc = { "Print statistics after processing (default: false)" } },
	{ name = "base", arg = "DIR", complete = "dir", desc = {
		"Show directories under DIR relative to it in %dir%",
		"(%path% is unchanged)",
	} },
	{ name = "dirs", desc = { "Treat every path as a directory (folder icon and colors)" } },
	{ name = "field", arg = "N", desc = {
		"Decorate only field N of each line (1 is the first, -1 the",
		"last); the other fields pass through. A line without",
		"field N is printed unchanged",
	} },
	{ name = "delimiter", arg = "D", desc = {
		'Field separator for --field, taken literally; "\\t" is a',
		"tab (default: tab)",
	} },
	{ name = "line-buffered", desc = {
		"Flush after every line (fzf on a slow source shows rows as",
		"they come; output is block-buffered otherwise)",
	} },
	{ name = "color", arg = "MODE", values = { "always", "never", "auto" }, desc = {
		"always, never or auto (only when stdout is a terminal);",
		"icons are kept either way (default: always, or never",
		"when NO_COLOR is set)",
	} },
}

local tokens = [[
Format Tokens:
  %path%        Original file path
  %icon%        Devicon with color
  %dir%         Directory portion (colorized)
  %name%        Filename portion (colorized)
  %score%       Numeric score (for ranked results)
  %size%        File size (human-readable)
  %access%      Last access time
  %mod%         Last modification time
  %create%      Creation time
  %access_ago%  Last access (relative, e.g. "2h ago")
  %mod_ago%     Last modification (relative)
  %create_ago%  Creation time (relative)
  (the metadata tokens print "-" for a missing file or with --stat_file=false)

Examples:
  find . -type f | prettypath
  fd . | prettypath --format='%icon% %name%'
  echo "/path/to/file.lua" | prettypath --format='%size% %icon% %dir%%name%'
  fd . "$PWD" | prettypath --base="$PWD"
  zoxide query -l | prettypath --dirs
  printf '3\t/etc/hosts\n' | prettypath --field=2

Shell completion:
  bash: eval "$(prettypath completion bash)"        (in ~/.bashrc)
  zsh:  prettypath completion zsh > "${fpath[1]}/_prettypath"
  fish: prettypath completion fish > ~/.config/fish/completions/prettypath.fish
]]

function M.help()
	local out = {
		"prettypath - Decorate file paths with devicons and colors",
		"",
		"Usage: prettypath [OPTIONS]",
		"       <command> | prettypath [OPTIONS]",
		"       prettypath completion bash|zsh|fish",
		"",
		"Options:",
	}
	for _, o in ipairs(M.options) do
		local flag = (o.short and ("-" .. o.short .. ", ") or "") .. "--" .. o.name .. (o.arg and ("=" .. o.arg) or "")
		for i, line in ipairs(o.desc) do
			local left = i == 1 and flag or ""
			-- a flag longer than the column gets its description on the next line
			if i == 1 and #flag > 19 then
				out[#out + 1] = "  " .. flag
				left = ""
			end
			out[#out + 1] = "  " .. left .. string.rep(" ", 20 - #left) .. line
		end
	end
	out[#out + 1] = ""
	return table.concat(out, "\n") .. "\n" .. tokens
end

local function words(list)
	return table.concat(list, " ")
end

local function bash()
	local flags, valued, cases = {}, {}, {}
	for _, o in ipairs(M.options) do
		if o.short then
			flags[#flags + 1] = "-" .. o.short
		end
		if o.arg then
			valued[#valued + 1] = "--" .. o.name .. "="
			if o.values then
				cases[#cases + 1] = ("    --%s) COMPREPLY=($(compgen -W '%s' -- \"$cur\")) ;;"):format(o.name, words(o.values))
			elseif o.complete == "dir" then
				cases[#cases + 1] = ('    --%s) COMPREPLY=($(compgen -d -- "$cur")) ;;'):format(o.name)
			else
				cases[#cases + 1] = ("    --%s) COMPREPLY=() ;;"):format(o.name)
			end
		else
			flags[#flags + 1] = "--" .. o.name
		end
	end
	return ([==[
# bash completion for prettypath (prettypath completion bash)
_prettypath() {
  local cur=${COMP_WORDS[COMP_CWORD]} opt=""
  if [[ ${COMP_WORDS[1]} == completion ]]; then
    ((COMP_CWORD == 2)) && COMPREPLY=($(compgen -W '%s' -- "$cur"))
    return
  fi
  # bash splits "--color=au" into "--color" "=" "au" (= is in COMP_WORDBREAKS); find the option
  if [[ $cur == = ]]; then
    opt=${COMP_WORDS[COMP_CWORD-1]} cur=""
  elif ((COMP_CWORD > 1)) && [[ ${COMP_WORDS[COMP_CWORD-1]} == = ]]; then
    opt=${COMP_WORDS[COMP_CWORD-2]}
  elif [[ $cur == --*=* ]]; then
    opt=${cur%%%%=*} cur=${cur#*=}
  fi
  if [[ -n $opt ]]; then
    case $opt in
%s
    esac
    return
  fi
  COMPREPLY=($(compgen -W '%s %s' -- "$cur"))
  ((COMP_CWORD == 1)) && COMPREPLY+=($(compgen -W 'completion' -- "$cur"))
  # no space after an option that takes a value
  [[ ${#COMPREPLY[@]} -eq 1 && ${COMPREPLY[0]} == *= ]] && compopt -o nospace 2> /dev/null
  return 0
}
complete -F _prettypath prettypath
]==]):format(words(M.shells), table.concat(cases, "\n"), words(flags), words(valued))
end

-- zsh _arguments spec: brackets and colons in descriptions would end the field
local function zsh_desc(o)
	return (o.desc[1]:gsub("[%[%]:]", ""):gsub("'", "'\\''"))
end

local function zsh()
	local specs = {}
	for _, o in ipairs(M.options) do
		local desc = zsh_desc(o)
		if o.arg then
			local action = o.values and ("(" .. words(o.values) .. ")") or (o.complete == "dir" and "_files -/" or " ")
			specs[#specs + 1] = ("    '--%s=[%s]:%s:%s'"):format(o.name, desc, o.arg:lower(), action)
		elseif o.short then
			specs[#specs + 1] = ("    '(- *)'{-%s,--%s}'[%s]'"):format(o.short, o.name, desc)
		else
			specs[#specs + 1] = ("    '--%s[%s]'"):format(o.name, desc)
		end
	end
	return ([==[
#compdef prettypath
# zsh completion for prettypath (prettypath completion zsh > "${fpath[1]}/_prettypath")
_prettypath() {
  if [[ ${words[2]} == completion ]]; then
    ((CURRENT == 3)) && _values shell %s
    return
  fi
  _arguments -s \
%s \
    '1::command:(completion)'
}
if [[ $funcstack[1] == _prettypath ]]; then
  _prettypath "$@"
else
  compdef _prettypath prettypath
fi
]==]):format(words(M.shells), table.concat(specs, " \\\n"))
end

local function fish()
	local out = {
		"# fish completion for prettypath (prettypath completion fish > ~/.config/fish/completions/prettypath.fish)",
		"complete -c prettypath -f",
		"complete -c prettypath -n '__fish_use_subcommand' -a completion -d 'Print a shell completion script'",
		("complete -c prettypath -n '__fish_seen_subcommand_from completion' -a '%s'"):format(words(M.shells)),
	}
	for _, o in ipairs(M.options) do
		local line = "complete -c prettypath -n 'not __fish_seen_subcommand_from completion'"
			.. (o.short and (" -s " .. o.short) or "")
			.. " -l "
			.. o.name
		if o.values then
			line = line .. " -x -a '" .. words(o.values) .. "'"
		elseif o.complete == "dir" then
			line = line .. " -x -a '(__fish_complete_directories)'"
		elseif o.arg then
			line = line .. " -x"
		end
		out[#out + 1] = line .. " -d '" .. o.desc[1]:gsub("'", "\\'") .. "'"
	end
	return table.concat(out, "\n") .. "\n"
end

local generators = { bash = bash, zsh = zsh, fish = fish }

-- the completion script for a shell, or nil and an error for an unknown one
function M.completion(shell)
	local gen = generators[shell or ""]
	if gen == nil then
		return nil, "completion takes bash, zsh or fish, not '" .. tostring(shell or "") .. "'"
	end
	return gen()
end

return M
